library(tidyverse)
library(dplyr)
library(lubridate)
library(htmltools)
library(viridis)
library(shiny)
library(plotly)
library(shinydashboard)
library(leaflet)
library(ggmap)
library(leaflet.extras)


df_summary = read_csv("https://www.dropbox.com/scl/fi/hd8ugc0cq1k243ehvq2cu/df_summary.csv?rlkey=miirkjpx50l75xoc6iyom4ms3&dl=1")
df_crime_patterns = read_csv("https://www.dropbox.com/scl/fi/9ecsdf8ps1gpx4hn3ox5o/df_crime_patterns_sample.csv?rlkey=ln5qd4mrxo690vd0dn6o0izjn&dl=1")
crime_counts = read_csv("https://www.dropbox.com/scl/fi/uc7loy417kmshq5gulxme/crime_counts.csv?rlkey=okb1xv5qgt0lgxzioq5ha6kfz&dl=1")

# Function to create linegraph
create_plot <- function(ofnsDesc) {
  # Generate the plot title
  plot_title <- paste("Number of", ofnsDesc, "in Each Year")
  
  # Create the plot
  crime_counts |>
    filter(ofns_desc == ofnsDesc) |>
    plot_ly(x = ~year, y = ~count, type = 'scatter', mode = 'markers+lines', 
            marker = list(color = viridis(6))) |>
    layout(
      title = plot_title,
      xaxis = list(title = "Year"),
      yaxis = list(title = "Number of Cases"),
      showlegend = FALSE
    )
}

crime_heatmap <- function(ofnsDesc, Year) {
  # Filter the data based on the given ky_cd and year
  filtered_data <- df_crime_patterns |> 
    filter(ofns_desc == ofnsDesc & year == Year)
  
  # Create the leaflet map
  leaflet_map <- leaflet(filtered_data) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addCircleMarkers(~longitude,
                     ~latitude,
                     stroke = FALSE, fillOpacity = 0.8,
                     clusterOptions = markerClusterOptions(), # adds summary circles
                     popup = ~as.character(ofns_desc)
    ) %>% 
    addHeatmap(lng=~longitude,
               lat=~latitude,
               radius = 8)
  
  return(leaflet_map)
}

ui <- fluidPage(
  titlePanel("Crime Data Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("yr", "Year", 
                  min = min(df_crime_patterns$year), 
                  max = max(df_crime_patterns$year), 
                  value = min(df_crime_patterns$year),
                  step = 1),
      selectInput("ofnsDesc", "Crime Type",
                  choices = unique(df_summary$ofns_desc))
    ),
    mainPanel(
      leafletOutput("crimeMap"),
      plotlyOutput("plotlyPlot")
    )
  )
)

server <- function(input, output) {
  output$crimeMap <- renderLeaflet(
    crime_heatmap(input$ofnsDesc, input$yr)
  )
  output$plotlyPlot = renderPlotly({
    create_plot(
      input$ofnsDesc)
  })
}

shinyApp(ui, server)
