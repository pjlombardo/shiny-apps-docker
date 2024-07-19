library(shiny)
library(ggplot2)

source('functions.R')

server <- function(input, output,session) {
    simulations<-reactiveValues(data = simulations_st)
    
    observeEvent(input$loss_ratio, {
        simulations$data<-iterate_event(input$loss_ratio,n=5000)
    })
    
    observeEvent(c(input$reload_plot,input$loss_ratio),{
        updateSliderInput(session,'num_sims',value = 5)
    })
    
    observeEvent(input$num_sims,{
        output$line_with_rel_freq<-renderPlot({
            generate_plot(simulations$data,input$num_sims,input$exp_val,input$loss_ratio)
        })
    })
    
}