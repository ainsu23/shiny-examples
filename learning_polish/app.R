# Libraries necesaries to run the app
source("dependencies.R")
source("R/firebase.R")
source("R/join_words.R")
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
    ),
    nav(
      title = "manual",
      manual_ui("manual")
    )
  )
)

server <- function(input, output, session) {
  init("actualizar_dt", "permission_given")
  init("validated_word", "password_confirmed")

  # Se inicializa objeto R6 para traer palabras almacenadas una sola vez.
  # Initialize object R6 to bring information from firebase at once.
  polish <- manager$new()

  # Se trae tabla de acuerdo a categoria seleccionada
  # Create reactive with table of category selected
  words_table_category <- reactive(
    # Método de objeto polish (R6), genera tabla de categoria seleccionada
    # Method from object polish (R6), generates table of selected category.
    polish$wybrana_kategoria(input$topic)
  ) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  # Se actualiza categoria
  # Updates category
  updateSelectInput(
    inputId = "topic",
    # Método de objeto polish (R6) kategorie para traer categorias existentes en
    # firebase. Se usa deframe para que muestre en el input el texto pero devuelva
    # el número de fila, con el fin de usar hashmap como filtro.
    # Method from polish (R6) to bring categories from firebase. I use deframe
    # to show text in input and bring number to serve, with the objective of
    # using hashmap as filter.
    choices = polish$kategorie %>%
      tibble::deframe()
  )

  # Renderiza tabla con palabras.
  # Render table with words
  output$table_words <- renderDT({
    polish$wybrana_słowa(words_table_category())
  }) %>%
    bindEvent(watch("actualizar_dt"), input$topic)

  # Permite eliminar palabras
  # Allows to delete words
  observe({
    req(words_table_category())
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
  #   Modulos ########### Modules #####
  #   captcha_server(input, output)
  delete_server(input, output)
  games_server("games")
}

shiny::shinyApp(ui, server)
