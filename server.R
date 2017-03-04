library(shiny)
### --- Language setting -------------------------------------------------------- ###
Sys.setenv(LANGUAGE = "de_CH")
Sys.setenv(LANG = "de_CH.utf8")

### --- load packages ----------------------------------------------------------- ###
require(DT, quietly = TRUE) # install.packages('DT', repos = 'http://cran.rstudio.com')
require(datasets, quietly = TRUE)
require(epitools, quietly = TRUE)
require(lattice, quietly = TRUE)


#### --- SHINY SERVER ---------------------------------------------------------- ####
server <- function(input, output) {

# --- Sources --------------------------------------------------------------------- #
  source(file = 'sources/dataselection.R', local = TRUE)
# --------------------------------------------------------------------------------- #


# --------------------------------------------------------------------------------- #

  output$visual <- renderUI({
    dataset <- data_Handler()
    selectInput('line',"Line Number",c(unique(dataset$linie)))
  })
  
  output$lines <- renderPlot({
    dataset <- data_Handler()
    hist(dataset[dataset$linie==input$line,"soll_an_von"])
  })
}