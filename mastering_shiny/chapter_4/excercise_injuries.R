# Case of Study ER Injuries

# Cargue de librerias
library(shiny)
library(vroom)
library(tidyverse)

# Lectura de información en repositorio de hadley
dir.create("neiss")
#> Warning in dir.create("neiss"): 'neiss' already exists
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")
injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

prod_codes <- setNames(products$prod_code, products$title)

# Si se trocan fct_lump con fct_infreq, se genera un error
count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}



# ui <- fluidPage(
#   fluidRow(
chapter_4_excercise_injuries_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        6,
        selectInput(ns("code"), "Product", choices = prod_codes),
        numericInput(
          inputId = ns("maximo"),
          label = "Maximo filas",
          value = 4,
          min = 1,
          max = 50
        )
      )
    ),
    fluidRow(
      column(4, tableOutput(ns("diag"))),
      column(4, tableOutput(ns("body_part"))),
      column(4, tableOutput(ns("location")))
    ),
    fluidRow(
      column(12, plotOutput(ns("age_sex")))
    ),
    fluidRow(
      column(
        2,
        actionButton(ns("story_f"), "Tell a story fordward"),
        actionButton(ns("story_b"), "Tell a story backward")
      ),
      column(10, textOutput(ns("narrative")))
    )
  )
}

# server <- function(input, output, session) {
chapter_4_excercise_injuries_server <- function(id) {
  ns <- NS(id)
  moduleServer(
    id = id,
    module = function(input, output, session) {
      selected <- reactive(injuries %>% filter(prod_code == input$code))

      output$diag <- renderTable(count_top(selected(), diag, n = input$maximo),
        width = "100%"
      )

      output$body_part <- renderTable(
        count_top(selected(),
          body_part,
          n = input$maximo
        ),
        width = "100%"
      )

      output$location <- renderTable(
        count_top(
          selected(),
          location,
          n = input$maximo
        ),
        width = "100%"
      )

      summary <- reactive({
        selected() %>%
          count(age, sex, wt = weight) %>%
          left_join(population, by = c("age", "sex")) %>%
          mutate(rate = n / population * 1e4)
      })

      output$age_sex <- renderPlot(
        {
          summary() %>%
            ggplot(aes(age, n, colour = sex)) +
            geom_line() +
            labs(y = "Estimated number of injuries")
        },
        res = 96
      )

      # Posicion del vector para recorrerlo de forma circular.
      posicion <- reactiveVal(1)

      # Actualiza posicion cuando se presiona "tell story forward"
      observeEvent(input$story_f, {
        if (nrow(selected()) == posicion()) posicion(0)
        nueva_posicion <- posicion() + 1
        posicion(nueva_posicion)
      })

      # Actualiza posicion cuando se presiona "tell story backward"¿
      observeEvent(input$story_b, {
        if (posicion() == 1) posicion(nrow(selected()))
        nueva_posicion <- posicion() - 1
        posicion(nueva_posicion)
      })

      narrative_sample <- eventReactive(
        list(input$story_f, input$story_b, selected()),
        {
          selected() %>%
            pull(narrative) %>%
            nth(posicion())
        }
      )

      output$narrative <- renderText(narrative_sample())
    }
  )
}

# shinyApp(ui, server)
