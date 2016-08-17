library(shiny)

# Plotting 
library(ggplot2)
library(rCharts)
library(ggvis)

# Data processing libraries
library(data.table)
library(reshape2)
library(dplyr)

# Required by includeMarkdown
library(markdown)

# Load helper functions
source("helpers.R", local = TRUE)


# Load data
dt <- fread('data/events.agg.csv') %>% mutate(EVTYPE = tolower(EVTYPE))
evtypes <- sort(unique(dt$EVTYPE))


# Shiny server 
shinyServer(function(input, output, session) {
    
    # Define and initialize reactive values
    values <- reactiveValues()
    values$evtypes <- evtypes
    
    # Create event type checkbox
    output$evtypeControls <- renderUI({
        checkboxGroupInput('evtypes', 'Event types', evtypes, selected=values$evtypes)
    })
    
    # Add observers on clear and select all buttons
    observe({
        if(input$clear_all == 0) return()
        values$evtypes <- c()
    })
    
    observe({
        if(input$select_all == 0) return()
        values$evtypes <- evtypes
    })

    # Preapre datasets
    
   
    # Prepare dataset for time series
    dt.agg.year <- reactive({
        aggregate_by_year(dt, input$range[1], input$range[2], input$evtypes)
    })
    
    
    # Population impact by year
    output$populationImpact <- renderChart({
        plot_impact_by_year(
            dt = dt.agg.year() %>% select(Year, Injuries, Fatalities),
            dom = "populationImpact",
            yAxisLabel = "Affected"
        )
    })
    
})

