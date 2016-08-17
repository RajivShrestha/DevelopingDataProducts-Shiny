library(shiny)

# Fix tag("div", list(...)) : could not find function "showOut… 
library(rCharts)

shinyUI(
    navbarPage("Storm Database Explorer",
        tabPanel("Plot",
                sidebarPanel(
                    sliderInput("range", 
                        "Range:", 
                        min = 1950, 
                        max = 2011, 
                        value = c(1993, 2011),
                        format="####"),
                    uiOutput("evtypeControls"),
                    actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                    actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
                ),
  
                mainPanel(
					tabsetPanel(
                        
                        # Time series data
                        tabPanel(p(icon("line-chart"), "By year"),
                                 
                                  h4('Population impact by year', align = "center"),
                                  showOutput("populationImpact", "nvd3")
                        )                     
                                                
                    )
                )
            
        ),
        
        tabPanel("About",
            mainPanel(
                includeMarkdown("include.md")
            )
        )
    )
)