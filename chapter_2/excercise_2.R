
# The following code contains all excersices proposed in chapter 2 in one app

library(shiny)
ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px"),
  verbatimTextOutput("tabla"),
  textOutput("texto"),
  tags$br(),
  verbatimTextOutput("ttest"),
  verbatimTextOutput("lm"),
  DT::dataTableOutput("table")
)

server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96)
  output$tabla <- renderPrint(summary(mtcars))
  output$texto <- renderText("good morning")
  output$ttest <- renderPrint(t.test(1:5, 2:6))
  output$lm <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
  # dom = 't' display just the table
  output$table <- DT::renderDataTable(mtcars,
    options = list(dom = "t")
  )
}

shiny::shinyApp(ui, server)
