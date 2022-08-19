library(tidyverse)
library(ggtext)
library(ggiraph)

data<-read_csv("https://raw.githubusercontent.com/tashapiro/open-psychometrics/main/data/psych_stats.csv")

#get subset of questions based on average number of ratings
top_questions<-data|>
  group_by(question)|>
  summarise(avg=mean(number_ratings))|>
  arrange(-avg)|>
  head(22)

#subset data based on questions sample
data_filter<-data|>
  filter(question %in% top_questions$question)%>%
  select(char_id, char_name, personality, question, avg_rating)%>%
  mutate(
    first_trait = substr(question,1,nchar(question)-nchar(sub("^(.+?)\\/","",question))-1),
    last_trait=sub("^(.+?)\\/","",question),
    trait = paste0(first_trait," (not ",last_trait,")"),
    #craete new rating, if the personality of character does not match anchor trait, flip it (100-avg_rating)
    rating = case_when(personality==first_trait ~ avg_rating, TRUE ~ 100-avg_rating)
)

#pivot data to create a matrix of variables
data_pivot<-data_filter%>%
  select(char_id, first_trait, rating)%>%
  pivot_wider(names_from=first_trait, values_from=rating)

#get correlation values
res<-data.frame(cor(data_pivot[,2:ncol(data_pivot)]))

#pivot longer to create trait1 and trait2, create positional values for plot
df_corr<-res|>
  rownames_to_column("trait1")|>
  pivot_longer(-trait1, names_to="trait2", values_to="corr")|>
  mutate(trait2 = case_when(trait2=="family.first"~"family-first", TRUE ~ trait2))|>
  arrange(trait1,trait2)|>
  rowwise()|>
  #pair the traits in sorted order
  mutate(paired_traits = paste(sort(c(trait1, trait2)), collapse=", "))|>
  group_by(paired_traits)|>
  #create rownumber to show how many times trait pair appears
  mutate(app = row_number())

#labels for trait1 and trait2
labels<-data.frame(
  label = unique(df_corr$trait1),
  pos = 1:length(unique(df_corr$trait1))
)

df_corr<-df_corr|>
  #get first appearence of pairing (creates a mask to create triangular corr plot)
  filter(app==1)|>
  #create numeric positional arguments for traits - needed for axis labels & scales 
  mutate(xpos = labels$pos[labels$label==trait1],
         ypos = labels$pos[labels$label==trait2],
  #add tooltip for ggiraph
         tooltip = paste0("<b>Trait 1</b>: ",trait1,
                          "<br><b>Trait 2</b>: ", trait2,
                          "<br><b>Corr</b>: ",round(corr,2))
  )

  
title="<span>**Correlation Matrix: Psychometrics**</span><br>
<span style='font-size:12pt;'>Exploring relationships between different psychometric ratings from 
Open-Source Psychometrics Project.</span>"


plot<-ggplot(df_corr, aes(x=xpos, y=ypos, fill=corr))+
  #correlation dots
  geom_point_interactive(shape=21, size=5.5, color="grey20", aes(tooltip=tooltip))+
  #y axis labels
  geom_text(inherit.aes=FALSE, data=labels, aes(x=0, y=pos, label=label), hjust=1)+
  #x axis labels
  geom_text(inherit.aes=FALSE, data=labels, aes(x=pos+0.4, y=pos-0.4, label=label), hjust=0, angle=45)+
  #adjust fill scale
  scale_fill_distiller(palette = "RdBu", limits=c(-1,1),
                       guide=guide_colorbar(barwidth = 22, barheight=0.7, frame.colour="black", direction="horizontal"))+
  #adjust x and y axis scales
  scale_x_continuous(limits=c(-3.5,23))+
  scale_y_reverse(limits=c(22,-2))+
  coord_equal()+
  #add plot title (uses ggtext - additional theme argument with element_textbox_simple)
  labs(title=title,x="", y="", fill="")+
  #adjust theme
  theme_minimal()+
  theme(panel.grid = element_blank(),
        plot.title=element_textbox_simple(),
        axis.text = element_blank(),
        legend.position = c(0.53,-0.03),
        plot.margin = margin(b=25, t=15))


plot

tooltip_css <- "background-color:black;color:white;font-family:sans-serif;padding:10px;border-radius:5px"

girafe(ggobj = plot,
       options = list(opts_tooltip(css = tooltip_css)),
       width_svg=6.5, height_svg=6.5)

