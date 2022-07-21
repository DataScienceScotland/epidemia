#Nicky Agius
#18/01/2021
#Generate report tables

#This piece of code generates the Epidemia report tables
# It will need to be sourced from the overall preprocessing script, so that the results feed in from there


# 1.0 Load libraries ------------------------------------------------------

library(epidemia)
library(tidyverse)
library(matrixStats)


# 2.0 Source key functions ------------------------------------------------

source('utils/plotting_functions.R')

# 3.0 Output function ------------------------------------------------

## 3.1 Rt data ------------------------------------------------

run_table <- function(country_index, total_output){
  
  
  #country_index <-"Scotland"
  levels <- c(0.05,0.25,0.5,0.75,0.95)
  
  print(paste0("Creating table for ", country_index))
  
  mu <- 6.5
  v <- 0.62
  a <- mu^2 / v
  b <- mu/v
  
  #these will feed in for other countries too
  rt <- posterior_rt(fit, newdata = newdata)
  
  #filter for country
  rt_output<- gr_subset(rt,country_index)
  
  dates <- filter(newdata, country == country_index) 
  
  #getting the percentiles of interest
  rt_finaloutput <- as.data.frame(colQuantiles(rt_output$draws, probs = levels) ) %>%
    mutate(Country=country_index, date = dates$date) %>%
    select(date, Country, "5%_RT"="5%", "25%_RT"="25%", "50%_RT"="50%", "75%_RT"="75%", "95%_RT"="95%")
  
  ## 3.2 Growth rates ------------------------------------------------
  
  growth <- rt_output
  growth$draws <- b*(rt_output$draws^(1/a)-1)
  
  growth_output <- as.data.frame(colQuantiles(growth$draws, probs = levels) ) %>%
    mutate(Country=country_index, date = dates$date) %>%
    select(date, Country, "5%_growth"="5%", "25%_growth"="25%", "50%_growth"="50%", "75%_growth"="75%", "95%_growth"="95%")
  
  
  ## 3.3 Infections data ------------------------------------------------
  
  #these will feed in for other countries too
  infec <- posterior_infections(fit, newdata=newdata)
  
  #filter for country
  infec_output <- gr_subset(infec,country_index)
  
  #getting the percentiles of interest
  infec_finaloutput <- as.data.frame(colQuantiles(infec_output$draws, probs = levels) ) %>%
    mutate(Country=country_index, date = dates$date) %>%
    select(date, Country, "5%_inf"="5%", "25%_inf"="25%", "50%_inf"="50%", "75%_inf"="75%", "95%_inf"="95%")
  
  ## 3.4 Deaths data ------------------------------------------------
  
  #these will feed in for other countries too
  deaths <- posterior_predict(fit, type="deaths", newdata = newdata)
  
  #filter for country
  deaths_output <- gr_subset(deaths,country_index)
  
  deaths_finaloutput <- as.data.frame(colQuantiles(deaths_output$draws, probs = levels) ) %>%
    mutate(Country=country_index, date = dates$date) %>%
    select(date, Country, "5%_deaths"="5%", "25%_deaths"="25%", "50%_deaths"="50%", "75%_deaths"="75%", "95%_deaths"="95%")
  
  ## 3.5 Combine data ------------------------------------------------
  
  #combine the tables into a single table
  
  output_table <- rt_finaloutput %>%
    left_join(growth_output, by=c("date", "Country")) %>%
    left_join(infec_finaloutput,by=c("date","Country")) %>%
    left_join(deaths_finaloutput,by=c("date","Country"))
  
  #output the results
  
  write.csv(output_table,paste0(results_fp,JOBID,"_output_table_",country_index,".csv"))
  total_output <- rbind(total_output, output_table)
  return(total_output)
}

total_output_table <- data.frame()

for (country_index in unique(newdata$country)) {
  total_output_table <- run_table(country_index, total_output_table)
}

print("Creating total output table")

write.csv(total_output_table,paste0(results_fp,JOBID,"_total_output_table.csv"))

print("Creating SPI submission table")

source('utils/spim_table.R')

print("Summarising")

#source('utils/summary_table.R')










