
source("../global.R")

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  h4(content(temperatura)),
  titlePanel("What have I learned from Mastering Shiny?"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "chapter",
        label = "select chapter",
        choices = "chapter_1"
      ),
      selectInput(
        inputId = "excercises",
        label = "select excercise",
        choices = "excercise_1"
      )
    ),
    mainPanel(
      uiOutput("manuales"),
      tags$br(),
      tags$hr(),
      uiOutput("chapters")
    )
  )
)
