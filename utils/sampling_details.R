#### SAMPLING SPECIFICATION ####

sampling_level <- list()
sampling_level[['DEBUG']] <- list(iter=40,seed=SEED,warmup=20,chain=2)
sampling_level[['LONG']] <- list(iter=3000,seed=SEED,warmup=2000,chain=8,thin=1,control=list(adapt_delta=0.95,max_treedepth=15))
sampling_level[['FULL']] <- list(iter=1800,seed=SEED,warmup=1000,chain=5,thin=1,control=list(adapt_delta=0.95,max_treedepth=15))
sampling_level[['MEDIUM']] <- list(iter=1350,seed=SEED,warmup=750,chain=4,thin=1,control=list(adapt_delta=0.95,max_treedepth=15))
sampling_level[['SHORT']] <- list(iter=1000,seed=SEED,warmup=500,chain=3,thin=1,control=list(adapt_delta=0.95,max_treedepth=11))

if(!(SAMPLING_LEVEL %in% names(sampling_level)))
  stop(paste0("No valid option for specified sampling level ",SAMPLING_LEVEL))
