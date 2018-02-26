library(shiny)
library(SweetAleRt)

ui = fluidPage(includeSweetAlert(),
               titlePanel("SweetAleRt"),
               actionButton("showAlert", "Show Alert"))

server = function(input, output) {
  observeEvent(input$showAlert, {
    sweetAlert(text = "Hello World!")
  })
}

shinyApp(ui = ui, server = server)