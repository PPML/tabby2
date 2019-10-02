#' Load Risk Group Data for Targeted Testing and Treatment
#' 
load_risk_group_data <- function() {

  # Load and Clean Data -----------------------------------------------------
  
  df <- readxl::read_xlsx(system.file("riskgroup_rate_ratios.xlsx", package = 'utilities'))
  df <- df[1:6, 1:4]
  colnames(df)[[1]] <- 'population'
  
  df %>% mutate(
    `RR of active TB given LTBI` = as.numeric(gsub("\\*", "", `RR of active TB given LTBI`)),
    `RR of LTBI prevalence` = as.numeric(`RR of LTBI prevalence`),
    `RR of mortality` = as.numeric(`RR of mortality`)
  ) -> df
  
  # since some of the data is still missing, we're going to fill it in with 
  # assumed values for the time being.
  low <- 1
  med <- 25
  high <- 50
  
  # Rename Populations
  df$population <- 
    c("Non-US Born Individuals from High Burden Countries",
      "Homeless Individuals",
      "HIV Positive",
      "Diabetics",
      "End Stage Renal Disease",
      "Smokers")
  
  # Add All Individuals
  df <- rbind.data.frame(df, list("All Individuals", 1, 1, 1))
  

  # Replace Empty Values ----------------------------------------------------

  empty_values <- data.frame(row = 1:6, col = c(3, 3, 4, 4, 4, 4))
  all_na <- all(apply(empty_values, 1, function(coord) is.na(df[coord[[1]], coord[[2]]])))
  if (! all_na) stop("the previously empty values in the risk group data now have data.")
  
  df[empty_values[1,1], empty_values[1,2]] <- 10.4 # immigrant from high burden country ltbi
  df[empty_values[2,1], empty_values[2,2]] <- 5.11 # homeless ltbi 
  df[empty_values[3,1], empty_values[3,2]] <- 2.19 # hiv mortality
  df[empty_values[4,1], empty_values[4,2]] <- 1.88 # diabetic mortality 
  df[empty_values[5,1], empty_values[5,2]] <- 4.21 # end stage renal disease mortality 
  df[empty_values[6,1], empty_values[6,2]] <- 1.3 # smokers mortality 
  
  return(df)
}

load_risk_group_data2 <- function() {
  # load data
  df <- readxl::read_xlsx(system.file("Risk Group Rate Ratios for Tabby2.xlsx", package = 'utilities'), col_names=)

  colnames(df)[1:4] <- c('population', 'rr_prog', 'rr_mort', 'rr_ltbi')
  
  df <- df[,c(1,2,4,3,5,6)] # re-order to match prog, ltbi, mort ordering
  return(df)
}
