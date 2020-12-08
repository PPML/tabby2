# runCostComparisonModule<-function(input, output, session, n, values, costcomparisonData) { 
#   reactive({
#     
#     costs<-list()
#     costs[['LTBIIdCost']]<-input[['LTBIIdCost']]
#     costs[['TSTCost']]<-input[['TSTCost']]
#     costs[['IGRACost']]<-input[['IGRACost']]
#     costs[['NoTBCost']]<-input[['NoTBCost']]
#     
#     costs[['3HPCost']]<-input[['Cost3HP']]
#     costs[['4RCost']]<-input[['Cost4R']]
#     costs[['3HRCost']]<-input[['Cost3HR']]
#     
#     costs[['TBtest']]<-input[['TBTestCost']]
#     costs[['TBtx']]<-input[['TBTreatCost']]
#     
#     #calculate the cost of TB disease treatments
#     
#     baseline_TBtx<-sum(costcomparisonData)
#     
#     new_cost_data<-list()
#     return(new_cost_data)
#   }) #end of reactive
# }#end of function