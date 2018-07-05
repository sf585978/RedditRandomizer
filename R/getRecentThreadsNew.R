#' Get New Reddit Threads
#'
#' @param subreddit The name of a subreddit as it appears in its url
#' @return A vector of urls beginning with /r/ for the latest posts for the given subreddit
#' @export
#' @example
#' getRecentThreads("politics")
getRecentThreadsNew <- function(subreddit) {
  require(httr)
  require(RJSONIO)
  cat(paste("Now getting information for: ", subreddit, sep = ""), sep = "\n")
  subredditURL <- "https://oauth.reddit.com/r/"
  urlTail <- "/new.json?limit=1000"
  data <- GET(paste(subredditURL, subreddit, urlTail, sep = ""),
              user_agent("MY_USER_AGENT"),
              config(token = token))
  data <- fromJSON(content(data, "text"))
  links <- character(length(data$data$children))
  for (i in 1:length(data$data$children)) {
    links[i] <- data$data$children[[i]]$data$permalink
  }
  return(links)
}
