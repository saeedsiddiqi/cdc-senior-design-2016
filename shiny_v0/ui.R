
shinyUI(fluidPage(
        headerPanel("Deterministic SIR Model"),
        sidebarLayout(
                sidebarPanel(
                        h2("Initialization"),
                        numericInput("s.num", label=h4("Initial Population Size:"), value=1000),
                        numericInput("i.num", label=h4("Initial No. of Infecteds:"), value=1),
                        numericInput("r.num", label=h4("Initial No. of Recovered persons:"), value=0),
                        h2("Parameters"),
                        p("Adjust the following parameters according to you desired output."),
                        sliderInput("inf.prob", label=h4("Probability of Transmission:"),
                                    min=0, max=1, value=0.5),
                        numericInput("act.rate", label=h4("Acts per unit time:"),value=0.25),
                        numericInput("rec.rate", label=h4("Recoveries per unit time:"), value=0.10),
                        numericInput("nsteps", label=h4("Number of timesteps:"), value=10),
                        actionButton("replot", label=h4("Update"))
                ),
                mainPanel(
                        h3("DCM-SIR Results"),
                        plotlyOutput("result",height="auto", width="100%")
                )
        )
))

