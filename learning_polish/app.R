source("R/firebase.R")
source("R/join_words.R")
source("dependencies.R")
source("modules/modal_captcha.R")
source("modules/delete_words.R")
source("modules/games.R")

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  titlePanel("My progress learning polish"),
  tags$br(),
  bslib::navs_tab(
    nav(
      title = "vocabulary",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "topic",
            label = "select topic",
            choices = "animals"
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
          ),
          actionButton(
            inputId = "delete_word",
            label = "delete"
          )
        ),
        mainPanel(
          DTOutput(outputId = "table_words"),
          tags$br()
        )
      )
    ),
    nav(
      title = "games",
      games_ui("games")
    )
  )
)

server <- function(input, output, session) {
  init("actualizar_dt")
  init("validated_word", "password_confirmed")

  words_table_category <- reactive(
    words_table(input$topic)
  ) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  updateSelectInput(
    inputId = "topic",
    choices = names(select_categories())
  )

  output$table_words <- renderDT({
    words_table_category()
  }) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  observe({
    words_delete <- words_table_category()[
      input$table_words_rows_selected, "words"
    ]

    delete_words(input$topic, words_delete)
    trigger("actualizar_dt")
  }) %>%
    bindEvent(watch("password_confirmed"))


  observe({
    if (nchar(input$new_word) != 0 & nchar(input$translation) != 0) {
      add_words(
        categories = input$topic,
        word = join_words(input$new_word, input$translation)
      )
      trigger("actualizar_dt")
    }
  }) %>%
    bindEvent(watch("validated_word"))


  captcha_server(input, output)
  delete_server(input, output)
  games_server("games")
}

shiny::shinyApp(ui, server)
