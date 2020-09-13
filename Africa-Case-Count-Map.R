#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
install.packages("sf")
install.packages("shiny")
library(sf)
library(shiny)
library(leaflet)
library(spData)
library(dplyr)
install.packages("readxl")
library("readxl")

#downloading rgdal to read Africa shapefile
install.packages("rgdal")
library(rgdal)

Africa_Case_Count_Data <- read_excel("Modified Africa Case Count Data.xlsx")
# Define UI for application that filters map points based on year and minimum population
ui <- fluidPage(
  
  # Application title
  titlePanel("June COVID Case Counts in Africa"),
  
  # Sidebar with a slider input for year, numeric input for population 
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("day",
                  "Day",
                  min = 2,
                  max = 30,
                  step = 2,
                  sep = "",
                  value = 2),
      
      numericInput("case_count",
                   "Minimum Case Count",
                   min = 0,
                   max = 1600,
                   value = 0)
    ),
    
    # Show the map and table
    mainPanel(
      # plotOutput("distPlot"),
      leafletOutput("map"),
      dataTableOutput("table")
      )
    )
  )

# Define server logic required to draw a map and table
server <- function(input, output) {
  
  
  output$map <- renderLeaflet({
    
      casecount_by_day <- filter(Africa_Case_Count_Data, 
                          Day == input$day,
                          Case_Count > input$case_count)
    
    leaflet(data = casecount_by_day) %>% 
      addTiles() %>%
      addMarkers()
  })
  
  output$table <- renderDataTable({
    
    casecount_by_day <- filter(Africa_Case_Count_Data, 
                          Day == input$day,
                          Case_Count > input$case_count)
    
    casecount_by_day
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
