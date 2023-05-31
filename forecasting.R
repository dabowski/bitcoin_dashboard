library(quantmod)
library(forecast)
library(tidyverse)

btc <- getSymbols("BTC-USD", from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE)
btc <- as.vector(btc[,4])
btc
btc.adjusted <- ts(btc, start = 2018, frequency = 365)

# Plot Adjusted Close price using base R
plot(btc.adjusted, type = "l", xlab = "Year", ylab = "Price Adjusted", main = "BTC-USD")

# Plot Adjusted Close price using ggplot
autoplot(btc.adjusted) +
    ggtitle("BTC-USD") +
    xlab("Year") +
    ylab("Adjusted")

# Arima
fitA <- auto.arima(btc.adjusted, seasonal = F)
fcA <- forecast(fitA, h=365)
autoplot(fcA, h=365)

# NNETAR
fitB <- nnetar(btc.adjusted)
fcB <- forecast(fitB, h=365)
autoplot(fcB, h=365)

# stl
fitC <- stlf(btc.adjusted, method='naive')
fcC <- forecast(fitC, h=365)
autoplot(fcC, h=365)
