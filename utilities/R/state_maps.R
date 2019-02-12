# Let's Make Maps with State Data
#' @import readxl
load_state_data <- function() {
	require(ggplot2)
	require(mapproj)
	require(fiftystater)
	# devtools::install_github("wmurphyrd/fiftystater")
	require(ggrepel)

	# load data
	cases_df <- readr::read_csv(file = system.file('state_data/cases.csv', package = 'utilities'))

	# visualize for a single year

	# just testing
	crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)

	centroid_of_each_state <- fifty_states %>% 
		group_by(id) %>% 
		summarize(lat = mean(lat), long = mean(long)) 


	p <- ggplot(crimes) + geom_map(aes( fill = Assault, map_id = state), map = fifty_states) + 
		geom_text_repel(
			data = centroid_of_each_state, 
			mapping = aes(x=long, y=lat, label = id), size=2) + 
		expand_limits(x = fifty_states$long, y = fifty_states$lat) +
		coord_map() + 
		scale_x_continuous(breaks = NULL) + 
		scale_y_continuous(breaks = NULL) +
		labs(x = "", y = "") +
		theme(panel.background = element_blank())

	p


	# geographic center of DC
	# 38.904167, -77.016111

	
}
