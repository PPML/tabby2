risk_groups <- c(
  "All Individuals",
  "Non-US Born Individuals from High Burden Countries",
  "Homeless or Incarcerated Individuals",
  "HIV Positive",
  "Diabetics",
  "End Stage Renal Disease",
  "Smokers"
) # TODO add custom risk groups.

formatted_risk_group <- list(
  "All Individuals",
  "Define a Custom Risk Group",
  `Elevated LTBI Prevalence` = c(
    "Non-US Born Individuals from High Burden Countries",
    "Homeless or Incarcerated Individuals"
  ),
  `Elevated Progression Risk` = c(
    "HIV Positive",
    "Diabetics",
    "End Stage Renal Disease",
    "Smokers")
)


intervention_content <- function(n=1) {
  tttn <- paste0("ttt", n)
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
              choices = c("All Nativity Groups", "U.S. Born", "Non-U.S. Born")
            ),
            # __subcol1: choose age group ----
            radioButtons(
              inputId = paste0(tttn, "agegroups"),
              label = "Targeted Age Groups",
              choices = c("All Ages", "0 to 24", "25 to 64", "65+")
            )
          ),
          column(
            6,
            # __subcol2: choose number targeted ----
            numericInput(
              inputId = paste0(tttn, "numberTargeted"),
              label = "Number of Individuals in the Risk Group in 2018",
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
                  min = 2018,
                  max = 2050,
                  value = 2018,
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
              tags$br(),
              tags$p("Incidence: 0%\n"),
              tags$p("LTBI Prevalence: 0%"),
              tags$p("Population: ", textOutput(paste0(tttn, "numberTargeted"), inline = T))
              
            ),
            column(
              6,
              tags$br(),
              tags$b("Age-Nativity Group"),
              tags$br(),
              tags$br(),
              tags$p("Incidence: 0%\n"),
              tags$p("LTBI Prevalence: 0%"),
              tags$p("Population Size: 0")
            )
          )
        ),
        # __risk group parameters ----
        wellPanel(
          tags$h4("Risk Group Rate Ratios"),
          fluidRow(
            column(
              6,
              numericInput(
                inputId = paste0(tttn, "progression-rate-slider"),
                label = "Rate Ratio of LTBI Progression",
                min = 1,
                max = 40,
                value = 1,
                width = '200px',
              )
            ),
            column(
              6,
              numericInput(
                inputId = paste0(tttn, "prevalence-rate-slider"),
                label = "Rate Ratio of LTBI Prevalence",
                min = 1,
                max = 40,
                value = 1,
                width = '200px'
              )
            ),
            column(
              6,
              numericInput(
                inputId = paste0(tttn, "mortality-rate-slider"),
                label = "Rate Ratio of Mortality",
                min = 1,
                max = 40,
                value = 1,
                width = '200px',
              )
            )
          )
        )
      ) # end of column
    ) # end of fluidRow
  ) # end of return 
}
