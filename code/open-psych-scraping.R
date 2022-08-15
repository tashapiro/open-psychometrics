library(tidyverse)
library(rvest)

#select universes from the Open Source Psychometrics Project, includes directory ID and name
df_universe<-data.frame(
  id = c("F","EU","HIMYM","GOT","FUTR","TO","HP","GA","H","PR","BBT","SUC",
          "WSW", "R30","UA","GILG","SsC","GOG","S","SCRUBS","LOTR","BOBB","TL","WD",
          "B","ARCH","O","SHL","TW","WW","SOP","FS","S8","DA","GP","MCU","ASP","NG","CM",
          "SF","GTH","AD","V", "T7S","SV","BVS","MF","YJ","ST","TP","SC","DH","MM",
          "BSG","ALA","TB","SP","RD","C","WV","MASH","D","SCDL","VK","TWCH","SL","SE",
         "GLEE","MG","CXG","WE","KE","ARC","PC","BDC","DK","EXP","TGW","WC","SVU",
         "FR","SW","PKB","XF","ER","TIU","ONB","B99","BB","LK","BATB",
         "BC","RJ","LU","CH","NCIS","HAM","LW","TNG","SBSP"),
  name = c("Friends","Euphoria","How I Met Your Mother",
           "Game of Thrones","Futurama", "The Office",
           "Harry Potter","Grey's Anatomy","House",
           "Parks and Recreation","The Big Bang Theory","Succession",
           "Westworld", "30 Rock", "The Umbrella Academy","Gilmore Girls",
           "Schitt's Creek","Gossip Girl","The Simpsons","Scrubs",
           "Lord of the Rings","Bob's Burgers","Ted Lasso","The Walking Dead",
           "Bones","Archer","Ozark","Shameless","The Wire","The West Wing",
           "The Sopranos","Firefly + Serenity","Sense8", "Downton Abbey",
           "The Good Place","Marvel Cinematic Universe","It's Always Sunny in Philadelphia",
           "New Girl","Criminal Minds","Seinfeld","Gotham","Arrested Development",
           "Veep", "That 70's Show","Silicon Valley","Buffy the Vampire Slayer",
           "Modern Family","Yellowjackets","Stranger Things","Twin Peaks","Sex and the City",
           "Desperate Housewives","Mad Men","Battlestar Galactica","Avatar: The Last Airbender",
           "The Boys","South Park","Riverdale","Community","WandaVision","M*A*S*H","Dexter",
           "Scandal","Vikings", "The Witcher","Sherlock","Sex Education",
           "Glee","Mean Girls","Craze Ex-Girlfriend","Wynonna Earp","Killing Eve", "Arcane","Pirates of the Carribean",
           "Broad City","The Dark Knight","The Expanse","The Good Wife","White Collar","Law & Order: SVU",
           "Frozen","Star Wars","Peaky Blinders","The X-Files","ER","This Is Us","Orange is the New Black",
           "Brooklyn Nine-Nine","Breaking Bad","The Lion King","Beauty and the Beast",
           "The Breakfast Club","Romeo and Juliet","Lucifer","Calvin and Hobbes","NCIS","Hamilton",
           "Little Women","Star Trek: The Next Generation","SpongeBob SquarePants")
)


#Helper Functions ----
#Function to scrape characters based on universe ID
get_characters<-function(id){
    
  base_url='https://openpsychometrics.org/tests/characters/stats/'
  url=paste0(base_url,id)
  
  table=url%>%
    read_html()%>%
    html_elements("table")%>%
    .[1]
  
  data=table%>%
    html_table()%>%
    .[[1]]%>%
    rename(notability=1, name=2)
  
  href=table%>%
    html_elements("a")%>%
    html_attr("href")%>%
    str_replace("\\/","")
  
  #create IDs
  data$uni_id=id 
  data$uni_char_id = href
  data$id = paste0(data$uni_id,data$uni_char_id)
  data$link = paste0('https://openpsychometrics.org/tests/characters/stats/',id,"/",data$uni_char_id)
  data$image_link = paste0("https://openpsychometrics.org/tests/characters/test-resources/pics/",id,"/",data$uni_char_id,".jpg")
  data|>select(id, uni_id, name, notability, link, image_link)
}

