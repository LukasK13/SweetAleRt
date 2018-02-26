#' Include the sweetalert library for later usage.
#'
#' This function needs to be called during the creation
#' of the UI of a shiny web application. It takes care of
#' including the needed libraries for showing sweet alerts.
#'
#' @return HTML-Tags
#' @seealso \link{https://sweetalert.js.org/docs/}
#' @examples shinyApp(
#' ui = SweetAleRt::includeSweetAlert(),
#' server = function(session, input, output){
#'    SweetAleRt::sweetAlert("Hello World!")
#' })
#' @export
includeSweetAlert <- function ()
{
  addResourcePath('SweetAlert', system.file("www", package="SweetAleRt"))
  htmltools::singleton(htmltools::tags$head(htmltools::tags$script(src="SweetAlert/sweetalert.min.js"),
                                            htmltools::tags$script(src="SweetAlert/sweetalert_handler.js")))
}

#' Show a sweetalert on the clients screen.
#'
#' This function creates and displays a sweetalert on the clients screen.
#' All arguments are inspired by \link{https://sweetalert.js.org/docs/}
#'
#' @param text Text to display in the alert
#' @param title Title of the alert
#' @param icon Icon of the alert. Available are warning, error,
#' success, info
#' @param button Standart button of the alert
#' @param buttons Custom buttons of the alert
#' @param content Custom inputs in the alert
#' @param closeOnClickOutside Boolean, close the alert on a click outside
#' of the alert
#' @param closeOnEsc Boolean, close the alert by pressing the escape key
#' @param dangerMode Enable danger mode. The danger mode sets the focus
#' to the cancel button instead of accept.
#' @param timer Timeout to automatically close the alert
#' @param session Shiny session object
#' @return HTML-Tags
#' @seealso \link{https://sweetalert.js.org/docs/}
#' @examples shinyApp(
#' ui = SweetAleRt::includeSweetAlert(),
#' server = function(session, input, output){
#'    SweetAleRt::sweetAlert("Hello World!")
#' })
#' @export
sweetAlert <- function(text, title = NULL, icon = NULL, button = NULL, buttons = NULL, content = NULL,
           closeOnClickOutside = T, closeOnEsc = T, dangerMode = F, timer = NULL, session = getDefaultReactiveDomain()) {
  message = createSweetAlert(text, title, icon, button, buttons, content, closeOnClickOutside, closeOnEsc, dangerMode, timer)
  session$sendCustomMessage("showConfirmDialog", message)
}

#' Show a confirmation dialog based on sweetalert on the clients screen.
#'
#' This function creates and displays a confirmation dialog based on
#' sweetalert on the clients screen.
#' All arguments are inspired by \link{https://sweetalert.js.org/docs/}
#'
#' @param inputId ID of the input under which the acceptance will be available
#' @param questionTitle Title of the confirmation dialog
#' @param questionText Text to display in the confirmation dialog
#' @param questionIcon Icon of the confirmation dialog. Available are
#' warning, error, success, info
#' @param dangerMode Enable danger mode. The danger mode sets the focus
#' to the cancel button instead of accept.
#' @param acceptTitle Title of the accept alert
#' @param acceptText Text to display in the accept alert
#' @param acceptIcon Icon of the accept alert. Available are
#' warning, error, success, info
#' @param acceptTimer Timout for the accept alert to disappear
#' @param declineTitle Title of the decline alert
#' @param declineText Text to display in the decline alert
#' @param declineIcon Icon of the decline alert. Available are
#' warning, error, success, info
#' @param declineTimer Timout for the decline alert to disappear
#' @param session Shiny session object
#' @return HTML-Tags
#' @seealso \link{https://sweetalert.js.org/docs/}
#' @examples shinyApp(
#' ui = SweetAleRt::includeSweetAlert(),
#' server = function(session, input, output){
#'    SweetAleRt::confirmDialog("confirm", "Question", "Do you want to continue?", "warning",
#'    acceptText = "continuing...", acceptIcon = "success", acceptTimer = 1000)
#' })
#' @export
confirmDialog <- function(inputId, questionTitle = NULL, questionText = NULL, questionIcon = NULL, dangerMode = F,
                          acceptTitle = NULL, acceptText = NULL, acceptIcon = NULL, acceptTimer = NULL,
                          declineTitle = NULL, declineText = NULL, declineIcon = NULL, declineTimer = NULL,
                          session = getDefaultReactiveDomain()) {
  message = createSweetAlert(questionText, questionTitle, questionIcon, dangerMode = dangerMode, buttons = T)
  message = paste0(message, ".then((accepted) => {if (accepted) {Shiny.onInputChange('", inputId, "', Math.random());")
  if (!(is.null(acceptTitle) && is.null(acceptText) && is.null(acceptIcon)))
    message = paste0(message, createSweetAlert(acceptText, acceptTitle, acceptIcon, timer = acceptTimer))
  message = paste0(message, "} else {")
  if (!(is.null(declineTitle) && is.null(declineText) && is.null(declineIcon)))
    message = paste0(message, createSweetAlert(declineText, declineTitle, declineIcon, timer = declineTimer))
  else
    message = paste0(message, "swal.close();")
  message = paste0(message, "}});")
  accept = list()
  session$sendCustomMessage("showConfirmDialog", message)
}

#' Create a sweetalert message
#'
#' This function creates a sweetalert message
#' All arguments are inspired by \link{https://sweetalert.js.org/docs/}
#'
#' @param text Text to display in the alert
#' @param title Title of the alert
#' @param icon Icon of the alert. Available are warning, error,
#' success, info
#' @param button Standart button of the alert
#' @param buttons Custom buttons of the alert
#' @param content Custom inputs in the alert
#' @param closeOnClickOutside Boolean, close the alert on a click outside
#' of the alert
#' @param closeOnEsc Boolean, close the alert by pressing the escape key
#' @param dangerMode Enable danger mode. The danger mode sets the focus
#' to the cancel button instead of accept.
#' @param timer Timeout to automatically close the alert
#' @return Javascript code to create the alert.
#' @seealso \link{https://sweetalert.js.org/docs/}
createSweetAlert <- function(text, title = NULL, icon = NULL, button = NULL, buttons = NULL, content = NULL,
                             closeOnClickOutside = T, closeOnEsc = T, dangerMode = F, timer = NULL) {
  alert = list(text = text, title = title, icon = icon, button = button, buttons = buttons,
               content = content, closeOnClickOutside = closeOnClickOutside, closeOnEsc = closeOnEsc,
               dangerMode = dangerMode, timer = timer)
  alert[sapply(alert, is.null)] = NULL
  return(paste0("swal(", gsub("\"", "'", jsonlite::toJSON(alert, auto_unbox = T, null = "null")), ")"))
}
