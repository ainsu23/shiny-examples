
games_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 3,
        selectInput(
          inputId = ns("games"),
          label = "select game",
          choices = c("bucket list" = "bucket_list", "meaning" = "meaning"),
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
          selectizeInput(
            inputId = ns("categories"),
            label = "select 3 categories",
            choices = names(select_categories()),
            multiple = TRUE,
            options = list(maxItems = 3)
          )
        ),
          #         shiny::uiOutput(
          #           outputId = ns("categories"),
          #           inline = TRUE
          #         ),
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

      #       output$categories <- renderUI({
      #         tagList(
      #           tags$hr(),
      #           tags$br(),
      #           selectizeInput(
      #             inputId = ns("categories"),
      #             label = "select 3 categories",
      #             choices = names(select_categories()),
      #             multiple = TRUE,
      #             options = list(maxItems = 3)
      #           )
      #         )
      #       })

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
        print(palabras3)

        print(input$bucket3)

        if (
          sum(input$bucket1 %in% palabras1) == length(palabras1) &
            sum(input$bucket2 %in% palabras2) == length(palabras2) &
            sum(input$bucket3 %in% palabras3) == length(palabras3)
        ) {
          show_alert(title = "You Won!")
          updateSelectInput(
            session = session,
            inputId = "categories",
            choices = names(select_categories()),
            selected = NULL
          )
        } else {
          show_alert(title = "Not yet", text = "keep trying")
        }
      }) %>%
        bindEvent(input$end_game)
    }
  )
}
