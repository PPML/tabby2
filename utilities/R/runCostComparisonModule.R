runCostComparisonModule<-function(input, output, session, sim_data, treat_dist) {
  reactive({
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
### SET THE UNIT COSTS BASED ON USER INPUT 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
    costs<-rep(0,12)
    names(costs)<-c('LTBIIdCost','TSTCost','IGRACost','NoTBCost',
                    '3HPCost','4RCost','3HRCost','TBIdCost', 'TBtest', 
                    'TBtx', 'Discount', 'EndYear')
    
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
    
    costs['Discount']<-3
    costs["EndYear"]<-input[['CostEndYr']]
    
    nyrs<-length(2020:costs['EndYear'])
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
### SET THE LTBI TESTING AND TREATMENT PARAMETERS BASED ON USER INPUT ON CARE CASCADE PAGE
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
    IGRA_frc<-treat_dist[1]
    tx_dist<-treat_dist[2:4]
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
### REACTIVE SIMULATION DATA FOR THE CALCULATIONS OF COSTS BELOW 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
    COSTCOMPARISON_DATA <-  reactive({ sim_data()[['ADDOUTPUTS_DATA']] })
    TRENDS_DATA <-  reactive({ sim_data()[['TRENDS_DATA']] })
    AGEGROUPS_DATA <- reactive({ sim_data()[['AGEGROUPS_DATA']] })
### FILTER THESE DATA DOWN TO THEIR RELEVANT PARTS
    cc_data<-COSTCOMPARISON_DATA() %>%
      dplyr::filter(
        population == "all_populations",
        age_group == "all_ages",
        comparator == "absolute_value", 
        type== "mean", 
        scenario !="base_case2",
        scenario !="scenario_1",
        scenario !="scenario_2",
        scenario !="scenario_3") %>% 
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
             value = signif(value, 3)*2) 
    
    ef_data<-TRENDS_DATA() %>%
      dplyr::filter(
        population == "all_populations",
        age_group == "all_ages",
        comparator == "absolute_value",
        type=="mean", 
        scenario !="base_case2",        
        scenario !="scenario_1",
        scenario !="scenario_2",
        scenario !="scenario_3")%>%
      arrange(scenario) %>%
      mutate(
        year_adj = year + position_year(scenario)
      ) %>% 
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
             value = signif(value, 3)*2)
    
    ag_data<-AGEGROUPS_DATA() %>% 
      dplyr::filter(
        population == "all_populations",
        comparator == "absolute_value", 
        type== "mean", 
        scenario !="base_case2",        
        scenario !="scenario_1",
        scenario !="scenario_2",
        scenario !="scenario_3") %>%
      arrange(scenario) %>%
      mutate(scenario = relevel(as.factor(scenario), 'base_case'),
             value = signif(value, 3)*2)
###filter the years from user input to for the time horizon of the savings 
    cc_data<-cc_data %>% dplyr::filter(year>=2020 & year <= costs["EndYear"])
    ef_data<-ef_data %>% dplyr::filter(year>=2020 & year <= costs["EndYear"])
    ag_data<-ag_data %>% dplyr::filter(year>=2020 & year <= costs["EndYear"])
    
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
### DEFINE DISCOUNTING VECTORS
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
    double_discount<-function(
      r = costs['Discount'], # discount rate
      t, # number of years delay (t=0 for 2020) vector (0:30)
      t2=nyrs,  # duration of the stream of outcomes
      V=1) # Value of outcome in year t
      ####  TO DISCOUNT A STREAM OF ANNUAL VALUES STARTING TODAY
    {
      if(t==0){
        PV = (1-(1+r)^(-t2))/(log(1+r))
      }else{
        ####  TO DISCOUNT A STREAM OF ANNUAL VALUES STARTING AT YEAR t  (DOUBLE DISCOUNTING)
        PV = V * (1-(1+r)^(-t2))/log(1+r) * (1+r)^(-t)
      }
      return(PV)}
    
    #basic discounting is going to be equal to
    disc_vec<-(1+(costs['Discount']/100))^-(0:nyrs)
    
    #double discounting is going to be
    doub_disc_vec<-rep(0,nyrs)
    for (i in 1:nyrs){
      doub_disc_vec[i]<-double_discount(t=(i-1))
    }    
    
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
### VECTORS OF LIFE EXPECTANCY BOTH DISCOUNTED AND NOT DISCOUNTED 
### THESE COME FROM MORTALITY.ORG LIFE TABLES 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
    disc_life_exp<-rep(0,11*length(doub_disc_vec))
    life_exp<-c(78.7,72.0,62.2,52.7,43.4,34.2,25.7,18.0,11.3,6.19,3.18)
    for (i in 1:nyrs){
      disc_life_exp[(11*(i-1)+1):(11*i)]<-life_exp*doub_disc_vec[i]
    }
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## define some constants used in calculations below 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## QALY CALCULATION VALUES  
TLTBI_UW<-1 #utility weight with LTBI treatment with toxicity
TLTBI_UW_tox<-.75 #utility weight with LTBI treatment with toxicity
TB_UW<-.76 #utility weight with TB disease and treatment 
P_TLTBI_tox<-.04 #probability of toxicity during LTBI treatment
DUR_TLTBI_tox<-(2/52) #duration of reduced quality of life with toxicity (two weeks)
DUR_TB<-.75
## PRODUCTIVITY COST CALCULATION VALUES
TLTBI_clinic<-(45.72+26.82) #initial and follow-up clinic visits
TLTBI_ae<-3.55 #adverse event costs with 3HP or 3HR
P_TB_hosp<-.49 #probability of hospitalization with TB
DUR_TB_hosp<-(24/365) #average duration of hospitalization with TB (24 days)
DUR_TB_outpatient<-(6.8/365) #duration of time loss from outpatient services (6.8 days)

## ANNUAL PRODUCTIVITY BY AGE 
annual_prod<-c(0,0,20166,64686,87023,83354,67990,38504,16017,16017,16017)
lifetime_prod<-c(1117558,1399870,1757978,1856808,1582474,1142626,675070,315914,150406,88059,30805)
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### 

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## CALCULATE THE BASECASE TB CASES AND DEATHS 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####      

bc_cases<-sum(ef_data %>% filter(outcome=="tb_incidence_000s", scenario=="base_case") %>% select(value))
bc_cases_ag<-ag_data %>% filter(outcome=="tb_incidence_000s", scenario=="base_case") %>% select(value,age_group) %>%
  group_by(age_group) %>% summarise(cases=round(sum(value))) %>% select(cases)
bc_deaths<-sum(ef_data %>% filter(outcome=="tb_mortality_000s", scenario=="base_case") %>% select(value))
bc_deaths_ag<-ag_data %>% filter(outcome=="tb_mortality_000s", scenario=="base_case") %>% select(value,age_group) %>%
  group_by(age_group) %>% summarise(deaths=round(sum(value))) %>% select(deaths)

bc_tltbi_inits<-sum(cc_data %>% dplyr::filter(scenario=='base_case') %>% dplyr::filter(outcome=="ltbi_txinits_000s")%>%select(value))

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
## ANNUAL RESULTS DATAFRAME
# calculate the cost effectiveness dataframe from the larger dataframe above by year
# we want the following columns
# "Scenario", "Cost","TB Cases Averted", "TB Deaths Averted", "QALYs Saved", & "Life Years Saved", "Year"
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
all_cost_data<-data.frame(
  "Scenario"=rep(unique(cc_data$scenario),length(unique(ef_data$year))*2),
  "Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "Health Service Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "Discount"= rep(c(0,1), each=length(unique(cc_data$scenario))*length(unique(ef_data$year))),
  "Cases Averted (in 000s)"=rep(0,length(unique(cc_data$scenario))*length(unique(ef_data$year))*2),
  "Deaths Averted (in 000s)"=rep(0,length(unique(cc_data$scenario))*length(unique(ef_data$year))*2),
  "QALYs (in 000s)"=rep(0,length(unique(cc_data$scenario))*length(unique(ef_data$year))*2),
  "Life Years (in 000s)"=rep(0,length(unique(cc_data$scenario))*length(unique(ef_data$year))*2),
  "year"=rep(rep(unique(ef_data$year),each=length(unique(cc_data$scenario))),2),
  check.names = FALSE
)

#create a second dataframe for populating the costs below 
extra_cost_data<-data.frame(
  "Scenario"=rep(unique(cc_data$scenario),length(unique(ef_data$year))*2),
  "TLTBI Prod Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "TLTBI Health Service Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "TB Prod Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "TB Health Service Cost (in mil)"=rep(0,length(unique(ef_data$year))*2),
  "Discount"= rep(c(0,1), each=length(unique(cc_data$scenario))*length(unique(ef_data$year))),
  "year"=rep(rep(unique(ef_data$year),each=length(unique(cc_data$scenario))),2),
  check.names = FALSE
)

for(i in 1:nrow(all_cost_data)){
  # scen_no<-all_cost_data[i,"Scenario"]
  
  #calculate the cases, deaths, and TLTBI initiations by year and age for the scenario and the basecase 
  scen_cases_ag<-ag_data %>% filter(outcome=="tb_incidence_000s", scenario==all_cost_data[i,"Scenario"],year==all_cost_data[i,"year"]) %>% group_by(age_group) %>% summarise(cases = as.numeric(sum(value))) %>% select(cases)
  scen_cases_ag<-as.numeric(unlist(scen_cases_ag))
  
  bc_cases_agyr<-ag_data %>% filter(outcome=="tb_incidence_000s", scenario=="base_case",year==all_cost_data[i,"year"]) %>% group_by(age_group) %>% summarise(cases = as.numeric(sum(value))) %>% mutate(cases=as.numeric(cases)) %>% select(cases)
  bc_cases_agyr<-as.numeric(unlist(bc_cases_agyr))
  
  scen_deaths_ag<- ag_data %>% filter(outcome=="tb_mortality_000s", scenario==all_cost_data[i,"Scenario"],year==all_cost_data[i,"year"]) %>% group_by(age_group)  %>% summarise(deaths = as.numeric(sum(value))) %>% select(deaths)
  scen_deaths_ag<-as.numeric(unlist(scen_deaths_ag))
  bc_deaths_agyr<-ag_data %>% filter(outcome=="tb_mortality_000s", scenario=='base_case',                year==all_cost_data[i,"year"]) %>% group_by(age_group)  %>% summarise(deaths = as.numeric(sum(value))) %>% select(deaths)
  bc_deaths_agyr<-as.numeric(unlist(bc_deaths_agyr))

  scen_tests_ag<-cc_data %>% dplyr::filter(scenario==all_cost_data[i,"Scenario"],year==all_cost_data[i,"year"]) %>% dplyr::filter(outcome=="ltbi_tests_000s")%>%select(value)
  scen_tests_ag<-as.numeric(unlist(scen_tests_ag))
  
  scen_tltbi_inits_ag<-cc_data %>% dplyr::filter(scenario==all_cost_data[i,"Scenario"],year==all_cost_data[i,"year"]) %>% dplyr::filter(outcome=="ltbi_txinits_000s")%>%select(value)
  scen_tltbi_inits_ag<-as.numeric(unlist(scen_tltbi_inits_ag))
  
  bc_tltbi_inits_agyr<-cc_data %>% dplyr::filter(scenario=='base_case',year==all_cost_data[i,"year"],outcome=="ltbi_txinits_000s") %>% select(value)
  bc_tltbi_inits_agyr<-as.numeric(unlist(bc_tltbi_inits_agyr))
  
  #calculate the indvidual qalys
  index<-(all_cost_data[i,"year"]-2020)+1
  TLTBI_qaly<-TLTBI_UW_tox*P_TLTBI_tox*sum(bc_tltbi_inits_agyr-scen_tltbi_inits_ag)
  case_qaly <-sum(TB_UW*DUR_TB*(bc_cases_agyr-scen_cases_ag))
  death_qaly <- sum((bc_deaths_agyr-scen_deaths_ag)*life_exp)
  disc_death_qaly <- sum((bc_deaths_agyr-scen_deaths_ag)*disc_life_exp[(11*(index-1)+1):(11*index)])

  #calculate the individual costs 
  #set the discount factor 
  if (all_cost_data[i,"Discount"]==0){
    discount<-1; 
  } else {
    discount<-disc_vec[index]
  }
  # PRODUCTIVITY COSTS DUE TO TLTBI
  # # number of tests times the cost of those tests * clinic visit cost * adverse event costs
  extra_cost_data[i,"TLTBI Prod Cost (in mil)"]<-(scen_tltbi_inits_ag*(TLTBI_clinic+TLTBI_ae)*discount)/1e3 #probability of toxicity and cost of adverse events
  # HEALTH SERVICES COSTS DUE TO TLTBI
  # number of tests times the cost of those tests * the cost of the regimen.
  # Each of these costs will be calculated as a weighted average.
  LTBI_test_cost<-scen_tests_ag*(IGRA_frc*costs[['IGRACost']])+((1-IGRA_frc)*costs[['TSTCost']])
  TLTBI_cost<- scen_tltbi_inits_ag*(tx_dist[1]*costs[['3HPCost']])+(tx_dist[2]*costs[['4RCost']])+(tx_dist[3]*costs[['3HRCost']])
  
  extra_cost_data[i,"TLTBI Health Service Cost (in mil)"]<-((LTBI_test_cost + TLTBI_cost)*discount)/1e3
  
  #PRODUCTIVITY COSTS DUE TO TB DISEASE
  #age specific TB treatment initiations*((probability of TB hospitalization*duration of TB hospitalization)+
  #duration of outpatient losses)*annual productivity estimates +
  #age specific TB deaths*lifetime productivity estimates
  extra_cost_data[i,"TB Prod Cost (in mil)"]<-((sum(scen_cases_ag*((P_TB_hosp*DUR_TB_hosp)+DUR_TB_outpatient)*annual_prod)+sum(scen_deaths_ag*lifetime_prod))*discount)/1e3
  # HEALTH SERVICES COSTS DUE TO TB DISEASE
  # Number of tests * (cost of those tests + the cost of the regimen)
  extra_cost_data[i,"TB Health Service Cost (in mil)"]<-((sum(scen_cases_ag)*(costs[['TBtest']]+costs[['TBtx']]))*discount)/1e3
  
####fill in the all costs data tabel using these values above   
  #costs are calculated above using the discount so they can be outside of the loop
  all_cost_data[i,"Cost (in mil)"]<- round(extra_cost_data[i,2]+extra_cost_data[i,3]+extra_cost_data[i,4]+extra_cost_data[i,5])
  all_cost_data[i,"Health Service Cost (in mil)"]<- round(extra_cost_data[i,3]+extra_cost_data[i,5])
  #no discounting
  if (all_cost_data[i,"Discount"]==0){
    all_cost_data[i,"Cases Averted (in 000s)"]<-
      round((ef_data%>%filter(scenario=="base_case", outcome=="tb_incidence_000s", year==all_cost_data[i,"year"])%>%select(value))-
      ef_data%>%filter(scenario==all_cost_data[i,"Scenario"], outcome=="tb_incidence_000s", year==all_cost_data[i,"year"])%>%select(value),3)
    
    all_cost_data[i,"Deaths Averted (in 000s)"]<-
      round((ef_data%>%filter(scenario=="base_case", outcome=="tb_mortality_000s", year==all_cost_data[i,"year"])%>%select(value))-
      ef_data%>%filter(scenario==all_cost_data[i,"Scenario"], outcome=="tb_mortality_000s", year==all_cost_data[i,"year"])%>%select(value),3)
    all_cost_data[i,"QALYs (in 000s)"]<-round((TLTBI_qaly+case_qaly)+death_qaly,3)
    all_cost_data[i,"Life Years (in 000s)"]<-round(death_qaly,3)
  } else {
    #yes discounting
    # all_cost_data[i,"Cost (in mil)"]<- round(((tltbi_prod + tltbi_health + tb_prod + tb_health)*disc_vec[index])/1e3)
    # all_cost_data[i,"Health Service Cost (in mil)"]<- round(((tltbi_health + tb_health)*disc_vec[index])/1e3)
    
    all_cost_data[i,"Cases Averted (in 000s)"]<-
      round((ef_data%>%filter(scenario=="base_case", outcome=="tb_incidence_000s", year==all_cost_data[i,"year"])%>%select(value))-
      ef_data%>%filter(scenario==all_cost_data[i,"Scenario"], outcome=="tb_incidence_000s", year==all_cost_data[i,"year"])%>%select(value)*disc_vec[index],3)
    all_cost_data[i,"Deaths Averted (in 000s)"]<-
      round((ef_data%>%filter(scenario=="base_case", outcome=="tb_mortality_000s", year==all_cost_data[i,"year"])%>%select(value))-
      ef_data%>%filter(scenario==all_cost_data[i,"Scenario"], outcome=="tb_mortality_000s", year==all_cost_data[i,"year"])%>%select(value)*disc_vec[index],3)
    all_cost_data[i,"QALYs (in 000s)"]<-round(((TLTBI_qaly+case_qaly)*disc_vec[index])+disc_death_qaly,3)
    all_cost_data[i,"Life Years (in 000s)"]<-round(disc_death_qaly,3)
  }
}

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## EFFECTIVENESS MEASURES DATAFRAME
## create a new data frame of the effectiveness measures with the following columns:
## "Scenario", "TB Cases Averted", "TB Deaths Averted", "QALYs Saved", "Life Years Saved" 
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####    
new_effect_data<-matrix(0,length(unique(cc_data$scenario)),4)
new_effect_data<-as.data.frame(new_effect_data)
colnames(new_effect_data)<-c("TB Cases Averted (in 000s)", "TB Deaths Averted (in 000s)", "QALYs Saved (in 000s)", "Life Years Saved (in 000s)")
for (i in 1:length(unique(cc_data$scenario))){
  scen_no<-unique(cc_data$scenario)[i]

  #filter the data based on the scenario
  new_effect_data[i,1]<-round(bc_cases-(sum(ef_data%>%filter(scenario==scen_no, outcome=="tb_incidence_000s")%>%select(value))),3)
  new_effect_data[i,2]<-round(bc_deaths-(sum(ef_data%>%filter(scenario==scen_no, outcome=="tb_mortality_000s")%>%select(value))),3)

 # get the scenario specific age cases and deaths
  scen_cases_ag<-ag_data %>% filter(outcome=="tb_incidence_000s", scenario==scen_no) %>% select(value,age_group) %>%
    group_by(age_group) %>% summarise(cases=round(sum(value))) %>% select(cases)
  scen_deaths_ag<-ag_data %>% filter(outcome=="tb_mortality_000s", scenario==scen_no) %>% select(value,age_group) %>%
    group_by(age_group) %>% summarise(deaths=round(sum(value))) %>% select(deaths)

  new_effect_data[i,3]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == scen_no) %>% select("QALYs (in 000s)"))),0)
  new_effect_data[i,4]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == scen_no) %>% select("Life Years (in 000s)"))),0)
}

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####    

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## COSTS MEASURES DATAFRAME
##create a new data frame of costs with the following columns:
## "Scenario", "Productivity Cost Due to TLTBI","Health services Cost Due to TLTBI"
## "Productivity Cost Due to TB Disease","Health services Cost Due to TB Disease"
## "Total Health services Cost","Total Cost"
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  

