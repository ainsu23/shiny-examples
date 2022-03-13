
landing_server <- function(input, output) {
  # Return the UI for a modal dialog with data selection input. If 'failed' is
  # TRUE, then display a message that the previous value was invalid.
  landingModal <- function() {
    modalDialog(
      #       includeMarkdown(paste0("man/manual.md")),
      #       renderUI(includeHTML("man/manual.html")),
      tagList(
        tags$div(
          tags$iframe(
            src = "manual.html",
            width = "100%", height = "400", scrolling = "no",
            seamless = "seamless", frameBorder = "0"
          )
        )
      ),
      footer = tagList(
        actionButton("ok_landing", "OK")
      )
    )
  }

  observe({
    showModal(landingModal())
  })

  # When OK button is pressed, attempt to load the data set. If successful,
  # remove the modal. If not show another modal, but this time with a failure
  # message.
  observe({
    removeModal()
  }) %>%
    bindEvent(input$ok_landing)
}
