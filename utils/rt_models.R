#### 11 R_ SPECIFICATION ####
#
# The following define configurations of the specification of the covariate
# structure on Rt. It would appear that epidemia is somewhat restrictive in 
# the way that Rt is defined, opting for a logit functional form as opposed
# to an exponential form as in Flaxman et al 2020.
#
#
#

rt_type <- list()
model_desc <- list()

# On lockdown is included as an imposed intervention,
# all phases and a end of summer covariate are added

rt_type[['JANUARY_LOCKDOWN']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + p2 + p3 + summer_end,
  prior = shifted_gamma(shape=1/8, scale=1, shift = log(1.05)/8),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['JANUARY_LOCKDOWN']] <- "All interventions to January. No new variant"

rt_type[['REDUCED_JANUARY_LOCKDOWN']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end,
  prior = shifted_gamma(shape=1/6, scale=1, shift = log(1.05)/6),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['REDUCED_JANUARY_LOCKDOWN']] <- "All interventions to January, reduced phases. No new variant"

rt_type[['JANUARY_LOCKDOWN_NEW_VARIANT']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + p2 + p3 + summer_end + new_variant,
  prior = shifted_gamma(shape=1/9, scale=1, shift = log(1.05)/9),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['JANUARY_LOCKDOWN_NEW_VARIANT']] <- "All interventions to January. New variant included."


rt_type[['REDUCED_JANUARY_LOCKDOWN_NEW_VARIANT']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['REDUCED_JANUARY_LOCKDOWN_NEW_VARIANT']] <- "All interventions to January, reduced phases. New variant included."

rt_type[['REDUCED_PHASES_NEW_VARIANT']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + 
    # Lifting intervention covariates
    p1 + summer_end + new_variant,
  prior = shifted_gamma(shape=1/6, scale=1, shift = log(1.05)/6),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['REDUCED_PHASES_NEW_VARIANT']] <- "All interventions to October measures, reduced phases. New variant included."

rt_type[['PHASED_SCHOOLS']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + new_interventions +  p1 + summer_end + new_variant + january_lockdown + phased_schools || country)  + 
	lockdown + new_interventions + p1 + summer_end + new_variant + january_lockdown + phased_schools,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['PHASED_SCHOOLS']] <- "All interventions to January lockdown. Reduced phases, new variant, phased schools."

rt_type[['FURTHER_RELAXATIONS']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + new_interventions +  p1 + summer_end + new_variant + january_lockdown + further_relaxations || country)  + 
	lockdown + new_interventions + p1 + summer_end + new_variant + january_lockdown + further_relaxations,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['FURTHER_RELAXATIONS']] <- "All interventions to January lockdown. Reduced phases, new variant, further April relaxations."

rt_type[['REDUCED_JANUARY_LOCKDOWN_NEW_VARIANT_RW']] <- epirt(
  formula = R(country, date) ~ 
0 + (1 + lockdown + new_interventions +  p1 + summer_end + new_variant + january_lockdown || country)  + 
lockdown + new_interventions + p1 + summer_end + new_variant + january_lockdown +
   rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['REDUCED_JANUARY_LOCKDOWN_NEW_VARIANT_RW']] <- "All interventions to January, reduced phases. New variant included. Country specific random walk"

# Multiple Countries, country specific weekly effect via random walk
# https://imperialcollegelondon.github.io/epidemia/articles/TimeDependentR.html
rt_type[['JANUARY_LOCKDOWN_RW']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + p2 + p3 + summer_end +
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/8, scale=1, shift = log(1.05)/8),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['JANUARY_LOCKDOWN_RW']] <- "All interventions to January. No new variant, country specific RW."

