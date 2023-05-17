library(shiny)

ui <- fluidPage(
    titlePanel("Forecasting Dashboard"),
    plotOutput("plot")
)
