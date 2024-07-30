library(shiny)
library(ggplot2)

source('functions.R')

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Reactive values
    record_num<-reactiveValues(data=0)
    rlist<-reactiveValues(data=get_index_and_bars(5, 1,8))
    plot_samples<-reactiveValues(data= gen_truth(8))
    plot_cis<-reactiveValues(data= ci_plot_gen(8))
    
    output$pop_mean<-renderText({
        paste("Actual Population Mean = ",round(PM,2),"inches")
    })
    
    output$null_mean_txt<-renderText({
        paste("Null Hyp. Mean = ",round(input$null_mu,2),"inches")
    })
    
    output$diff<-renderText({
        paste("Size of Difference to Detect = ",round(abs(PM-input$null_mu),2),"inches")
    })
    
    output$diff_sig<-renderText({
        paste("Number of Standard Deviations Away = ",round(abs(PM-input$null_mu)/PS,2))
    })
    
    output$sampling<-renderPlot({
        plot_samples$data
    })
    
    output$conf_int<-renderPlot({
        plot_cis$data+
            labs(x="",
                 y="")+
            geom_hline(yintercept=rlist$data[[2]][record_num$data,'m'],
                       col='blue',
                       lty=2, linewidth=.7)
    })
    
    observeEvent(input$null_mu, {
        plot_samples$data<-gen_truth(input$null_mu)
        rlist$data <- update_flags(rlist$data, input$ME, input$null_mu)
        plot_cis$data<-add_ci(record_num$data,
                              rlist$data[[2]],
                              input$show_interval,
                              input$null_mu)
        
        output$success_rate<-renderText({
            sr<-100*(sum(rlist$data[[2]]$flag[1:record_num$data]=='blue')/record_num$data)
            paste("Power: ",sr,"%")
        })
        
        # output$conf_int<-renderPlot({
        #     plot_cis$data+
        #         labs(x="",
        #              y="")+
        #         geom_hline(yintercept=rlist$data[[2]][record_num$data,'m'],
        #                    col='blue',
        #                    lty=2, linewidth=.7)
        # })
    })
    
    output$success_rate<-renderText({
        sr<-100*(sum(rlist$data[[2]]$flag[1:record_num$data]=='blue')/record_num$data)
        paste("Power: ",sr,"%")
    })
    
    observeEvent(input$sample_size,{
        rlist$data= get_index_and_bars(input$sample_size, input$ME, input$null_mu)
        plot_samples$data<-gen_truth(input$null_mu)
        plot_cis$data<-ci_plot_gen(input$null_mu)
        record_num$data<-0
    })
    
    observeEvent(input$ME,{
        rlist$data <- update_margin_error(rlist$data,input$ME,input$null_mu)
        plot_cis$data<-add_ci(record_num$data,
                              rlist$data[[2]],input$show_interval,
                              input$null_mu)
    })
    
    observeEvent(input$get_samp,{
        record_num$data<-record_num$data+1
        plot_samples$data<-plot_with_sample(gen_truth(input$null_mu),record_num$data,
                                            rlist$data[[1]],
                                            rlist$data[[2]],
                                            input$null_mu)
        
        plot_cis$data<-add_ci(record_num$data,
                              rlist$data[[2]],input$show_interval,
                              input$null_mu)
        
    })
    
    observeEvent(input$show_interval,{
        if (record_num$data==0) {
            plot_cis$data<-ci_plot_gen(input$null_mu)
        } else {
            plot_cis$data<-add_ci(record_num$data,
                                  rlist$data[[2]],input$show_interval,
                                  input$null_mu)}
    })
    
    observeEvent(input$get_50,{
        record_num$data<-record_num$data+50
        plot_samples$data<-plot_with_sample(gen_truth(input$null_mu),record_num$data,
                                            rlist$data[[1]],
                                            rlist$data[[2]],
                                            input$null_mu)
        
        plot_cis$data<-add_ci(record_num$data,
                              rlist$data[[2]],input$show_interval,
                              input$null_mu)
        
    })
    
    observeEvent(input$reset, {
        plot_samples$data<-gen_truth(input$null_mu)
        plot_cis$data<-ci_plot_gen(input$null_mu)
        record_num$data<-0
        rlist$data= get_index_and_bars(input$sample_size, input$ME, input$null_mu)
    })
    
    
    #workflow: 
    # sample_index as reactive value that updates
    # success_rate as reactive value that updates
    # record_num as reactive value that updates
    # get sample: updates sample_index, show the sample and sample mean
    # in pane 1, adds mean and CI in pain 2, update 
    # success_rate.
    # render the current success rate of the CI
    # get 100 sample: repeats process above 100 times.
}
