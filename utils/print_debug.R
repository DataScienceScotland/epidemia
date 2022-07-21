library(tidyr)
library(dplyr)
library(lubridate)

debug_fn <- paste0("./results/debug_output_", JOBID, ".txt")
sink(debug_fn)

print(now())
print(paste0('JOBID = ', JOBID))
print(paste0('Running epidemia model with: '))
print(paste0('SAMPLING_LEVEL =',SAMPLING_LEVEL))
print(paste0('RT_TYPE =',RT_TYPE))
print(paste0('IFR =',read_ifr()))
#print(paste0('case rate = ', read_case_rate()))

model_inputs <- args$data

data_fn <- paste0("./results/debug_",SAMPLING_LEVEL,"_",RT_TYPE,"_",JOBID,".csv")
write.csv(model_inputs, data_fn)
print(paste0("Saving input data as ", data_fn, "."))

date_check <- model_inputs %>% group_by(country) %>%
  summarise(min_date = min(date), 
            max_date = max(date))

print(date_check)

sink()

