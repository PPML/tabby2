

runTTT <- function(input, output, session, n, geo_short_code) { 
  # return a reactive which runs the TTT scenario
	reactive({

    prefix <- function(x) { paste0(paste0('ttt', n), x) } 
    
    if (input[[prefix('name')]] == '') { 
      scenario_name <- prefix('')
    } else {
      scenario_name <- input[[prefix('name')]]
    }

    model_load(geo_short_code())

    ttt_list <- def_ttt()

    # $NativityGrp
    # [1] "All"
    # $AgeGrp
    # [1] "All"
    # $NRiskGrp
    # [1] 0
    # $FrcScrn
    # [1] 0
    # $StartYr
    # [1] 2018
    # $EndYr
    # [1] 2050
    # $RRprg
    # [1] 1
    # $RRmu
    # [1] 1
    # $RRPrev
    # [1] 1

  ttt_list[['NativityGrp']] <- 
    switch(input[[paste0('ttt', n, "nativity")]], 
      all_populations = 'All',
      usb_population = 'USB',
      fb_population = 'NUSB')

  ttt_list[['AgeGrp']] <- 
    switch(input[[paste0('ttt', n, "agegroups")]],
      all_ages = "All",
      age_0_24 = "0 to 24",
      age_25_64 = "25 to 64",
      age_65p = "65+")
  
  ttt_list[['NRiskGrp']] <- input[[paste0('ttt', n, "numberTargeted")]] / 1e3
  ttt_list[['FrcScrn']] <- input[[paste0('ttt', n, "fractionScreened")]]

  ttt_list[['StartYr']] <- input[[paste0('ttt', n, 'startyear')]]
  ttt_list[['EndYr']] <- input[[paste0('ttt', n, 'stopyear')]]

  ttt_list[['RRprg']] <- input[[paste0('ttt', n, 'progression-rate')]]
  ttt_list[['RRmu']] <- input[[paste0('ttt', n, 'mortality-rate')]]
  ttt_list[['RRPrev']] <- input[[paste0('ttt', n, 'prevalence-rate')]]

  prg_chng <- MITUS::def_prgchng(ParVec = Par[1,])


  presimulated_results_name <- load(system.file(paste0(geo_short_code(), "/", geo_short_code(), "_results_1.rda"),
    package="MITUS"))
  presimulated_results <- get(presimulated_results_name)

	# simulate program changes scenario
	custom_scenario_output <- OutputsInt(loc = geo_short_code(), ParMatrix = Par[1:2,], prg_chng = prg_chng, ttt_list = ttt_list)
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

	#make a vector of outputs to include in add outputs 
	add_outputs_vec<-c(    "ltbi_tests_000s", 
	                       "ltbi_txinits_000s", 
	                       "ltbi_txcomps_000s", 
	                       "tb_txinits_000s", 
	                       "tb_txcomps_000s")
	new_data <- list()
	
	new_data[['AGEGROUPS_DATA']] <-  restab_small %>% dplyr::filter( !(outcome %in% add_outputs_vec))
	
	restab_big$year <- as.integer(as.character(restab_big$year))
	new_data[['TRENDS_DATA']] <- restab_big  %>% dplyr::filter( !(outcome %in% add_outputs_vec))
	new_data[['ADDOUTPUTS_DATA']] <- restab_big  %>% dplyr::filter(outcome %in% add_outputs_vec)
	
	
	new_data[['ESTIMATES_DATA']] <- 
	  dplyr::filter(restab_big, year %in% c(2022, 2025, 2030, 2040, 2050),!(outcome %in% add_outputs_vec) )

   # cat('new data has: ', as.character(nrow(filter(new_data[['TRENDS_DATA']], scenario == scenario_name))),
   #     'new_data rows\n')

  return(new_data)

  })
}
