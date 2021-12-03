
chapter_2_excercise_2_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(
      outputId = ns("plot"),
      width = "700px",
      height = "300px"
    ),
    verbatimTextOutput(ns("tabla")),
    textOutput(ns("texto")),
    tags$br(),
    verbatimTextOutput(ns("ttest")),
    verbatimTextOutput(ns("lm")),
    DT::dataTableOutput(ns("table"))
  )
}

chapter_2_excercise_2_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$plot <- renderPlot(plot(1:5), res = 96)
      output$tabla <- renderPrint(summary(mtcars))
      output$texto <- renderText("good morning")
      output$ttest <- renderPrint(t.test(1:5, 2:6))
      output$lm <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
      output$table <- DT::renderDataTable(mtcars,
        options = list(dom = "t")
      )
    }
  )
}

# ui <- fluidPage(
#   plotOutput("plot", width = "700px", height = "300px"),
#   verbatimTextOutput("tabla"),
#   textOutput("texto"),
#   tags$br(),
#   verbatimTextOutput("ttest"),
#   verbatimTextOutput("lm"),
#   DT::dataTableOutput("table")
# )

# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
#   output$tabla <- renderPrint(summary(mtcars))
#   output$texto <- renderText("good morning")
#   output$ttest <- renderPrint(t.test(1:5, 2:6))
#   output$lm <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
#   output$table <- DT::renderDataTable(mtcars,
#     options = list(dom = "t")
#   )
# }
#
# shiny::shinyApp(ui, server)
