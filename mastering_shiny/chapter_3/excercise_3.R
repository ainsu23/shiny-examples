library(shiny)

# Original
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))

# Correction


ui <- fluidPage(
  h2("Can I name a reactiveValue var and range ?"),
  textOutput("answer")
)

server <- function(input, output, session) {
  output$answer <- renderText(
    paste("The previous names are used to calculate
    variance and range, so they are reserved names.")
  )
}

shiny::shinyApp(ui, server)
