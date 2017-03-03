library(shiny)
### ---load packages--- #############################################################
require(shinydashboard, quietly = TRUE)

#### --- SHINY UI -------------------------------------------------------------- ####
ui <- dashboardPage(
  dashboardHeader(title = "ODD App"),
  ### ---dashboardSidebar--- ##########################################################
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Data Selection", tabName = 'dataselection', icon = icon("database")), 
      
      menuItem("Visualizing Data",
               tabName = 'visualizingdata',
               menuSubItem("Map",
                           tabName = 'map', icon = icon("bar-chart"))),
      menuItem("Analyzing Data", tabName = 'analyzingdata', icon = icon("bar-chart")
             ),
      
      menuItem("About", tabName = 'about')
    )
  ),
  ### ---dashboardBody--- #############################################################
  dashboardBody(
    tabItems(
      
      # --- dataselection --------------------------------------------------------------- #
      source("./sources/selection.R", local = TRUE)$value,
      
      # --- Visualization --------------------------------------------------------------- #
      source("./sources/visualization.R", local = TRUE)$value,
      
      # --- Analyzing ------------------------------------------------------------------- #
      source("./sources/analyzing.R", local = TRUE)$value,
      
      # --- About ----------------------------------------------------------------------- #
      source("./sources/about.R", local = TRUE)$value

    )
  ))
