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
          tags$h4("Targeted Population Summary Statistics"),
          tags$p("Incidence: 5.1%\n"),
          tags$p("LTBI Prevalence: 12.5%")
        ),
        # __risk group parameters ----
        wellPanel(
          # style = "overflow-y:scroll; max-height: 350px",
          tags$h4("Define Custom Risk Group"),
          sliderInput(
            inputId = paste0(customn, "mortality-rate"),
            label = "Specify Targeted Population's Relative Mortality Rate",
            min = 0,
            max = 40,
            value = 1
          ),
          sliderInput(
            inputId = paste0(customn, "reactivation-rate"),
            label = "Specify Targeted Population's Relative LTBI Progression Rate",
            min = 0,
            max = 40,
            value = 1
          ),
          sliderInput(
            inputId = paste0(customn, "prevalence-rate"),
            label = "Specify Targeted Population's Relative LTBI Prevalence Rate",
            min = 0,
            max = 40,
            value = 1
          )
        )
      ) # end of column
    ) # end of fluidRow
  ) # end of return 
}
