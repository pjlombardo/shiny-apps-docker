ui<-fluidPage(
    
    # Application title
    titlePanel("Carnival Game:"),
    h3("Simulating the Average Winnings Per Game in the Long-term"),
    hr(),
    p("Consider the following carnival game:"),
    p("A player rolls two dice: a green die and a red die."),
    p("If the green die is a 5 or a 6, the player wins the amount on the face of the red die."),
    p("But, if the green die is a 4 or less, the player pays a percentage of the amount on the red die."),
    p(""),
    p("The slider below allows us to change the percentage that the player owes if he or she loses!"),
    p("Let's explore how this affects the expected value!"),
    
    # Sidebar with a slider for sample size and action button to get a new sample.
    fluidRow(
        # Put slider and button in the sidebar
        column(4, 
               sliderInput("num_sims",
                           "Number of Simulations",
                           min = 5,
                           max = 5000,
                           value = 5,
                           step=10,
                           animate=animationOptions(interval = 400,
                                                    loop = TRUE))),
        column(4,sliderInput("loss_ratio","% of the red die face paid in the event of a loss.",
                             min = .1, max = .9, value = .5, step = .05),
               checkboxInput("exp_val","Show Expected Value:")),
        column(3,
               actionButton("reload_plot","Reset Simulation")
        )
    ),
    
    fluidRow(
        column(12,
               plotOutput("line_with_rel_freq",
                          height = "600px")
               )
    )
)