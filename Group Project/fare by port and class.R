library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("C:/Users/lilsl/OneDrive/Documents/School/INFSYS3830/titanic/train_edited.csv")  

ui <- fluidPage(
  titlePanel("Fare Paid by Class and Port Embarked"),
  sidebarLayout(
    sidebarPanel(
      selectInput("pclass", "Select Passenger Class:",
                  choices = c("All", unique(data$Pclass))),
      selectInput("embarked", "Select Port Embarked:",
                  choices = c("All", unique(data$Embarked)))
    ),
    mainPanel(
      plotOutput("fare_chart")
    )
  )
)

server <- function(input, output) {
  output$fare_chart <- renderPlot({
    if (input$pclass == "All" & input$embarked == "All") {
      filtered_data <- data
    } else if (input$pclass == "All") {
      filtered_data <- data %>% filter(Embarked == input$embarked)
    } else if (input$embarked == "All") {
      filtered_data <- data %>% filter(Pclass == input$pclass)
    } else {
      filtered_data <- data %>% filter(Pclass == input$pclass, Embarked == input$embarked)
    }
    
    ggplot(filtered_data, aes(x = factor(Pclass), y = Fare, fill = factor(Pclass))) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Fare Paid by Class and Port Embarked",
           x = "Passenger Class", y = "Fare",
           fill = "Passenger Class") +
      scale_fill_discrete(name = "Passenger Class") +
      facet_wrap(~Embarked)
  })
}

shinyApp(ui = ui, server = server)
