box::use(
  shiny[...],
  DT[DTOutput, renderDT],
  data.table[data.table],
  httr[GET, content],
  magrittr[`%>%`],
  tidyr[separate],
  R / firebase,
  R / join_words,
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
      textInput(
        inputId = "translation",
        label = "translation"
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
  init("actualizar_dt")

  updateSelectInput(
    inputId = "topic",
    choices = names(firebase$select_categories())
  )

  output$words <- renderDT({
    data.frame(words = firebase$select_words(input$topic)) %>%
      separate(words, c("words", "translation"), ":")
  }) %>%
    bindEvent(watch("actualizar_dt"), input$topic)


  observe({
    firebase$add_words(
      categories = input$topic,
      word = join_words$join_words(input$new_word, input$translation)
    )
    trigger("actualizar_dt")
  }) %>%
    bindEvent(input$add_word)
}

shiny::shinyApp(ui, server)
