
grammar_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 2,
        selectInput(
          inputId = ns("units"),
          label = "units",
          choices = data.frame(
            "unit" = paste("unit", 1:4, sep = ""),
            "unit_id" = 1:4
          ) %>%
            tibble::deframe()
        )
      ),
      column(width = 10, uiOutput(ns("units_markdown")))
    )
  )
}

grammar_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$units_markdown <- shiny::renderUI({
      includeMarkdown(paste0("man/unit", input$units, ".md"))
    })
  })
}
