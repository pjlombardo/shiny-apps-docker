library(shiny)
library(ggplot2)

source('functions.R')

server <- function(input, output) {
    
    coin1<-reactiveValues(data = coin)
    # Tab 1
    output$line_with_rel_freq<-renderPlot({
        generate_plot(coin1$data,input$num_sims)
    })
    
    observeEvent(input$new_sim1,{
        set.seed(round(runif(1,0,1000),0))
        coin1$data<-coin_flip(n=2000)
        output$line_with_rel_freq<-renderPlot({
            generate_plot(coin1$data,input$num_sims)
        })
    })
    
}