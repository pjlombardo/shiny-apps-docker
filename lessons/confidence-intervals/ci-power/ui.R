########################
# Create Shiny Page ####
########################
# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Power for confidence intervals"),
    h3("What percentage of confidence interval correctly rule out the null hypothesis (red)?"),
    hr(),
    # Sidebar with a slider for sample size and action button to get a new sample.
    fluidRow(position = 'left',
             column(4,
                    sliderInput("null_mu","Set the Null Hypothesis Mean",
                                min=5, max = 25, step=.1, value=8)
                    ),
             column(2),
             column(6,
                span(textOutput("pop_mean"), style="color:green; font-size:20px"),
                span(textOutput("null_mean_txt"), style="color:red; font-size:20px"),
                hr(),
                span(textOutput("diff"), style="font-size:20px; font-style:bold"),
                span(textOutput("diff_sig"), style="font-size:16px; font-style:bold")
             )
    ),
    hr(),hr(),
    fluidRow( position = 'left',
              # Put slider and button in the sidebar
              column(5,
                     plotOutput("sampling",
                                height="450px")
              ),
              column(7,
                     plotOutput("conf_int",
                                height="450px"))
    ),
    
    fluidRow(
        column(4,
               actionButton("get_samp", "Get one sample"),
               actionButton("get_50", "Get 50 samples"),
               checkboxInput("show_interval","Show confidence interval",
                             value=F)
        ),
        column(4,
               sliderInput("sample_size","Set the fixed sample size",
                           min=5, max = 100, step=5, value=5),
               sliderInput("ME","Choose a margin of error for the confidence interval",
                           min=0.1, max = 8, step=.1, value=1),
               actionButton("reset","Reset plot")
        ),
        column(4,
               h3(textOutput("success_rate")))
        
    )
    
)
