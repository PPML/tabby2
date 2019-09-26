summaryStatistics <- function(input, output, session, values, sim_data, geo_short_code) {

  # the Summary Statistics computed here appear in the TTT scenario 
  # builder in order to assist users with building their targeted group. 

  # they consist of incidence, prevalence, population size for the 
  # corresponding age and nativity group of their target group, as well 
  # for the target group. 

  # the LTBI prevalence and Incidence for the age-nativity group are 
  # looked up from the presimulated ESTIMATES_DATA table. 

  # the LTBI prevalence and incidence for the TTT group are then 
  # computed (somewhat naively) from the risk group rate ratios specified 
  # by the user for their targeted group.

  # the formulas are:
  # ltbi_prev_ttt = ltbi_prev_age_nat * RR_prev
  # inc_ttt = inc_age_nat * RR_prev * RR_prog

  # to look up the population size of the age-nat group, we look into the 
  # results_1.rda file for the user specified location.

	ESTIMATES_DATA <- reactive({ sim_data[['presimulated']][['ESTIMATES_DATA']] })

  format_number_targeted <- function(x) { 
    if (x >= 1e3) { paste0(as.character(round(x/1e3, 2)), " million") }
    else if (x >= 1) { paste0(as.character(round(x, 2)), " thousand") }
    else { paste0(as.character(round(x*1e3, 2)), " people") }
  }

  # output number targeted directly from user input
	output$ttt1numberTargeted <- renderText({format_number_targeted(input$ttt1numberTargeted)})
	output$ttt2numberTargeted <- renderText({format_number_targeted(input$ttt2numberTargeted)})
	output$ttt3numberTargeted <- renderText({format_number_targeted(input$ttt3numberTargeted)})

  # function to output a reactive which computes the tb incidence of the age-nat group
  constructTTTIncidenceReactive <- function(iter) { 
    tttagegroups <- paste0('ttt', iter, 'agegroups')
    tttnativity <- paste0('ttt', iter, 'nativity')

    reactive({ 
            ESTIMATES_DATA() %>% 
              filter(age_group == input[[tttagegroups]],
                     population == input[[tttnativity]],
                     outcome == 'tb_incidence_per_100k',
                     scenario == 'base_case',
                     year == 2018,
                     comparator == 'absolute_value',
                     type == 'mean'
                     ) %>% `[[`('value') 
          })
  }

  # function to output a reactive which computes the ltbi prevalence of the age-nat group
  constructTTTPrevalenceReactive <- function(iter) { 
    tttagegroups <- paste0('ttt', iter, 'agegroups')
    tttnativity <- paste0('ttt', iter, 'nativity')

    reactive({ 
            ESTIMATES_DATA() %>% 
              filter(age_group == input[[tttagegroups]],
                     population == input[[tttnativity]],
                     outcome == 'pct_ltbi',
                     scenario == 'base_case',
                     year == 2018,
                     comparator == 'absolute_value',
                     type == 'mean'
                     ) %>% `[[`('value') 
          })
  }

  # build the incidence reactives for 1,2,3
  ageNativityIncidence1 <- constructTTTIncidenceReactive(1)
  ageNativityIncidence2 <- constructTTTIncidenceReactive(2)
  ageNativityIncidence3 <- constructTTTIncidenceReactive(3)

  # build ltbi prev reactives for 1,2,3
  ageNativityPrevalence1 <- constructTTTPrevalenceReactive(1)
  ageNativityPrevalence2 <- constructTTTPrevalenceReactive(2)
  ageNativityPrevalence3 <- constructTTTPrevalenceReactive(3)


	# Functions (2) to Produce Reactive Values with Formatted Incidence / LTBI Prev in Age-Nativity Group

  # inc reactive formatted
  ageNativityIncidenceForTTT <- function(n) { 
		reactive({
      value <- get(paste0('ageNativityIncidence', n))()
			paste0("Incidence per hundred thousand: ", round(value, 2))
		 })
	 }

  # prev reactive formatted
  ageNativityPrevalenceForTTT <- function(n) { 
		reactive({
        value <- get(paste0('ageNativityPrevalence', n))()
				paste0("LTBI Prevalence: ", round(value, 2), "%")
		 })
	 }

   # function to produce reactives with rounded target-group prevalence computed from age-nat prevalence and inputted relative rate of prevalence
   targetedPrevalence <- function(n, ageNativityPrevalenceReactive) { 
     reactive({ 
       round(ageNativityPrevalenceReactive * input[[paste0('ttt', n, 'prevalence-rate')]], 2)
     })
   }

   # function to produce reactives with rounded target-group incidence computed from age-nat incidence and input rr_prev, rr_prog
   targetedIncidence <- function(n, ageNativityIncidenceReactive) { 
     reactive({ 
       round(ageNativityIncidenceReactive * input[[paste0('ttt', n, 'prevalence-rate')]] * input[[paste0('ttt', n, 'progression-rate')]], 2)
     })
   }

	### Reactives send the formatted results to UI as output

  ## Age-Nat Outputs: 

  # 1
  output$ttt1AgeNativityIncidence <- renderText({ paste0("Incidence per hundred thousand: ", round(ageNativityIncidence1(), 2)) })
  output$ttt1AgeNativityPrevalence <- renderText({ paste0("LTBI Prevalence: ", round(ageNativityPrevalence1(), 2), "%") })

  # 2
  output$ttt2AgeNativityIncidence <- renderText({ paste0("Incidence per hundred thousand: ", round(ageNativityIncidence2(), 2)) })
  output$ttt2AgeNativityPrevalence <- renderText({ paste0("LTBI Prevalence: ", round(ageNativityPrevalence2(), 2), "%") })

  # 3
  output$ttt3AgeNativityIncidence <- renderText({ paste0("Incidence per hundred thousand: ", round(ageNativityIncidence3(), 2)) })
  output$ttt3AgeNativityPrevalence <- renderText({ paste0("LTBI Prevalence: ", round(ageNativityPrevalence3(), 2), "%") })

  ## TTT Outputs:

  # 1 
  output$ttt1TargetedIncidence <- renderText({ targetedIncidence(1, ageNativityIncidence1())() })
  output$ttt1TargetedLTBIPrevalence <- renderText({ targetedPrevalence(1, ageNativityPrevalence1())() })

  # 2 
  output$ttt2TargetedIncidence <- renderText({ targetedIncidence(2, ageNativityIncidence2())() })
  output$ttt2TargetedLTBIPrevalence <- renderText({ targetedPrevalence(2, ageNativityPrevalence2())() })

  # 3 
  output$ttt3TargetedIncidence <- renderText({ targetedIncidence(3, ageNativityIncidence3())() })
  output$ttt3TargetedLTBIPrevalence <- renderText({ targetedPrevalence(3, ageNativityPrevalence3())() })

  # Age-Nativity Group Population Size

  generate_age_nat_popsize_reactive <- function(n) { 
    reactive({
      load(system.file(paste0(geo_short_code(),"/", geo_short_code(),"_results_1.rda"), package="MITUS"))

      tttagegroups <- paste0('ttt', n, 'agegroups')
      tttnativity <- paste0('ttt', n, 'nativity')

      ag<-switch(input[[tttagegroups]],
                     "all_ages"=33:43,
                     "age_0_24"=33:35,
                     "age_25_64"=36:39,
                     "age_65p"=40:43
      )
      na<-switch(input[[tttnativity]],
                     "all_populations"=c(rep(0,length(ag)),rep(11,length(ag))),
                     "usb_population"=rep(0,length(ag)),
                     "fb_population"=rep(11,length(ag))
      )

      pop<-sum(out[1,69,ag+na])
      return(pop)
    })
  }

  format_population_size <- function(x) { 
    if (x >= 1) return(paste0(as.character(round(x, 2)), " million"))
    else if (x >= 1e-3) return(paste0(as.character(round(x*1e3, 2)), " thousand"))
    else return(paste0(as.character(round(x*1e6, 2)), " people"))
  }

  age_nat_popsize_1 <- generate_age_nat_popsize_reactive(1)
  age_nat_popsize_2 <- generate_age_nat_popsize_reactive(2)
  age_nat_popsize_3 <- generate_age_nat_popsize_reactive(3)

  output$ttt1ageNatPopsize <- renderText({ format_population_size(age_nat_popsize_1()) }) 
  output$ttt2ageNatPopsize <- renderText({ format_population_size(age_nat_popsize_2()) }) 
  output$ttt3ageNatPopsize <- renderText({ format_population_size(age_nat_popsize_3()) }) 

}
