library(shiny)
library(lubridate)

# Define UI for application
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Baby Infant Growth Chart Calculator", windowTitle ="Baby Infant Growth Chart Calculator"),
        
        helpText( h5("Description:"),
                  
                  h6("This calculator provides your baby's length percentile based on age and gender.
                        It uses the data table from WHO growth charts for babies and infants from birth to two years of age."),
                  a("http://www.cdc.gov/growthcharts/who_charts.htm"),

                  h5("Input:"),        
                  h6("- Enter Birthday"),
                  h6("- Enter Lenght in cm."),
                  
                  h5("Output:"),
                  
                  h6("- Percentile: The length percentile of the child."),
                  h6("- Age: The age of the child in months."),
                  h6("- Graph Plot: Length versus Age graph and calculated percentile lines.")),
      
        fluidRow(
                
                column(3,radioButtons("gender", label = h4("Gender"),
                                      choices = list("Male" = "M", "Female" = "F"),selected = "M")),
                
                column(3,dateInput("dateBirth", 
                                   label = h4("Birthday"), 
                                   value = Sys.Date() - years(1),
                                   min = Sys.Date() - years(2),
                                   max = Sys.Date(),
                                   format="dd-M-yyyy") ),
                
                column(3,numericInput("length", 
                                      label = h4("Length"), 
                                      min= 35,
                                      max=100,
                                      step=0.1,
                                      value = 75.5))
        ),

        fluidRow(
                column(1,h5("Age:",align = "left")),
                column(2,h5(textOutput("age")))
        ),
        fluidRow(
                column(1,h5("Percentile:",align = "left")),
                column(4,h5(textOutput("percentile")))
        ),
        
        plotOutput("distPlot")
        
))
