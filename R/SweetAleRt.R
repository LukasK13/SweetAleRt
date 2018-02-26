includeSweetAlert <- function ()
{
  addResourcePath('SweetAlert', system.file('inst/www', package='SweetAleRt'))
  htmltools::singleton(htmltools::tags$head(htmltools::tags$script(src="SweetAlert/sweetalert.min.js")),
                       htmltools::tags$head(htmltools::tags$script(src="SweetAlert/sweetalert_handler.js")))
}

sweetAlert <- function(text, title = NULL, icon = NULL, button = NULL, buttons = NULL, content = NULL,
           closeOnClickOutside = T, closeOnEsc = T, dangerMode = F, timer = NULL) {
  message = createSweetAlert(text, title, icon, button, buttons, content, closeOnClickOutside, closeOnEsc, dangerMode, timer)
  session$sendCustomMessage("showConfirmDialog", message)
}

createSweetAlert <- function(text, title = NULL, icon = NULL, button = NULL, buttons = NULL, content = NULL,
                             closeOnClickOutside = T, closeOnEsc = T, dangerMode = F, timer = NULL) {
  alert = list(text = text, title = title, icon = icon, button = button, buttons = buttons,
               content = content, closeOnClickOutside = closeOnClickOutside, closeOnEsc = closeOnEsc,
               dangerMode = dangerMode, timer = timer)
  alert[sapply(alert, is.null)] = NULL
  return(paste0("swal(", gsub("\"", "'", jsonlite::toJSON(alert, auto_unbox = T, null = "null")), ")"))
}

confirmDialog <- function(id, questionTitle = NULL, questionText = NULL, questionIcon = NULL, dangerMode = F,
                          acceptTitle = NULL, acceptText = NULL, acceptIcon = NULL, acceptTimer = NULL,
                          declineTitle = NULL, declineText = NULL, declineIcon = NULL, declineTimer = NULL,
                          session = getDefaultReactiveDomain()) {
  message = createSweetAlert(questionText, questionTitle, questionIcon, dangerMode = dangerMode, buttons = T)
  message = paste0(message, ".then((accepted) => {if (accepted) {Shiny.onInputChange('", id, "', Math.random());")
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
