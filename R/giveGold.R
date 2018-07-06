#' Give gold to posts and comments
#'
#' @param id The fullname of the post (t3_) or comment (t1_) being rewarded
#' @return The status message from the POST function
#' @export
#' @example
#' gildContent("t3_8wk7t8")

giveGold <- function(id) {
  require(httr)
  redditURL <- paste("https://oauth.reddit.com/api/v1/gold/gild/", id, sep = "")
  POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
}
