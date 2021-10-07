
ui <- fluidPage(
  verbatimTextOutput("tabla"),
  textOutput("texto"),
  tags$br(),
  verbatimTextOutput("ttest"),
  verbatimTextOutput("lm")
)

server <- function(input, output, session) {
  output$tabla <- renderPrint(summary(mtcars))
  output$texto <- renderText("good morning")
  output$ttest <- renderPrint(t.test(1:5,2:6))
  output$lm <- renderPrint(str(lm(mpg ~ wt, data = mtcars))) 
}

shiny::shinyApp(ui, server)
