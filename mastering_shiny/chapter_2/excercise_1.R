
chapter_2_excercise_1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput("name", "", placeholder = "Your name"),
    sliderInput("delivery", "When should we deliver?",
      min = as.Date("2020-09-16", "%Y-%m-%d"),
      max = as.Date("2020-09-23", "%Y-%m-%d"),
      value = as.Date("2020-09-17"),
      timeFormat = "%Y-%m-%d"
      ),
    sliderInput("interval", "select interval",
      min = 0, max = 100, step = 5,
      value = 5, animate = TRUE
      ),
    selectizeInput("long_list", "select month",
      choices = list(
        "meses completos" = month.name,
        "meses abreviados" = month.abb
      )
    )
  )
}

chapter_2_excercise_1_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$name <- renderText({
        input$name
      })
    }
  )
}

# ui <- fluidPage(
#   textInput("name", "", placeholder = "Your name"),
#   sliderInput("delivery", "When should we deliver?",
#     min = as.Date("2020-09-16", "%Y-%m-%d"),
#     max = as.Date("2020-09-23", "%Y-%m-%d"),
#     value = as.Date("2020-09-17"),
#     timeFormat = "%Y-%m-%d"
#   ),
#   sliderInput("interval", "select interval",
#     min = 0, max = 100, step = 5,
#     value = 5, animate = TRUE
#   ),
#   selectizeInput("long_list", "select month",
#     choices = list(
#       "meses completos" = month.name,
#       "meses abreviados" = month.abb
#     )
#   )
# )


# server <- function(input, output, session) {
#   output$name <- renderText({
#     input$name
#   })
# }
# 
# shiny::shinyApp(ui, server)
