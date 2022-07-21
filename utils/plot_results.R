#Nicky Agius
#13/01/2021
#Code drafted to generate various outputs for the epidemia model

#B Miller, amended to produce Rmarkdown doc
  
JOBID <- model_to_run$JOBID
MODEL_DATE <- model_to_run$MODEL_DATE
arg_1 <- paste0("./results/epidemia_", JOBID, ".rds")

print(paste0("Creating outputs for ", JOBID))

fit <- readRDS(arg_1)

# Extend table for projections ----------------------------------------------------------------------

Projection <- 20

if (!"country" %in% colnames(fit$data)) {
  fit$data$country <- fit$data$group
}

newdata <- fit$data %>%
  ungroup() %>%
  select(-c("group"))

countries <- unique(newdata$country)

for (country_index in countries){

  nd_temp <- filter(newdata, country == country_index)
  nd_temp <- nd_temp[nd_temp$date==max(nd_temp$date),]

  for (i in 1:Projection){

    nd_temp$date <- nd_temp$date + 1
    if ("deaths" %in% colnames(nd_temp)) {nd_temp$deaths <- 0}
    if ("cases" %in% colnames(nd_temp)) {nd_temp$cases <- 0}

    newdata <- rbind(newdata, nd_temp)
  }
}

# 2.0 Create tables ----------------------------------------------------------------------

print("Creating output tables")

if ("deaths" %in% colnames(nd_temp)) {
   source('utils/generate_report_output_tables.R')
} else {
   source('utils/generate_report_output_tables_cases.R')
}

# # 3.0 Plot charts ----------------------------------------------------------------------

print("Creating charts")
if ("deaths" %in% colnames(nd_temp)) {
  source('utils/generate_report_output_charts.R')
} else {
   source('utils/generate_report_output_charts_cases.R')
}


