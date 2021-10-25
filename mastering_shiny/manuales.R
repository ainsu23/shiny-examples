
source("../global.R")

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  h4(content(temperatura)),
  titlePanel("What have I learned from Mastering Shiny?"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "chapter",
        label = "select chapter",
        choices = "chapter_1"
      )
    ),
    mainPanel(
      uiOutput("manuales")
    )
  )
)

server <- function(input, output, server) {
  updateSelectInput(
    inputId = "chapter",
    choices = dir(pattern = "chapter")
  )

  output$manuales <- renderUI({
    includeMarkdown(paste0("man/", input$chapter, ".md"))
  })
}
shiny::shinyApp(ui, server)
