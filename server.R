library(shiny)
library(raster)
library(tidyverse)
library(tmap)
library(ggmap)
library(mongolite)
library(lubridate)
library(jsonlite)
library(memoise)

source(file = 'sources/show_lines.R', local = TRUE)

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

  output$visual.1d <- renderUI({
    dataset <- data_Handler()
    selectInput('line',"Line Number",c(unique(dataset$linie)))
  })
  
  
  output$visual.2d <- renderUI({
    dataset <- data_Handler()
    selectInput('lines',"Line Number",c(unique(dataset$linie)),multiple = T)
 #   actionButton('plot',"Plot")
  })
  
  output$line.plot <- renderPlot({
    dataset <- data_Handler()
    hist(dataset[dataset$linie==input$line,"soll_an_von"])
  })
  
  output$maps <- renderPlot({
    show_lines_mem(lines = input$lines)
  })
}