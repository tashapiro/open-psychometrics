library(tidyverse)
library(ggimage)
library(ggtext)
library(tidytuesdayR)
library(sysfonts)
library(showtext)

#import data
tuesdata <- tidytuesdayR::tt_load(2022, week = 33)
characters<-tuesdata$characters
ps<-tuesdata$psych_stats

#reshape data
sc<-ps|>
  #filter to just see characters from Bob's Burgers. use two personality items
  filter(uni_name=="Schitt's Creek" 
         & question %in% c("genuine/sarcastic","cynical/gullible"))|>
  #rescale the personality avg_ratings based on extremes
  mutate(anchor = sub("^(.+?)\\/","",question),
         rescaled = case_when(anchor!=personality~ 100-avg_rating, TRUE ~ avg_rating))|>
  select(char_id, char_name, anchor, rescaled)|>
  #reshape data - we want to use this for a matrix plot with x & y points for personality scores
  pivot_wider(names_from=anchor, values_from=rescaled)

#append images from characters dataset
sc<-sc|>left_join(characters|>select(id, image_link), by=c("char_id"="id"))

axis_labels<-data.frame(
  label=c("GENUINE","SARCASTIC","CYNICAL","GULLIBLE"),
  x= c(-10, 110, 50, 50),
  y=c(50, 50, -10, 110)
)

#import fonts from sysfont package
sysfonts::font_add_google("roboto")
sysfonts::font_add_google("DM Serif Display","dm")
showtext_auto()


#custom title and caption for ggtext using HTML/CSS
title = "<span style='font-size:24pt;color:white;font-family:dm;'>**Schitts**</span><span style='font-size:24pt;color:#FFED47;font-family:dm'> **Creek**</span><br>
<span style='font-size:11pt;color:white;font-family:roboto;'>Character Personality Matrix. Data from the Open-Source Psychometrics Project.</span>"

caption= "<span style='color:white;'>Graphic by </span><span style='color:#FFED47;'>@tanya_shapiro</span>"

#custom palette
pal_bg<-'black'
pal_line<-'#FFED47'
pal_text<-'white'

plot<-ggplot(data=sc, mapping=aes(x=sarcastic, y=gullible))+
  #create matrix axis
  geom_segment(mapping=aes(x=0, xend=100, y=50, yend=50), color=pal_line, arrow=arrow(length=unit(0.1,"inches"), ends="both"))+
  geom_segment(mapping=aes(y=0, yend=100, x=50, xend=50), color=pal_line, arrow=arrow(length=unit(0.1,"inches"),ends="both"))+
  geom_text(mapping=aes(label="GENUINE",x=-10, y=50), angle=90, color=pal_text, size=5, family="roboto")+
  geom_text(mapping=aes(label="SARCASTIC",x=110, y=50), angle=-90, color=pal_text, size=5, family="roboto")+
  geom_text(mapping=aes(label="GULLIBLE",x=50, y=110),  color=pal_text, size=5, family="roboto")+
  geom_text(mapping=aes(label="CYNICAL",x=50, y=-10), color=pal_text, size=5, family="roboto")+
  #plot character names and images
  geom_image(aes(image=image_link), size=0.07)+
  #add character label beneath image, adjust by subtracting a little from y value
  geom_label(aes(label=char_name, y=gullible-7.5), fill="black", color="white", family="roboto", size=3.5)+
  #adjust scales
  scale_y_continuous(limits=c(-10,110))+
  scale_x_continuous(limits=c(-10,110))+
  #add plot labels
  labs(title=title, caption=caption)+
  #adjust theme
  theme_void()+
  theme(plot.title=element_textbox_simple(halign =0.5),
        plot.caption=element_textbox_simple(halign=0.95),
        plot.background = element_rect(fill=pal_bg, color=NA),
        plot.margin = margin(rep(20,4)))


plot

ggsave("schitts-creek.jpeg", height=8, width=8)