# Single Country, Random Walk 
rt_type[['JANUARY_LOCKDOWN_RW1']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + p2 + p3 + summer_end +
    rw(time=week),
  prior = shifted_gamma(shape=1/8, scale=1, shift = log(1.05)/8),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
model_desc[['JANUARY_LOCKDOWN_RW1']] <- "All interventions to January. No new variant, general RW."

# ------------------------- temp ----------------------------

rt_type[['RANDOM_WALK_1']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# THIS ONE IDENTICAL TO RECENT RUNS

rt_type[['RANDOM_WALK_2']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/8, scale=1, shift = log(1.05)/8),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# SAME AS R_W_1, BUT WITH DIFFERNT PRIORS

rt_type[['RANDOM_WALK_3']] <- epirt(
  formula = R(country, date) ~ 1 + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# SAME AS R_W_1, BUT WITH NO PARTIAL POOLING

rt_type[['RANDOM_WALK_4']] <- epirt(
  formula = R(country, date) ~ 1 + lockdown + new_interventions + (january_lockdown || country) +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# PARTIAL POOLING ON JAN_LOCKDOWN

rt_type[['RANDOM_WALK_5']] <- epirt(
  formula = R(country, date) ~ (lockdown || country) + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# REMOVED DUPLICATE LOCKDOWN IN RW1

rt_type[['RANDOM_WALK_6']] <- epirt(
  formula = R(country, date) ~ (lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant || country) +
    rw(time=week, gr=country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# PARTIAL POOLING ON ALL INTERVENTIONS

rt_type[['RANDOM_WALK_7']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + january_lockdown +
    # Lifting intervention covariates
    p1 + summer_end + new_variant+
    rw(time=week),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)
# COUNTRY GENERAL RANDOM WALK

# ----------------------------------------------------------------------------------

# Trying alternative pooling arrangements for interventions.

rt_type[['RP_0']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_1']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/6, scale=1, shift = log(1.05)/6),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_2']] <- epirt(
  formula = R(country, date) ~ 1  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_3']] <- epirt(
  formula = R(country, date) ~ 1  + (0 + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown | country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_4']] <- epirt(
  formula = R(country, date) ~ 1  + (lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown | country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_5']] <- epirt(
  formula = R(country, date) ~ 
        lockdown + new_interventions + p1 + summer_end + new_variant + january_lockdown +                         
        (lockdown + new_interventions + p1 + summer_end + new_variant + january_lockdown || country),
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['RP_6']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + new_interventions +  p1 + summer_end + new_variant + january_lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)



rt_type[['RP_6A']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + new_interventions +  p1 + summer_end + new_variant + january_lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale = 1, shift = log(1.05)/7),
  prior_covariance = decov(shape = c(2, rep(0.5, 6)),scale=0.25),
  link = scaled_logit(6.5)
)
# set up using the rt closest to documentation

rt_type[['RP_7']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(7) 
)

rt_type[['RP_8']] <- epirt(
  formula = R(country, date) ~ (lockdown || country)  + lockdown + new_interventions + 
    p1 + summer_end + new_variant + january_lockdown,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(5) 
)

rt_type[['RW_only']] <- epirt(
  formula = R(country, date) ~ 0 + rw(time=week, prior_scale=0.1)
)

rt_type[['REDUCED']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + january_lockdown + further_relaxations || country)  +
	lockdown + january_lockdown + further_relaxations,
  prior = shifted_gamma(shape=1/3, scale=1, shift = log(1.05)/3),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['REDUCED_1']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + summer_end + january_lockdown + further_relaxations || country)  +
	lockdown + summer_end + january_lockdown + further_relaxations, 
  prior = shifted_gamma(shape=1/4, scale=1, shift = log(1.05)/4),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['school_holidays']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + lockdown + summer_end + january_lockdown + further_relaxations + school_holidays || country)  +
	lockdown + summer_end + january_lockdown + further_relaxations + school_holidays,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['level_zero']] <- epirt(
 formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero || country)  + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5) 
)

rt_type[['september_2021']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero + september_2021 || country)  + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero + september_2021,
  prior = shifted_gamma(shape=1/6, scale=1, shift = log(1.05)/6),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['level_zero2']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero || country)  + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero,
  prior = shifted_gamma(shape=1/100, scale=500, shift = log(50)/5),
  prior_intercept = rstanarm::normal(log(5), 0.5),
  link = 'log'
)


rt_type[['level_zero_no_schools']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + level_zero || country)  +
        summer_end + january_lockdown + further_relaxations + level_zero,
  prior = shifted_gamma(shape=1/4, scale=1, shift = log(1.05)/4),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['COP1']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero + september_2021 + COP || country)  + summer_end + january_lockdown + further_relaxations + school_holidays + level_zero + september_2021 + COP,
  prior = shifted_gamma(shape=1/7, scale=1, shift = log(1.05)/7),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['COP2']] <- epirt(
  formula = R(country, date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + september_2021 + COP || country)  + summer_end + january_lockdown + further_relaxations + september_2021 + COP,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['Omicron1']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + september_2021 + COP + Omicron1 || country) + summer_end + january_lockdown + further_relaxations + september_2021 + COP + Omicron1,
  prior = shifted_gamma(shape=1/6, scale=1, shift = log(1.05)/6),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)



rt_type[['Omicron2']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + summer_end + january_lockdown + further_relaxations + september_2021 + Omicron1 || country) + summer_end + january_lockdown + further_relaxations + september_2021 + Omicron1,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['Omicron3']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + january_lockdown + further_relaxations + september_2021 + Omicron1 || country) +  january_lockdown + further_relaxations + september_2021 + Omicron1,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['ONS1']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + Omicron1 || country) +  Omicron1,
  prior = shifted_gamma(shape=1/2, scale=1, shift = log(1.05)/2),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['ONS2']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + Omicron1 || country) +  Omicron1,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['ONS3']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + Omicron1 + post_christmas || country) +  Omicron1 + post_christmas,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['ONS4']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + post_christmas || country) +  post_christmas,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['LFD']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + further_relaxations + september_2021 +  Omicron1 + post_christmas || country) + further_relaxations + september_2021 +  Omicron1 + post_christmas,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['indoor_open']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + further_relaxations + september_2021 +  Omicron1 + post_christmas + indoor_open || country) + further_relaxations + september_2021 +  Omicron1 + post_christmas + indoor_open,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['March_fall']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + further_relaxations + september_2021 +  Omicron1 + post_christmas + indoor_open + March_fall || country) + further_relaxations + september_2021 +  Omicron1 + post_christmas + indoor_open + March_fall,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)


rt_type[['April_relaxation']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + further_relaxations + september_2021 + Omicron1 + post_christmas + indoor_open + March_fall + no_mask_mandate || country) + further_relaxations + september_2021 + Omicron1 + post_christmas + indoor_open + March_fall + no_mask_mandate,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

# delete all above, to leave only below


rt_type[['May_2022']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + inc5 + decr1 + inc8 + decr2 + inc10 + inc11 || country) + inc5 + decr1 + inc8 + decr2 + inc10 + inc11,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)

rt_type[['May_2022_2']] <- epirt(
  formula = R(country,date) ~ 0 + (1 + inc5  + decr1 + inc8 + decr2 + inc10 + inc11 + inc12 || country) + inc5 + decr1 + inc8 + decr2 + inc10 + inc11 + inc12,
  prior = shifted_gamma(shape=1/5, scale=1, shift = log(1.05)/5),
  prior_intercept = rstanarm::normal(location=0, scale = 0.5),
  link = scaled_logit(6.5)
)



if(!(RT_TYPE %in% names(rt_type)))
  stop(paste0("No valid option for specified Rt type ",RT_TYPE))



