library(tidyverse)
library(lubridate)


#  Read in and format list of countries to include in model
read_countries_list <- function(){
  countries <- read_csv('data/regions.csv') %>% rename(country = Regions)
  return(countries)
}

#  Read in and format data on deaths by country
read_observation_data <- function(countries){

  obs_data <- readRDS('./data/observations.rds') %>% 
  	   select(date = Date,
                  country = Country,
                  cases = Cases,
                  deaths = Deaths) %>%
           filter(date >= ONS_start) %>%
           select(country, date, cases, deaths)

# Reduce to just countries of interest
  obs_data <- countries %>% left_join(obs_data)
 
 print(obs_data)

 return(obs_data)
}

#  Read in and format intervention dates
read_interventions <- function(countries){

  interventions = read.csv('data/interventions.csv', stringsAsFactors = FALSE)

  # need to amend next line if additional interventions are added. These all have impact of DECReasing transmission
  names_interventions = c('decr1', 'decr2', 'decr3') 
  interventions <- interventions[interventions$Type %in% names_interventions,c(1,2,4)]  
  interventions <- spread(interventions, Type, Date.effective) 
  names(interventions) <- c('country', 'decr1', 'decr2', 'decr3')

  interventions <- interventions[c('country', 'decr1', 'decr2', 'decr3')] %>%    
           mutate(
           decr1 = as.Date(interventions$decr1, format = "%d.%m.%Y"),
           decr2 = as.Date(interventions$decr2, format = "%d.%m.%Y"),
           decr3 = as.Date(interventions$decr3, format = "%d.%m.%Y"))
    
# get only countries of interest

  interventions <- countries %>% left_join(interventions, by = 'country')  

  print(interventions)
  return(interventions)
}

#  Read in and format phased relaxation of interventions. These should all have the impact of INCreasing transmission
read_phases <- function(countries){
  no_data_date <- dmy('01-01-2030')     # arbitrarily chosen, a date after all others  
  phases <- read_csv('data/country_phases_4.csv') %>% rename("country"="Country")
  phases <- left_join(countries, phases, by="country") %>% 
    # Convert to dates and add summer_end
    mutate(p1 = dmy(`Phase 1`),p2 = dmy(`Phase 2`),p3 = dmy(`Phase 3`), p4 = dmy(`Phase 4`), inc1 = dmy(inc1), inc2 = dmy(inc2), inc3 = dmy(inc3), inc4 = dmy(inc4), inc5 = dmy(inc5), inc6 = dmy(inc6), inc7 = dmy(inc7), inc8 = dmy(inc8), inc9 = dmy(inc9), inc10 = dmy(inc10), inc11 = dmy(inc11), inc12 = dmy(inc12)) %>% 
    select(country,p1,p2,p3,p4,inc1,inc2,inc3,inc4,inc5,inc6,inc7,inc8,inc9,inc10,inc11,inc12) %>%
    replace_na(list(p1=no_data_date,p2=no_data_date,p3=no_data_date,p4=no_data_date,inc1=no_data_date,inc2=no_data_date,inc3=no_data_date,inc4=no_data_date,inc5=no_data_date,inc6=no_data_date,inc7=no_data_date,inc8=no_data_date,inc9=no_data_date,inc10=no_data_date,inc11=no_data_date,inc12=no_data_date))

  print(phases)
  return(phases)
}

read_SI <- function(){
  serial_interval <- read_csv('./data/serial_interval.csv')
  serial_interval <- as.numeric(serial_interval[[1]])
  return(serial_interval)
}

read_i2d <- function(){
  i2d <- read_csv('./data/i2d.csv')
  i2d <- as.numeric(i2d[[1]])
  return(i2d)
}

read_ifr <- function(){
  ifr <- read_csv('./data/ifr.csv')[[1]]
  return(ifr)
}

read_case_rate <- function(){
  case_rate <- read_csv('./data/case_rate.csv')[[1]]
  return(case_rate)
}
