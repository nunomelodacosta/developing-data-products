# developing-data-products
This shiny app predicts the miles per gallon consumptions based on mtcars dataset.  

Its design is based on a sidebarLayout for input and a mainPanel for output. The 
mainPanel is built based on a tabsetPanel with 5 tabPanel **Prediction**, **Residuals**, **Pairs**,
**Google charts** and **Data**.  

The *sidebarPanel* serves has the input panel for the predictors values of our 
selected model. The output under **Prediction** *tabPanelwill* is reactive to 
input changes. **Residual** plots static residual graphs, **Pairs** plots static 
 pair wise comparison between the selected model predictors, **Google charts**
plots a dynamic graph based on *googleVis* library. Use can zoom in and zoom out. "Data" has the mtcars dynamic table created with *DT* library.  

Note: Plots may take a couple of seconds to render, so be patient and enjoy.

