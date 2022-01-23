box::use(
  shiny[...],
  DT[DTOutput, renderDT],
  data.table[data.table],
  httr[GET, content],
  magrittr[`%>%`],
  R / firebase,
  gargoyle[init, watch, trigger]
)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  titlePanel("My progress learning polish"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "topic",
        label = "select topic",
        choices = "transport"
      ),
      textInput(
        inputId = "new_word",
        label = "Add new word"
      ),
      actionButton(
        inputId = "add_word",
        label = "add"
      )
    ),
    mainPanel(
      DTOutput(outputId = "words"),
      tags$br()
    )
  )
)

server <- function(input, output, session) {
  updateSelectInput(
    inputId = "topic",
    choices = names(firebase$select_categories())
  )

  output$words <- renderDT({
    data.frame(words = firebase$select_words(input$topic))
  })


  observe({
    firebase$add_words(input$topic, input$new_word)
  }) %>%
    bindEvent(input$add_word)
}

shiny::shinyApp(ui, server)
