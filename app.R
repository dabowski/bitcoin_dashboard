library(shiny)
library(forecast)
library(quantmod)
library(ggplot2)
library(rvest)
library(prophet)

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
    sidebarLayout(
        sidebarPanel(
            selectInput("token", "Select a token.", tokens),
            sliderInput("dateSlider", label="Which period do you want to see?", min=as.Date("2018-01-01"), max=Sys.Date(), value=c(as.Date("2020-09-01"), as.Date("2020-10-01"))
        )),
        mainPanel(
            plotOutput("candleStick")
        )
    ),
    sidebarLayout(
        sidebarPanel(
            sliderInput("term", "How many days into the future you want to forecast?", min=30, max=720, step = 30, value=360),
            radioButtons("bt", "Choose a method:", c("PROPHET", "NNETAR"))
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)


server <- function(input, output) {
    coin_data <- reactive({
        na.approx(getSymbols(input$token, from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE))  
    })

    output$plot <- renderPlot({

        if(input$bt == "NNETAR"){
            fit <- nnetar(coin_data()[,4])
            fc <- forecast(fit, h=input$term)
            autoplot(fc, h=input$term) +
                ylab("Adjusted Close Price") +
                xlab("Year")
        } else {

            data <- data.frame(ds = time(coin_data()), y=as.numeric(coin_data()[,4]))
            model <- prophet(data)
            future <- make_future_dataframe(model, periods = input$term)
            forecast <- predict(model, future)
            plot(model, forecast)
        }

    })

    output$candleStick <- renderPlot({
        chartSeries(coin_data()[paste0(input$dateSlider[1], "/", input$dateSlider[2])], type="candlesticks", name=input$token)
    })
}

shinyApp(ui, server)
