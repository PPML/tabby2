#' @export
#' @importFrom dplyr %>% filter select
#' @importFrom ggplot2 ggplot geom_line aes
render_plot <- function(df, selected_output) {
  if (! selected_output %in% df$Output) {
    stop("selected_output must be one of the outputs included in the data.")
  }
  df <- df %>% 
    filter(Output == selected_output) %>% 
    select(Year, Value)
  
  p <- ggplot(data = df, aes(x = Year, y = Value)) +
    geom_line()
  
  return(p)
}