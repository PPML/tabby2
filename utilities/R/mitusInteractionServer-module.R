#' @import MITUS
mitusInteractionServer <- function(input, output, session, geo_short_code) {
  # load outcomes data for selected geography

	reactive({
		# Load geography into MITUS 
		mitus_env <- MITUS::model_load(geo_short_code(), return_env = T)
		 
		# For each custom scenario ... 
		# For as many simulations as desired
		with(mitus_env, {

			# get optimized parameter vector for selected geography
			load(system.file("US/parAll10_2019-01-18 17:59:23.rda", package="MITUS")) 

			# Stop the <<- operator in OutputZInt from assigning to the global scope
			Int1<-0
			Int2<-0
			Int3<-0
			Int4<-0
			Int5<-0
			Scen1<-0
			Scen2<-0
			Scen3<-0
			IP <- NULL
			trans_mat_tot_ages <- NULL
			results <- NULL

			# Alter parameters for a given custom scenario

			# Feed parameter vector and scenario definition into MITUS 
			OutputsZint(
				1,
				ParMatrix=ParMatrix, 
				startyr=1950, 
				endyr=2050,
				Int1=0,
				Int2=0,
				Int3=0,
				Int4=0,
				Int5=0,
				Scen1=0,
				Scen2=0,
				Scen3=0)

			# Reshape results "on-the-fly" for the selected outcomes plot and append new
			# results to the original outcomes dataframes
		})
	})
}