new_cost_data<-matrix(0,length(unique(cc_data$scenario)),7)
new_cost_data<-as.data.frame(new_cost_data)
colnames(new_cost_data)<-c("Productivity cost due to LTBI treatment", "Health services cost due to LTBI treatment",
                           "Productivity cost due to TB disease", "Health services cost due to TB disease",
                           "Total health services cost", "Total cost", "Discount")

for (i in 1:length(unique(cc_data$scenario))){

  scen_no<-unique(cc_data$scenario)[i]

  new_cost_data[i,1]<-round(sum(extra_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`TLTBI Prod Cost (in mil)`)))
  new_cost_data[i,2]<-sum(extra_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`TLTBI Health Service Cost (in mil)`))
  new_cost_data[i,3]<-round(sum(extra_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`TB Prod Cost (in mil)`)))
  new_cost_data[i,4]<-sum(extra_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`TB Health Service Cost (in mil)`))
  
  #Total Health services Cost is simply the sum of the two above Health services columns
  new_cost_data[i,5]<-sum(all_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`Health Service Cost (in mil)`))
  #Total Cost is simply the sum of the other four costs
  new_cost_data[i,6]<-sum(all_cost_data %>% filter(Scenario==scen_no, Discount==0) %>% select(`Cost (in mil)`))
}

