compute_default_cost_inputs<- function(input, output, session, geo_short_code) {
  reactive({ 
    # load the geography data into mitus
    model_load(geo_short_code())
    
    # Get the prg_chng vector from the parameter vector
    cost_inputs <- def_costinputs()
    
    return(cost_inputs)
  })
}
