programChangesButton <- function(input, output, session, n, compute_program_change_reactive) { 

      # Construct programChange ID
      pc_n <- paste0('programChange', n)

      # Compute and Fill in Data Into sim_data reactiveList
			sim_data[[pc_n]] <- compute_program_change_reactive()

      # Disable Input for the programChange Scenario
			sapply(paste0(pc_n, c('Name', 'StartYear', 'CoverageRate', 'IGRACoverage',
			'IGRA_frc', 'AcceptingTreatmentFraction', 'CompletionRate',
			'TreatmentEffectiveness', 'AverageTimeToTreatment', 'DefaultRate', 'RunSimulations')), disable)

      # Enable the Change Settings and View Outcomes Button
			sapply(paste0(pc_n, c('ChangeSettings', 'ViewOutcomes')), enable)

}
