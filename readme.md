# Crypto-currency Dashboard📈
This Crypto-currency Forecasting Dashboard is a web application built using R Shiny that provides user with interactive visualization of price forecast and candle stick chart.
The dashboard utilizes historical crypto-currency data from Yahoo Finance and several forecasting techniques. 

## Features🎯
- Forecast term slider
- Forecast plot
- Token picker
- Method Selection
- Candle Stick chart

## Requirements
- R and packages:
    - Shiny
    - prophet
    - forecast
    - quantmod
    - ggplot2
    - rvest

## Installation
1. Clone repository
```{bash}
    git clone https://github.com/dabowski/bitcoin_dashboard
```

2. Install packages
```{r}
    install.packages(c("shiny", "forecast", "quantmod", "ggplot2", "rvest", "prophet"))
```

## Usage
1. Run using command
```{bash}
    Rscript ./bitcoin-dashboard/app.R
```
2. Choose token you want to forecast
3. Select period over which you want to forecast
4. Select forecasting method (PROPHET, NNETAR)
