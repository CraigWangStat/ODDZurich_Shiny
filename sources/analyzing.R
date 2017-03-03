tabItem(tabName = 'analyzingdata',
        sidebarPanel(h2("Method")
        ),
        
        mainPanel(h3("Analyzing the selected Variable"),
                  plotOutput("mapPlot"))
)