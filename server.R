library(shiny)
data(mtcars)

mtcars$cyl<-as.factor(mtcars$cyl)
mtcars$vs<-as.factor(mtcars$vs)
mtcars$am<-as.factor(mtcars$am)
mtcars$gear<-as.factor(mtcars$gear)
mtcars$carb<-as.factor(mtcars$carb)
#regression model
fitall<-lm(mpg~ ., mtcars)
fitgood<-step(fitall,direction="backward",trace=0)

#shiny part

shinyServer(function(input,output){
        
#Prediction Tab
        data<-reactive({
                
                data.frame(Features=c("Number of cylinders","Gross horsepower",
                                      "Weight (lb/1000)","Transmission Type"),
                           Values=c(input$cyl,input$hp,input$wt,input$am))
        })
        output$values<-renderTable(data())
        
        datahat<-reactive({
                amhat<-switch(input$am,
                              Automatic=factor(0),
                              Manual=factor(1))
                data.frame(cyl=input$cyl,hp=input$hp,wt=input$wt,am=amhat)
        })
        output$hat<-renderText(
                predict(fitgood,newdata=datahat())
                )
#Alternate tab

       output$cyl<-renderText(paste(input$cyl,"cylinders"))
       output$hp<-renderText(paste(input$hp,"Gross Horsepower"))
       output$wt<-renderText(paste(input$wt,"thousand lbs"))
       output$am<-renderText(paste(input$am,"Transmission Type"))
       
       datacyl<-reactive({
               amhat<-switch(input$am,
                             Automatic=factor(0),
                             Manual=factor(1))
               cylinder<-factor(c(4,6,8))
               a<-data.frame(cyl=cylinder[!cylinder %in% input$cyl],hp=rep(input$hp,2),wt=rep(input$wt,2),
                          am=rep(amhat,2))
               a$pred<-predict(fitgood,a)
               a<-subset(a,select=c(cyl,pred))
               names(a)<-c("Number of Cylinders","Estemate MPG")
               a
       })

       output$cylalt<-renderTable(datacyl())
       
       dataam<-reactive({
               amhat<-switch(input$am,
                             Automatic=factor(0),
                             Manual=factor(1))
               amtype<-factor(c(0,1))
               data.frame(cyl=input$cyl,hp=input$hp,wt=input$wt,
                             am=amtype[!amtype %in% amhat])
       })
       amsw<-reactive({
               switch(input$am,Automatic="Manual",Manual="Automatic")
       })
       
       amalt<-reactive({
               b<-data.frame(Transmission=amsw(),MPG=predict(fitgood,dataam()))
               colnames(b)<-c("Transmission Type","Estimate MPG")
               b
               })
       output$amalt<-renderTable(
               amalt()
               )

#Documentation tab
      output$summary<-renderPrint(
              summary(fitgood)
              )
        
})