runCostComparisonModule<-function(input, output, session, sim_data) {
  reactive({

    costs<-rep(0,13)
    names(costs)<-c('LTBIIdCost','TSTCost','IGRACost','NoTBCost',
                    '3HPCost','4RCost','3HRCost','TBIdCost', 'TBtest', 
                    'TBtx', 'Discount','StartYear', 'EndYear')
    
    costs['LTBIIdCost']<-input[['LTBIIdCost']]
    costs['TSTCost']<-input[['TSTCost']]
    costs['IGRACost']<-input[['IGRACost']]
    costs['NoTBCost']<-input[['NoTBCost']]

    costs['3HPCost']<-input[['Cost3HP']]
    costs['4RCost']<-input[['Cost4R']]
    costs['3HRCost']<-input[['Cost3HR']]
    
    costs['TBIdCost']<-input[['TBIdCost']]
    costs['TBtest']<-input[['TBTestCost']]
    costs['TBtx']<-input[['TBTreatCost']]
    
    costs['Discount']<-input[['DiscountRate']]
    costs["StartYear"]<-input[['CostStartYr']]
    costs["EndYear"]<-input[['CostEndYr']]
    
    # return(costs)
  #use the values in the costing equations below
  COSTCOMPARISON_DATA <-  reactive({ sim_data()[['COSTCOMPARISON_DATA']] })
  
  data<-COSTCOMPARISON_DATA() %>%
    dplyr::filter(
      population == "all_populations",
      age_group == "all_ages",
      comparator == "absolute_value"
    ) %>%
    arrange(scenario) %>%
    mutate(
      year_adj = year + position_year(scenario)
    ) %>% 
    mutate(scenario = relevel(as.factor(scenario), 'base_case'),
           value = signif(value, 3)*2) 
  
  # View(data)
    
  #filter the years from user input to for the time horizon of the savings 
  cc_data<-data %>% dplyr::filter(year >=costs["StartYear"] & year <= costs["EndYear"])
  
  # View(cc_data)
  # print(unique(cc_data$scenario))

  #outcomes are as follows:
    #ltbi_tests_000s
    #ltbi_txinits_000s
    #ltbi_txcomps_000s
    #tb_txinits_000s
    #tb_txcomps_000s

  #program change options:
  # prg_chng[['IGRA_frc']]
  # prg_chng[['frc_3hp']]
  # prg_chng[['frc_4r']]
  # prg_chng[['frc_3hr']]

#   colnames.df<-c( "Scenario", "Productivity Cost Due to TLTBI", "Health services Cost Due to TLTBI",
#                   "Productivity Cost Due to TB Disease",   "Health services Cost Due to TB Disease",
#                   "Total Health services Cost", "Total Cost")
  
  ##create a new data frame with the following columns:
  # "Scenario", "Productivity Cost Due to TLTBI","Health services Cost Due to TLTBI"
  # "Productivity Cost Due to TB Disease","Health services Cost Due to TB Disease"
  # "Total Health services Cost","Total Cost"
  
  new_cost_data<-matrix(0,length(unique(cc_data$scenario)),7)
  new_cost_data<-as.data.frame(new_cost_data)
  colnames(new_cost_data)<-c("Scenario", "Productivity cost due to TLTBI", "Health services cost due to TLTBI",
                    "Productivity cost due to TB disease", "Health services cost due to TB disease",
                    "Total health services Cost", "Total cost")
  
  #calculate basecase tbtx inits for the effectiveness measure --this will need to be expanded
  tbtx_inits_bc<-sum(cc_data %>% dplyr::filter(outcome=="tb_txinits_000s", scenario=='base_case')%>%select(value))
  
  for (i in 1:length(unique(cc_data$scenario))){
  #set the scenario names
  new_cost_data[i,1]<-unique(cc_data$scenario)[i]
  #filter the data based on the scenario 
  filter_cost_data<-cc_data %>% dplyr::filter(scenario==unique(cc_data$scenario)[i])
  
  ltbi_tests<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_tests_000s")%>%select(value))
  tltbi_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_txinits_000s")%>%select(value))
  # tbtx_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="tb_txinits_000s")%>%select(value))
  if(i==1){
    tbtx_inits<-tbtx_inits_bc
  }else{
  tbtx_inits<-tbtx_inits_bc-(tltbi_inits*.33*.78*.93)
  }
#productivity costs due to LTBI is going to be equal to the number of tx initiations and
  new_cost_data[i,2]<-round(tltbi_inits,0)
  
  # View(new_cost_data)
# #Health servicess costs due to TLTBI is going to equal the number of tests times the cost
# #of those tests + the cost of the regimen. Each of these costs will be calculated as a
# #weighted average.
#   # LTBI_test_cost<-cc_data$ltbi_tests_000s*(prg_chng[['IGRA_frc']]*costs[['IGRACost']])+((1-prg_chng[['IGRA_frc']])*costs[['TSTCost']])
  LTBI_test_cost<-ltbi_tests*(.33*costs[['IGRACost']])+((1-.33)*costs[['TSTCost']])
#   
#     # TLTBI_cost<-filter_cost_data$ltbi_txinits_000s*(prg_chng[['frc_3hp']]*costs[['3HPCost']])+(prg_chng[['frc_4r']]*costs[['4RCost']])+(prg_chng[['frc_3hr']]*costs[['3HRCost']])
  TLTBI_cost<-tltbi_inits*(.33*costs[['3HPCost']])+(.33*costs[['4RCost']])+(.33*costs[['3HRCost']])
#   
  new_cost_data[i,3]<- round(LTBI_test_cost + TLTBI_cost,0)
#   #productivity costs due to TB is going to be equal to the number of tx initiations and TB deaths
  new_cost_data[i,4]<-round(tbtx_inits,0)
#   #Health servicess costs due to TB Disease is going to equal the number of tests times the cost
#   #of those tests + the cost of the regimen. Each of these costs will be calculated as a
#   #weighted average.
  new_cost_data[i,5]<-round(tbtx_inits*(costs[['TBtest']]+costs[['TBtx']]),0)
#   #Total Health services Cost is simply the sum of the two above Health servicess columns
  new_cost_data[i,6]<-round(new_cost_data[i,3]+new_cost_data[i,5],0)
#   #Total Cost is simply the sum of the other four costs
  new_cost_data[i,7]<-round(new_cost_data[i,6]+new_cost_data[i,2]+new_cost_data[i,4],0)
  }
  
  #calculate the cost effectiveness dataframe 
  # we want the following columns
  # "Scenario", "Cost", "Incremental Cost","Effectiveness","Incremental Effectiveness", "ICER"
  
  cost_eff_data<-matrix(0,length(unique(cc_data$scenario)),6)
  cost_eff_data<-as.data.frame(cost_eff_data)
  colnames(cost_eff_data)<-c("Scenario", "Cost", "Incremental cost",
                             "Effectiveness","Incremental effectiveness", "ICER")
  

  for (i in 1:length(unique(cc_data$scenario))){
    #set the scenario names
    cost_eff_data[i,1]<-unique(cc_data$scenario)[i]
    #filter the data based on the scenario 
    filter_cost_data<-cc_data %>% dplyr::filter(scenario==unique(cc_data$scenario)[i])
    
    ltbi_tests<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_tests_000s")%>%select(value))
    tltbi_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_txinits_000s")%>%select(value))
    # tbtx_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="tb_txinits_000s")%>%select(value))
    
    tbtx_inits<-tbtx_inits_bc-(tltbi_inits*.33*.78*.93)
    
    #total cost is going to be the same as above 
    cost_eff_data[i,2]<-new_cost_data[i,7]
    # }
    # #sort by costs
    # cost_eff_data<-reorder(cost_eff_data, cost_eff_data[,2])
    # print(cost_eff_data)
    # #total effectiveness is going to be set to TB cases averted for the time being
    # for (i in 1:length(unique(cc_data$scenario))){
    #   
    #   filter_cost_data<-cc_data %>% dplyr::filter(scenario==unique(cc_data$scenario)[i])
    #   
    #   ltbi_tests<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_tests_000s")%>%select(value))
    #   tltbi_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="ltbi_txinits_000s")%>%select(value))
    #   # tbtx_inits<-sum(filter_cost_data %>% dplyr::filter(outcome=="tb_txinits_000s")%>%select(value))
    #   
    #   tbtx_inits<-tbtx_inits_bc-(tltbi_inits*.33*.78*.93)
    if(i==1){
      cost_eff_data[i,5]<-0
      cost_eff_data[i,3]<-0
      cost_eff_data[i,4]<-0
    }else{
    cost_eff_data[i,4]<-round(tbtx_inits_bc-tbtx_inits,0)
    cost_eff_data[i,5]<-round(((tbtx_inits-tbtx_inits_bc)-cost_eff_data[i-1,4]),0)
    cost_eff_data[i,3]<-round((new_cost_data[i,7]-new_cost_data[i-1,7]),0)
    }
    #calculate the ICER
    cost_eff_data[i,6]<-round((cost_eff_data[i,3]/cost_eff_data[i,5]),2)
  }
  new_cost_data_list<-list()
  #we need to sort the data based on the ICER 
  new_cost_data_list[['new_cost_data']]<-new_cost_data
  new_cost_data_list[['costeff_data']]<-cost_eff_data
  
  return(new_cost_data_list)
  }) #end of reactive
  
  
}#end of function