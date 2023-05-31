library(shiny)
library(forecast)
library(quantmod)
library(ggplot2)
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
    sidebarLayout(
        sidebarPanel(
            selectInput("token", "Select a token.", tokens),
            sliderInput("term", "How many days into the future you want to forecast?", min=30, max=720, step = 30, value=360),
            radioButtons("bt", "Choose a method:", c("STLF", "NNETAR"))
        ),
        mainPanel(
            plotOutput("plot") 
        )
    )
)

server <- function(input, output) {
    coin_data <- reactive({
        getSymbols(input$token, from = "2018-01-01", to = Sys.Date(), auto.assign = FALSE)
    })

    price <- reactive({
        ts(as.vector(coin_data()[, 4]), start = 2018, frequency= 365)
    })

    output$plot <- renderPlot({

        if(input$bt == "NNETAR"){
            fit <- nnetar(price())
        } else {
            fit <- stlf(price(), method='naive')
        }

        fc <- forecast(fit, h=input$term)
        autoplot(fc, h=input$term) +
            ylab("Adjusted Close Price") +
            xlab("Year")
    })
}

shinyApp(ui, server)
