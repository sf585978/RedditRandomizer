#' Get top-level comments for a given Reddit thread
#'
#' @param thread The unique portion of a reddit url beginning with /r/ for which you would like to identify the top-level commenters
#' @return A data frame containing the author, subreddit, thread, comment id, time created in UTC, the comment text, the number of direct replies, the up votes received, the down votes received, the post score, status of whether or not the comment can be gilded, and whether or not it is already gilded
#' @export
#' @example
#' getComments("/r/politics/comments/8w1me0/record_number_of_native_americans_running_for/")
getComments <- function(thread) {
  require(httr)
  require(RJSONIO)
  redditURL <- "https://oauth.reddit.com"
  urlTail <- "comments.json?limit=1000"
  data <- GET(paste(redditURL, thread, urlTail, sep = ""),
              user_agent("MY_USER_AGENT"),
              config(token = token))
  data <- RJSONIO::fromJSON(content(data, "text"))
  ncomms <- length(data[[2]]$data$children)
  if (ncomms > 1) {
    comments <- try(data.frame(author = data[[2]]$data$children[[1]]$data$author,
                               subreddit = data[[2]]$data$children[[1]]$data$subreddit,
                               thread = thread,
                               id = data[[2]]$data$children[[1]]$data$id,
                               created = data[[2]]$data$children[[1]]$data$created_utc,
                               comment = data[[2]]$data$children[[1]]$data$body,
                               replies = length(data[[2]]$data$children[[1]]$data$replies),
                               ups = data[[2]]$data$children[[1]]$data$ups,
                               downs = data[[2]]$data$children[[1]]$data$downs,
                               score = data[[2]]$data$children[[1]]$data$score,
                               canGild = data[[2]]$data$children[[1]]$data$can_gild,
                               gilded = data[[2]]$data$children[[1]]$data$gilded))
    if (class(comments) == "try-error"){
      comments <- data.frame(author = NA,
                        subreddit = NA,
                        thread = NA,
                        id = NA,
                        created = NA,
                        comment = NA,
                        replies = NA,
                        ups = NA,
                        downs = NA,
                        score = NA,
                        canGild = NA,
                        gilded = NA)

    }
    for (i in 2:(ncomms - 1)) {
      out <- try(data.frame(author = data[[2]]$data$children[[i]]$data$author,
                            subreddit = data[[2]]$data$children[[i]]$data$subreddit,
                            thread = thread,
                            id = data[[2]]$data$children[[i]]$data$id,
                            created = data[[2]]$data$children[[i]]$data$created_utc,
                            comment = data[[2]]$data$children[[i]]$data$body,
                            replies = length(data[[2]]$data$children[[i]]$data$replies),
                            ups = data[[2]]$data$children[[i]]$data$ups,
                            downs = data[[2]]$data$children[[i]]$data$downs,
                            score = data[[2]]$data$children[[i]]$data$score,
                            canGild = data[[2]]$data$children[[i]]$data$can_gild,
                            gilded = data[[2]]$data$children[[i]]$data$gilded))
      if (class(out) == "try-error"){
        out <- data.frame(author = NA,
                          subreddit = NA,
                          thread = NA,
                          id = NA,
                          created = NA,
                          comment = NA,
                          replies = NA,
                          ups = NA,
                          downs = NA,
                          score = NA,
                          canGild = NA,
                          gilded = NA)
      }
      comments <- rbind(comments, out)
    }
  } else if (ncomms == 1) {
    comments <- try(data.frame(author = data[[2]]$data$children[[1]]$data$author,
                               subreddit = data[[2]]$data$children[[1]]$data$subreddit,
                               thread = thread,
                               id = data[[2]]$data$children[[1]]$data$id,
                               created = data[[2]]$data$children[[1]]$data$created_utc,
                               comment = data[[2]]$data$children[[1]]$data$body,
                               replies = length(data[[2]]$data$children[[1]]$data$replies),
                               ups = data[[2]]$data$children[[1]]$data$ups,
                               downs = data[[2]]$data$children[[1]]$data$downs,
                               score = data[[2]]$data$children[[1]]$data$score,
                               canGild = data[[2]]$data$children[[1]]$data$can_gild,
                               gilded = data[[2]]$data$children[[1]]$data$gilded))
    if (class(comments) == "try-error"){
      comments <- data.frame(author = NA,
                             subreddit = NA,
                             thread = NA,
                             id = NA,
                             created = NA,
                             comment = NA,
                             replies = NA,
                             ups = NA,
                             downs = NA,
                             score = NA,
                             canGild = NA,
                             gilded = NA)
    }
  } else {
    comments <- NULL
  }
  return(comments)
}

