# This Shiny source Provides the ui Output of the Dataselection menuItem and moreover
# the Data_Handler with to the switch corresponding 'dataset transporters'

# = Main Panel ==================================================================== #
  output$dataset <- renderUI({
    if(is.null(input$input_type)){return(NULL)}
      DT::dataTableOutput('dataset_dataTable')
  })
# = Sidebar Panel ================================================================= #
  output$ui.dataselection <- renderUI({
    if(is.null(input$input_type)){return(NULL)}
list(
          selectInput('dataset', "Datensatz auswählen",
            choices = c("Example 1","Example 2"),
              selected = "Example 1", multiple = TRUE,
              selectize = FALSE, size = 8)
          )
    
  })
# ================================================================================= #

# DATA HANDLER #################################################################### #
  data_Handler <- reactive({
      tmp <- datasetInput()
      if(is.null(tmp)){return(NULL)}
      data.object <- as.data.frame(tmp)
     })
# ################################################################################# #

# = Provided Datasets ============================================================= #
  # switch of provided datasets
  datasetInput <- reactive({
    if(is.null(input$dataset)){return(NULL)}
    
    switch(input$dataset,
          "Example 1" = read.csv("sources/data/example_data.csv"),
          "Example 2" = read.csv("sources/data/example2_data.csv")
)
  })

  # display of a provided dataset
  output$dataset_dataTable <- DT::renderDataTable({
    datasetInput()
  }, options = list(language = list(url = '//cdn.datatables.net/plug-ins/1.10.7/i18n/German.json'),
                    searching = FALSE,
                    ordering = FALSE,
                    lengthMenu = list(c(10, -1), c('10', 'All')),
                    pageLength = 10)
  )

# ================================================================================= #
