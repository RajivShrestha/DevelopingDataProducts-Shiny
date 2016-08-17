#' Aggregate dataset by year
#' 
#' @param dt data.table
#' @param year_min integer
#' @param year_max integer
#' @param evtypes character vector
#' @return data.table
#'
aggregate_by_year <- function(dt, year_min, year_max, evtypes) {
    round_2 <- function(x) round(x, 2)
    
    # Filter
    dt %>% filter(YEAR >= year_min, YEAR <= year_max, EVTYPE %in% evtypes) %>%
    # Group and aggregate
    group_by(YEAR) %>% summarise_each(funs(sum), COUNT:CROPDMG) %>%
    # Round
    mutate_each(funs(round_2), PROPDMG, CROPDMG) %>%
    rename(
        Year = YEAR, Count = COUNT,
        Fatalities = FATALITIES, Injuries = INJURIES,
        Property = PROPDMG, Crops = CROPDMG
    )
}

#' Add Affected column based on category
#'
#' @param dt data.table
#' @param category character
#' @return data.table
#'
compute_affected <- function(dt, category) {
    dt %>% mutate(Affected = {
        if(category == 'both') {
            INJURIES + FATALITIES
        } else if(category == 'fatalities') {
            FATALITIES
        } else {
            INJURIES
        }
    })
}

#' Prepare plots of impact by year
#'
#' @param dt data.table
#' @param dom
#' @param yAxisLabel
#' @param desc
#' @return plot
#' 
plot_impact_by_year <- function(dt, dom, yAxisLabel, desc = FALSE) {
    impactPlot <- nPlot(
        value ~ Year, group = "variable",
        data = melt(dt, id="Year") %>% arrange(Year, if (desc) { desc(variable) } else { variable }),
        type = "stackedAreaChart", dom = dom, width = 650
    )
    impactPlot$chart(margin = list(left = 100))
    impactPlot$yAxis(axisLabel = yAxisLabel, width = 80)
    impactPlot$xAxis(axisLabel = "Year", width = 70)
    
    impactPlot
}
