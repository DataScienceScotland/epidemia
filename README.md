
## Scottish Government Covid-19 Modelling

### Epidemia

This model uses the [Flaxman
methodology](https://www.imperial.ac.uk/media/imperial-college/medicine/sph/ide/gida-fellowships/Imperial-College-COVID19-Europe-estimates-and-NPI-impact-30-03-2020.pdf)
to calculate the short-term estimates of R, growth and incidence. The
academics behind this methodology also developed a bespoke
[package](http://imperialcollegelondon.github.io/epidemia) in which to
implement it. We use this package with adjustments to the original model
to account for later policy changes, updated epidemiological parameters
and to allow for Scotland to be included.

The model uses a time series of observables (deaths, cases, wastewater)
and a mechanistic set of scenarios to define the
restrictions/relaxations. The model uses Bayesian inference to fit the
incidence or deaths to the set of observables and uses this to estimate
R and growth.

The sources of data for the model are:

  - Cases from Public Health Scotland (PHS) or UK Government; Rest of UK
    deaths from UK Government; Scottish deaths from National Records of
    Scotland (NRS) (management information only). Daily time series are
    used. Deaths are by date of death; cases by date of specimen.
    Recently, the number of LFD tests is included in the definition for
    Scotland and England. Where non-UK observables are used, John
    Hopkins University data is used.

  - Wastewater from BioSS. This is provided as a weekly time series, and
    is spliced to create a daily series.

  - Judgement as to what scenarios to include. Key dates are usually
    based on policy changes (lockdown, end of masks requirement etc).

  - Epidemiological sources for key parameters. These include the
    infection fatality ratio; serial interval; ascertainment rate.

Outputs are included in the overall UK Health Security Authority (UKHSA)
consensus and are used to inform the publicly available estimates of R
and incidence in Scotland. The model is run on a weekly basis. We often
run using different observations (cases and wastewater) and submit
multiple potential outputs to UKHSA.

### Other Covid-19 Modelling

This model is one of a
[series](https://github.com/search?q=topic%3Ac19-modelling+org%3ADataScienceScotland+fork%3Atrue)
used by the Scottish Government during the pandemic to model the spread
and levels of Covid-19 in Scotland. Many of the results of these models
have been published in the [Modelling the
Epidemic](https://www.gov.scot/collections/coronavirus-covid-19-modelling-the-epidemic/)
series of reports.

If you have any questions regarding the contents of this repository,
please contact <sgcentralanalysisdivision@gov.scot>.

### Licence

This repository is available under the [Open Government Licence
v3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
