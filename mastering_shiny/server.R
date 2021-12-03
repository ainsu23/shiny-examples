server <- function(input, output, session) {
  updateSelectInput(
    inputId = "chapter",
    choices = dir(pattern = "chapter")
  )

  output$manuales <- renderUI({
    includeMarkdown(paste0("man/", input$chapter, ".md"))
  })

  observe({
    updateSelectInput(
      session = session,
      inputId = "excercises",
      choices = dir(input$chapter, pattern = "excercise") %>%
        stringr::str_remove(".R")
    )
  })


  chapter_1_excercise_1_server("chapter_1_excercise_1")
  chapter_1_excercise_2_server("chapter_1_excercise_2")
  chapter_1_excercise_4_server("chapter_1_excercise_4")
  chapter_1_excercise_5_server("chapter_1_excercise_5")
  chapter_2_excercise_1_server("chapter_2_excercise_1")
  chapter_2_excercise_2_server("chapter_2_excercise_2")
  chapter_3_excercise_1_server("chapter_3_excercise_1")
  chapter_3_excercise_3_server("chapter_3_excercise_3")
  chapter_4_excercise_injuries_server("chapter_4_excercise_injuries")



  output$chapters <- renderUI({
    lapply(
      paste0(input$chapter, "_", input$excercises),
      paste0(input$chapter, "_", input$excercises, "_ui")
    )
  })
}
