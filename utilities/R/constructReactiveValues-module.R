# ---------------------------------------------------------------------------
#  Reactive Values 
#   ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅
#    The reactive values store the user's input for targeted testing and
#    treatment scenarios and program changes.
# 
#    To allow the user to have multiple targeted testing and treatment
#    scenarios as well as multiple program changes, we add to the scenario
#    specification input a choice for which scenario (of 1 through 3) the
#    user is defining. Their input is then filled into the corresponding
#    reactive values.
# 
#    This approach is preferred to having separate input for each of the
#    scenarios and program changes because it saves space as compared to
#    rendering separate input for each of the 3 available scenarios to fill
#    in.
# --------------------------------------------------------------------------

constructReactiveValues <- function(input, output, session) {
  values <- reactiveValues()

	#  The ttt_template list is going to be used three times later in filling 
	#  in constructing placeholders inside the reactive `values` object 
	# 
	#  These list elements correspond to the values the user can set in the TTT
	#  panel of the application.
	ttt_template <- list(
    name = NULL,
    risk_group = NULL,
    nativity_group = NULL,
    age_group = NULL,
    number_targeted = NULL,
    fraction_screened_annually = NULL,
    start_year = NULL,
    stop_year = NULL,
    rate_ratio_progression = 1,
    rate_ratio_mortality = 1,
    rate_ratio_prevalence = 1
  )

	# The programChanges_template is used later to fill in placeholders inside
	# the reactive `values` object.
	# 
	#  These list elements correspond to the values the user can set in the
	#  program changes panel of the application.
  programChanges_template <- list(
    name = NULL,
    ltbi_screening_coverage_multiplier = NULL,
    fraction_receiving_igra = NULL,
    fraction_accepting_ltbi_treatment = NULL,
    fraction_completing_ltbi_treatment = NULL,
    average_time_to_treatment_active = NULL,
    fraction_defaulting_from_treatment_active = NULL
  )

	# Use the ttt_template and programChanges_template to construct placeholders
	# for the scenarios inside the reactive `values` object.
	# 
	# Each of the 3 definable TTT and Program Changes will be given their own 
	# place within `values`, i.e. 1, 2, & 3 inside 
	# values[['scenarios']][['ttt']]` and similar for program changes.
  values[['scenarios']] <-
    list(
      ttt = list(ttt_template,
                 ttt_template,
                 ttt_template),
      program_changes = list(programChanges_template,
                             programChanges_template,
                             programChanges_template))

	values
}
