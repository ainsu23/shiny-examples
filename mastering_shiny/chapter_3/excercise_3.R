library(shiny)

# Original
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))

# Correction


chapter_3_excercise_3_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Can I name a reactiveValue var and range ?"),
    textOutput(ns("answer"))
  )
}

chapter_3_excercise_3_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$answer <- renderText(
        paste("The previous names are used to calculate
          variance and range, so they are reserved names.")
      )
    }
  )
}

# ui <- fluidPage(
#   h2("Can I name a reactiveValue var and range ?"),
#   textOutput("answer")
# )

# server <- function(input, output, session) {
#   output$answer <- renderText(
#     paste("The previous names are used to calculate
#     variance and range, so they are reserved names.")
#   )
# }
# 
# shiny::shinyApp(ui, server)
