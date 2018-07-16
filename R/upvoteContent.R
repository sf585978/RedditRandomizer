#' Upvote posts and comments
#'
#' @param id The fullname of the post (t3_) or comment (t1_) being upvoted
#' @param dir The vote direction; one of (1, 0, -1)
#' @return The status message from the POST function
#' @export
#' @example
#' upvoteContent("t3_8wk7t8")

upvoteContent <- function(id, dir) {
  require(httr)
  redditURL <- paste("https://oauth.reddit.com/api/vote/?dir=", dir,
                     "&id=", id, "&rank=2", sep = "")
  POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
}
