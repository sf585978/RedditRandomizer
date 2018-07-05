#' Get usernames of top-level Reddit commenters
#'
#' @param thread The unique portion of a reddit url beginning with /r/ for which you would like to identify the top-level commenters
#' @return A vector of Reddit usernames belonging to the top-level commenters for the given thread
#' @export
#' @example
#' getCommenters("/r/politics/comments/8w1me0/record_number_of_native_americans_running_for/")
getCommenters <- function(thread) {
  require(httr)
  require(RJSONIO)
  redditURL <- "https://oauth.reddit.com"
  urlTail <- "comments.json?limit=1000"
  data <- GET(paste(redditURL, thread, urlTail, sep = ""),
              user_agent("MY_USER_AGENT"),
              config(token = token))
  data <- RJSONIO::fromJSON(content(data, "text"))
  if (length(data[[2]]$data$children) > 1) {
    comms <- character((length(data[[2]]$data$children) - 1))
    for (i in 1:length(comms)) {
      comms[i] <- data[[2]]$data$children[[i]]$data$author
    }
  } else if (length(data[[2]]$data$children) == 1) {
    comms <- character(1)
    for (i in 1:length(comms)) {
      comms[i] <- data[[2]]$data$children[[i]]$data$author
    }
  } else {
    comms <- c()
  }
  return(comms)
}
