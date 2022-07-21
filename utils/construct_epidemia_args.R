
source('utils/read_data.R')
data("EuropeCovid2")

#' Create epidemia arguments object matching Flaxman et al. 2020
#' adjusted to take account of requirements for Scottish modelling and
#' latest data, including relaxation of interventions
construct_default_epidemia_args <- function(){
 
  # Load various data sources
 countries <- read_countries_list()
 model_data <- read_observation_data(countries)
 intervention_dates <- read_interventions(countries)
  phases_dates <- read_phases(countries)
  serial_interval <- read_SI()
  i2d <- read_i2d()
  sg_ifr <- read_ifr()
  ifr_scale = sg_ifr/EuropeCOVID_ifr	#	this scale is used in utils/construct_epidemia_args.R to specify prior for deaths
  case_rate = read_case_rate()

  model_data <- model_data %>% 
    
    ####### INTRODUCTION OF INTERVENTIONS ##########
  # Combine with data on implementation of interventions
  # Code interventions as 0 prior to implementation, 1 afterward
  # Add additional interventions here if required
  left_join(intervention_dates) %>% 
  mutate(
         decr1 = ifelse(decr1 > date,0,1),
         decr2 = ifelse(decr2 > date,0,1),
         decr3 = ifelse(decr3 > date,0,1))  %>%
 
    ###### LIFTING OF INTERVENTIONS #################
  # Combine with data on lifting of interventions
  # Code interventions as 0 prior to lockdown, 1 during lockdown, and
  # 0 after relaxation
  left_join(phases_dates) %>% 
  mutate(p1 = ifelse( (date > p1),0,1),
         p2 = ifelse( (date > p2),0,1),
         p3 = ifelse( (date > p3),0,1),
         p4 = ifelse( (date > p4),0,1),
         inc1 = ifelse((date>inc1),0,1),
         inc2 = ifelse((date>inc2),0,1),
         inc3 = ifelse((date>inc3),0,1),
         inc4 = ifelse((date>inc4),0,1),
         inc5 = ifelse((date>inc5),0,1),
         inc6 = ifelse((date>inc6),0,1),
         inc7 = ifelse((date>inc7),0,1),
         inc8 = ifelse((date>inc8),0,1),
         inc9 = ifelse((date>inc9),0,1),
         inc10 = ifelse((date>inc10),0,1),
         inc11 = ifelse((date>inc11),0,1),
         inc12 = ifelse((date>inc12),0,1))

  if (USE_SI) {si <- serial_interval} else {si = EuropeCovid2$si}
  si_sum <- sum(si)
  si <- si / si_sum

  if (USE_i2d) {inf2death <- i2d} else {inf2death = EuropeCovid2$inf2death}
  i2d_sum <- sum(inf2death)
  inf2death <- inf2death / i2d_sum
  
  #add in cases and infections

  inf <- epiinf(gen=si,seed_days=6)

  cases <- epiobs(formula = cases ~ 1, prior_intercept = rstanarm::normal(location=1, scale=0.02),
 		link = scaled_logit(case_rate), i2o = rep(1,1))

  args1 <- list(rt=rt_type[[RT_TYPE]],inf=inf,obs=cases,data=model_data,
               iter=sampling_level[[SAMPLING_LEVEL]]$iter,seed=sampling_level[[SAMPLING_LEVEL]]$seed,chain=sampling_level[[SAMPLING_LEVEL]]$chain, 
               warmup=sampling_level[[SAMPLING_LEVEL]]$warmup)

  return(args1)			  


}
