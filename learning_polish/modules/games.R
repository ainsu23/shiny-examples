
games_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 3,
        selectInput(
          inputId = ns("games"),
          label = "select game",
          choices = c("bucket list" = "bucket_list", "guess" = "guess"),
          selected = NULL
        )
      ),
      column(
        width = 12,
        conditionalPanel(
          condition = "input.games == 'bucket_list'",
          ns = ns,
          tags$hr(),
          tags$br(),
          tags$h4("Choose 3 categories to start play, after that, drag and drop
            words into each category. When you have finished end the game"),
          selectizeInput(
            inputId = ns("categories"),
            label = "select 3 categories",
            choices = names(select_categories()),
            multiple = TRUE,
            options = list(maxItems = 3)
          )
        ),
        conditionalPanel(
          condition = "input.games == 'guess'",
          ns = ns,
          tags$hr(),
          tags$br(),
          tags$h4("Guess the word from the category chosen. Tip: Letters are
              given out of order"),
          tags$div(
            class = "row",
            tags$br(),
            selectizeInput(
              inputId = ns("category"),
              label = "select 1 category",
              choices = names(select_categories()),
              multiple = FALSE
            )
          ),
          tags$div(
            class = "row",
            tags$br(),
            textOutput(ns("text_unsorted")),
            tags$br(),
          ),
          tags$div(
            class = "row",
            uiOutput(ns("textos")),
            uiOutput(ns("msg")),
            uiOutput(ns("css"))
          )
        ),
        shiny::uiOutput(
          outputId = ns("game_selected"),
          inline = TRUE
        ),
        actionButton(
          inputId = ns("end_game"),
          label = "Finish game"
        )
      )
    )
  )
}

games_server <- function(id) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      ns <- session$ns

      bucket_words <- reactiveValues()
      palabras <- reactive({
        sample(words_table(input$category)[, "words"], 1)
      })

      linkedList <- reactive({
        complete_linkedList(palabras())
      })

      output$text_unsorted <- renderText({
        glue::glue("Word unsorted: {stringi::stri_rand_shuffle(palabras())}")
      })

      output$textos <- renderUI({
        tagList(
          tags$hr(),
          tags$br(),
          fluidRow(
            purrr::map(
              .x = 1:nchar(palabras()),
              .f = function(.x) {
                column(
                  width = 1,
                  textInput(
                    inputId = ns(glue("texto{.x}")),
                    label = glue("{.x}"),
                    value = NULL
                  )
                )
              }
            )
          )
        )
      })

      output$msg <- renderUI({
        tagList(
          tags$p("Colors representation:"),
          tags$p("red: letter in position is not correct", class = "red"),
          tags$p("yellow: letter in position correct, previous or next nodes are not correct",
            class = "yellow"
          ),
          tags$p("green: letter in position is correct, next and previous nodes are corrected",
            class = "green"
          ),
          tags$style(".red {color: red;}"),
          tags$style(".yellow {color: #b1b100;}"),
          tags$style(".green {color: green;}"),
        )
      }) %>%
        bindEvent(input$end_game)

      output$css <- renderUI({
        purrr::map(
          .x = 1:nchar(palabras()),
          .f = function(.x) {
            color <- change_color(
              LinkedList = linkedList(),
              position = .x,
              .prev = input[[glue("texto{.x - 1}")]],
              .next = input[[glue("texto{.x + 1}")]],
              letter = input[[glue("texto{.x}")]]
            )
            tags$style(
              type = "text/css",
              paste0("#", ns(""), "texto", .x, "-label {color: ", color, ";font-weight: bold}")
            )
          }
        )
      }) %>%
        bindEvent(input$end_game)

      output$game_selected <- shiny::renderUI({
        if (length(input$categories) == 3) {
          bucket_words$palabras1 <- words_table(input$categories[1])[, "words"]
          bucket_words$palabras2 <- words_table(input$categories[2])[, "words"]
          bucket_words$palabras3 <- words_table(input$categories[3])[, "words"]
          palabras <- c(
            bucket_words$palabras1, bucket_words$palabras2,
            bucket_words$palabras3
          )
          bucket_words$palabras_game <-
            sample(palabras, round(length(palabras) / 3)) %>%
            stringr::str_wrap(.)

          tagList(
            bucket_list(
              header = c(glue::glue("Sort these items into
                  {input$categories[1]}, {input$categories[2]},
                  {input$categories[3]} ")),
              add_rank_list(
                text = "Drag from here",
                labels = bucket_words$palabras_game
              ),
              add_rank_list(
                text = input$categories[1],
                input_id = ns("bucket1")
              ),
              add_rank_list(
                text = input$categories[2],
                input_id = ns("bucket2")
              ),
              add_rank_list(
                text = input$categories[3],
                input_id = ns("bucket3")
              )
            )
          )
        } else {
          tagList()
        }
      })

      observe({
        palabras1 <- intersect(
          bucket_words$palabras1,
          bucket_words$palabras_game
        )
        palabras2 <- intersect(
          bucket_words$palabras2,
          bucket_words$palabras_game
        )
        palabras3 <- intersect(
          bucket_words$palabras3,
          bucket_words$palabras_game
        )

        if (
          sum(input$bucket1 %in% palabras1) == length(palabras1) &
            sum(input$bucket2 %in% palabras2) == length(palabras2) &
            sum(input$bucket3 %in% palabras3) == length(palabras3)
        ) {
          if ("input.game" == "bucket_list") {
            show_alert(title = "You Won!")
          }
          updateSelectInput(
            session = session,
            inputId = "categories",
            choices = names(select_categories()),
            selected = NULL
          )
        } else {
          show_alert(title = "Not yet", text = "keep trying", type = "error")
        }
      }) %>%
        bindEvent(input$end_game)
    }
  )
}
