
### Program Changes ### 

# Behavior for when Run Simulation is clicked
programChangesRunButton <- function(input, output, session, n, compute_program_change_reactive, sim_data) { 

		# Construct programChange ID
		pc_n <- paste0('programChange', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(pc_n, c('Name', 'StartYear', 'CoverageRate', 'IGRACoverage',
		'IGRA_frc', 'AcceptingTreatmentFraction', 
		#'CompletionRate', 'TreatmentEffectiveness',
		'Fraction3HP', 'Completion3HP', 'Fraction4R', 'Completion4R', 'Fraction3HR', 'Completion3HR',
		'AverageTimeToTreatment', 'DefaultRate', 'RunSimulations', 'RestoreDefaults')), disable)

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
	'IGRA_frc', 'AcceptingTreatmentFraction', 
  'CompletionRate', 'TreatmentEffectiveness',
  'DefaultRate', 'RunSimulations', 'RestoreDefaults')), enable)

	# Disable Change Settings and View Outcomes buttons
	sapply(paste0(pc_n, c('ChangeSettings', 'ViewOutcomes')), disable)
}

### Targeted Testing and Treatment ### 

tttRunButton <- function(input, output, session, n, compute_ttt_reactive) { 
		# Construct programChange ID
		tttn <- paste0('ttt', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(tttn, c('name', 'risk', 'nativity', 'agegroups', 'numberTargeted',
		'fractionScreened', 'startyear', 'stopyear', 'RunSimulations')), disable)

		# Enable the Change Settings and View Outcomes Button
		sapply(paste0(tttn, c('ChangeSettings', 'ViewOutcomes')), enable)

		# Compute and Return Data to Fill Into sim_data reactiveList
		compute_ttt_reactive()
}

tttChangeSettingsButton <- function(input, output, session, n) {
		# Construct programChange ID
		tttn <- paste0('ttt', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(tttn, c('name', 'risk', 'nativity', 'agegroups', 'numberTargeted',
		'fractionScreened', 'startyear', 'stopyear', 'RunSimulations')), enable)

		# Enable the Change Settings and View Outcomes Button
		sapply(paste0(tttn, c('ChangeSettings', 'ViewOutcomes')), disable)
}


### Combination Scenarios ### 


combinationRunButton <- function(input, output, session, n, compute_combination_reactive) { 
		# Construct programChange ID
		combinationn <- paste0('combination', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(combinationn, c('SelectedProgramChange', 'SelectedTTT', 'Name', 'RunSimulations')), disable)

		# Enable the Change Settings and View Outcomes Button
		sapply(paste0(combinationn, c('ChangeSettings')), enable)

		# Compute and Return Data to Fill Into sim_data reactiveList
		compute_combination_reactive()
}

combinationChangeSettingsButton <- function(input, output, session, n) {
		# Construct programChange ID
		combinationn <- paste0('combination', n)

		# Disable Input for the programChange Scenario
		sapply(paste0(combinationn, c('SelectedProgramChange', 'SelectedTTT', 'Name', 'RunSimulations')), enable)
		# sapply(paste0(combinationn, c('name', 'risk', 'nativity', 'agegroups', 'numberTargeted',
		# 'fractionScreened', 'startyear', 'stopyear', 'RunSimulations')), enable)

		# Enable the Change Settings and View Outcomes Button
		# sapply(paste0(combinationn, c('ChangeSettings', 'ViewOutcomes')), disable)
		sapply(paste0(combinationn, c('ChangeSettings')), disable)
}
