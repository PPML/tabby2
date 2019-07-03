fillDefaultProgramChangeValues <- function(input, output, session, geo_short_code) {
	# load the geography data into mitus
	model_load(geo_short_code())

  # Get the prg_chng vector from the parameter vector
	prg_chng <- def_prgchng(ParVec=Par[1,])

  render_PC_coverageRateInput <- function(id) { renderUI({
			numericInput(inputId = paste0(id, "CoverageRate"),
									label = "Screening Coverage Rate as a Multiple of the Current Rate",
									value = prg_chng['scrn_cov'], min = 1, max = 5)
		})
	}
  
	output[['programChange1CoverageRateInput']] <- render_PC_coverageRateInput('programChange1')
	output[['programChange2CoverageRateInput']] <- render_PC_coverageRateInput('programChange2')
	output[['programChange3CoverageRateInput']] <- render_PC_coverageRateInput('programChange3')

  render_PC_receivingIGRAInput <- function(id) { renderUI({
        numericInput(inputId = paste0(id, "IGRACoverage"),
                     label = "Fraction of Individuals Receiving IGRA (%)",
                     value = prg_chng['IGRA_frc'], min = 0, max = 100)
		})
	}

	output[['programChange1IGRACoverageInput']] <- render_PC_receivingIGRAInput('programChange1')
	output[['programChange2IGRACoverageInput']] <- render_PC_receivingIGRAInput('programChange2')
	output[['programChange3IGRACoverageInput']] <- render_PC_receivingIGRAInput('programChange3')

  render_PC_accepting_ltbi_trt <- function(id) { renderUI({
        numericInput(inputId = paste0(id, "AcceptingTreatmentFraction"),
                     label = "Fraction of Individuals Testing Positive who Accept Treatment (%)",
                     value = prg_chng['ltbi_init_frc'], min = 0, max = 100)
		})
	}

	output[['programChange1AcceptingTrtFrcInput']] <- render_PC_accepting_ltbi_trt('programChange1')
	output[['programChange2AcceptingTrtFrcInput']] <- render_PC_accepting_ltbi_trt('programChange2')
	output[['programChange3AcceptingTrtFrcInput']] <- render_PC_accepting_ltbi_trt('programChange3')


  render_PC_completion_rate <- function(id) { renderUI({
        numericInput(inputId = paste0(id, "CompletionRate"),
                     label = "Fraction of Individuals Initiating Treatment Who Complete Treatment (%)",
                     value = prg_chng['ltbi_comp_frc'], min = 0, max = 100)
	  })
  }

	output[['programChange1CompletionRateInput']] <- render_PC_completion_rate('programChange1')
	output[['programChange2CompletionRateInput']] <- render_PC_completion_rate('programChange2')
	output[['programChange3CompletionRateInput']] <- render_PC_completion_rate('programChange3')

  
  render_PC_AvgTimeToTrtInput <- function(id) { renderUI({
      numericInput(inputId = paste0(id, "AverageTimeToTreatment"),
                   label = "Duration of Infectiousness (0-100% of current value)",
                   value = prg_chng['tb_tim2tx_frc'], min = 0, max = 1)
	 }) }

	output[['programChange1AvgTimeToTrtInput']] <- render_PC_AvgTimeToTrtInput('programChange1')
	output[['programChange2AvgTimeToTrtInput']] <- render_PC_AvgTimeToTrtInput('programChange2')
	output[['programChange3AvgTimeToTrtInput']] <- render_PC_AvgTimeToTrtInput('programChange3')
  
  render_PC_TrtDefaultInput <- function(id) { renderUI({
      numericInput(inputId = paste0(id, "DefaultRate"),
                   label = "Fraction Discontinuing/Defaulting from Treatment (%)",
                   value = prg_chng['tb_txdef_frc'], min = 0, max = 100)
	 }) }

	output[['programChange1TrtDefaultInput']] <- render_PC_TrtDefaultInput('programChange1')
	output[['programChange2TrtDefaultInput']] <- render_PC_TrtDefaultInput('programChange2')
	output[['programChange3TrtDefaultInput']] <- render_PC_TrtDefaultInput('programChange3')


  return(prg_chng)
}
