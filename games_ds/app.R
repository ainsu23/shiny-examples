source("dependencies.R")
source("R/linked_list.R")

palabras = data.frame(
"words" = c(
  "data_structures", "stacks", "linked_lists", "queues", "hash_tables", 
  "arrays", "trees", "graphs"),
freq = 1:8 
)

ui <- fluidPage(
  theme = bslib::bs_theme(
    bootswatch = "flatly",
    base_font = font_link(
      "Bad Script",
      href = "https://fonts.googleapis.com/css2?family=Bad+Script&display=swap"
    ),
    font_scale = 1.3
  ),
  fluidRow(
    column(
      width = 2,
      actionButton(
        inputId = "change_word",
        label  = "Change word"
      )
    ),
    column(
      width = 10,
      tagList(
        tags$p("Double linked list representation with random words. The user
          should guess the word from the wordcloud, the letters introduced are
          compared to a linkedlist saved in a R6Class.", class = "descripcion"
        ),
        tags$style(".descripcion {font-size: 30px;}"),
        tags$br(),
        tags$br()
      )
    )
  ),
  uiOutput("textos"),
  uiOutput("msg"),
  uiOutput("css"),
  actionButton(
    inputId = "validate",
    label  = "Validate"
  ),
  wordcloud2::wordcloud2Output("cloud")

)


server <- function(input, output, session) {
  init("palabra")
  lista <- new.env()
  lista$palabra <- sample(palabras$words, 1)

  observe({
    lista$palabra <- sample(palabras$words, 1)
    trigger("palabra")
  }) %>%
    bindEvent(input$change_word)

  observe({
    lista$ll <- complete_linkedList(lista$palabra)
  }) %>%
    bindEvent(lista$palabra, watch("palabra"))

  output$textos <- renderUI({
    watch("palabra")
    tagList(
      fluidRow(
        purrr::map(
          .x = 1:nchar(lista$palabra),
          .f = function(.x) {
            column(
              width = 1,
              textInput(
                inputId = glue("texto{.x}"),
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
        class = "yellow"),
      tags$p("green: letter in position is correct, next and previous nodes are corrected",
        class = "green"),
      tags$style(".red {color: red;}"),
      tags$style(".yellow {color: #b1b100;}"),
      tags$style(".green {color: green;}"),
    )
  }) %>%
  bindEvent(input$validate)

  output$css <- renderUI({
    purrr::map(
      .x = 1:nchar(lista$palabra),
      .f = function(.x) {
        color <- change_color(
          LinkedList = lista$ll,
          position = .x,
          .prev = input[[glue("texto{.x - 1}")]],
          .next = input[[glue("texto{.x + 1}")]],
          letter = input[[glue("texto{.x}")]]
        )
        tags$style(
          type="text/css", 
          paste0("#texto", .x, "-label {color: ", color, ";font-weight: bold}")
        )
      }
    )
  }) %>%
    bindEvent(input$validate)

  output$cloud <- wordcloud2::renderWordcloud2({
    wordcloud2::wordcloud2(data=palabras, size=0.7, color='random-dark')
  })


}
shiny::shinyApp(ui, server)




