library(shiny)
library(dplyr)
library(ggplot2)
library(viridis)
library(forcats)
library(readr)
library(plotly)

crime_counts <- read_csv('data/crime_counts.csv')

ui <- fluidPage(
  titlePanel(" "),  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year", choices = c("Overall", "2017", "2018", "2019", "2020", "2021", "2022")),
      br(),
      selectInput("boro", "Select Borough", choices = unique(crime_counts$boro_nm)),
      br(),
      p("Select a year and a borough to view the top 10 crime types.")
    ),
    mainPanel(
      plotlyOutput('plot')
    )
  )
)

server <- function(input, output) {
  # Load data
  crime_counts <- read_csv('data/crime_counts.csv')
  
  selected_data <- reactive({
    data_filtered <- switch(input$year,
                            "Overall" = crime_counts %>% filter(year == 0000),
                            "2017" = crime_counts %>% filter(year == 2017),
                            "2018" = crime_counts %>% filter(year == 2018),
                            "2019" = crime_counts %>% filter(year == 2019),
                            "2020" = crime_counts %>% filter(year == 2020),
                            "2021" = crime_counts %>% filter(year == 2021),
                            "2022" = crime_counts %>% filter(year == 2022))
    
    data_filtered <- data_filtered |>
      filter(boro_nm == input$boro)
    
    data_filtered
  })
  
  output$plot <- renderPlotly({ 
    crime_counts <- selected_data()
    
    plot_ly(
      data = crime_counts,
      x = ~forcats::fct_reorder(ofns_desc, Incident_Count),
      y = ~Incident_Count,
      type = "bar",
      marker = list(color = ~viridis::viridis(10)),
      showlegend = FALSE
    ) |>
      layout(
        title = paste("Top 10 Crime Types: Identification and Count -", input$year),
        xaxis = list(title = "Crime Type", tickangle = 45, tickmode = "array"),
        yaxis = list(title = "Incident Count"),
        legend = list(orientation = "h")
      )
  })
}

shinyApp(ui, server)
