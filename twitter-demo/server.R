#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(wordcloud)
library(twitteR)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  api_key <- "8LKIOy7rPRMJmGCfTi8KJJG8f"
  api_secret <- "NJ71om3p3JRosCGKiP2UcB9vm9bnVN1FmpC6U3JiYlDfvdHfko"
  #access_token <- "791056543517147136-R7FHjj9v7lrmZ1W8RXIm8R5UphhftfH"
  #access_token_secret <- "vc2dloCQ8sqMSYJIgsK89BNvAo05FCjAx59ogvhyrG4CQ"
  
  setup_twitter_oauth(api_key,api_secret)#,access_token = NULL,access_token_secret = NULL)
  token <- get("oauth_token", twitteR:::oauth_cache)                                  #save cred info
  token$cache()
  output$currentTime <- renderText({ invalidateLater(1000,session)
                                      paste("Current time is: ", Sys.time())
                                  })
  
  rawData <- reactive(
    { tweets <- searchTwitter(input$term, n=input$cant, lang=input$lang)
      return(twListToDF(tweets))
  })
  
  output$tablel <- renderTable( {
    head(rawData()[1],n=5)
  })
  
  output$wordcl <- renderPlot( 
    {
      tw.text <- rawData()$text
      tw.text <- enc2native(rawData()$text)
      tw.text <- tolower(tw.text)
      tw.text <- removeWords(tw.text,c(stopwords('en'),'rt'))
      tw.text <- removePunctuation(tw.text,TRUE)
      tw.text <- unlist(strsplit(tw.text,' '))
      word <- sort(table(tw.text),TRUE)
      wordc <- head(word,n=15)
      wordcloud(names(wordc),
                wordc,
                random.color = TRUE,
                colors = rainbow(10),
                scale = c(5,2),
                min.freq = 1)
  })
  
  #observe({
   # invalidateLater(60000,session)
    #
    #count_Positive = 0
    #count_negative = 0
    #count_neutral = 0
#    
#    positive_text <- vector()
#    negative_text <- vector()
#    neutral_text <- vector()
#    vector_users <- vector()
#    vector_sentiments <- vector()
#    
#    tweets_result = ""
#  tweets_result = searchTwitter("PathofFire") #use searchTwitter function to extract tweets
#    
#    if (grepl("I love it", tweet$text, ignore.case = TRUE) == TRUE | grepl("Wonderful", tweet$text, ignore.case = TRUE) |
#                  grepl("Awesome", tweet$text, ignore.case = TRUE)) 
#        {   count_Positive = count_Positive + 1
#            print("Positive")
#            vector_sentiments <- c(vector_sentiments, "Positive")
#            positive_text <- c(positive_text, as.character(tweet$text))
#      } else if (grepl("Boring", tweet$text, ignore.case = TRUE) | grepl("I'm sleeping", tweet$text, ignore.case = TRUE)) 
#        {   count_negative = count_negative + 1
##            print("Negative")
##            vector_sentiments <- c(vector_sentiments, "Negative")
#            negative_text <- C(negative_text, as.character(tweet$text))
#      } else {
#            count_neutral = count_neutral + 1
#            print("Neutral")
#            vector_sentiments <- c(vector_sentiments, "Neutral")
#            neutral_text <- c(neutral_text, as.character(tweet$text))
#      }
#    }

#    df_users_sentiment <- data.frame(vector_users,vector_sentiments)
#    output$tweets_table = renderDatatable({
#      df_users_sentiment
#      })
    
    #output$distPlot <- renderPlot({
    #  results = data.frame(tweets = c("Positive", "Negative", "Neutral"), numbers = c(count_Positive,count_negative,count_neutral))
    #  barplot(results$numbers,names = results$tweets, xlab = "Sentiment", ylab = "Counts", col = c("Green", "Red", "Blue"))
    #  
    #  if (length(positive_text) > 0){
    #    output$positive_wordcloud <- renderPlot({ wordcloud(paste(positive_text, collapse = " "),
    #                                                        min.freq = 0,
    #                                                        random.color = TRUE,
    #                                                        max.words = 100,
    #                                                        colors = brewer.pal(8,"Dark2")) })
    #  }
      
    #  if (length(negative_text) > 0){
    #    output$negative_wordcloud <- renderPlot({ wordcloud(paste(negative_text, collapse = " "),
    #                                                        min.freq = 0,
    #                                                        random.color = TRUE,
    #                                                        max.words = 100,
    #                                                        colors = brewer.pal(8, "Set3")) })
    #  }
    #  
    #  if (length(neutral_text) > 0){
    #    output$neutral_wordcloud <- renderPlot({ wordcloud(paste(neutral_text, collapse = " "),
    #                                                       min.freq = 0,
    #                                                       random.color = TRUE,
    #                                                       max.words = 100,
    #                                                       colors = brewer.pal(8, "Dark2"))})
    #  }
    #})
  #})
})