# new_cost_data[i,7]<-0 #zero means no discount
new_cost_data<-rbind(new_cost_data,new_cost_data)
new_cost_data[(length(unique(cc_data$scenario))+1):nrow(new_cost_data),1]<-1:length(unique(cc_data$scenario))#restores scenarios to whole numbers
new_cost_data[(length(unique(cc_data$scenario))+1):nrow(new_cost_data),7]<-1 #one means yes to discount
new_cost_data<-data.frame("Scenario"=rep(unique(cc_data$scenario),2),
                          new_cost_data, check.names = FALSE)
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####    

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
## COST EFFECTIVENESS DATAFRAME   
## larger dataframe for filtering for calculations of CE table below
## we need the following columns:
## "Scenario", "Cost", "HealthSys/All", "Discount","AvtCases","AvtDeaths", "SavQALYs", "SavLYs"
cost_eff_base<-data.frame(
  "Scenario"=rep(unique(cc_data$scenario),4),
  "Cost (in mil)"=rep(0,(length(unique(cc_data$scenario))*4)),
  "perspectives"=c(rep("healthsys",(length(unique(cc_data$scenario))*2)),rep("all",(length(unique(cc_data$scenario))*2))),
  "discount"=rep(c(rep(1,length(unique(cc_data$scenario))),rep(0,length(unique(cc_data$scenario)))),2),
  "avtcases"=rep(0,(length(unique(cc_data$scenario))*4)),
  "avtdeaths"=rep(0,(length(unique(cc_data$scenario))*4)),
  "savqalys"=rep(0,length(unique(cc_data$scenario))*4),
  "savlys"=rep(0,length(unique(cc_data$scenario))*4),
  check.names = FALSE
)

