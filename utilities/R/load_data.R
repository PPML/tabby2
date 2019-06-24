# Functions to Load Simulation Data

load_data <- function(input, output, session, values, geo_short_code) { 
  data <- reactiveValues()

	# Import and format Age Groups Data
	data[['AGEGROUPS_DATA']] <- reactive({
		if (geo_short_code() == 'US') {
			return(data_agegroups() %>% rename(type = statistic))
		}

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
		return(restab2)
	})

	# Import and format Age Groups Data
	data[['TRENDS_DATA']] <- reactive({

		if (geo_short_code() == 'US') { return(data_trends()) }

		# Lookup bg_restab2 by geo_short_code, cast the data as.data.frame
		restab2 <- as.data.frame(readRDS(system.file(geo_short_code(), "bg_restab2.rds",
		package="MITUS", mustWork = TRUE)))

		# Temporary Fix for Trivial Confidence Intervals 
		# If confidence intervals aren't present (because the statistic
		# column hasn't been rendered yet, just duplicate (triplicate) the 
		# data for mean/ci_high/ci_low.
		# if (! 'statistic' %in% colnames(restab2)) {
			restab2 <- 
				do.call(rbind.data.frame, list(
				cbind.data.frame(restab2, type = 'mean'),
				cbind.data.frame(restab2, type = 'ci_high'),
				cbind.data.frame(restab2, type = 'ci_low')))
		# }

    restab2 %>% mutate_if(is.factor, as.character) -> restab2
		restab2$year <- as.numeric(restab2$year)
		return(restab2)
	})


  data[['ESTIMATES_DATA']] <- reactive({ 
		filter(data[['TRENDS_DATA']](), year %in% c(2018, 2020, 2025, 2035, 2049))
	})
  
	return(data)

}
