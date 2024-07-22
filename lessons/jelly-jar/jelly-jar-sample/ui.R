ui<-fluidPage(
    h1("Sampling From the Jelly Jar!"),br(),br(),
    tabsetPanel(type = "tabs",
                tabPanel("One Sample at a Time",
                         br(),
                         source('tab-ui-files/tab1.R',local=TRUE)$value),
                tabPanel("Several Samples: Creating a Sampling Distribution",
                         br(),
                         source('tab-ui-files/tab2.R',local=TRUE)$value)
    )
)