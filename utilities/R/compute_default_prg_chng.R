compute_default_prg_chng <- function(input, output, session, geo_short_code) {
	reactive({ 
		# load the geography data into mitus
		model_load(geo_short_code())

		# Get the prg_chng vector from the parameter vector
		prg_chng <- def_prgchng(ParVec=Par[1,])

		return(prg_chng)
	})
}
