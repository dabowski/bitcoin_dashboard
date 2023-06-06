library(quantmod)
library(forecast)
library(tidyverse)

btc <- getSymbols("BTC-USD", from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE)
btc

today <- Sys.Date()
s <- "2023-01-01"

plot(btc[,4][paste0(s, "/", today)], main="BTC-USD from 1st of January, 2023 to 10th of January, 2023")
chartSeries(btc[paste0(s, "/", today)], type="candlesticks", name="BTC-USD")

# Plot Close price using base R
plot(btc[,4], type = "l", xlab = "Year", ylab = "Price Adjusted", main = "BTC-USD")

# Plot Close price using ggplot
autoplot(btc[,4]) +
    ggtitle("BTC-USD") +
    xlab("Year") +
    ylab("Adjusted")

# Arima
fitA <- auto.arima(btc[,4], seasonal = F)
fcA <- forecast(fitA, h=365)
autoplot(fcA, h=365)

# NNETAR
fitB <- nnetar(btc[,4])
fcB <- forecast(fitB, h=365)
autoplot(fcB, h=365)

# stl
fitC <- stlf(btc[,4], method='naive')
fcC <- forecast(fitC, h=365)
autoplot(fcC, h=365)

# prophet
library(prophet)
data <- data.frame(ds = time(btc), y=as.numeric(btc[,4]))
data

model <- prophet(data)
future <- make_future_dataframe(model, periods = 365)
forecast <- predict(model, future)
plot(model, forecast)
