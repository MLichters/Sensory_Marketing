---
title: "Sensory Marketing"
subtitle: 'Solutions - Exercise: The Light = Healthy Intuition'
author: "Uni.-Prof. Dr. Marcel Lichters"
date: "2021-07-13"
output:
  html_document: 
    df_print: default
    editor_options:
      chunk_output_type: console
    keep_md: yes
    number_sections: yes
    toc: yes
    toc_collapsed: yes
    toc_float: yes
  chunk_output_type: console
theme: lumen
bibliography: Citavi_Export2.bib
csl: apa.csl
---






**************************************************************

<a title="Follow me on ResearchGate" href="https://www.researchgate.net/profile/Marcel_Lichters?cp=shp"><img src="https://www.researchgate.net/images/public/profile_share_badge.png" alt="Follow me on ResearchGate" /></a>

[Connect with me on Open Science Framework](https://osf.io/u7hyz/) | 
[Contact me via LinkedIn](https://www.linkedin.com/in/lichters/) 

*Depending on your machine it might be necessary to use right-click -> open in new browser window.*

**************************************************************


R analysis script presenting the solutions for the exercise in Sensory Marketing regarding Li, Heuvinck, & Pandelaere [-@Li.2021]. In one of the questions students are asked to estimate the appropriate samples size for a replication of Study 1's findings (under $\alpha$=5%, Power=0.8).

> If this exercise grabs your attention, please check-out our study programs at the Chemnitz University of Technology by clicking on the logo (Germany): 
<a title="Chemnitz University of Technology" href="https://www.tu-chemnitz.de/wirtschaft/fakultaet/studiengaenge.php.en"><img src="TU_Chemnitz_Logo.png" alt="Chemnitz University of Technology" /></a>


# Loading packages that we will use

> Beware: *R* is a context-sensitive language. Thus, 'data' will be interpreted not in the same way as 'Data' will.

In *R* most functionality is provided by additional packages.  
Most of the packages are well-documented, See: https://cran.r-project.org/

The code chunk below first evaluates if the package [pacman](https://cran.r-project.org/web/packages/pacman/index.html) is already installed to your machine. If yes, the corresponding package will be loaded. If not, *R* will install the package. 

Alternatively, you can do this manually first by executing *install.packages("pacman")* and then *library(pacman)*.

The second line then loads the package *pacman*

The third line uses the function *p_load()* from the pacman package to install (if necessary) and load all packages that we provide as arguments (e.g., [pwr](https://cran.r-project.org/web/packages/pwr/index.html), which provides functions for *power analysis*).




```r
if(!"pacman" %in% rownames(installed.packages())) install.packages("pacman")

library(pacman)

pacman::p_load(tidyverse, dplyr, pwr, tidyselect, compute.es)
```


Here is the *R* session info which gives you information on my machine, all loaded packages and their version:


```r
sessionInfo()
```

```
## R version 4.1.0 (2021-05-18)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 19043)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=German_Germany.1252  LC_CTYPE=German_Germany.1252   
## [3] LC_MONETARY=German_Germany.1252 LC_NUMERIC=C                   
## [5] LC_TIME=German_Germany.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] compute.es_0.2-5 tidyselect_1.1.1 pwr_1.3-0        forcats_0.5.1   
##  [5] stringr_1.4.0    dplyr_1.0.6      purrr_0.3.4      readr_1.4.0     
##  [9] tidyr_1.1.3      tibble_3.1.2     ggplot2_3.3.3    tidyverse_1.3.1 
## [13] pacman_0.5.1    
## 
## loaded via a namespace (and not attached):
##  [1] xfun_0.23         bslib_0.2.5.1     haven_2.4.1       colorspace_2.0-1 
##  [5] vctrs_0.3.8       generics_0.1.0    htmltools_0.5.1.1 yaml_2.2.1       
##  [9] utf8_1.2.1        rlang_0.4.11      jquerylib_0.1.4   pillar_1.6.1     
## [13] glue_1.4.2        withr_2.4.2       DBI_1.1.1         dbplyr_2.1.1     
## [17] modelr_0.1.8      readxl_1.3.1      lifecycle_1.0.0   munsell_0.5.0    
## [21] gtable_0.3.0      cellranger_1.1.0  rvest_1.0.0       codetools_0.2-18 
## [25] evaluate_0.14     knitr_1.33        fansi_0.4.2       broom_0.7.6      
## [29] Rcpp_1.0.6        backports_1.2.1   scales_1.1.1      jsonlite_1.7.2   
## [33] fs_1.5.0          hms_1.1.0         digest_0.6.27     stringi_1.6.2    
## [37] grid_4.1.0        cli_2.5.0         tools_4.1.0       magrittr_2.0.1   
## [41] sass_0.4.0        crayon_1.4.1      pkgconfig_2.0.3   ellipsis_0.3.2   
## [45] xml2_1.3.2        reprex_2.0.0      lubridate_1.7.10  rstudioapi_0.13  
## [49] assertthat_0.2.1  rmarkdown_2.8     httr_1.4.2        R6_2.5.0         
## [53] compiler_4.1.0
```

********************************************************************


# Finding an answer to question #4

> For your master thesis it could be an idea to replicate the IAT-findings of Study 1. Based on a power analysis (Assumptions: $\alpha$=5%, Power=0.8), how many subjects should you recruit for such a study?


## Extract information on the effect size Cohen's d and the statistical analysis procedure

Information the article provides on page 3:

*The D-score was significantly greater than 0 (D = 0.45, SD = 0.47, t(133) = 10.98, p < .001, 95% CI = [0.37, 0.53], Cohen’s d = 0.95), suggesting that participants responded significantly faster in assigning the stimuli when healthy and light were grouped together.*

From this we are able to extract:

* The effect size measure Cohen's d equals 0.95.
* For analysis the authors applied a one sample t test, which tests against the constant value of 0.


## Conduct A priori power analysis to search for minimum n


In the question we are asked for a statistical power of 80% (a commonly used threshold in social sciences).

To estimate a minimum sample size n for the replication we apply the *pwr.t.test()* function from the [pwr](https://cran.r-project.org/web/packages/pwr/index.html) package. This function needs us to provide 6 arguments to fill its parameters. These are (see help by pressing 'F1' when setting the corsor into the function's name):

* d	= Effect size Cohen's d
* n	= Total number of observations
* sig.level	= Significance level (Type I error probability $\alpha$)
* power	= Power of test (1 minus Type II error probability)
* type = Type of t test: one- ("one.sample") two- ("two.sample") or paired-samples ("paired")
* alternative = parameter indicating the test strategy: one of "two.sided" (default), "greater" or "less"

The function, furthermore, assumes us to set one of the arguments (d, n, sig.level, or power) to **NULL**. By doing so, we tell the function to use the remaining 5 parameters to search for the value of the sixth. In our case, we are searching for 'n', therefore, we set 'n=NULL'. Furthermore, we are using a one sample t test and the original study expects the d score to be greater than 0. Therefore, we set alternative to "greater".

We assign the results of our power analysis to a new object named 'results'. Then we call for its content.



```r
results <- pwr.t.test(d = 0.95, n = NULL, type = "one.sample", sig.level = 0.05, power = 0.8, alternative = "greater")

results
```

     One-sample t test power calculation 

              n = 8.379928
              d = 0.95
      sig.level = 0.05
          power = 0.8
    alternative = greater

> We can see that the (conservatively rounded) calculated sample size 9 perfectly mirrors the one we have seen in G*Power 3 [@Faul.2007]. As discussed in our exercise, the authors of the study applied standard exclusion criteria for IAT procedures. Therefore, 1.49 times the sample size estimate (1.49 times 9 = 14) would be nessecary to end at n = 9 in the net sample.

Keep in mind: if an original study comes with a very large effect size, then a replication with a power of 80% often needs fewer subjects as compared to the original study. However, studies reporting only small effects usually need much more participants for a successful replication.

******************************************************************



# Additional reading *(not relevant for the exam)*

In the above-discussed example, we were planning a replication of the original findings.
In doing so, we have made certain assumptions:

We assume that the observed effect size Cohen's d = 0.95 is the true effect size to find. Strictly speaking, this is wrong. Our calculated value is only a sample estimate of the true effect size in the underlying population.
Under the assumption of knowing the true effect size we calculated that we need at least n=14 participants for a replication of the original findings with a power of 80%. This means that we will have approximately the chance of 80% to find the effect as to be significant at $\alpha$=0.05. Because, the true effect to find might, however, be smaller, this calculation may present an overly optimistic approach.
Therefore, other researchers prefer to focus on the confidence intervals for the estimate of effect sizes measures [@Thompson.2002].

To estimate the lower limit of the observed Cohen's d, we can apply a formula proposed by Hedges & Olkin [-@Hedges.1985]:

$d \pm se * z_{crit}$

Where se is the standard error given by:

$se = \sqrt{\frac{1}{n}+\frac{d^{2}}{2n}}$

and $z_{crit}$ is given by the standard normal distribution at p=0.95 ($\alpha$=5%).

Let us first calculate **se**. Table 4 in the article informs that n = 134 participants were used for analysis.
 


```r
se <- sqrt((1/134)+((0.95*0.95)/(2*134)))

se
```

```
## [1] 0.1040684
```

Next, let us determine the critical z-value ($\alpha$=5%). For this purpose we use the *qnorm()* function. We only have to provide the probability (95%) as well as the mean and standard deviation.


```r
z_crit <- qnorm(p = 0.95, mean = 0, sd = 1, lower.tail = TRUE)

z_crit
```

```
## [1] 1.644854
```

Finally, we calculate the lower limit of the 95% confidence interval of Cohen's d:


```r
d_lower95 <- 0.95 -se*z_crit

d_lower95
```

```
## [1] 0.7788228
```


The results tells us which lower Cohen's d to expect in the underlying population (0.78). This is an alternative to the classical t test. If we reach at a significant result here (i.e., the lower limit is not crossing 0), this means that the effect size obtained is significantly greater than 0. Put differently, the effect is assumed to exist in the underlying population. Researchers in the context effect domain are starting to report tests on effect sizes, especially, when their articles span over multiple studies [@Evangelidis.2018].

We can briefly calculate how this will change our assumptions about the minimum sample size.
We, again, use the *pwr.t.test()* function (see above). This time, we hand in **d_lower95** as the argument for the effect size parameter d.



```r
results_worst_case <- pwr.t.test(d = d_lower95, n = NULL, type = "one.sample", sig.level = 0.05, power = 0.8, alternative = "greater") 

results_worst_case 
```

     One-sample t test power calculation 

              n = 11.67058
              d = 0.7788228
      sig.level = 0.05
          power = 0.8
    alternative = greater

> We can see that the more conservative sample size is 12. Combined with the exclusion factor discussed above, we end at a (worst-case) gross sample n of 18.


************************************************************************

# List of References



