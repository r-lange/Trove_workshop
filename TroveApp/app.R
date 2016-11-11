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

url_base="http://api.trove.nla.gov.au/result?key="
# api_key="u0pi59qa33f2f3e2"
zone="&zone="
query="&q="
type="&encoding=json"

# zone_name="newspaper"
# question="john%20curtin%20kip"

url_query=paste0(url_base,api_key,zone,zone_name,query,question,type)
url_query2=paste0(url_base,api_key,zone,zone_name,query,question)



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
         actionButton("go_query","Go")
      ),

      # Show a plot of the generated distribution
      mainPanel(
         tableOutput("query_out")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$query_out <- renderTable({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application
shinyApp(ui = ui, server = server)

