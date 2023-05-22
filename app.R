library(shiny)
library(forecast)
library(quantmod)
library(tidyverse)
library(rvest)

url <- "https://coinranking.com/"
webpage <- read_html(url)

tbl <- html_table(html_nodes(webpage, "table"))[[2]][1]
tokens <- sapply(tbl, function(x) substr(x, nchar(x) - 5, nchar(x)))
tokens <- as.vector(tokens)
tokens <- gsub("\\s+", "", tokens)
tokens <- tokens[tokens != "gainer"]
tokens <- tokens[tokens != "loser"]
tokens <- tokens[tokens != ""]
tokens <- paste0(tokens, "-USD")

ui <- fluidPage(
    titlePanel("Forecasting Dashboard"),
    selectInput("token", "Select a token.", tokens),
    sliderInput("term", "How many days into future.", min=30, max=720, step = 30, value=360),
    plotOutput("plot")
)

server <- function(input, output) {
    output$plot <- renderPlot({
        btc <- getSymbols(input$token, from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE)
        btc <- as.vector(btc[, 4])
        btc <- ts(btc, start = 2018, frequency= 365)

        fit <- stlf(btc, method='naive')
        fc <- forecast(fit, h=input$term)
        autoplot(fc, h=input$term)
    })
}

shinyApp(ui, server)
