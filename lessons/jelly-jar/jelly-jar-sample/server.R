library(tidyverse)
library(ggplot2)
library(kableExtra)
# library(rclipboard)

source('functions.R')

server <- function(input, output) {
    
    # Initial outputs:
    output$jelly_sample<-function(){
        tbl
    }
    
    output$sample_sum<-renderTable(
        summ, digits = 3
    )
    
    output$history<-renderTable(
        data.frame(
            "Sample Number" = "Sample 1",
            "Percent Green" = history
        ),
        digits = 3
    )
    output$sim_summ<-renderTable(
        get_sim_summ(history)
    )
    
    output$hist_percents<-renderPlot(
        ggplot()+theme_bw()
    )
    
    # tab 1: single sample
    udf<-reactiveValues(data = df)
    utbl<-reactiveValues(data = get_sample_tbl(df))
    u_summ<-reactiveValues(data = get_sample_summ(df))
    
    
    # output$clip <- renderUI({
    #     rclipButton(
    #         inputId = "clipbtn",
    #         label = "Copy The Current Sample",
    #         clipText = utbl$data, 
    #         icon = icon("clipboard"),
    #         tooltip = "Make a copy of the current sample from the jar.",
    #         placement = "top",
    #         options = list(delay = list(show = 800, hide = 100), trigger = "hover")
    #     )
    # })
    
    observeEvent(input$num_sims1, {
        utbl$data<-data.frame(color=NA) %>% kable("html",col.names="Jelly Color",
                                                  row.names =FALSE,
                                                  align = "c")
        u_summ$data<-data.frame(summary=NA)
        
    })
    
    observeEvent(c(input$new_sim1), {
        # update reactive values
        udf$data<-get_sample(input$num_sims1)
        utbl$data<-get_sample_tbl(udf$data)
        u_summ$data <-get_sample_summ(udf$data)

        #update outputs
        output$jelly_sample <-function(){
            utbl$data
        }
        
        output$sample_sum <-renderTable(
            u_summ$data, digits = 3
        )
        

    })
    
    
    
    
    # tab 2: sampling dist
    #
    u_sim_summ<-reactiveValues(data = history)
    counter<-reactiveValues(data = 0)
    uhistory<-reactiveValues(data = NULL)
    usim_summ<-reactiveValues(data = get_sim_summ(history))
    
    observeEvent(input$num_sims2, {
        counter$data<-0
        uhistory$data<-NULL
        
        output$history<-renderTable(
            data.frame(history = NA)
        )
        
        output$sim_summ<-renderTable(
            data.frame(summaries=NA),
            digits=3
        )
        
        
        output$hist_percents<-renderPlot(
            ggplot()+theme_bw()
        )
    })
    
    observeEvent(input$new_sim2, {
        counter$data<-counter$data+1
        uhistory$data<-c(uhistory$data, mean(rbinom(input$num_sims2,1,0.2123)))
        
        output$history<-renderTable(
            data.frame(
                "Sample Number" = paste("Sample",1:counter$data),
                "Percent Green" = uhistory$data
            ),
            digits = 3
        )
        
        
        output$sim_summ<-renderTable(
            get_sim_summ(uhistory$data),
            digits=3
        )
        
        output$hist_percents<-renderPlot(
            generate_plot(uhistory$data, counter$data, input$binsize)
        )
        
    })
    
    
    observeEvent(input$new_sim2_100, {
        counter$data<-counter$data+100
        uhistory$data<-c(uhistory$data, rbinom(100,input$num_sims2,0.2123)/input$num_sims2)
        
        output$history<-renderTable(
            data.frame(
                "Sample Number" = paste("Sample",1:counter$data),
                "Percent Green" = uhistory$data
            ),
            digits = 3
        )
        
        
        output$sim_summ<-renderTable(
            get_sim_summ(uhistory$data),
            digits=3
        )
        
        output$hist_percents<-renderPlot(
            generate_plot(uhistory$data, counter$data, input$binsize)
        )

    })
    
    observeEvent(input$binsize, {
        if (counter$data !=0){
            output$hist_percents<-renderPlot(
                generate_plot(uhistory$data, counter$data, input$binsize)
            )
        }
    })

    # 
}