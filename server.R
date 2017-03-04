library(shiny)
library(raster)
library(tidyverse)
library(tmap)
library(ggmap)
library(mongolite)
library(lubridate)
library(jsonlite)
library(memoise)

source(file = 'global.R', local = TRUE)
source(file = 'sources/show_lines.R', local = TRUE)
source(file = 'Fn_delay.R', local = TRUE)
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
    list(selectInput('line',"Line Number",selected=2,c(unique(dataset$linie))),
    selectInput('day',"Day",c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")))
  })
  
  
  output$visual.2d <- renderUI({
    dataset <- data_Handler()
    list(selectInput('lines',"Line Number",c(unique(dataset$linie)),multiple = T,selected = 2),
    selectInput('date',"Date",c(dmy(unique(dataset$betriebsdatum)))))
  })
  
  
              
  output$line.plot <- renderPlot({
    dataset <- data_Handler()
    Final(Data=dataset,Line=input$line,input$day)
  })
  
  output$maps <- renderPlot({
    req(input$lines)
    show_lines_mem(lines = input$lines)
  })
}