for (i in 1:nrow(cost_eff_base)){
  #no discounting
  if(cost_eff_base[i,3]=="all" & cost_eff_base[i,4]==0){
    cost_eff_base[i,2]<-new_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==0) %>% select(`Total cost`)
    cost_eff_base[i,2]<-sum(all_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==0) %>% select(`Cost (in mil)`))
    
  } else if (cost_eff_base[i,3]=="healthsys" & cost_eff_base[i,4]==0) {
    # cost_eff_base[i,2]<-new_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==0) %>% select(`Total health services cost`)
    cost_eff_base[i,2]<-sum(all_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==0) %>% select(`Health Service Cost (in mil)`))
    
  #discounting
  } else if (cost_eff_base[i,3]=="all" & cost_eff_base[i,4]==1) {
    # cost_eff_base[i,2]<-new_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==1) %>% select(`Total cost`)
    cost_eff_base[i,2]<-sum(all_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==1) %>% select(`Cost (in mil)`))
    
  } else if (cost_eff_base[i,3]=="healthsys" & cost_eff_base[i,4]==1) {
    # cost_eff_base[i,2]<-new_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==1) %>% select(`Total health services cost`)
    cost_eff_base[i,2]<-sum(all_cost_data %>% filter(Scenario==cost_eff_base[i,1], Discount==1) %>% select(`Health Service Cost (in mil)`))
  }
  
  #no discounting outcomes
  if(cost_eff_base[i,4]==0){
    cost_eff_base[i,5]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_base[i,1]) %>% select("Cases Averted (in 000s)"))),3)
    cost_eff_base[i,6]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_base[i,1]) %>% select("Deaths Averted (in 000s)"))),3)
    cost_eff_base[i,7]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_base[i,1]) %>% select("QALYs (in 000s)"))),3)
    cost_eff_base[i,8]<- round((sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_base[i,1]) %>% select("Life Years (in 000s)"))),3)
  #discounting outcomes
  } else if (cost_eff_base[i,4]==1){
    cost_eff_base[i,5]<- round((sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_base[i,1]) %>% select("Cases Averted (in 000s)"))),3)
    cost_eff_base[i,6]<- round((sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_base[i,1]) %>% select("Deaths Averted (in 000s)"))),3)
    cost_eff_base[i,7]<- round((sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_base[i,1]) %>% select("QALYs (in 000s)"))),3)
    cost_eff_base[i,8]<- round((sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_base[i,1]) %>% select("Life Years (in 000s)"))),3)
  }
}

