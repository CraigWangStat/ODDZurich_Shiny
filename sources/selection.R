tabItem(tabName = 'dataselection', fluidPage(# theme = "shiny-gymi.css",
  tags$head(
    tags$style(HTML(".shiny-output-error-validation {color: green;}"))
  ),
  sidebarPanel(
    selectInput('inputdata', "Data Selection",
                c("Example 1", "Example 2"), 
                selected = "Example 1")),
  
  mainPanel(h3("example"),
            tableOutput('dataset'))
))
