#' Give gold to posts, comments, and accounts
#'
#' @param id The fullname of the post (t3_), comment (t1_), or account (t2_) being rewarded
#' @return The status message from the POST function
#' @export
#' @example
#' gildContent("t3_8wk7t8")

giveGold <- function(id) {
  require(httr)
  redditURL <- paste("https://oauth.reddit.com/api/v1/gold/gild/", id, sep = "")
  POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
}
