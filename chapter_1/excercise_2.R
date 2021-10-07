library(shiny)

ui <- fluidPage(
  sliderInput("x", 
	label = "If x is", 
	min = 1, 
	max = 50, 
	value = 30
	),
  "then x times 5 is",
  sliderInput("y",
	label = "and y is",
	min = 1,
	max = 50,
	value = 30),
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    input$x * input$y
  })
}

shinyApp(ui, server)
