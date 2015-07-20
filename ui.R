library(shiny)

shinyUI(pageWithSidebar(
        headerPanel("MPG Prediction"),
        
        sidebarPanel(
                h4("Please select following features"),
                selectInput("cyl","Number of Cylinders",choices=c(4,6,8)),
                br(),
                sliderInput("hp","Gross horsepower",
                            min=50,max=335,value=145),
                br(),
                sliderInput("wt","Weight (lb/1000)",
                            min=1.5,max=5.5,step=0.1,value=3),
                br(),
                radioButtons("am","Transmission Type",
                             list("Automatic"= "Automatic", "Manual"="Manual")),
                submitButton("Submit")
        ),
        
        mainPanel(
                tabsetPanel(
                  tabPanel("Prediction",
                           br(),
                           tableOutput("values"),
                           br(),
                           h3("The estimated mpg is"),
                           h4(textOutput("hat",inline=F))),
                  
                  tabPanel("Alternate",
                           br(),
                           p("You selected a car with the following features"),
                           strong(textOutput("cyl",inline=F)),
                           strong(textOutput("hp",inline=F)),
                           strong(textOutput("wt",inline=F)), div("and"),
                           strong(textOutput("am",inline=F)),
                           br(),
                           p("The mpg of a car will be affected by the number of cylinders the engine has, even if the other features were the same."),
                           tableOutput("cylalt"),
                           br(),
                           p("The mpg will be affected by the transmission type, even if the other features were the same."),
                           tableOutput("amalt")
                           
                           ),
                  
                  tabPanel("Documentation",
                           br(),
                           p("A car's mpg is determined by complex interactions among many parameters. The database mtcars in R provides fuel consumption and 10 aspects of automobile design and performance for 32 automobiles. This application developed a linear regression model to predict the mpg of a car using the mtcars data base. The relevant variables are selected stepwise, using the Akaike Information Criterion (AIC) index. The linear regression model is summarized below. "),
                           br(),
                           verbatimTextOutput("summary"),
                           br(),
                           p("Aside from giving predictions based on the input values for each features, this application also provides alternative mpg estimates given different numbers of cylinders and transmission types.")
                        )
        )
)))