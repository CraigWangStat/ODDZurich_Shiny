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
      menuItem("Data Selection", tabName = 'dataselection', icon = icon("database")), 

      menuItem("Visualization",
                          tabName = 'deskriptive Statistik',
              menuSubItem("1D Visualization",
                          tabName = '1d', icon = icon("bar-chart")),
              menuSubItem("Spatial Visualization",tabName = '2d', icon = icon("map"))),
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
                uiOutput('visual.1d')
              ),

              mainPanel(h3("Barplot of Average Delay Times"),
                        plotOutput('line.plot')
                        )
      ),
# --- Map Visualization ------------------------------------------------------------ #
tabItem(tabName = '2d',
        sidebarPanel(
          uiOutput('visual.2d')
        ),
        
        mainPanel(h3("Spatial Display"),
                  plotOutput('maps')
        )
),
# --- About ----------------------------------------------------------------------- #
      tabItem(tabName = 'about', fluidPage(
        h3("Impressum"),
        h4("Build by: Carlos, Craig, David")
      ))
    )
  ))
