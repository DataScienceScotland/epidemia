#!/bin/bash
#SBATCH --job-name=pl_nrs_3_full		  	  # Job name
#SBATCH --ntasks=1                                # Run a single task - this is important for multi-thread jobs
#SBATCH --cpus-per-task=6                         # Number of CPU cores per task (note that each compute node has a total of 40 CPU cores, so must be <=40)
#SBATCH --mem=20gb                                # Job memory request
#SBATCH --time=7-00:00:00                         # Time limit days-hrs:min:sec
#SBATCH --output=pl_nrs_3_full_output_%j.log        # Standard output and error log

#SBATCH --partition=fast48core                    # COVID modelling node


# output working direcoty, hostname and start time
pwd; hostname; date

# load modules needed to run
# GCC needs to be loaded for cxx14 enabled compiler for stan 
module load gcc
export R_INSTALL_STAGED=false

# remember to set any other environement variabales etc if you need them

# run the base model with FULL enabled to get enough samples
Rscript run_epidemia_cases.R --rt_type="May_2022" --sampling_level="FULL" 

# output end time
date
