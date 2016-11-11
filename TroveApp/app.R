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

url_base="http://api.trove.nla.gov.au/result?key="
api_key="u0pi59qa33f2f3e2"
zone="&zone="
query="&q="
type="&encoding=json"
json_file=jsonlite::fromJSON("curtin_kip.json")

# zone_name="newspaper"
# question="john%20curtin%20kip"


# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Retrieve simple searches from Trove and download as csv"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         selectInput("zone_name",
                     "Select the Zone of interest:",
                     choices = c('book', 'picture', 'article', 'music', 'map',
                               'collection', 'newspaper', 'list'),
                     selected = NULL
                      ),
         textInput("api_key",
                   "Please provide your Trove API key"
                    ),
         textAreaInput("question", "Please enter your query"),
         actionButton("go_query","Go"),
         downloadButton('downloadData', 'Download Data (as csv)')
      ),

      # Show a plot of the generated distribution
      mainPanel(
        textOutput("question_out"),
          DT::dataTableOutput("query_out"))
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  url_query <- function(k,z,q){
    q=str_replace_all(q," ","%20")
  paste0(url_base,k,zone,z,query,q,type)
}

  output$question_out <- renderText({
    input$go_query
    isolate({
      # qr=paste("Your query included:\n",input$zone_name,"\n",input$question)
      q=url_query(input$api_key,input$zone_name,input$question)
    })
  })

  query_data <- reactive({
    input$go_query
    isolate({
      q=url_query(input$api_key,input$zone_name,input$question)
      json_file=jsonlite::fromJSON(q)
      dat=as.data.frame(json_file$response$zone$records[[5]])
    })
  })

   output$query_out <-   DT::renderDataTable({
     input$go_query
     isolate({
     # q=url_query(input$api_key,input$zone_name,input$question)
     # json_file=jsonlite::fromJSON(q)
     # dat=as.data.frame(json_file$response$zone$records[[5]])
     if(nrow(query_data())>0){
     DT::datatable(query_dat(), options = list(pageLength = 20, autoWidth = TRUE))
     } else DT::datatable(data = NULL)
   })
   })


   output$downloadData <- downloadHandler(
     filename = function() { paste("Trove_query.csv") },
     content = function(file) {
       write.csv(x = query_data(), file = file, quote = F, row.names = F)
     }
   )

}

# Run the application
shinyApp(ui = ui, server = server)

