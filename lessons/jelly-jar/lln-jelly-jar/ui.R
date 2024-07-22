ui<-fluidPage(
    
    # Application title
    titlePanel("Tracking the Percentage of Green Jelly Beans"),
    
    # Sidebar with a slider for sample size and action button to get a new sample.
    fluidRow(
        # Put slider and button in the sidebar
        column(4,
            #This creates a button for us.
            # actionButton("reload_plot","Update Plot Simulation"),
            # This creates a slider to update the number of simulations
            sliderInput("num_sims",
                        "Number of Jelly Beans Drawn",
                        min = 5,
                        max = 2000,
                        value = 5,
                        step=4,
                        animate=animationOptions(interval = 400,
                                                 loop = TRUE))),
        column(1),
        column(4,
            actionButton("new_sim1","Generate a new simulation")
        )
    ),
    
    fluidRow(
        column(12,
               # Show a plot of the generated distribution
                   plotOutput("line_with_rel_freq")
               )
    )
)