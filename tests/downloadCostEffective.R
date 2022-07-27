#!/bin/Rscript

# When this shiny test is run: 
# 
# - a headless browser launches running shiny 
# - selects each geography
# - downloads estimates data for all interventions measured as percent basecase 2018
# - each of the downloads are renamed to reflect what data they contain

library(shinytest)
library(MITUS)

# before we run the shinytest which downloads the cost effectiveness data, 
# we need to delete the data that's in the test's download folder

current_files <- list.files("downloadCostEffective-current/", full.names=T)
file.remove(current_files)

# start a new headless browser running Tabby2

app <- ShinyDriver$new("~/tabby2")

# name the test so that the data downloaded goes into downloadCostEffective-current

app$snapshotInit("downloadCostEffective")

# these are the geographies downloaded in this test

geographies <- setNames(nm = state.abb, state.name)
invert_geographies <- setNames(nm = unname(geographies), object = names(geographies))

# we need to determine the population size to pass into the argument below 

# for (location in geographies){
#   load(system.file(paste0(location,"/", location,"_results_1.rda"), package="MITUS"))
#   NUSBpop <- sum(out[1,73,817:818])
# }

for (location in c("California")) {

  geo_short_code <- invert_geographies[[location]]
  load(system.file(paste0(geo_short_code,"/", geo_short_code,"_results_1.rda"), package="MITUS"))
  NUSBpop <- sum(out[1,73,817:818])*1e3
  
  app$setInputs(state = location, wait_=FALSE, values_=FALSE)
  print(location)

  app$setInputs(sidebar = "customscenarios", wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1nativity = "fb_population", wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1numberTargeted = 1.2, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1numberTargeted = 1, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1numberTargeted = 12, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1numberTargeted = NUSBpop, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1fractionScreened = 0, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1fractionScreened = 0.1, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1startyear = 2022, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1startyear = 2025, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1stopyear = 20, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1stopyear = 2029, wait_=FALSE, values_=FALSE)
  app$setInputs(ttt1RunSimulations = "click", wait_=FALSE, values_=FALSE)
  app$setInputs(sidebar = "entercosts", wait_=FALSE, values_=FALSE)
  app$setInputs(CalculateCosts = "click", wait_=FALSE, values_=FALSE, allowInputNoBinding_ = TRUE)
  app$setInputs(sidebar = "costcomparison", wait_=FALSE, values_=FALSE)
  app$setInputs(`tabby1-costcomparisonInterventions-6` = TRUE, wait_=FALSE, values_=FALSE, allowInputNoBinding_ = TRUE)
  app$setInputs(`tabby1-costcomparisonInterventions` = "ttt1", wait_=FALSE, values_=FALSE, allowInputNoBinding_ = TRUE)
  app$setInputs(`tabby1-costcomparisonCosts` = "savqalys", wait_=FALSE, values_=FALSE)
  app$setInputs(`tabby1-costcomparisonDiscount` = "1", wait_=FALSE, values_=FALSE)
  app$snapshotDownload("tabby1-costcomparisonCSV")
  
}

#### rename these files 

# filenames are constructed using the filenames and 
# outcomes lists

# filenames <- sapply(1:length(geographies), function(iter) {
#   file.path("downloadCostEffective-current/", 
#             paste0(geographies[[iter]],
#                    "_CE.csv")
#   )
# })

# current_files <- list.files("downloadCostEffective-current/", full.names=T)
# file.rename(current_files, filenames)