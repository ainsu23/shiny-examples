source("R/firebase.R")
source("R/join_words.R")
source("dependencies.R")
source("modules/modal_captcha.R")

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
  init("validated_word")

  updateSelectInput(
    inputId = "topic",
    choices = names(select_categories())
  )

  output$words <- renderDT({
    data.frame(words = select_words(input$topic)) %>%
      separate(words, c("words", "translation", "date_added"), ":")
  }) %>%
    bindEvent(watch("actualizar_dt"), input$topic)


  observe({
    add_words(
      categories = input$topic,
      word = join_words(input$new_word, input$translation)
    )
    trigger("actualizar_dt")
  }) %>%
    bindEvent(watch("validated_word"))


  captcha_server(input, output)
}

shiny::shinyApp(ui, server)
