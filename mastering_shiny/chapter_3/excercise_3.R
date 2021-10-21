library(shiny)

# Original
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))

# Correction
The previous names are used to calculate variance and range, so they are
reserved names.
