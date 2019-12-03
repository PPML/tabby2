library(shinytest)
app <- ShinyDriver$new("../")
app$snapshotInit("test_download_trends")


geographies <- c("United States", "California", "Florida", "Georgia",
                 "Illinois", "Massachusetts", "New Jersey", "New York",
                 "Pennsylvania", "Texas", "Virginia", "Washington") 

for (location in geographies) { 
  cat(location)
  app$setInputs(state = location)
  Sys.sleep(3)
  # app$setInputs(sidebar = "timetrends")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_infection_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "pct_ltbi")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_incidence_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
  app$setInputs(`tabby1-trendsOutcomes` = "tb_deaths_per_100k")
  app$snapshotDownload("tabby1-trendsCSV")
}
