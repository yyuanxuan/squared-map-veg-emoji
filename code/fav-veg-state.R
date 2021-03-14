library(tidyverse)
library(ggtext)

state_location<-read.csv("data/state-location-grid.csv") %>% 
  dplyr::arrange(name)

state_location %>%
  ggplot()+
  geom_text(aes(x=x,y=y,label=code))

state_veg<-read.csv("data/state-fav-veg.csv")

emoji_pic<-data.frame(
  vegetatble = c("Broccoli", "Tomato",   "Carrot",   "Cucumber", "Corn"),
  emoji_link = c("img/broccoli_1f966.png",
                 "img/tomato_1f345.png",
                 "img/carrot_1f955.png",
                 "img/cucumber_1f952.png",
                 "img/ear-of-corn_1f33d.png"
  )
)

func_link_to_img <- function(x, size = 30) {
  paste0("<img src='", x, "' width='", size, "'/>")
}

state_veg<-state_veg %>% 
  left_join(state_location, by = c("name" = "name")) %>%
  left_join(emoji_pic,by=c("vegetable"="vegetatble"))
  

state_veg$vegetable<-factor(state_veg$vegetable,levels=c("Broccoli", "Tomato",   "Carrot",   "Cucumber", "Corn"))

head(state_veg)

ggplot()+
  geom_text(data = state_veg ,aes(x=x,y=(y-0.35),label=code),
            color="black",size=7,alpha=0.6,family="Arial Black")+ # add Abbreviations
  geom_text(data = state_veg ,aes(x=(x+0.01),y=(y-0.32),label=code,color=vegetable),
            size=7,alpha=1,family="Arial Black")+ # add a shade for the Abbreviations
  geom_text(aes(x=9.5,y=0.87),
            label="Data source \nhttps://www.thedailymeal.com/\neat/popular-vegetable-us-states\nTwitter @yyuanxuan",
            color="#bc8420",
            size=2,hjust = 0,family="Impact")+
  geom_text(aes(x=5.5,y=7.6),label="Most Popular Vegetable \nby State in US",color="#393E46",
            size=6,family="Silom")+
  geom_richtext(
    data = state_veg,
    aes(x=x,y=y,label=func_link_to_img(emoji_link)),
    fill= NA,label.color = NA)+ # remove background and outline
  scale_color_manual(values = c("#739e3b","#d9534f","#FD7013","#AFEAAA","#FFD800"))+
  xlim(0,12)+
  ylim(0,8.5)+
  theme_minimal()+
  coord_fixed()+
  theme(axis.title.x =element_blank(),
        axis.title.y = element_blank(),
        axis.text=element_blank(),
        panel.grid=element_blank(),
        strip.text=element_blank(),
        plot.background = element_rect(fill = "#fff1c1",color="#fff1c1"),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5,vjust=-10)
        
  )

ggsave(plot = last_plot(),filename = "img/veg-map.png",height=12.2,width=17, unit="cm")

