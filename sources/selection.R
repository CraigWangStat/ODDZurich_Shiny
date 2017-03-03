tabItem(tabName = 'dataselection', fluidPage(# theme = "shiny-gymi.css",
  tags$head(
    tags$style(HTML(".shiny-output-error-validation {color: green;}"))
  ),
  sidebarPanel(
    selectInput('input_type', "Data Selection",
                c("Choice 1", "Choice 2", "Choice 3"), 
                selected = "Choice 1")),
  
  mainPanel()
))