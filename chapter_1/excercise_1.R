
ui <- fluidPage(
  tags()$h1("ainsu23")

  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

shiny::shinyApp(ui, server)
