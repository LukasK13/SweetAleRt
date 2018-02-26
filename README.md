# SweetAleRt
Create alerts within a shiny webapp using the SweetAlert library.

Install by `devtool::install_github("LukasK13/SweetAleRt")`

Basic example:
```
library(shiny)
library(SweetAleRt)

ui = fluidPage(includeSweetAlert(),
               titlePanel("SweetAleRt"),
               actionButton("showAlert", "ShowAlert"))

server = function(input, output) {
  observeEvent(input$showAlert, {
    sweetAlert(text = "Hello World!")
  })
}

shinyApp(ui = ui, server = server)
