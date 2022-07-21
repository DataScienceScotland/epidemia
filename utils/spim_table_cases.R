library(readr)
library(readxl)
library(lubridate)#
library(gtools)



# The template has a place holder row to define columns type,
# remove it once read in.
template <- read_xlsx('./data/spi_m_template.xlsx',sheet = "Template") %>% 
  filter(Group != "TEMPLATE")

gp <- "ScottishGovernment"
mdl <- "Epidemia_wastewater_Scot"
mdl_type <- 'Multiple'
age_band <- 'All'
version <- 3
creation_date <- dmy(MODEL_DATE)
kappa_value_type <- "kappa"
kappa_value <- 0.3844
mgt_value <- 6.5

cn <- c("Geography","time","Quantile 0.05","Quantile 0.25","Quantile 0.5","Quantile 0.75","Quantile 0.95")

output_countries <- unique(total_output_table$Country)

rt_tbl <- total_output_table %>% select(Country,date, '5%_RT', '25%_RT', '50%_RT', '75%_RT', '95%_RT')
growth_tbl <- total_output_table %>% select(Country,date, '5%_growth', '25%_growth', '50%_growth', '75%_growth', '95%_growth')
cases_tbl <- total_output_table %>% select(Country,date, '5%_inf', '25%_inf', '50%_inf', '75%_inf', '95%_inf')
  
colnames(rt_tbl) <- cn
colnames(growth_tbl) <- cn
colnames(cases_tbl) <- cn

kappa_row <- tibble(Geography=output_countries,time=creation_date,med=kappa_value,min=kappa_value,
                      lq=kappa_value,uq=kappa_value,max=kappa_value)
colnames(kappa_row) <- cn
  
mgt_row <- tibble(Geography=output_countries,time=creation_date,med=mgt_value,min=mgt_value,
                    lq=mgt_value,uq=mgt_value,max=mgt_value)
colnames(mgt_row) <- cn
  
spi_table <- bind_rows("kappa"=kappa_row,"mean_generation_time"=mgt_row,
                         R=rt_tbl,growth_rate=growth_tbl,
                         incidence=cases_tbl,.id="ValueType")
  
spi_table$Scenario <- 'Nowcast'

spi_table <- spi_table %>%
    mutate(Geography = replace(Geography,Geography=="NI","Northern Ireland"),
           Group = gp, Model=mdl, ModelType=mdl_type, Version=version,
           `Creation Day` = day(creation_date),
           `Creation Month` = month(creation_date),
           `Creation Year` = year(creation_date),
           `Day of Value` = day(time),
           `Month of Value` = month(time),
           `Year of Value` = year(time),
           'AgeBand' = age_band) %>% select(-time)
  
spi_table <- template %>% bind_rows(spi_table) 

write_csv(spi_table,paste0(results_fp,"spi_m_submission_4n_",JOBID,".csv"), na="")

spi_tbl_Scotland <- spi_table %>% filter(Geography == "Scotland")

write_csv(spi_tbl_Scotland,paste0(results_fp,"spi_m_submission_Scotland_",JOBID,".csv"),na="")
