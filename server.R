library(shiny)
library(ggplot2)
library(dplyr)
library(reshape)

#WHO_Length_Chart <- read.csv("data/WHO_Length_Chart.csv")
WHO_Length_Chart <-readRDS("data/WHO_Lenght_Chart.rds")

# Define server logic
shinyServer(function(input, output) {
        
        months<-reactive({as.numeric(round((Sys.Date()-input$dateBirth)/30.4166666667 , 1))})
        value<-reactive({input$length })
        test<-reactive({
                Month<-as.numeric(round((Sys.Date()-input$dateBirth)/30.4166666667 , 1))
                value<-input$length
                data.frame(Month,value)})
        
        
        WHO_GENDER_data <- reactive({melt(WHO_Length_Chart %>% 
                                                  filter(gender==input$gender)%>% 
                                                  select(Month,starts_with("Q")), id="Month")%>% 
                                             mutate(Percentile=as.integer(substring(variable, 2))) %>% 
                                             select(Month,Percentile,value)
        })
        
        
        percentile<-reactive({ 
                data <- WHO_GENDER_data()
                c1<-ceiling(months())
                c2<-floor(months())
                
                trainning <- data%>%
                        filter(Month == c1  | Month == c2)
                
                fit<-lm(Percentile ~ . ,  data=trainning)
                
                out<-round(predict.lm(fit,test()),1)
                
                if (out < 0) out<-0
                out
        })
        #         
        output$age <- renderText({ paste(months(), "months", sep=" ")})
        #         
        output$percentile <- renderText({ 
                if(test()$Month <=24 & test()$Month >= 0){
                        paste0(percentile(), "%")
                }
                else{
                        "Invalid Age: Requires age of 0-24 months"} })
        
        output$distPlot <- renderPlot({  qplot(main="Lenght for age percentiles",
                                               x = Month, 
                                               y = value, geom="line",
                                               colour=as.factor(Percentile),
                                               ylab="Lenght (cm)",
                                               xlab="Age (Months)",
                                               data = WHO_GENDER_data())+
                                                 geom_point(data=test(), colour="red", size= 4)
        })        
})
