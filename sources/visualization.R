tabItem(tabName = 'map',
        sidebarPanel(h2("Visual")
        ),
        
        mainPanel(h3("Visualising the selected Variable"),
                  plotOutput("mapPlot"))
)