library(shiny)
### --- Language setting -------------------------------------------------------- ###
Sys.setenv(LANGUAGE = "de_CH")
Sys.setenv(LANG = "de_CH.utf8")

### --- load packages ----------------------------------------------------------- ###


#### --- SHINY SERVER ---------------------------------------------------------- ####
server <- function(input, output) {

# --- Sources --------------------------------------------------------------------- #
  # source(file = 'sources/name.R', local = TRUE)

# --------------------------------------------------------------------------------- #

  output$visual1discrete <- renderUI({
    dataset <- data_Handler()
    if(is.null(dataset)){return(NULL)}
  })
  
  output$mapPlot <- renderPlot(
    plot.new()
  )
  
}