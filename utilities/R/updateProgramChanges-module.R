updateProgramChanges <- function(input, output, session, values) {
  observe({
		# ttt_to_update is a safe version of currentlySelectedTTT
    ttt_to_update <- ifelse(
      is.null(input$currentlySelectedTTT),
      1,
      as.integer(input$currentlySelectedTTT)
    )

		# Use ttt_to_update to get the specifications for the TTT scenario that is 
		# currently being defined.
    n <- ttt_to_update
    tttn <- paste0("ttt", n)
    tttName <- paste0(tttn, "name")
    tttRisk <- paste0(tttn, "risk")
    tttAge <- paste0(tttn, "agegroups")
    tttNativity <- paste0(tttn, "nativity")
    tttNumberTargeted <- paste0(tttn, "numberTargeted")
    tttFractionScreened <- paste0(tttn, "numberScreened")
    tttStartYear <- paste0(tttn, "startyear")
    tttStopYear <- paste0(tttn, "stopyear")
    tttProgression <- paste0(tttn, "progression-rate")
    tttPrevalence <- paste0(tttn, "prevalence-rate")
    tttMortality <- paste0(tttn, "mortality-rate")
    
    # Fill the user-input into the `values` object.
    values[['scenarios']][['ttt']][[ttt_to_update]][['name']] = input[[tttName]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['risk_group']] = input[[tttRisk]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['nativity_group']] = input[[tttNativity]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['age_group']] = input[[tttAge]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['number_targeted']] = input[[tttNumberTargeted]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['fraction_screened_annually']] = input[[tttFractionScreened]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['start_year']] = input[[tttStartYear]]
    values[['scenarios']][['ttt']][[ttt_to_update]][['stop_year']] = input[[tttStopYear]]
    
    # program_changes_to_update is the safe version of 
		# input$currentlySelectedProgramChange
    program_change_to_update <-
      if (is.null(input$currentlySelectedProgramChange)) 1
    else as.integer(input$currentlySelectedProgramChange)
    
		# Use program_change_to_update to get the specification for the Program
		# Change scenario that is currently being defined.
    pcn <- paste0("programChange", program_change_to_update)
    programChangeName = paste0(pcn, 'Name')
    programChangeStartYear = paste0(pcn, 'StartYear')
    programChangeLtbi_screening_coverage_multiplier = paste0(pcn, "CoverageRate")
    programChangeFraction_receiving_igra = paste0(pcn, "IGRACoverage")
    programChangeFraction_accepting_ltbi_treatment = paste0(pcn, "AcceptingTreatmentFraction")
    programChangeFraction_completing_ltbi_treatment = paste0(pcn, "CompletionRate")
    programChangeAverage_time_to_treatment_active = paste0(pcn, "AverageTimeToTreatment")
    programChangeFraction_defaulting_from_treatment_active = paste0(pcn, "DefaultRate")
    
    # Fill the user-input into the `values` object.
    values[['scenarios']][['program_changes']][[program_change_to_update]] <-
      list(
        name = input[[programChangeName]],
				start_year = input[[programChangeStartYear]],
        ltbi_screening_coverage_multiplier = input[[programChangeLtbi_screening_coverage_multiplier]],
        fraction_receiving_igra = input[[programChangeFraction_receiving_igra]],
        fraction_accepting_ltbi_treatment = input[[programChangeFraction_accepting_ltbi_treatment]],
        fraction_completing_ltbi_treatment = input[[programChangeFraction_completing_ltbi_treatment]],
        average_time_to_treatment_active = input[[programChangeAverage_time_to_treatment_active]],
        fraction_defaulting_from_treatment_active = input[[programChangeFraction_defaulting_from_treatment_active]]
      )
  })
	values
}
