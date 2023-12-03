library(shiny)

df_nypd_test = read_csv('../data/NYPD_Complaint_Data_Historic.csv') |>
  janitor::clean_names() |>
  mutate(cmplnt_fr_dt = mdy(cmplnt_fr_dt))
data_2017 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2017)
data_2018 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2018)
data_2019 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2019)
data_2020 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2020)
data_2021 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2021)
data_2022 = df_nypd_test |>
  filter(year(cmplnt_fr_dt) == 2022)

ui <- fluidPage(
  titlePanel("Top 10 Crime Types"),
  sidebarLayout(
    sidebarPanel(
      # Dropdown menu for selecting the year
      selectInput("year", "Select Year", choices = c("Overall", "2017", "2018", "2019", "2020", "2021", "2022")),
    ),
    mainPanel(
      plotOutput("crimePlot")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    switch(input$year,
           "Overall" = df_nypd_test,
           "2017" = data_2017,
           "2018" = data_2018,
           "2019" = data_2019,
           "2020" = data_2020,
           "2021" = data_2021,
           "2022" = data_2022)
  })
  
  output$crimePlot <- renderPlot({
    crime_counts <- selected_data() %>%
      group_by(ofns_desc) %>%
      summarise(Incident_Count = n()) %>%
      arrange(desc(Incident_Count)) %>%
      slice_head(n = 10)
    
    ggplot(crime_counts, aes(x = forcats::fct_reorder(ofns_desc, Incident_Count), y = Incident_Count, fill = ofns_desc)) +
      geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
            legend.position = "none") +
      labs(title = paste("Top 10 Crime Types: Identification and Count -", input$year),
           x = "Crime Type",
           y = "Incident Count")
  })
}

shinyApp(ui, server)
