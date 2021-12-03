chapter_1_excercise_1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "What's your name?"),
    textOutput(ns("greeting"))
  )
}

chapter_1_excercise_1_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$greeting <- renderText({
        paste0("Hello ", input$name)
      })
    }
  )
}

# ui <- fluidPage(
#   textInput("name", "What's your name?"),
#   textOutput("greeting")
# )

# server <- function(input, output, session) {
#   output$greeting <- renderText({
#     paste0("Hello ", input$name)
#   })
# }

# shiny::shinyApp(ui, server)
