library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(viridis)

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
      wellPanel(
        plotOutput("crimePlot", height = "400px")
      ),
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
    

    data_filtered <- data_filtered %>%
        filter(boro_nm == input$boro)
    
    data_filtered
  })
  
  output$crimePlot <- renderPlot({
    crime_counts <- selected_data()
    
    
    ggplot(crime_counts, aes(x = forcats::fct_reorder(ofns_desc, Incident_Count), y = Incident_Count, fill = ofns_desc)) +
      geom_bar(stat = "identity") +
      scale_fill_viridis(discrete = TRUE, option = "magma")+
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
            legend.position = "none") +
      labs(title = paste("Top 10 Crime Types: Identification and Count -", input$year),
           x = "Crime Type",
           y = "Incident Count")
  })
}

shinyApp(ui, server)
