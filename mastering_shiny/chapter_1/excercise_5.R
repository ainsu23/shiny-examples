attachNamespace("ggplot2")
datasets <- c("economics", "faithfuld", "seals")

chapter_1_excercise_5_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("dataset"), "Dataset", choices = datasets),
    verbatimTextOutput(ns("summary")),
    plotOutput(ns("plot"))
  )
}

chapter_1_excercise_5_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      dataset <- reactive({
        get(input$dataset, "package:ggplot2")
      })

      output$summary <- renderPrint({
        summary(dataset())
      })

      output$plot <- renderPlot(
        {
          plot(dataset())
        },
        res = 96
      )
    }
  )
}

# ui <- fluidPage(
#   selectInput("dataset", "Dataset", choices = datasets),
#   verbatimTextOutput("summary"),
#   plotOutput("plot")
# )
#
# server <- function(input, output, session) {
#   dataset <- reactive({
#     get(input$dataset, "package:ggplot2")
#   })
#   output$summary <- renderPrint({
#     summary(dataset())
#   })
#   output$plot <- renderPlot(
#     {
#       plot(dataset())
#     },
#     res = 96
#   )
# }
#
# shinyApp(ui, server)
# 1. plotOutput
# 2. output$Summary
# 3. plot(dataset())
