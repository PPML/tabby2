# Module to Load Simulation Data
load_data <- function(input, output, session, geo_short_code) { 
  data <- reactiveValues()

	# Import and format Age Groups Data
		if (geo_short_code() == 'US') {
			data[['AGEGROUPS_DATA']] <- 
				(data_agegroups() %>% rename(type = statistic))
		} else {

			# Lookup sm_restab2 by geo_short_code, cast the data as.data.frame
			restab2 <- as.data.frame(readRDS(system.file(geo_short_code(), "sm_restab2.rds",
			package="MITUS", mustWork = TRUE)))

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
		}
	

	# Import and format Age Groups Data

	if (geo_short_code() == 'US') { 
		data[['TRENDS_DATA']] <-data_trends()
	} else {

		# Lookup bg_restab2 by geo_short_code, cast the data as.data.frame
		restab2 <- as.data.frame(readRDS(system.file(geo_short_code(), "bg_restab2.rds",
		package="MITUS", mustWork = TRUE)))

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
	}
	


  data[['ESTIMATES_DATA']] <-  
		filter(data[['TRENDS_DATA']], year %in% c(2018, 2020, 2025, 2035, 2049))
  
	return(data)
}
