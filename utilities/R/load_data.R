# Module Constructs a Reactive Returns Pre-Simulated Data
load_data <- function(geo_short_code) { 
	data <- list()

	# Lookup sm_restab2 by geo_short_code, cast the data as.data.frame
	restab2 <- as.data.frame(readRDS(system.file(geo_short_code, "sm_restab2.rds",
																							 package="MITUS", mustWork = TRUE))) %>% 
    mutate(
      outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
        tb_mortality_per_mil = "tb_mortality_per_100k"))


	# Temporary Fix for Trivial Confidence Intervals 
	# If confidence intervals aren't present (because the statistic
	# column hasn't been rendered yet, just duplicate (triplicate) the 
	# data for mean/ci_high/ci_low.
	if (! 'statistic' %in% colnames(restab2)) {
		restab2 <- 
			do.call(rbind.data.frame, list(
																		 cbind.data.frame(restab2, type = 'mean'),
																		 cbind.data.frame(restab2, type = 'ci_high'),
																		 cbind.data.frame(restab2, type = 'ci_low')))
	}

	restab2 %>% mutate_if(is.factor, as.character) -> restab2
			
	data[['AGEGROUPS_DATA']] <- restab2

	# Lookup bg_restab2 by geo_short_code, cast the data as.data.frame
	restab2 <- as.data.frame(readRDS(system.file(geo_short_code, "bg_restab2.rds",
																							 package="MITUS", mustWork = TRUE))) %>% 
    mutate(comparator = recode(comparator, pct_basecase_2016 = "pct_basecase_2018"),
      outcome = recode(outcome, tb_incidence_per_mil = "tb_incidence_per_100k", 
        tb_infection_per_mil = "tb_infection_per_100k",
        tb_deaths_per_mil = "tb_deaths_per_100k"
        ))

	# !!!!!!!!! 
	# Temporary Fix for Trivial Confidence Intervals 
	# If confidence intervals aren't present (because the statistic
	# column hasn't been rendered yet, just duplicate (triplicate) the 
	# data for mean/ci_high/ci_low.
	restab2 <- 
		do.call(rbind.data.frame, list(
																	 cbind.data.frame(restab2, type = 'mean'),
																	 cbind.data.frame(restab2, type = 'ci_high'),
																	 cbind.data.frame(restab2, type = 'ci_low')))

	restab2 %>% mutate_if(is.factor, as.character) -> restab2
	restab2$year <- as.numeric(restab2$year)
	data[['TRENDS_DATA']] <- restab2
	
	data[['ESTIMATES_DATA']] <-  
		filter(data[['TRENDS_DATA']], year %in% c(2020, 2022, 2025, 2035, 2050))
	
	return(data)
}
