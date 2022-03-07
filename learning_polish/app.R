# Libraries necesaries to run the app
source("R/firebase.R")
source("R/join_words.R")
source("dependencies.R")
source("modules/modal_captcha.R")
source("modules/delete_words.R")
source("modules/games.R")

# ui
ui <- fluidPage(
  # use of bslib to give a theme flatly to all app
  theme = bslib::bs_theme(bootswatch = "flatly"),
  fluidRow(
    column(
      width = 6,
      titlePanel("My progress learning polish"),
    ),
    column(
      width = 3,
    ),
    column(
      width = 3,
      textOutput(
        outputId = "estadistica"
      )
    )
  ),
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
  init("actualizar_dt", "permission_given")
  init("validated_word", "password_confirmed")
  polish <- manager$new()

  words_table_category <- reactive(
    polish$wybrana_kategoria(input$topic)
  ) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  updateSelectInput(
    inputId = "topic",
    choices = polish$kategorie %>%
      tibble::deframe()
  )

  output$table_words <- renderDT({
    polish$wybrana_słowa(words_table_category())
  }) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  observe({
    words_delete <- polish$wybrana_słowa(words_table_category())[
      input$table_words_rows_selected, "words"
    ]

    delete_words(input$topic, words_delete)
    trigger("actualizar_dt")
  }) %>%
    bindEvent(watch("password_confirmed"))
  #
  #
  #   observe({
  #     print(watch("permission_given"))
  #     if (watch("permission_given") == 1) {
  #       if (nchar(input$new_word) != 0 & nchar(input$translation) != 0) {
  #         add_words(
  #           categories = input$topic,
  #           word = join_words(input$new_word, input$translation)
  #         )
  #         trigger("actualizar_dt")
  #       }
  #     }
  #   }) %>%
  #     bindEvent(input$add_word, watch("permission_given"), ignoreInit = TRUE)
  #
  #   observe({
  #     trigger("permission_given")
  #   }) %>%
  #     bindEvent(watch("validated_word"), ignoreInit = TRUE, once = TRUE)
  #
  #
  #   captcha_server(input, output)
  #   delete_server(input, output)
  games_server("games")
}

shiny::shinyApp(ui, server)