#test function
get_characters("DH")


#Function to scrape personality stats by character url
get_stats<-function(url){
  html = url%>%read_html()
  
  character = html%>%
    html_elements("h3")%>%
    head(1)%>%
    html_text()
  
  data= html%>%
    html_elements("table.zui-table")%>%
    html_table()%>%
    .[[1]]
  
  names(data)=c("item","avg_rating","rank","rating_sd","number_ratings")
  data$character = str_replace(character," Descriptive Personality Statistics","")
  
  data
}

#Helper function to get myers brigs
get_mb<-function(url){
  html = url%>%read_html()
  
  character = html%>%
    html_elements("h3")%>%
    head(1)%>%
    html_text()
  
  data= html%>%
    html_elements("table")%>%
    html_table()%>%
    .[[3]]
  
  names(data)=c("myers_briggs","avg_match_score","number_users")
  data$character = str_replace(character," Descriptive Personality Statistics","")
  
  data
}

get_mb('https://openpsychometrics.org/tests/characters/stats/SUI/3')


#test function
get_stats("https://openpsychometrics.org/tests/characters/stats/DH/6/")


#Create for loop to collect characeters for all shows ----
df_characters<-data.frame()
for(id in df_universe$id){
  temp_data_char <- get_characters(id)
  df_characters<-rbind(df_characters,temp_data_char)
}


#Create for loop to collect stats for all characters
df_stats<-data.frame()
for(url in df_characters$link){
  temp_data_stats<-get_stats(url)
  temp_data_stats$char_id<-df_characters$id[df_characters$link==url]
  df_stats <-rbind(df_stats,temp_data_stats)
}



#Create for loop to collect myers-briggs match scores
df_myers_briggs<-data.frame()
for(url in df_characters$link){
  temp_data_mb<-get_mb(url)
  temp_data_mb$char_id<-df_characters$id[df_characters$link==url]
  df_myers_briggs <-rbind(df_myers_briggs,temp_data_mb)
}


#clean up characters
cleaned_characters<-df_characters%>%
  left_join(df_universe%>%rename(uni_name=name), by=c("uni_id"="id"))%>%
  select(id, name, uni_id, uni_name, notability, link, image_link)

#clean up stats
cleaned_stats<-df_stats%>%
  left_join(df_characters%>%select(id, uni_id), by=c("char_id"="id"))%>%
  left_join(df_universe, by=c("uni_id"="id"))%>%
  rename(uni_name=name, char_name=character)%>%
  mutate(personality=item)%>%
  separate(item, into=c("item1","item2"), sep=" \\(not ")%>%
  mutate(item2=str_replace(item2,"\\)",""))%>%
  rowwise()%>%
  mutate(question = paste(sort(c(item1,item2)), collapse="/"),
         personality = str_replace(personality, "\\s*\\([^\\)]+\\)",""),)%>%
  select(char_id, char_name, uni_id, uni_name, question, personality, avg_rating, rank, rating_sd, number_ratings)
 # select(char_id, char_name, uni_id, uni_name, item, avg_rating, rank, rating_sd, number_ratings) 


cleaned_mb<-df_myers_briggs%>%
  mutate(avg_match_score = as.numeric(str_replace(avg_match_score,"%","")))%>%
  left_join(df_characters%>%select(id, uni_id), by=c("char_id"="id"))%>%
  left_join(df_universe, by=c("uni_id"="id"))%>%
  rename(char_name=character, uni_name=name, avg_match_perc = avg_match_score)%>%
  select(char_id, char_name, uni_id, uni_name,myers_briggs, avg_match_perc, number_users)
  
  

write.csv(cleaned_characters, "characters.csv", row.names = FALSE)
write.csv(cleaned_stats, "psych_stats.csv", row.names=FALSE)
write.csv(cleaned_mb, "myers_briggs.csv",row.names=FALSE)
