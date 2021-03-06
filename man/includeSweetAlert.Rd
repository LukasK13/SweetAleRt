% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SweetAleRt.R
\name{includeSweetAlert}
\alias{includeSweetAlert}
\title{Include the sweetalert library for later usage.}
\usage{
includeSweetAlert()
}
\value{
HTML-Tags
}
\description{
This function needs to be called during the creation
of the UI of a shiny web application. It takes care of
including the needed libraries for showing sweet alerts.
}
\examples{
shinyApp(
ui = SweetAleRt::includeSweetAlert(),
server = function(session, input, output){
   SweetAleRt::sweetAlert("Hello World!")
})
}
\seealso{
\link{https://sweetalert.js.org/docs/}
}
