library(shiny)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100,
                             value = c(25, 40), pre = "$"),
                 radioButtons("typeInput", "Product type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE"),
                 uiOutput("countryOutput"),

                 # Function 1: Download Button
                 # This will let users save the results of their specific filters
                 # and access them offline
                 downloadButton("downloadData", "Download")),
    mainPanel(plotOutput("coolplot"),
              br(),br(),
              tableOutput("results")),

  )
  )
server <- function(input, output) {
  filtered <- reactive({

    if (is.null(input$countryInput)) {
      return(NULL)
    }

    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
  })


  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }


    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(bins = 30)
})

output$results <- renderTable({
  filtered()
})

output$countryOutput <- renderUI({
  selectInput("countryInput", "Country",
              sort(unique(bcl$Country)),
              selected = "CANADA")
})


#Server code for function 1
output$downloadData <- downloadHandler(
  filename = "BCLiquor_search_results.csv",
  content = function(file) {
    write.csv(filtered(), file)
  }
)







}
shinyApp(ui = ui, server = server)

