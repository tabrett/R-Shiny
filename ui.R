#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Rshiny-twitter-demo"), #title
  sidebarPanel(
      textInput('term', 'Enter a term', ''),
      numericInput('cant', 'Select a number of tweets', 1, 0, 200),
      radioButtons('lang', 'Select the language',c(
        'English' = 'en',
        'Castellano' = 'es',
        'Deutsch' = 'de')),
      submitButton(text='Run')
      ),
    

  mainPanel(
      h4('Last 5 Tweets'),
      tableOutput('tablel'),
      plotOutput('wordcl')
    )
  )
)


