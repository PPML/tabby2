
# Behavior for when Run Simulation is clicked
programChangesRunButton <- function(input, output, session, n, compute_program_change_reactive, sim_data) { 

		# Construct programChange ID
		pc_n <- paste0('programChange', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(pc_n, c('Name', 'StartYear', 'CoverageRate', 'IGRACoverage',
		'IGRA_frc', 'AcceptingTreatmentFraction', 'CompletionRate',
		'TreatmentEffectiveness', 'AverageTimeToTreatment', 'DefaultRate', 'RunSimulations', 'RestoreDefaults')), disable)

		# Enable the Change Settings and View Outcomes Button
		sapply(paste0(pc_n, c('ChangeSettings', 'ViewOutcomes')), enable)

		# Compute and Return Data to Fill Into sim_data reactiveList
		compute_program_change_reactive()
}


# Behavior for when Change Settings is clicked
programChangesChangeSettingsButton <- function(input, output, session, n) { 

  # Construct programChange ID
	pc_n <- paste0('programChange', n)

	# Enable Input
	sapply(paste0(pc_n, c('Name', 'StartYear', 'CoverageRate', 'IGRACoverage',
	'IGRA_frc', 'AcceptingTreatmentFraction', 'CompletionRate',
	'TreatmentEffectiveness', 'AverageTimeToTreatment', 'DefaultRate', 'RunSimulations', 'RestoreDefaults')), enable)

	# Disable Change Settings and View Outcomes buttons
	sapply(paste0(pc_n, c('ChangeSettings', 'ViewOutcomes')), disable)
}


tttRunButton <- function(input, output, session, n, compute_ttt_reactive) { 
		# Compute and Return Data to Fill Into sim_data reactiveList
		compute_ttt_reactive()
}

tttChangeSettingsButton <- function(input, output, session, n) {
}
