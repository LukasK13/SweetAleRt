library(shiny)
library(SweetAleRt)

ui = fluidPage(includeSweetAlert(),
               titlePanel("SweetAleRt"),
               actionButton("showAlert", "Show Alert"))

server = function(input, output) {
  observeEvent(input$showAlert, {
    confirmDialog("confirm", "Question", "Do you want to continue?", "warning",
                  acceptText = "continuing...", acceptIcon = "success", acceptTimer = 1000)
  })
}

shinyApp(ui = ui, server = server)