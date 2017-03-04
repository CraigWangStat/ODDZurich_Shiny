library(shiny)
### ---load packages--- #############################################################
require(shinydashboard, quietly = TRUE)


#### --- SHINY UI -------------------------------------------------------------- ####
ui <- dashboardPage(
  dashboardHeader(title = "ODD Zurich App"),
### ---dashboardSidebar--- ##########################################################
  dashboardSidebar(
#      width=200,
    sidebarMenu(
      menuItem("Daten Wahl", tabName = 'dataselection', icon = icon("database")), 

      menuItem("Deskriptive Statistik",
                          tabName = 'deskriptive Statistik',
              menuSubItem("1D Visualization",
                          tabName = '1d', icon = icon("bar-chart"))),
      menuItem("Impressum", tabName = 'about')
    )
  ),
### ---dashboardBody--- #############################################################
  dashboardBody(
   #   includeCSS("www/shiny-gymi.css"),
    tabItems(

# --- dataselection --------------------------------------------------------------- #
      tabItem(tabName = 'dataselection', fluidPage(# theme = "shiny-gymi.css",
        tags$head(
          tags$style(HTML(".shiny-output-error-validation {color: green;}"))
        ),
        sidebarPanel(
          selectInput('input_type', "Datenquelle auswählen",
                      c("R Datensatz"), 
                      selected = "R Datensatz"),
          uiOutput('ui.dataselection')),
        
        mainPanel(
          h2("Datensatz"),
          tags$br(),
          uiOutput('dataset'))
      )),

# --- 1D Visualization ------------------------------------------------------------ #
      tabItem(tabName = '1d',
              sidebarPanel(
                uiOutput('visual')
              ),

              mainPanel(h3("Barplot of Average Delay Times"),
                        plotOutput('lines')
                        )
      ),

# --- About ----------------------------------------------------------------------- #
      tabItem(tabName = 'about', fluidPage(
        h3("Impressum")
      ))
    )
  ))
