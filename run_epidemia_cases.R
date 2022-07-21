# Main file for running different configurations of the model with specified
# level of sampling
#
# This script is designed to be run from the command line with appropriate command
# line configuration (see optparse below or run `Rscript run_epidemia.R -h` for 
# help.
#

library(optparse)
library(rstanarm)
library(epidemia)
library(tidyverse)
library(lubridate)

# Assumption basis. If false, uses EuropeCovid2 assumptions
USE_SI <- TRUE
USE_i2d <- FALSE

ONS_start <- "2021-03-01"

EuropeCOVID_ifr = .01   #  ifr assumptions used in EuropeCovid. Fixed.
SEED <- as.character(abs(round(rnorm(1) * 10000)))

system.time({  
print(now())

# take options from Option Parser
parser <- OptionParser()
parser <- add_option(parser,"--sampling_level", default="DEBUG", 
                     help = "Number of iterations and sampling parameters to use [default \"%default\"], valid options: DEBUG, FULL, MEDIUM, SHORT")
parser <- add_option(parser,"--rt_type", default="May_2022", 
                     help = "Covariate structure on Rt [default \"%default\"]")

cmdoptions <- parse_args(parser, args = commandArgs(trailingOnly = TRUE), positional_arguments = TRUE)
SAMPLING_LEVEL <- cmdoptions$options$sampling_level
RT_TYPE <- cmdoptions$options$rt_type
options(mc.cores = parallel::detectCores())

source('./utils/sampling_details.R')
source('./utils/rt_models.R')

#### CONSTRUCT EPIDEMIA ARGS ####

# Construct the object for epidemia run

source('./utils/construct_epidemia_args.R')
args <- construct_default_epidemia_args()

print(paste('Running epidemia model with: '))
print(paste('SAMPLING_LEVEL =',SAMPLING_LEVEL))
print(paste('RT_TYPE =',RT_TYPE))
print(paste('SEED =',SEED))

#### GET JOBID ####

# Set a unique JOBID for this run
JOBID = Sys.getenv("SLURM_JOBID")
if(JOBID == "")
  JOBID = as.character(abs(round(rnorm(1) * 1000000)))
print(sprintf("Jobid = %s",JOBID))

#### CREATE DEBUG DOC ####

source('./utils/print_debug.R')

#### RUN THE MODEL ####

fit <- do.call("epim", args)

#### SAVE RESULTS ####
saveRDS(fit,paste0('./results/epidemia_',JOBID,'.rds'))

print('Model finished')
print(sprintf("Jobid = %s",JOBID))
print(now())

})