cost_eff_base<-reshape2::melt(cost_eff_base, id.vars=c("Scenario","Cost (in mil)","perspectives","discount"))
colnames(cost_eff_base)[5]<-"Effectiveness Measure"
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
#calculate the cost effectiveness dataframe from the larger dataframe above
# we want the following columns
# "Scenario", "Cost", "Incremental Cost","Effectiveness","Incremental Effectiveness", "ICER"
# the effectiveness measure should update based on the radio button entry 
# options are: TB Cases Averted, TB Deaths Averted, QALYs Saved, & Life Years Saved
# The costs should also be pivoted between health services and health services & patient costs
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####  
cost_eff_ACER<-data.frame(
  "Scenario"=rep(unique(cc_data$scenario),4),
  "Cost (in mil)"=rep(0,(length(unique(cc_data$scenario))*4)),
  "Incremental Cost (in mil)" = rep(0,(length(unique(cc_data$scenario))*4)),
  "perspectives"=c(rep("healthsys",(length(unique(cc_data$scenario))*2)),rep("all",(length(unique(cc_data$scenario))*2))),
  "discount"=rep(c(rep(1,length(unique(cc_data$scenario))),rep(0,length(unique(cc_data$scenario)))),2),
  "avtcases"=rep(0,(length(unique(cc_data$scenario))*4)),
  "avtdeaths"=rep(0,(length(unique(cc_data$scenario))*4)),
  "savqalys"=rep(0,length(unique(cc_data$scenario))*4),
  "savlys"=rep(0,length(unique(cc_data$scenario))*4),
  check.names = FALSE
)

