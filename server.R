library(shiny)
library(forecast)
library(quantmod)
library(tidyverse)

server <- function(input, output) {
    output$plot <- renderPlot({
        btc <- getSymbols("BTC-USD", from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE)
        btc <- as.data.frame(btc)
        btc.adjusted <- ts(btc[, "BTC-USD.Adjusted"], start = 2018, frequency = 365)

        fit <- stlf(btc.adjusted, method='naive')
        fc <- forecast(fit, h=365)
        autoplot(fc, h=365)
    })
}
