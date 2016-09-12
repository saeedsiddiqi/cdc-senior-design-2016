#EXAMPLE
source("init/init_libraries.R")

shinyUI(fluidPage(
  headerPanel("Network Modeling"), # end headerPanel
  sidebarLayout(
    
    sidebarPanel(
      h2("Input parameters below."),
      
      numericInput("networkSize", label=h5("Size of Network:"), value=196),
      
      sliderInput("percentMales", label=h5("% of Males:"), min=0, max=1, value=0.577),
      
      sliderInput("percentWhite", label=h5("% that were of the white race"), min=0, max=1, value=0.985),
      
      sliderInput("percentIncome10k", label=h5("% Income below USD$10K:"), min=0, max=1, value=0.919),
      
      sliderInput("percentIncarcerated", label=h5("% of people incarcerated"), min=0, max=1, value=0.542),
      
      numericInput("avgDegree", label=h5("Average Degree Size:"), value=0.5),
      
      numericInput("avgEdgeDuration", label=h5("Average Edge Duration:"), value=90),
      
      numericInput("nsims", label=h5("Number of simulations:"), value=10),
      
      sliderInput("i.num", label=h5("Initial No. of Infecteds:"), min=1, max=100000, value=11),
      
      sliderInput("inf.prob", label=h5("Probability of Transmission:"), min=0, max=1, value=0.1),
      
      sliderInput("act.rate", label=h5("Acts per unit time:"), min=0, max=50, value=5),
      
      sliderInput("inter.eff", label=h5("Intervention efficacy:"), min=0, max=1, value=0),
      
      sliderInput("inter.start", label=h5("Intervention Start Time:"), min=0, max=200, value=0),
      
      sliderInput("nsteps", label=h5("Number of timesteps:"), min=1, max=200, value=100),
      
      actionButton("replot",icon = icon("bar-chart", "fa-3x"), label=h3("PLOT RESULTS"))
      
      
    ), # end sidebarPanel
    
    
    mainPanel(
      h3(textOutput("text here")),
      plotOutput("result", height="auto")
      
    )# end mainPanel
  )# end sidebarLayout
  
  
  
  
  
  
)# end fluidPage
)# end shinyUI