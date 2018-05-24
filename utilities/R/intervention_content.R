intervention_content <- function(n=1) {
  customn <- paste0("custom", n)
  return(
    fluidRow(
      column(
        6,
        wellPanel(
          tags$h4("Define Intervention"),
          textInput(inputId = paste0(customn, "name"), label = "Name Custom Intervention:"),
          radioButtons(
            inputId = paste0(customn, "risk"),
            label = "Select Targeted Risk Groups",
            choices = c(
              "All Individuals",
              "HIV Positive",
              "Diabetics",
              "Custom Risk Group"
            )
          ),
          radioButtons(
            inputId = paste0(customn, "agegroups"),
            label = "Select Targeted Age Groups",
            choices = c("All Ages", "0 to 24", "25 to 64", "65+")
          ),
          radioButtons(
            inputId = paste0(customn, "nativity"),
            label = "Select Targeted Nativity Groups",
            choices = c("All Ages", "U.S. Born", "Non-U.S. Born")
          ),
          sliderInput(
            inputId = paste0(customn, "numberscreened"),
            label = "Select Number of Individuals Screened",
            min = 0,
            max = 10000,
            value = 0,
            step = 10
          )
        )
      ),
      # __ define custom risk group ----
      column(
        6,
        wellPanel(
          tags$h4("Targeted Population Summary Statistics"),
          tags$p("Incidence: 5.1%\n"),
          tags$p("LTBI Prevalence: 12.5%")
        ),
        conditionalPanel(
          condition = paste0("input.", customn, "risk == 'Custom Risk Group'"),
          wellPanel(
            # style = "overflow-y:scroll; max-height: 350px",
            tags$h4("Define Custom Risk Group"),
            sliderInput(
              inputId = paste0(customn, "mortalityrisk"),
              label = "Specify Targeted Population's Relative Mortality Risk (%)",
              min = 0,
              max = 140,
              value = 100
            ),
            sliderInput(
              inputId = paste0(customn, "reactivation-risk"),
              label = "Specify Targeted Population's Relative LTBI Progression Risk (%)",
              min = 0,
              max = 140,
              value = 100
            )
          )
        )
      )
    )
  )
}