for (i in 1:nrow(cost_eff_ACER)){

  cost_eff_ACER[i,2]<-cost_eff_base[i,2]
  #calculate the incremental costs
  #no discounting
  if(cost_eff_ACER[i,4]=="all" & cost_eff_ACER[i,5]==0){
    cost_eff_ACER[i,3]<-cost_eff_base[i,2] -
                        new_cost_data %>% filter(Scenario=="base_case", Discount==0) %>% select(`Total cost`)
  } else if (cost_eff_ACER[i,4]=="healthsys" & cost_eff_ACER[i,5]==0) {
    
    cost_eff_ACER[i,3]<-cost_eff_base[i,2] -
      new_cost_data %>% filter(Scenario=="base_case", Discount==0) %>% select(`Total health services cost`)
    #discounting
  } else if (cost_eff_ACER[i,4]=="all" & cost_eff_ACER[i,5]==1) {
    cost_eff_ACER[i,3]<-cost_eff_base[i,2]-
      new_cost_data %>% filter(Scenario=="base_case", Discount==1) %>% select(`Total cost`)
  } else if (cost_eff_ACER[i,4]=="healthsys" & cost_eff_ACER[i,5]==1) {
    cost_eff_ACER[i,3]<-cost_eff_base[i,2] -
      new_cost_data %>% filter(Scenario=="base_case", Discount==1) %>% select(`Total health services cost`)
  }

  #calculate the effectiveness measures
  #no discounting outcomes
  if(cost_eff_ACER[i,5]==0){
    cost_eff_ACER[i,6]<- round(sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_ACER[i,1]) %>% select("Cases Averted (in 000s)")),0)
    cost_eff_ACER[i,7]<- round(sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_ACER[i,1]) %>% select("Deaths Averted (in 000s)")),0)
    cost_eff_ACER[i,8]<- round(sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_ACER[i,1]) %>% select("QALYs (in 000s)")),0)
    cost_eff_ACER[i,9]<- round(sum(all_cost_data %>% filter(Discount==0,Scenario == cost_eff_ACER[i,1]) %>% select("Life Years (in 000s)")),0)
    #discounting outcomes
  } else if (cost_eff_ACER[i,5]==1){
    cost_eff_ACER[i,6]<- round(sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_ACER[i,1]) %>% select("Cases Averted (in 000s)")),0)
    cost_eff_ACER[i,7]<- round(sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_ACER[i,1]) %>% select("Deaths Averted (in 000s)" )),0)
    cost_eff_ACER[i,8]<- round(sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_ACER[i,1]) %>% select("QALYs (in 000s)")),0)
    cost_eff_ACER[i,9]<- round(sum(all_cost_data %>% filter(Discount==1,Scenario == cost_eff_ACER[i,1]) %>% select("Life Years (in 000s)")),0)
  }
}

cost_eff_ACER[,3]<- - cost_eff_ACER[,3]

cost_eff_ACER<-reshape2::melt(cost_eff_ACER, id.vars=c("Scenario","Cost (in mil)","Incremental Cost (in mil)","perspectives","discount"))
colnames(cost_eff_ACER)[6]<-"Effectiveness Measure"
new_effect_data<-data.frame("Scenario"=unique(cc_data$scenario),
                            new_effect_data, check.names = FALSE)


    new_cost_data_list<-list()
    new_cost_data_list[['new_effect_data']]<-new_effect_data
    new_cost_data_list[['new_cost_data']]<-new_cost_data 
    new_cost_data_list[['ICER_data']]<-cost_eff_base
    new_cost_data_list[['ACER_data']]<-cost_eff_ACER
    new_cost_data_list[['annual']]<-all_cost_data
        
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####     
    return(new_cost_data_list)
  }) #end of reactive
  
  
}#end of function