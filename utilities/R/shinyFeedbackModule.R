shinyFeedbackModule <- function(input, output, session) { 
  callModule(programChangesInputFeedback, NULL, n=1)
  callModule(programChangesInputFeedback, NULL, n=2)
  callModule(programChangesInputFeedback, NULL, n=3)

}

programChangesInputFeedback <- function(input, output, session, n) { 

#   is_percent <- function(n) { 
#     (is.numeric(n) & n >= 0 & n <= 100)
#   }
# 
#   pcn_startyear <- paste0('programChange', n, 'StartYear')
# 
#   observeEvent(input[[pcn_startyear]], {
# 		feedbackDanger(
#       inputId = pcn_startyear,
#       condition = ((! is.numeric(input[[pcn_startyear]])) | input[[pcn_startyear]] < 2020 | input[[pcn_startyear]] > 2050),
#       text = "Interventions must start between 2020 and 2050."
#     )
#   })
#   
#   pcn_covrate <- paste0('programChange', n, 'CoverageRate')
# 
#   observeEvent(input[[pcn_covrate]], {
# 		feedbackDanger(
#       inputId = pcn_covrate,
#       condition = (! is.numeric(input[[pcn_covrate]])) | input[[pcn_covrate]] < 1 | input[[pcn_covrate]] > 5,
#       text = "Screening may only be increased up to 5x."
#     )
#   })
#   
#   pcn_igra <- paste0('programChange', n, 'IGRACoverage')
# 
#   observeEvent(input[[pcn_igra]], {
# 		feedbackDanger(
#       inputId = pcn_igra,
#       condition = ! is_percent(input[[pcn_igra]]),
#       text = "IGRA Coverage must be a percentage value (0-100%)."
#     )
#   })
# 
# 
#   pcn_init_frc <- paste0('programChange', n, 'AcceptingTreatmentFraction')
# 
#   observeEvent(input[[pcn_init_frc]], {
# 		feedbackDanger(
#       inputId = pcn_init_frc,
#       condition = ! is_percent(input[[pcn_init_frc]]),
#       text = "LTBI Treatment Initiation must be a percentage value (0-100%)."
#     )
#   })
# 

  # pcn_comp_rate <- paste0('programChange', n, 'CompletionRate')

#   observeEvent(input[[pcn_comp_rate]], {
# 		feedbackDanger(
#       inputId = pcn_comp_rate,
#       condition = ! is_percent(input[[pcn_comp_rate]]),
#       text = "LTBI Treatment Completion must be a percentage value (0-100%)."
#     )
#   })

  # pcn_effectiveness <- paste0('programChange', n, 'TreatmentEffectiveness')

#   observeEvent(input[[pcn_effectiveness]], {
# 		feedbackDanger(
#       inputId = pcn_effectiveness,
#       condition = ! is_percent(input[[pcn_effectiveness]]),
#       text = "LTBI Treatment Effectiveness must be a percentage value (0-100%)."
#     )
#   })


#   pcn_avg_ttt <- paste0('programChange', n, 'AverageTimeToTreatment')
# 
#   observeEvent(input[[pcn_avg_ttt]], {
# 		feedbackDanger(
#       inputId = pcn_avg_ttt,
#       condition = ! is_percent(input[[pcn_avg_ttt]]),
#       text = "Average Time to Treatment must be a percentage value (0-100%)."
#     )
#   })
# 
# 
#   pcn_def_rate <- paste0('programChange', n, 'DefaultRate')
# 
#   observeEvent(input[[pcn_def_rate]], {
# 		feedbackDanger(
#       inputId = pcn_def_rate,
#       condition = ! is_percent(input[[pcn_def_rate]]),
#       text = "Default Rate from Treatment must be a percentage value (0-100%)."
#     )
#   })
}
