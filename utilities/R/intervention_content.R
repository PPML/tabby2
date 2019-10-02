# risk_groups <- c(
#   "All Individuals",
#   "Non-US Born Individuals from High Burden Countries",
#   "Homeless or Incarcerated Individuals",
#   "HIV Positive",
#   "Diabetics",
#   "End Stage Renal Disease",
#   "Smokers"
# ) # TODO add custom risk groups.



intervention_content <- function(n=1) {

  tttn <- paste0("ttt", n)

  formatted_risk_group <- list(
    "All Individuals",
    "Define a Custom Risk Group",
    `Elevated LTBI Prevalence` = c(
      risk_group_rate_ratios$population[[3]],
      # "Non-US Born Individuals from High Burden Countries",
      risk_group_rate_ratios$population[[4]]
      # "Homeless Individuals"
    ),
    `Elevated Progression Risk` = c(
      risk_group_rate_ratios$population[[1]],
      # "HIV Positive",
      risk_group_rate_ratios$population[[2]],
      # "Diabetics",
      risk_group_rate_ratios$population[[5]],
      # "End Stage Renal Disease",
      risk_group_rate_ratios$population[[6]]
      # "Smokers"
      )
  )

  return(
    fluidRow(
      # col1: choose intervention risk, age, nativity ----
      column(6, wellPanel(
        tags$h4("Define a Targeted Testing and Treatment Intervention"),
        textInput(inputId = paste0(tttn, "name"),
                  label = "Intervention Name",
                  placeholder = paste0("Intervention ", n)),
        fluidRow(
          column(
            6,
            # __subcol1: choose risk group ----
            selectInput(
              inputId = paste0(tttn, "risk"),
              label = "Targeted Risk Group",
              choices = formatted_risk_group
            ),
            # __subcol1: choose nativity group ----
            radioButtons(
              inputId = paste0(tttn, "nativity"),
              label = "Targeted Nativity Groups",
              choices = c(`All Nativity Groups` = 'all_populations',  `U.S. Born` = 'usb_population', `Non-U.S. Born` = 'fb_population')
            ),
            # __subcol1: choose age group ----
            radioButtons(
              inputId = paste0(tttn, "agegroups"),
              label = "Targeted Age Groups",
              choices = c(`All Ages` = "all_ages", `0 to 24` = "age_0_24", `25 to 64` = "age_25_64", `65+` = "age_65p")
            )
          ),
          column(
            6,
            # __subcol2: choose number targeted ----
            numericInput(
              inputId = paste0(tttn, "numberTargeted"),
              label = "Number of Individuals in the Risk Group in 2018 in thousands",
              min = 0,
              value = 0
            ),
            # __subcol2: choose fraction screened----
            numericInput(
              inputId = paste0(tttn, "fractionScreened"),
              label = "Fraction of the Risk Group who are Screened Annually",
              min = 0,
              max = 1,
              value = 0,
              step = .0001
            ),
            # __subcol2: choose start and stop year ----
            fluidRow(
              column(
                6,
                numericInput(
                  inputId = paste0(tttn, 'startyear'),
                  label = "Start Year",
                  min = 2020,
                  max = 2050,
                  value = 2020,
                  step = 1
                )
              ),
              column(
                6,
                numericInput(
                  inputId = paste0(tttn, 'stopyear'),
                  label = 'Stop Year',
                  min = 2018,
                  max = 2050,
                  value = 2050,
                  step = 1
                )
              )
            ),
            fluidRow(
              column(6, 
                actionButton(paste0(tttn, 'RunSimulations'), label = 'Run Model!', class = 'btn-primary', style = 'color: white;'),
                # actionButton(paste0(tttn, 'RestoreDefaults'), label = 'Restore Defaults'),
                disabled(actionButton(paste0(tttn, 'ChangeSettings'), label = 'Change Settings'))
              )
            )
          )
        ) # end of fluidRow
      ) # end of wellPanel
      ), # end of column
      # col2: summary stats & risk group parameters ----
      column(
        6,
        # __summary statistics ----
        wellPanel(
          tags$h4("Population Summary Statistics in 2018"),
          fluidRow(
            column(
              6,
              tags$br(),
              tags$b("Targeted Group"),
              tags$br(),
              tags$p(), # add an extra empty paragraph to match the one that erroneously/magically appears in the Age-Nativity box
              tags$p("Incidence per 100,000: ", textOutput(paste0(tttn, "TargetedIncidence"), inline=T), ""),
              tags$p("LTBI Prevalence: ", textOutput(paste0(tttn, "TargetedLTBIPrevalence"), inline=T), "%"),
              tags$p("Population: ", textOutput(paste0(tttn, "numberTargeted"), inline = T))
              
            ),
            column(
              6,
              tags$br(),
              tags$b("Age-Nativity Group"),
              tags$br(),
							tags$p(textOutput(paste0(tttn, 'AgeNativityIncidence'))),
							tags$p(textOutput(paste0(tttn, 'AgeNativityPrevalence'))),
              tags$p("Population Size: ", textOutput(paste0(tttn, "ageNatPopsize"), inline=T))
            )
          )
        ),
        # __risk group parameters ----
        uiOutput(paste0(tttn, 'risk_group_rate_ratios'))
      ), # end of column
			column(width = 12, 
				actionButton(
					inputId = paste0('toPredefinedScenarios', n),
					label = 'Back to Predefined Scenarios'
					),
				if (n < 3) { 
					actionButton(
						inputId = paste0('toTTT', n+1),
						label = 'Define Another TTT Intervention',
						class = 'btn-primary',
						style = 'color: white;'
					)
				} else NULL,
				actionButton(
					inputId = paste0('toProgramChanges', n),
					label = 'Define Program Change Scenarios',
					class = 'btn-primary',
					style = 'color: white;'
				),
				actionButton(
					inputId = paste0('toEstimates', n),
					label = 'View Outcomes',
					class = 'btn-primary',
					style = 'color: white;'
				)
			) # end of 12-column for buttons
    ) # end of fluidRow
  ) # end of return 
}
