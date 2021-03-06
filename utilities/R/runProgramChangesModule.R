runProgramChanges <- function(input, output, session, n, values, geo_short_code, sim_data, prg_chng_default) { 
	reactive({

	prefix <- function(x) paste0('programChange', n, x) 

	# load the geography data into mitus
	model_load(geo_short_code())

  prg_chng <- prg_chng_default()

	# # replace this shortly with the user defined prg_chng
	# prg_chng<-c(2020,2,.90,.95,.85,.90,.8,.25)
	# names(prg_chng)<-
	# 	c("start_yr", #year in which the program change starts (discontinuous step up to the values below at this year)
	# 		"scrn_cov", #Screening Coverage Rate as a Multiple of the Current Rate
	# 		"IGRA_frc", #Fraction of Individuals Receiving IGRA
	# 		"ltbi_init_frc", #Fraction of Individuals Testing Positive who Accept Treatment
	# 		"ltbi_comp_frc", #Fraction of Individuals Initiating Treatment Who Complete Treatment
	# 		"ltbi_eff_frc", # LTBI Treatment Efficacy
	# 		"tb_tim2tx_frc", #Duration of Infectiousness 
	# 		"tb_txdef_frc") #Fraction Discontinuing/Defaulting from Treatment

	if (input[[prefix('Name')]] == '') { 
		scenario_name <- prefix('')
	} else {
		scenario_name <- input[[prefix('Name')]]
	}

  prg_chng[['start_yr']] <- input[[prefix('StartYear')]]

  prg_chng[['scrn_cov']] <- 
    input[[prefix('CoverageRate')]] 

  prg_chng[['IGRA_frc']] <- 
    input[[prefix('IGRACoverage')]] / 100

  prg_chng[['ltbi_init_frc']] <- 
    input[[prefix('AcceptingTreatmentFraction')]] / 100

  prg_chng[['ltbi_comp_frc']] <- 
    input[[prefix('CompletionRate')]] / 100

  prg_chng[['ltbi_eff_frc']] <- 
    input[[prefix('TreatmentEffectiveness')]] / 100


  prg_chng[['tb_tim2tx_frc']] <- 
    input[[prefix('AverageTimeToTreatment')]] 

  prg_chng[['tb_txdef_frc']] <- 
    input[[prefix('DefaultRate')]] / 100

  # Load pre-simulated basecase
  # load_US_data <- function(i) {
  #     data_name <- 
  #     load(system.file(paste0("US/US_results_",i,".rda"), package='MITUS'))
  #     return(get(data_name))
  # }

  # US_results <- lapply(1:9, load_US_data)
  presimulated_results_name <- load(system.file(paste0(geo_short_code(), "/", geo_short_code(), "_results_1.rda"),
    package="MITUS"))
  presimulated_results <- get(presimulated_results_name)

	# simulate program changes scenario
  custom_scenario_output <- OutputsInt(loc = geo_short_code(), ParMatrix = Par[1:2,], prg_chng = prg_chng, ttt_list = def_ttt())
  custom_scenario_output <- list(presimulated_results[1:2,,], custom_scenario_output)

	# reformat into small/big restabs (two lists of (ResTab, ResTabus, ResTabfb) for small/big)
	# restabs <- format_as_restab_for_custom_scenarios(geo_short_code(), custom_scenario_output)
  restabs <- list()
  restabs[['small_results']] <- format_as_restab_small_ages(simulation_data=custom_scenario_output)
  restabs[['big_results']] <- format_as_restab_big_ages(simulation_data=custom_scenario_output)


	# # mean the simulations
	ResTabC_small <- mean_small_restabs(restabs, nr = 2, nints = 2)
	ResTabC_big <- mean_big_restabs(restabs, nr = 2, nints = 2)

	# # reshape small results
	restab <- restab1 <- make_empty_res_tab2sm(intvs = c('base_case2', scenario_name)) # , prefix('')))
	restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
	restab_small <- cpp_reshaper(ResTabC_small[[1]], ResTabC_small[[2]], ResTabC_small[[3]], restab)
	restab_small %<>% as.data.frame
	# Re-factor each column from integers
	for (i in 1:6) {
		restab_small[,i] <- factor(restab_small[,i], labels = unique(restab1[,i]))
	}

	# # reshape big results
	restab <- restab1 <- make_empty_res_tab2bg(intvs = c('base_case2', scenario_name))
	restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
	restab_big <- cpp_reshaper(ResTabC_big[[1]], ResTabC_big[[2]], ResTabC_big[[3]], restab)
	restab_big %<>% as.data.frame
	# Re-factor each column from integers
	for (i in 1:6) {
		restab_big[,i] <- factor(restab_big[,i], labels = unique(restab1[,i]))
	}

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

	new_data <- list()

	new_data[['AGEGROUPS_DATA']] <-  restab_small

	restab_big$year <- as.integer(as.character(restab_big$year))
	new_data[['TRENDS_DATA']] <- restab_big

	new_data[['ESTIMATES_DATA']] <- 
		dplyr::filter(restab_big, year %in% c(2020, 2022, 2025, 2035, 2049))

   # cat('new data has: ', as.character(nrow(filter(new_data[['TRENDS_DATA']], scenario == scenario_name))),
   #     'new_data rows\n')

  return(new_data)
	})
}
