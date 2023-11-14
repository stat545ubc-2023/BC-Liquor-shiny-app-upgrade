library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(titlePanel("BC Liquor Store Prices"),
                sidebarLayout(

                  ## Sidebar ##
                  sidebarPanel(

                    sliderInput(
                      "priceInput",
                      "Price",
                      min = 0,
                      max = 100,
                      value = c(25, 40),
                      pre = "$"
                    ),

                    radioButtons(
                      "typeInput",
                      "Product type",
                      choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                      selected = "WINE"
                    ),

                    uiOutput("countryOutput"),


                    # Feature 1: Download Button.
                    # This will let users save the results of their specific filters
                    # and access them offline
                    strong("Download table"),
                    downloadButton("downloadData", "Download")
                  ),

                  ## Main Panel ##
                  mainPanel(

                    # Feature 2: Separate main display into tabs.
                    # This allows easy toggling between the plot and data table,
                    # without the need for scrolling.
                    tabsetPanel(
                      tabPanel("Alcohol Percent Plot", plotOutput("alcoholPctPlot")),

                      # Feature 3: Interactive table with DT.
                      # Easily allows users to sort results, search for entries,
                      # and page through results, creating a much more flexible
                      # viewing experience
                      tabPanel("Matched Results", DT::dataTableOutput("results"))
                    ),)

                ))


server <- function(input, output) {

  ## Setup ##

  # Create data table
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }


    bcl %>%
      filter(
        Price >= input$priceInput[1],
        Price <= input$priceInput[2],
        Type == input$typeInput,
        Country == input$countryInput
      )
  })

  ## Main Panel ##

  # Plot
  output$alcoholPctPlot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }

    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(bins = 30) +
      labs(x = "Alcohol content", y = "Count") +
      theme_minimal()
  })

  # Table
  # Server code for feature 3
  # Add custom column names, to remove the underscore from "Alcohol Content"
  output$results <- DT::renderDataTable({
    filtered()
  }, colnames = c(
    "Type",
    "Subtype",
    "Country",
    "Name",
    "Alcohol Content",
    "Price",
    "Sweetness"
  ))

  ## Sidebar ##

  # Country selector
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })

  # Download button
  # Server code for feature 1
  output$downloadData <- downloadHandler(
    filename = "BCLiquor_search_results.csv",
    content = function(file) {
      write.csv(filtered(), file)
    }
  )

}
shinyApp(ui = ui, server = server)
