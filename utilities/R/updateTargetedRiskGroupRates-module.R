# Run an `observe` to fill in `values[['scenarios']][['ttt']]`
# and `values[['scenarios']][['program_changes']]` accordingly. 
# This is done by watching for changes in the currentlySelectedTTT and 
# currentlySelectedProgramChanges. 

updateTargetedRiskGroupRates <- function(input, output, session, risk_group_rate_ratios, values) {

	# ttt_to_update is a safe version of currentlySelectedTTT
  ttt_to_update <- reactive({ ifelse(
    is.null(input$currentlySelectedTTT),
    1,
    as.integer(input$currentlySelectedTTT)
  )
  })
  
	# Use ttt_to_update to get the names of the risk-groups' relative-rate fields
  tttn <- reactive({ paste0("ttt", ttt_to_update()) })
  tttRisk <- reactive({ paste0(tttn(), "risk") })
  tttProgression <- reactive({ paste0(tttn(), "progression-rate") })
  tttPrevalence <- reactive({ paste0(tttn(), "prevalence-rate") })
  tttMortality <- reactive({ paste0(tttn(), "mortality-rate") })
  
  observeEvent(input[[tttRisk()]], {
    
    if (input[[tttRisk()]] == 'All Individuals') {
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- 1
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <- 1
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- 1
      
    } else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
      rate_ratio_row <- which(risk_group_rate_ratios$population == as.character(input[[tttRisk()]]))
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- risk_group_rate_ratios[[rate_ratio_row, 2]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <-  risk_group_rate_ratios[[rate_ratio_row, 3]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- risk_group_rate_ratios[[rate_ratio_row, 4]]
      
    } else { # Custom Risk Group
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]  <- input[[tttProgression()]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']]  <- input[[tttPrevalence()]]
      values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']]  <- input[[tttMortality()]]
      
    }
    
    output$ttt1risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
            )
          )
        )
      )
    }) })
    
    output$ttt2risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
            )
          )
        )
      )
    }) })
    
    output$ttt3risk_group_rate_ratios <-  renderUI({ isolate({
      wellPanel(
        tags$h4("Risk Group Rate Ratios"),
        fluidRow(
          column(
            6,
            numericInput(
              inputId = isolate({ tttProgression() }),
              label = "Rate Ratio of LTBI Progression",
              min = 1,
              max = 40,
              value = isolate({ values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_progression']]}), 
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttPrevalence(),
              label = "Rate Ratio of LTBI Prevalence",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_prevalence']],
              width = '200px'
            )
          ),
          column(
            6,
            numericInput(
              inputId = tttMortality(),
              label = "Rate Ratio of Mortality",
              min = 1,
              max = 40,
              value = values[['scenarios']][['ttt']][[ttt_to_update()]][['rate_ratio_mortality']],
              width = '200px'
						)
					)
        )
      )
		}) })
  })
  
	observeEvent(
		input[[tttProgression()]], {
			disable(tttProgression())
			if (input[[tttRisk()]] == 'Define a Custom Risk Group') {
				enable(tttProgression())
			}
		})

	observeEvent(
		input[[tttPrevalence()]], {
			disable(tttPrevalence())
			if (input[[tttRisk()]] == 'All Individuals') {
				disable(tttPrevalence())
			} else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
				disable(tttPrevalence())
			} else { # Custom Risk Group
				enable(tttPrevalence())
			}
		})

	observeEvent(
		input[[tttMortality()]], {
			disable(tttMortality())
			if (input[[tttRisk()]] == 'All Individuals') {
				disable(tttMortality())
			} else if (input[[tttRisk()]] != 'Define a Custom Risk Group') {
				disable(tttMortality())
			} else { # Custom Risk Group
				enable(tttMortality())
			}
		})

	values
}
