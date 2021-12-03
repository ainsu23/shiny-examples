# library(shiny)
# Resolver excercises in chapter 3 of shiny mastering

chapter_3_excercise_1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "What's your name?"),
    textOutput(ns("greeting"))
  )
}
# ui <- fluidPage(
#   textInput("name", "What's your name?"),
#   textOutput("greeting")
# )

chapter_3_excercise_1_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, server) {
      output$greeting <- renderText(paste0("Hello ", input$name))
    }
  )
}

# server1 <- function(input, output, server) {
#   output$greeting <- renderText(paste0("Hello ", input$name))
# }
#
# server2 <- function(input, output, server) {
#   greeting <- reactive(paste0("Hello ", input$name))
#   output$greeting <- renderText(greeting())
# }
#
# server3 <- function(input, output, server) {
#   output$greeting <- renderText(paste0("Hello ", input$name))
# }
#
# shiny::shinyApp(ui, server1)
# shiny::shinyApp(ui, server2)
# shiny::shinyApp(ui, server3)
