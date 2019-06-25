runProgramChanges <- function(input, output, session, values, geo_short_code, data) { 


	# load the geography data into mitus
	model_load(geo_short_code())

	# replace this shortly with the user defined prg_chng
	prg_chng<-c(2020,2,.90,.95,.85,.90,.8,.25)
	names(prg_chng)<-
		c("start_yr", #year in which the program change starts (discontinuous step up to the values below at this year)
			"scrn_cov", #Screening Coverage Rate as a Multiple of the Current Rate
			"IGRA_frc", #Fraction of Individuals Receiving IGRA
			"ltbi_init_frc", #Fraction of Individuals Testing Positive who Accept Treatment
			"ltbi_comp_frc", #Fraction of Individuals Initiating Treatment Who Complete Treatment
			"ltbi_eff_frc", # LTBI Treatment Efficacy
			"tb_tim2tx_frc", #Duration of Infectiousness 
			"tb_txdef_frc") #Fraction Discontinuing/Defaulting from Treatment

	# simulate program changes scenario
	custom_scenario_output <- new_OutputsInt(loc = 'US', ParMatrix = StartVal, prg_chng = prg_chng)

	# reformat into small/big restabs (two lists of (ResTab, ResTabus, ResTabfb) for small/big)
	restabs <- format_as_restab_for_custom_scenarios('US', custom_scenario_output)

	# mean the simulations
	ResTabC_small <- mean_small_restabs(restabs)
	ResTabC_big <- mean_big_restabs(restabs)

	# reshape small results
	restab <- restab1 <- make_empty_res_tab(intvs = c('basecase', 'custom_scenario'), big_or_small = 'small')
	restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
	restab_small <- cpp_reshaper(ResTabC_small[[1]], ResTabC_small[[2]], ResTabC_small[[3]], restab)
	restab_small %<>% as.data.frame
	# Re-factor each column from integers
	for (i in 1:6) {
		restab_small[,i] <- factor(restab_small[,i], labels = unique(restab1[,i]))
	}

	# reshape big results
	restab <- restab1 <- make_empty_res_tab(intvs = c('basecase', 'custom_scenario'), big_or_small = 'big')
	restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
	restab_big <- cpp_reshaper(ResTabC_big[[1]], ResTabC_big[[2]], ResTabC_big[[3]], restab)
	restab_big %<>% as.data.frame
	# Re-factor each column from integers
	for (i in 1:6) {
		restab_big[,i] <- factor(restab_big[,i], labels = unique(restab1[,i]))
	}

	# filter out the basecase
	restab_small <- filter(restab_small, scenario != 'basecase')
	restab_big <- filter(restab_big, scenario != 'basecase')

	# add a type column
	restab_small <- 
		do.call(rbind.data.frame, list(
		cbind.data.frame(restab_small, type = 'mean'),
		cbind.data.frame(restab_small, type = 'ci_high'),
		cbind.data.frame(restab_small, type = 'ci_low')))

	restab_big <- 
		do.call(rbind.data.frame, list(
		cbind.data.frame(restab_big, type = 'mean'),
		cbind.data.frame(restab_big, type = 'ci_high'),
		cbind.data.frame(restab_big, type = 'ci_low')))


	new_data <- reactiveValues()
	new_data[['AGEGROUPS_DATA']] <- rbind.data.frame(data[['AGEGROUPS_DATA']], restab_small)

	new_data[['TRENDS_DATA']] <- rbind.data.frame(data[['TRENDS_DATA']], restab_big)

	new_data[['ESTIMATES_DATA']] <- rbind.data.frame(data[['ESTIMATES_DATA']], 
		filter(restab_big, year %in% c(2018, 2020, 2025, 2035, 2049)))

  return(new_data)
}
