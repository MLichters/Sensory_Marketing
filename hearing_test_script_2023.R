#clear workspace
rm(list = ls())

#load packages
if(!"pacman" %in% rownames(installed.packages())) install.packages("pacman")

library(pacman)

pacman::p_load(tidyverse, osfr, rstatix, hrbrthemes, broom, labelled)



#import data


d <- readxl::read_xlsx("hearing test.xlsx")


# model data with linear regression on age an visualize results by gender

model <- lm(d$frequency ~ d$age)

ggplot(d, aes(x=age, y=frequency, color=gender)) + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  geom_point(size=6) +
  theme_ipsum() +
  annotate(geom = "text", x = 27, y = 17000, label = paste("Model : ", 
                                                           round(model$coefficients[1], digits=2), 
                                                           " - " , 
                                                           abs(round(model$coefficients[2], digits=2)), 
                                                           "*years"  , "\n\n" , "R²(adjusted) = ", 
                                                           round(summary(model)$adj.r.squared, digits=2) 
                                                           ), hjust = "left")

summary(model)


#Is capability to hear high frequencies a function of the interaction between age and gender?

model_moderation_regression <- lm(frequency ~ age*gender, data = d)

summary(model_moderation_regression)


# do the same thing with process marco model 1

d <- d %>% as_tibble() 
d$gender <- d$gender %>% to_factor() %>% to_labelled()

d$gender

source("process.R")

process(
  data = d,
  y = "frequency",
  x = "age",
  w = "gender",
  model = 1,
  center = 2, jn = 1,
  moments = 1, modelbt = 1,
  boot = 5000, seed = 54545, progress = F,
  conf = 0.95
)
