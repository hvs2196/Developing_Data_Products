#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(curl)

### Define server logic

shinyServer(function(input, output) {
  
  ## load the data
  
  data(diamonds)
   
  ## create the initial output
  
  output$distPlot <- renderPlot({
    
    # subset the date based on the inputs
    
    diamonds_sub <-
      subset(
        diamonds,
          cut == input$cut &
          color == input$color &
          clarity == input$clarity
      )
    
    # draw the diamonds data and its influence regarding carat and price
    
    p <-
      ggplot(data = diamonds_sub, aes(x = carat, y = price)) + geom_point()
    p <-
      p + geom_smooth(method = "lm") + xlab("Carat") + ylab("Price")
    p <- p + xlim(0, 6) + ylim (0, 20000)
    p
  }, height = 700)
  
  # show the price summary
  
  output$summary <- renderPrint({
    diamonds_sub <-
      subset(
        diamonds,
        cut == input$cut &
          color == input$color &
          clarity == input$clarity
      )
    
    summary(diamonds_sub$price)
    })
  
  # create linear model
  
  output$predict <- renderPrint({
    diamonds_sub <-
      subset(
        diamonds,
        cut == input$cut &
          color == input$color &
          clarity == input$clarity
      )
    
    fit <- lm(price~carat,data=diamonds_sub)
    
    unname(predict(fit, data.frame(carat = input$lm)))
  })
  
  # reset the filtering with the button
  
  observeEvent(input$showall, {
    distPlot <<- NULL
    
    output$distPlot <- renderPlot({
      p <-
        ggplot(data = diamonds, aes(x = carat, y = price)) + geom_point()
      p <-
        p + geom_smooth(method = "lm") + xlab("Carat") + ylab("Price")
      p <- p + xlim(0, 6) + ylim (0, 20000)
      p
    }, height = 700)
    
    # show the price summary
    
    output$summary <- renderPrint(summary(diamonds$price))
    
    # create linear model
    
    output$predict <- renderPrint({
      
      fit <- lm(price~carat,data=diamonds)
      
      unname(predict(fit, data.frame(carat = input$lm)))
    })
    
    
  })
  
  # reapply the filter
  
  observeEvent(input$appfil, {
    distPlot <<- NULL
    
    output$distPlot <- renderPlot({
      # subset the date based on the inputs
      
      diamonds_sub <-
        subset(
          diamonds,
          cut == input$cut &
            color == input$color &
            clarity == input$clarity
        )
      
      # draw the diamonds data and its influence regarding carat and price
      p <-
        ggplot(data = diamonds_sub, aes(x = carat, y = price)) + geom_point()
      p <-
        p + geom_smooth(method = "lm") + xlab("Carat") + ylab("Price")
      p <- p + xlim(0, 6) + ylim (0, 20000)
      p
    }, height = 700)
    
    # show the price summary
    
    output$summary <- renderPrint({
      diamonds_sub <-
        subset(
          diamonds,
          cut == input$cut &
            color == input$color &
            clarity == input$clarity
        )
      
      summary(diamonds_sub$price)
    })
    
    # create linear model
    
    output$predict <- renderPrint({
      diamonds_sub <-
        subset(
          diamonds,
          cut == input$cut &
            color == input$color &
            clarity == input$clarity
        )
      
      fit <- lm(price~carat,data=diamonds_sub)
      
      unname(predict(fit, data.frame(carat = input$lm)))
    })
    
  })
  
})