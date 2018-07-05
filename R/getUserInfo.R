#' Gather Reddit user info
#' 
#' @param user A Reddit username given as a string
#' @return A data frame containing the user's username, account creation date in UTC, link karma, comment karma, Reddit Gold status, moderator status, verified status, verified email status, number of comments (up to 100), and number of submissions (up to 100)
#' @example
#' getUserInfo("awildsketchappeared") 
getUserInfo <- function(user) {
  require(httr)
  require(RJSONIO)
  cat(paste("Now getting information for: ", user, sep = ""), sep = "\n")
  accountURL <- "https://oauth.reddit.com/user/"
  urlTail <- "/about.json"
  data <- GET(paste(accountURL, user, urlTail, sep = ""),
              user_agent("MY_USER_AGENT"),
              config(token = token))
  data <- fromJSON(content(data, "text"))
  comments <- GET(paste(accountURL, user, 
                        "/comments.json?limit=100000", sep = ""),
                  user_agent("MY_USER_AGENT"),
                  config(token = token))
  comments <- fromJSON(content(comments, "text"))
  submissions <- GET(paste(accountURL, user,
                           "/submitted.json?limit=100000", sep = ""),
                     user_agent("MY_USER_AGENT"),
                     config(token = token))
  submissions <- fromJSON(content(submissions, "text"))
  out <- try(data.frame(user = data$data$name,
                        created = data$data$created,
                        linkKarma = data$data$link_karma,
                        commentKarma = data$data$comment_karma,
                        isGold = data$data$is_gold,
                        isMod = data$data$is_mod,
                        verified = data$data$verified,
                        verifiedEmail = data$data$has_verified_email,
                        comments = length(comments$data$children),
                        submissions = length(submissions$data$children)))
  if (class(out) == "try-error"){
    return(data.frame(user = NA,
                      created = NA,
                      linkKarma = NA,
                      commentKarma = NA,
                      isGold = NA,
                      isMod = NA,
                      verified = NA,
                      verifiedEmail = NA,
                      comments = NA,
                      submissions = NA))
  }
  return(out)
}