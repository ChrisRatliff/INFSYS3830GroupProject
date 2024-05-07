library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("C:/Users/lilsl/OneDrive/Documents/School/INFSYS3830/titanic/train_edited.csv")  

ui <- fluidPage(
  titlePanel("Passengers by Class"),
  sidebarLayout(
    sidebarPanel(
      selectInput("embarked", "Sort by Embarked:",
                  choices = c("All", unique(data$Embarked)))
    ),
    mainPanel(
      plotOutput("pie_chart")
    )
  )
)

server <- function(input, output) {
  output$pie_chart <- renderPlot({
    if (input$embarked == "All") {
      filtered_data <- data
    } else {
      filtered_data <- data %>% filter(Embarked == input$embarked)
    }
    
    ggplot(filtered_data, aes(x = "", fill = factor(Pclass))) +
      geom_bar(width = 1) +
      coord_polar(theta = "y") +
      labs(title = "Passengers by Class", fill = "Class")
  })
}

shinyApp(ui = ui, server = server)

