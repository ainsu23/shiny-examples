
chapter_1_excercise_2_ui <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(
      inputId = ns("x"),
      label = "If x is",
      min = 1,
      max = 50,
      value = 30
    ),
  "then x times 5 is",
  textOutput(ns("cincox")),
  sliderInput(
    inputId = ns("y"),
    label = "and y is",
    min = 1,
    max = 50,
    value = 30),
  textOutput(ns("product"))
  )
}

chapter_1_excercise_2_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$product <- renderText({ 
        input$x * input$y
      })
      output$cincox <- renderText({ 
        input$x * 5
      })
    }
  )
}

# ui <- fluidPage(
#   sliderInput("x", 
#     label = "If x is", 
#     min = 1, 
#     max = 50, 
#     value = 30
#     ),
#   "then x times 5 is",
#   sliderInput("y",
#     label = "and y is",
#     min = 1,
#     max = 50,
#     value = 30),
#   textOutput("product")
# )


# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     input$x * input$y
#   })
# }
# 
# shinyApp(ui, server)
