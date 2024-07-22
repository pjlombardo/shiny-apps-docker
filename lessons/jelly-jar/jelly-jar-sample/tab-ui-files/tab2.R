fluidPage(
    
    # Application title
    titlePanel("Tracking the Percentage of Green Jelly Beans"),
    
    # Sidebar with a slider for sample size and action button to get a new sample.
    fluidRow(
        # Put slider and button in the sidebar
        column(4,
            sliderInput("num_sims2",
                        "Number of Jelly Beans Drawn",
                        min = 10,
                        max = 200,
                        value = 25,
                        step=1
                        # animate=animationOptions(interval = 400,
                        #                          loop = TRUE)
                        )),
        column(1),
        column(4,
            actionButton("new_sim2","Collect a new sample"),
            actionButton("new_sim2_100","Collect 100 new samples")
        ),
        column(3,
               numericInput(
                   "binsize",
                   "Pick Bin Width",
                   0.04,
                   min = .005,
                   max = .1,
                   step = .005,
                   width = NULL
               ))
    ),
    hr(),hr(),
    fluidRow(
        h3("History of Sample Percentages:"),br(),
        column(3,
               tableOutput("history")),
        column(1),
        column(8,
               tableOutput("sim_summ"),hr(),
               plotOutput("hist_percents"))
    )
)