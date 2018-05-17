library(caret)
library(dplyr)
attach(mtcars)
server <-function(input, output) {
  observeEvent(input$var1, {
    print(paste0("You have chosen: ", input$id2))
  })
  output$id1<-renderText(input$var1)
  
  
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$mpgPlot functions
  formulaText <- reactive({
    paste('mpg', "~", input$var1)
  })
  
  Text <- reactive({
    paste('Relation between mpg and', input$var1 , 'by transmission type')
    
  })
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    Text()
  })
  
  output$doc <- renderText({
    "Enter the variables in the dropdown to see the relationship between the variable and mpg.You can also select
     the transmission type or leave it blank. If transmission type is left blank the data will show the relation between mpg and 
     the selected variable regardless of transmission type(automatic or manual).The main panel tabs will show scatterplot,boxplot
     and the data based on the selected variables.Press the submit button each time you change the variables"
    })
  
  output$preddoc <- renderText({
    
    "First We built a multiple linear regression model taking all predictor variables into account.
     In the modelsummary tab you will see the model details. 
     You can see the most important predictors are am,qsec,wt according to the lower p values.
     In the varimp tab we also see the same predictors as more important than others.
     So we built a second model with these 3 predictors only. In the side bar panel users can select these 
     predictors and can see the predicted mpg in the prediction tab.Press the submit button each time you change the variables to see
     the changed predicted mpg"

  })
  
  output$results <- renderTable({
    if(input$trans==0){
      mtcars_output=mtcars[mtcars$am==0,]
      
    } else if (input$trans==1){
      mtcars_output=mtcars[mtcars$am==1,]
      
    }else {mtcars_output=mtcars
    }
  
    mtcars_output
  })
  
  output$scatterplot <- renderPlot({
    if(input$trans==0){
      mtcars1=mtcars[mtcars$am==0,]
    } else if (input$trans==1){
      mtcars1=mtcars[mtcars$am==1,]
    }else {mtcars1=mtcars}
    print(plot(as.formula(formulaText()),data=mtcars1) )
  })
    output$boxplot <- renderPlot({
      if(input$trans==0){
        mtcars1=mtcars[mtcars$am==0,]
      } else if (input$trans==1){
        mtcars1=mtcars[mtcars$am==1,]
      }else {mtcars1=mtcars}
      print(boxplot(as.formula(formulaText()),data=mtcars1,ylab ="mpg", xlab =input$var1) )
    }) 
     
 #Prediction Tab
     
    #  mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg -20 ,0)
    #  model1 <- lm(hp ~ mpg, data = mtcars)
    # model2 <- lm(hp ~ mpgsp + mpg, data = mtcars)
      # model2 =
      model1 <- lm(mpg ~ ., data = mtcars)
      model2 <- lm(mpg ~ am+qsec+wt, data = mtcars)
      model2pred <- reactive({
        
        aminput <- as.numeric(input$id1)
        qsecinput <- input$id2
        wtinput <- input$id3
        predict(model2, newdata = data.frame(am=aminput,qsec=qsecinput,wt=wtinput))
        
      })
     
     
      
      
      
  #    output$pred2 <- renderText({
  #      if(input$model2){
  #        model2pred()
  #      }
   #   })  
      
      output$summary <- renderPrint ({
        
          summary(model1)
        
      })  
      output$varimp <- renderPrint ({ 
        
      varImp(model1, scale = FALSE)
        
      }) 
      
      output$pred2 <- renderText({
        
        model2pred()
        
      })
}

