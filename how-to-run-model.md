Running the Epidemia Model
================

Model developed by Imperial College London. Implemented by James
Ounsley, Nicky Agius, Barry Miller.

### Background

The Epidemia model is based on a bespoke R package developed by ICL
researchers to implement the Bayesian Semimechanistic model for
estimating the prevalence and growth of COVID-19 in Scotland.

The package is available on GitHub:
<http://imperialcollegelondon.github.io/epidemia>.

## Weekly model run protocol

### Phases and interventions data

The dates for the various countries entering equivalent phases for
Scotland needs to be checked and incorporated in to the model to capture
the latest information. This is encoded within
`data/country_phases_4.csv`. These are the interventions which relate to
the easing of restrictions and are expected to increase the rate of
transmission.

In addition, the file `data/interventions.csv` captures the dates of any
government interventions across differing countries which are used to
inform the model. These are the interventions which relate to the
imposing of restrictions and are expected to decrease the rate of
transmission.

### Observations data

The `data/observations.rds` file contains the observations
(cases/deaths) which are used to inform the model. For cases in
Scotland, this is compiled from the estimated number of cases as
indicated by the wastewater analysis. Cases for the other three UK
nations, and the number of deaths for all four nations are sourced from
the published numbers of confirmed deaths and cases. The model is
currently set up to only use the number of cases, but historically
deaths and deaths+cases have been used. We have also mostly used the
number of deaths in Scotland based on the NRS measures. The latter
deaths are management information only and so are not included here.

### Infection fatality ratio

The IFR is derived from the Scottish Contact Survey. Some additional
code, saved in the public datashare, is used to provide the actual
inputs to the model.

Epidemia can only provide a static IFR, for all countries. This is
inputted as an argument in `run_epidemia_1.0.R`, and is implemented by
changing the prior assumption on the deaths function within
`utils/constuct_epidemia_args.R`. When `USE_i2d` is set to false, the
code does not use this method, but instead reads off an alternative
infection to death distribution within the data folder. This method is
flawed and should not be used.

### Serial interval

The `serial_interval.csv` has the current assumptions for SI, and should
be updated if needed. This is also within the data folder.

When `USE_SI` is set to false, the model uses the default SI assumption
as given in EuropeCovid. When `Use_SI` is true, then the model uses the
data from `serial_interval.csv`.

### Countries

The countries to be included are listed in `regions.csv`. These
currently are the four UK nations.

## Running the model

The standard script to launch the model is `run_epidemia.R`, which takes
two arguments to specify the Rt model and the sampling level. For
instance,

`Rscript run_epidemia.r --rt_type="JANUARY_LOCKDOWN'
--sampling_level="FULL"`

These two arguments can be omitted; the model will then run using the
default parameters, as given in `run_epidemia_1.0.R`. The full
parameters behind the rt\_model and sampling specifications are located
in `utils/rt_models.R` and `utils\sampling_details.R` respectively.

As part of the model set up, a csv and txt file are generated within the
`results` folder. They should be checked to ensure that inputs look
correct. The JOBID should be noted and are recorded in the Scottish
Government model log.

## Post-processing

### Creating the table and chart outputs

The models to be run are informed by `data\model_input.csv`.Update this
with model details. This must have the headings `JOBID` and
`MODEL_DATE`.

These tables are run using `generate_outputs.R`. Update where the
results are to be saved by changing `results_fp` and run the script.
This reads the models to be run from `model_input.csv` above, and
creates all the required tables and charts, saved to
`results\DATE\epidemia`.
