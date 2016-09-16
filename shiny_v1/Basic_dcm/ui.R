#EXAMPLE
source("init/init_libraries.R")
shinyUI(navbarPage("SIR Analytical Tool V1",
                   tabPanel("DCM SIR", icon = icon("group", "fa-3x"), 
                            sidebarLayout(
                                    sidebarPanel(
                                            h2("Initialization"),
                                            conditionalPanel(
                                                    
                                                    condition = "output.initUpload",

                                                    sliderInput("i.num", label=h5("Initial No. of Infecteds:"), 
                                                                min=1, max=100000, value=50000),
                                                    
                                                    h2("Parameters"),
                                                    p("Adjust the following parameters according to your desired output."),
                                                    
                                                    sliderInput("inf.prob", label=h5("Probability of Transmission:"),
                                                                min=0, max=1, value=0.5),
                                                    
                                                    sliderInput("act.rate", label=h5("Acts per unit time:"),
                                                                min=0, max=1, value=0.5),

                                                    sliderInput("inter.eff", label=h5("Intervention efficacy:"), 
                                                                min=0, max=1, value=0.5),

                                                    sliderInput("inter.start", label=h5("Intervention Start Time:"), 
                                                                min=1, max=200, value=0.5),
                                                    #### End demographic inputs here ####
                                                    sliderInput("nsteps", label=h5("Number of timesteps:"), 
                                                                min=1, max=200, value=100),
                                                    
                                                    actionButton("replot",icon = icon("bar-chart", "fa-3x"), label=h3("PLOT RESULTS"))
                                                    # Dev-ref: http://fontawesome.io/icons/
                                                    
                                            ) #end conditional Panel
                                        ), #end sidebarPanel

                                    mainPanel( "mainPanel"

                                    ) #end mainPanel
                            ) #end sidebarLayout
                        ) #end tablPanel
)) #end shinyUI
