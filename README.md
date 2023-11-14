# BC Liquor Catalogue: an exercise in app development with R shiny

## About
This git repo contains the source code for the webpage hosted at [https://tdeckers.shinyapps.io/BC-Liquor-shiny-app-upgrade/](https://tdeckers.shinyapps.io/BC-Liquor-shiny-app-upgrade/)


It was created for STAT 545 2023W1 at the University of British Columbia to learn how to create a shiny app.

This was option A - expanding the BC Liquor app.

## Features

In addition to the features from the base BC Liquor app, this implementaion has added:

1. A download button, to download a filtered version of the data table
2. A tab view, to allow pagination between the histogram of alcohol contents and the filtered table of offerings
3. An interactive table using the DT package, allowing for searching and filtering.


## Acknowledgements
This project was created by modifying [a tutorial from Dean Attali](https://deanattali.com/blog/building-shiny-apps-tutorial/).


The data is provided by [OpenDataBC](https://catalogue.data.gov.bc.ca/dataset/bc-liquor-store-product-price-list-historical-prices), as pre-filtered by Dean Attali.
