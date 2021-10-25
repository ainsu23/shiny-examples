

library(shiny)
library(dplyr)
library(httr)

temperatura <- GET("https://wttr.in/?format=3")

