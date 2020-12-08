#' Load Raw or Transformed TB Model Results Data
#'
#' Melted arrays, now data frames, containing the tab results of the TB model
#' output.
#'
#' @details
#'
#' The `results_*` functions return the raw data, where as `data_*` functions
#' return formatted results ready for use in the tabby application.
#'
#' @section Outcomes:
#'
#' 1. Incident M. TB Infection (per Mil)
#' 2. LTBI Prevalence (%)
#' 3. New TB Cases (per Mil)
#' 4. MDR-TB in Incident TB Cases (%)
#' 5. TB-Related Deaths (per Mil)
#'
#' @section Scenarios:
#'
#' 1. Base case
#' 2. Intervention scenario 1 -- TLTBI for new immigrants
#' 3. Intervention scenario 2 -- Improved TLTBI in US
#' 4. Intervention scenario 3 -- Better case detection
#' 5. Intervention scenario 4 -- Better TB treatment
#' 6. Intervention scenario 5 -- All improvements together
#' 7. Sensitivity analysis  1 -- no transmission within the United States after 2016
#' 8. Sensitivity analysis  2 -- no LTBI among all immigrants after 2016
#'
#' @section Populations:
#'
#' 1. All
#' 2. US-born
#' 3. Foreign-born
#'
#' @keywords internal
#' @name model-results
NULL

#' @rdname model-results
#' @export
results_estimates <- function() {
  readRDS(system.file("res-tab-all.rds", package = "tabby1utilities", mustWork = TRUE))
}

#' @rdname model-results
#' @export
results_trends <- function() {
  readRDS(system.file("res-tab-time-trend.rds", package = "tabby1utilities", mustWork = TRUE))
}

#' @rdname model-results
#' @export
results_agegroups <- function() {
  readRDS(system.file("res-tab-age-groups.rds", package = "tabby1utilities", mustWork = TRUE))
}

#' @rdname model-results
#' @export
results_addoutputs <- function() {
  readRDS(system.file("res-tab-time-trend.rds", package = "tabby1utilities", mustWork = TRUE))
}

#' @rdname model-results
#' @export
results_costcomparison <- function() {
  readRDS(system.file("res-tab-time-trend.rds", package = "tabby1utilities", mustWork = TRUE))
}

#' @rdname model-results
#' @export
data_estimates <- function() {
  results_estimates() %>%
    filter(
      (scenario != "base_case" & year != 2016) | scenario == "base_case"
    ) %>%
    mutate_if(is.factor, as.character) %>%
    mutate(
      year = recode(
        year,
        `2016` = 2000,
        `2025` = 2025,
        `2050` = 2050,
        `2075` = 2075,
        `2099` = 2100
      )
    ) %>%
    gather(type, value, mean, ci_high, ci_low) %>% 
    mutate(comparator = recode(comparator, pct_basecase_2016 = "pct_basecase_2018"),
      outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
        tb_mortality_per_mil = "tb_mortality_per_100k"))
}

#' @rdname model-results
#' @export
data_trends <- function() {
  results_trends() %>%
    gather(type, value, mean, ci_high, ci_low) %>%
    mutate_if(is.factor, as.character) %>% 
    mutate(comparator = recode(comparator, pct_basecase_2016 = "pct_basecase_2018"),
      outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
        tb_mortality_per_mil = "tb_mortality_per_100k"))
}

#' @rdname model-results
#' @export
data_agegroups <- function() {
  results_agegroups() %>%
    mutate(
      age_group = str_replace(age_group, "_", "-"),
      age_group = str_replace(age_group, "p$", "+")
    ) %>%
    mutate_if(is.factor, as.character) %>% 
    mutate(
      outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
        tb_mortality_per_mil = "tb_mortality_per_100k"))

}

#' @rdname model-results
#' @export
data_addoutputs <- function() {
  results_addoutputs() %>%
    gather(type, value, mean, ci_high, ci_low) %>%
    mutate_if(is.factor, as.character) %>% 
    mutate(comparator = recode(comparator, pct_basecase_2016 = "pct_basecase_2018"),
           outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
                            tb_mortality_per_mil = "tb_mortality_per_100k"))
}

#' @rdname model-results
#' @export
data_costcomparison <- function() {
  results_costcomparison() %>%
    gather(type, value, mean, ci_high, ci_low) %>%
    mutate_if(is.factor, as.character) %>% 
    mutate(comparator = recode(comparator, pct_basecase_2016 = "pct_basecase_2018"),
           outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
                            tb_mortality_per_mil = "tb_mortality_per_100k"))
}
