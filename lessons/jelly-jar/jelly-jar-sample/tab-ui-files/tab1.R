fluidPage(
    
    # rclipboardSetup(),
    
    # Application title
    titlePanel("Tracking the Percentage of Green Jelly Beans"),
    
    # Sidebar with a slider for sample size and action button to get a new sample.
    fluidRow(
        # Put slider and button in the sidebar
        column(4,
            sliderInput("num_sims1",
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
            actionButton("new_sim1","Collect a new sample")
            
        )
    ),
    hr(),hr(),
    fluidRow(
        h3("Most Recent Sample Information:"),br(),
        column(3,
               # uiOutput("clip"),
               tableOutput("jelly_sample"), hr(),hr()
               ),
        column(3,
               div(tableOutput("sample_sum"), style = "font-size:200%"))
    )
)