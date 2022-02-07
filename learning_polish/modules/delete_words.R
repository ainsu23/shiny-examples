
delete_server <- function(input, output) {
  # Return the UI for a modal dialog with data selection input. If 'failed' is
  # TRUE, then display a message that the previous value was invalid.
    deleteModal <- function(failed = FALSE) {
      modalDialog(
        textInput(
          "deleteset", 
          glue::glue("Please introduce password:")
        ),
        if (failed)
          div(tags$b("Password incorrect, try again", style = "color: red;")),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("ok_delete", "OK")
        )
      )
    }

    observe({
      showModal(deleteModal())
    }) %>%
      bindEvent(input$delete_word)

      # When OK button is pressed, attempt to load the data set. If successful,
      # remove the modal. If not show another modal, but this time with a failure
      # message.
      observe({
        # Check that data object exists and is data frame.
        if (!is.null(input$deleteset) && nzchar(input$deleteset) &&
          Sys.getenv("password") == input$deleteset
        ) {
          trigger("password_confirmed")
          removeModal()
        } else {
          showModal(deleteModal(failed = TRUE))
        }
      }) %>%
        bindEvent(input$ok_delete)
}
