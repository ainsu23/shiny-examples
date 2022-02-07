
captcha_server <- function(input, output) {
  # reactiveValues object for storing current data set.
  vals <- reactiveValues(data = NULL)

  # Return the UI for a modal dialog with data selection input. If 'failed' is
  # TRUE, then display a message that the previous value was invalid.
  dataModal <- function(failed = FALSE) {
    category_sample <- names(sample(select_categories(), 1))
    word_selected <- sample(select_words(category_sample), 1) %>%
      stringr::str_split(., ":")
    vals$word_captcha <- word_selected[[1]][1]
    vals$translate_captcha <- word_selected[[1]][2] %>%
      stringr::str_squish(.) %>%
      stringr::str_to_lower(.)


    modalDialog(
      textInput(
        "dataset", 
        glue::glue(
          "Write translation in spanish of the  following word 
          (lower letters): {vals$word_captcha} "),
        placeholder = glue::glue("tip! category: {category_sample}")
      ),
      if (failed)
        div(tags$b("Translation incorrect, try again", style = "color: red;")),

      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok", "OK")
      )
    )
  }

  # Show modal when button is clicked.
  observe({
    showModal(dataModal())
  }) %>%
    bindEvent(input$add_word)

    # When OK button is pressed, attempt to load the data set. If successful,
    # remove the modal. If not show another modal, but this time with a failure
    # message.
    observe({
      # Check that data object exists and is data frame.
      if (!is.null(input$dataset) && nzchar(input$dataset) &&
        vals$translate_captcha == input$dataset
          ) {
        trigger("validated_word")
        removeModal()
      } else {
        showModal(dataModal(failed = TRUE))
      }
    }) %>%
      bindEvent(input$ok)
  
}
