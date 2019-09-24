# I'm not sure if this file/code is used anymore??

constructSimulationDFs <- function(input, output, session, geo_short_code, prg_chng_default) { 
  sim_data <- callModule(load_data, NULL, geo_short_code)

  # run one program change
  new_data <- eventReactive(input[['1RunSimulations']], {
	  
		req({ input[['programChange1StartYear']] })
		req({ input[['programChange1CoverageRate']] })
		req({ input[['programChange1IGRACoverage']] })
		req({ input[['programChange1AcceptingTreatmentFraction']] })
		req({ input[['programChange1CompletionRate']] })
		req({ input[['programChange1AverageTimeToTreatment']] })
		req({ input[['programChange1DefaultRate']] })

		# load the geography data into mitus
		model_load(geo_short_code())

    # copy the default program change
		prg_chng <- prg_chng_default

    # print some helpful statements
    cat(input[['1RunSimulations']])
		cat("did anything happen?\n")

		prg_chng['start_yr'] <- input[['programChange1StartYear']]
		prg_chng['scrn_cov'] <- input[['programChange1CoverageRate']] 
		prg_chng['IGRA_frc'] <- input[['programChange1IGRACoverage']]
		prg_chng['ltbi_init_frc'] <- input[['programChange1AcceptingTreatmentFraction']]
		# prg_chng['ltbi_eff_frc'] <- input[['programChange1LTBITrtEfficacy']]
		prg_chng['ltbi_comp_frc'] <- input[['programChange1CompletionRate']]
		prg_chng['tb_tim2tx_frc'] <- input[['programChange1AverageTimeToTreatment']]
		prg_chng['tb_txdef_frc'] <- input[['programChange1DefaultRate']]

		# simulate program changes scenario
		custom_scenario_output <- new_OutputsInt(loc = 'US', ParMatrix = Par[1:2,], prg_chng = prg_chng)

		# reformat into small/big restabs (two lists of (ResTab, ResTabus, ResTabfb) for small/big)
		restabs <- format_as_restab_for_custom_scenarios('US', custom_scenario_output)

		# # mean the simulations
		ResTabC_small <- mean_small_restabs(restabs)
		ResTabC_big <- mean_big_restabs(restabs)

		# # reshape small results
		restab <- restab1 <- make_empty_res_tab2sm(intvs = c('base_case2', 'programChange0'))
		restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
		restab_small <- cpp_reshaper(ResTabC_small[[1]], ResTabC_small[[2]], ResTabC_small[[3]], restab)
		restab_small %<>% as.data.frame
		# Re-factor each column from integers
		for (i in 1:6) {
			restab_small[,i] <- factor(restab_small[,i], labels = unique(restab1[,i]))
		}

		# # reshape big results
		restab <- restab1 <- make_empty_res_tab2bg(intvs = c('base_case2', 'programChange0'))
		restab %<>% mutate_if(is.factor, as.integer) %>% as.matrix
		restab_big <- cpp_reshaper(ResTabC_big[[1]], ResTabC_big[[2]], ResTabC_big[[3]], restab)
		restab_big %<>% as.data.frame
		# Re-factor each column from integers
		for (i in 1:6) {
			restab_big[,i] <- factor(restab_big[,i], labels = unique(restab1[,i]))
		}

		# # filter out the basecase
		# restab_small <- filter(restab_small, scenario != 'base_case2')
		# restab_big <- filter(restab_big, scenario != 'base_case2')

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

		return(list(restab_small = restab_small, restab_big = restab_big))
	}, ignoreNULL = TRUE) # end eventReactive( input$1RunSimulations, ... )


  # append the new simulated data (new_data) to the data from load_data (sim_data)
  if (! is.null(new_data())) {
		sim_data[['AGEGROUPS_DATA']] <- rbind.data.frame(sim_data[['AGEGROUPS_DATA']], new_data()[['restab_small']])

		trendsData <- rbind.data.frame(sim_data[['TRENDS_DATA']], new_data()[['restab_big']])
			trendsData$year <- as.integer(trendsData$year)

		sim_data[['TRENDS_DATA']] <- trendsData

		sim_data[['ESTIMATES_DATA']] <- rbind.data.frame(sim_data[['ESTIMATES_DATA']], 
			dplyr::filter(new_data()[['restab_big']], as.integer(as.character(year)) %in% c(2018, 2020, 2025, 2035, 2049)))

   cat('new data has: ', as.character(nrow(filter(sim_data[['TRENDS_DATA']], scenario == 'programChange0'))),
       'new_data rows\n')
	}

  return(sim_data)
}
