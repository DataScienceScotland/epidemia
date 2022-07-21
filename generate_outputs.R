library(readr)
library(tidyverse)
library(bayesplot)
library(epidemia)
library(rstanarm)
library(cowplot)
library(dplyr)
library(optparse)
library(stringr)
library(ggplot2)
library(lubridate)
library(scales)

# update this to show where outputs saved. you may need to create the folder first.

results_fp <- "./results/2022_04_22/" 

# update the evaluation date.
evaluation_date <- "2022_04_12"


# this does not need updating. values prior to the first intervention point are not converging well. take values after this date only
min_date <- "2021_05_09"

if (!dir.exists(results_fp)){
  dir.create(results_fp)
}

# you only need to add the JOBID to this csv.
model_inputs <- read_csv('data/model_inputs.csv')
print("Post processing the following model outputs.")
print(model_inputs)

for (run in 1:nrow(model_inputs)){

  model_to_run <- model_inputs[run,]
  source("utils/plot_results.R") 
  
}

