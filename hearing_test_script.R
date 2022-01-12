

if(!"pacman" %in% rownames(installed.packages())) install.packages("pacman")

library(pacman)

pacman::p_load(tidyverse, dplyr, tidyselect, osfr, rstatix, hrbrthemes)


d <- readxl::read_xlsx("hearing test.xlsx")


ggplot(d, aes(x=Age, y=frequency, color=Gender)) + 
  geom_point(size=6) +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum()


