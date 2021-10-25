
source("global.R")


ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  titlePanel("Mastering Shiny excercises solutions"),
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
    choices = dir("mastering_shiny", pattern = "chapter")
  )

  output$manuales <- renderUI({
    includeMarkdown(paste0("mastering_shiny/man/", input$chapter, ".md"))
  })
}
shiny::shinyApp(ui, server)
