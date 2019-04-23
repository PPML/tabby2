#' Function to Determine Geographies Available in MITUS
#' 
#' A temporary/patched feature of this function is that it will
#' always include the United States.
#' 
#' @param geography_ids A Vector of Two-Character Codes Corresponding to Geographies 
#' @return A vector of two-character codes corresponding to geographies which have 
#' 1. an optimization data file (Optim_all or opt_all), 
#' 2. A "bg_restab2" data file, and
#' 3. A "sm_restab2" data file.
#' @example
#' library(MITUS)
#' geographies <- setNames(nm = state.abb, state.name)
#' geographies[['US']] <- 'United States'
#' geographies[['DC']] <- 'District of Columbia'
#' scan_for_available_geographies(names(geographies))
#' #> [1] "US" "CA" "FL" "GA" "IL" "NJ" "NY" "PA" "TX" "VA" "WA" 

scan_for_available_geographies <- function(geography_ids) {
  # available_geographies <- MITUS::load_optim()
	# available_geography_names <- geographies[available_geographies]
	c('US', geography_ids[sapply(geography_ids, function(loc) {
	  all(c(
		  any(grepl(paste0(loc, "_Optim_all|opt_all"), list.files(system.file(loc,
            package = "MITUS"), full.names = TRUE))),
		  any(grepl('bg_restab2.rds', list.files(system.file(loc,
            package = "MITUS"), full.names = TRUE))),
		  any(grepl('sm_restab2.rds', list.files(system.file(loc,
            package = "MITUS"), full.names = TRUE)))
		))
	})])
}
