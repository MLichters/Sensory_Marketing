

if(!"pacman" %in% rownames(installed.packages())) install.packages("pacman")

library(pacman)

pacman::p_load(tidyverse, dplyr, tidyselect, osfr, rstatix, hrbrthemes, rstatix, broom)


d <- readxl::read_xlsx("hearing test.xlsx")


model <- lm(d$frequency ~ d$Age)

ggplot(d, aes(x=Age, y=frequency, color=Gender)) + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  annotate(geom = "text", x = 27, y = 17000, label = paste("Model : ", 
                                                           round(model$coefficients[1], digits=2), 
                                                           " + " , 
                                                           round(model$coefficients[2], digits=2), 
                                                           "*years"  , "\n\n" , "R²(adjusted) = ", 
                                                           round(summary(model)$adj.r.squared, digits=2) 
                                                           ) , hjust = "left") +
  geom_point(size=6) +
  theme_ipsum()


Frequency_ANOVA <- d %>% anova_test(frequency~ Age*Gender)

print(Frequency_ANOVA, 
      digits = 3)

tibble(Frequency_ANOVA)
