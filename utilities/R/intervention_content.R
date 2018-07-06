intervention_content <- function(n=1) {
  customn <- paste0("custom", n)
  return(
    fluidRow(
      # col1: choose intervention risk, age, nativity ----
      column(6, wellPanel(
        tags$h4("Define Intervention"),
        textInput(inputId = paste0(customn, "name"),
                  label = "Name Custom Intervention:"),
        fluidRow(
          column(
            6,
            # __subcol1: choose risk group ----
            selectInput(
              inputId = paste0(customn, "risk"),
              label = "Select Targeted Risk Groups",
              choices = list(
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
            ),
            # __subcol1: choose nativity group ----
            radioButtons(
              inputId = paste0(customn, "nativity"),
              label = "Select Targeted Nativity Groups",
              choices = c("All Nativity Groups", "U.S. Born", "Non-U.S. Born")
            ),
            # __subcol1: choose age group ----
            radioButtons(
              inputId = paste0(customn, "agegroups"),
              label = "Select Targeted Age Groups",
              choices = c("All Ages", "0 to 24", "25 to 64", "65+")
            )
          ),
          column(
            6,
            # __subcol2: choose number targeted ----
            sliderInput(
              inputId = paste0(customn, "numbertargeted"),
              label = "Specify the Number of Individuals in The Risk Group",
              min = 0,
              max = 10000,
              value = 0,
              step = 10
            ),
            # __subcol2: choose fraction screened----
            sliderInput(
              inputId = paste0(customn, "numberscreened"),
              label = "Specify the Fraction of the Risk Group who are Screened",
              min = 0,
              max = 1,
              value = 0,
              step = .01
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
          fluidRow(
            column(
              6,
              tags$h4("Targeted Population Summary Statistics"),
              tags$p("Incidence: 0%\n"),
              tags$p("LTBI Prevalence: 0%")
            ),
            column(
              6,
              tags$h4("Age-Nativity Group Population Summary Statistics"),
              tags$p("Incidence: 0%\n"),
              tags$p("LTBI Prevalence: 0%"),
              tags$p("Population Size: 0")
            )
          )
        ),
        # __risk group parameters ----
        wellPanel(
          # style = "overflow-y:scroll; max-height: 350px",
          tags$h4("Define Custom Risk Group"),
          fluidRow(
            column(
              8, 
              uiOutput('custom1_mortality_slider')
            ),
            column(
              4,
              uiOutput('custom1_mortality_numeric')
            )
          ),
          fluidRow(
            column(
              8,
              sliderInput(
                inputId = paste0(customn, "reactivation-rate-slider"),
                label = "Specify Targeted Population's Relative LTBI Progression Rate",
                min = 1,
                max = 40,
                value = 1
              )
            ),
            column(
              4,
              numericInput(
                inputId = paste0(customn, "reactivation-rate-numeric"),
                label = '',
                min = 1, max = 40, value = 1)
            )
          ),
          fluidRow(
            column(
              8,
              sliderInput(
                inputId = paste0(customn, "prevalence-rate-slider"),
                label = "Specify Targeted Population's Relative LTBI Prevalence Rate",
                min = 1,
                max = 40,
                value = 1
              )
            ),
            column(
              4, 
              numericInput(
                inputId = paste0(customn, "prevalence-rate-numeric"),
                label = '',
                min = 1, max = 40, value = 1)
            )
          )
        )
      ) # end of column
    ) # end of fluidRow
  ) # end of return 
}
