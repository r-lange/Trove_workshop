#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# This app lets you set up queries and download data from trove
# basic query
# http://api.trove.nla.gov.au/result?key=<INSERT KEY>&zone=<ZONE NAME>&q=<YOUR SEARCH TERMS>

library(jsonlite)
library(XML)
library(plyr)
library(dplyr)
library(shiny)
library(DT)
library(stringr)
options(stringsAsFactors=FALSE)
url_base="http://api.trove.nla.gov.au/result?key="

zone="&zone="
query="&q="
type="&encoding=json"


# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Retrieve simple searches from Trove and download as csv"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel( width = 3,
         selectInput("zone_name",
                     "Select the Zone of interest:",
                     choices = c('book', 'picture', 'article', 'music', 'map',
                               'collection', 'newspaper', 'list'),
                     selected = NULL
                      ),
         selectInput("recl",
                     "Level of information",
                     choices = c('brief', 'full'),
                     selected = 'brief'
         ),
 #        sliderInput(inputId = "year", label = "selcet the years of interest", min = 1800, max = 2016, value = c(1890,1950)),
         textInput("api_key",
                   "Please provide your Trove API key",
                   value=NULL
                    ),
         textAreaInput("question", "Please enter your query", value = "John Curtin Kip"),
         actionButton("go_query","Go"),
         downloadButton('downloadData', 'Download Data (as csv)')
      ),

      mainPanel(
        textOutput("question_out"),
          DT::dataTableOutput("query_out"))
   )
)

server <- function(input, output) {

  url_query <- function(k,z,q){
    q=str_replace_all(q," ","%20")
    paste0(url_base,k,zone,z,query,q,type,"&n=100")
  }

  query_data <- reactive({
    # validate(
    #   need(input$api_key, "Please provide an API key")
    # )
    q=url_query(input$api_key,input$zone_name,input$question)
    json_file=jsonlite::fromJSON(q, flatten = T)

    tmp=json_file$response$zone[[length(json_file$response$zone)]]
    dat=as.data.frame(tmp)
    # n=json_file$response$zone$records.next
    # while(!is.null(n)){
    #   json_file=jsonlite::fromJSON(paste0("http://api.trove.nla.gov.au",n,"&key=",input$api_key), flatten = T)
    #   n=json_file$response$zone$records.next
    #   tmp=json_file$response$zone[[6]]
    #   dat=rbind(dat,tmp)
    # }
  })


  output$question_out <- renderText({
    input$go_query
    isolate({
       q=url_query(input$api_key,input$zone_name,input$question)
    })
  })

   output$query_out <- DT::renderDataTable({
     input$go_query
     isolate({
     if(nrow(query_data())>0 & !is.null(query_data())){
       my.data=query_data()
       my.data$troveUrl <- paste0("<a href='",my.data$troveUrl,"' target='_blank'>",my.data$troveUrl,"</a>")
     DT::datatable(my.data, options = list(pageLength = 20, autoWidth = TRUE), escape = F)
     } else DT::datatable(data = NULL)
   })
   })

   output$downloadData <- downloadHandler(

     # This function returns a string which tells the client
     # browser what name to use when saving the file.
     filename = function() {
       paste("Trove_query.csv", sep = ".")
     },

     # This function should write data to a file given to it by
     # the argument 'file'.
     content = function(file) {
       my.df <- data.frame(lapply(query_data(), as.character), stringsAsFactors=FALSE)
         write.csv(my.df, file, row.names = FALSE)
     }
   )

}

# Run the application
shinyApp(ui = ui, server = server)

