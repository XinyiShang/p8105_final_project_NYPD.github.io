library(shiny)
library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(knitr)
library(plotly)
library(kableExtra)


# Read the data
crime_counts <- read_csv('data/nypd_ses_df.csv')

# Define the UI
ui <- fluidPage(
  titlePanel(" "),
  
  # Global select input
  selectInput("neighborhoodTables", "Select Neighborhood", 
              choices = list(
                "Chelsea/Clinton/Midtown",
                "University Heights/Fordham",
                "Mott Haven/Hunts Point",
                "East Harlem",
                "Lower East Side/Chinatown"
              )),
  
  tabsetPanel(
    tabPanel("Tables", 
             tableOutput("barTable")),
    tabPanel("Bar Chart", 
             plotlyOutput("barPlot")),
  )
)

# Define the server
server <- function(input, output, session) {
  
  # Function to generate table
  generateTable <- function(neighborhood_name) {
    result <- crime_counts %>%
      filter(neighborhood == neighborhood_name) %>%
      arrange(desc(count)) %>%
      head(5) %>%
      mutate(percentage = scales::percent(count / sum(count), scale = 100)) %>%
      select(ofns_desc, percentage) %>%
      rename(crime_type = ofns_desc) %>%
    
    return(result)
  }
  
  
  # Function to generate bar plot
  generateBarPlot <- function(neighborhood_name) {
    result = 
    crime_counts %>%
      filter(neighborhood == neighborhood_name) %>%
      arrange(desc(count)) %>%
      head(5) %>%
      mutate(percentage = count / sum(count) * 100)|>
      ggplot(aes(x = ofns_desc, y = percentage, fill = ofns_desc)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      scale_fill_viridis_d()+
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
            legend.position = "none") +
      labs(title = paste("Top 5 Crime Types in", neighborhood_name),
           x = "Crime Types",
           y = "Percentage of all crimes",
           caption = "Data Source: NYC Crime Explorer")
    result = ggplotly(result)
    return (result)
  }
  
  
  # Bar table output
  output$barTable <- renderTable({
    generateTable(input$neighborhoodTables)
  })
  
  # Bar chart output
  output$barPlot <- renderPlotly({
    generateBarPlot(input$neighborhoodTables)
  })
}

# Run the Shiny app
shinyApp(ui, server)

