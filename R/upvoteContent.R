#' Upvote posts and comments
#'
#' @param id The fullname of the post (t3_) or comment (t1_) being upvoted
#' @param dir The vote direction; one of (1, 0, -1); defaults to upvote (1)
#' @return The status message from the POST function
#' @export
#' @example
#' upvoteContent("t3_8wk7t8")

upvoteContent <- function(id, dir = 1) {
  require(httr)
  if (dir == 1) {
    for (i in 1:length(id)) {
      redditURL <- paste("https://oauth.reddit.com/api/vote/?dir=", dir,
                         "&id=", id[i], "&rank=2", sep = "")
      obj <- POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
      if (obj$status_code == 200) {
        cat(paste("Upvoted: ", id[i], sep = ""), sep = "\n")
      } else {
        warning(paste("There may have been a problem with upvoting ",
                      id[i],
                      ".",
                      sep = ""))
      }
    }
  } else if(dir == 0) {
    for (i in 1:length(id)) {
      redditURL <- paste("https://oauth.reddit.com/api/vote/?dir=", dir,
                         "&id=", id[i], "&rank=2", sep = "")
      obj <- POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
      if (obj$status_code == 200) {
        cat(paste("Vote Removed: ", id[i], sep = ""), sep = "\n")
      } else {
        warning(paste("There may have been a problem with removing the vote for ",
                      id[i],
                      ".",
                      sep = ""))
      }
    }
  } else if(dir == -1) {
    for (i in 1:length(id)) {
      redditURL <- paste("https://oauth.reddit.com/api/vote/?dir=", dir,
                         "&id=", id[i], "&rank=2", sep = "")
      obj <- POST(redditURL, config(token = token), user_agent("MY_USER_AGENT"))
      if (obj$status_code == 200) {
        cat(paste("Downvoted: ", id[i], sep = ""), sep = "\n")
      } else {
        warning(paste("There may have been a problem with downvoting ",
                      id[i],
                      ".",
                      sep = ""))
      }
    }
  }
}
