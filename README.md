# RedditRandomizer
An R package to scrape Reddit commenters and their basic user info before assigning them to an experimental condition.

## Introduction
As part of a series of online field experiments I needed to be able to collect samples of redditors and assign them to various treatment conditions. The easiest and cheapest way to do so is to collect the commenters on popular posts in various subreddits. This package provides a few functions to interface with the Reddit API in R and pull down a set of popular posts from a set of subreddits, identify the commenters, and generate a table of their user account information.

## Install

## Set Up
To set up Reddit Randomizer you will need to create your own Reddit web app. [The guide provided by the Reddit Archive](https://github.com/reddit-archive/reddit/wiki/OAuth2) provides you with the necessary information to get started. It is important to note that a Reddit web app expires after one hour. When this happens any API queries will return 401 errors. An easy fix when this happens is to change the name of your app, update via the /prefs/apps page on your Reddit account, and then rerun the code below.

Once you make the app you need to create an access token using the httr library.

```r
library(httr)
# 1. Find OAuth settings for reddit:
#    https://github.com/reddit/reddit/wiki/OAuth2
reddit <- oauth_endpoint(
  authorize = "https://www.reddit.com/api/v1/authorize",
  access =    "https://www.reddit.com/api/v1/access_token"
)

# 2. Register an application at https://www.reddit.com/prefs/apps
app <- oauth_app("############", secret = "##################", 
                 key = "##############", 
                 redirect_uri = "http://localhost:1410/")

# 3. Get OAuth credentials
token <- oauth2.0_token(reddit, app,
                        scope = c("read", "history"),
                        use_basic_auth = TRUE,
                        config_init = user_agent("MY_USER_AGENT"))
```

## Getting Recent Threads
In order to collect Reddit commenters, you first need to collect threads for the API to pull from. We do this by identifying a set of target subreddits and scraping the links of the most popular subreddits over the last 24 hours. Doing so helps to ensure that the threads that are collected will have comments.

```r
subreddits <- c("politics", "sports")
links <- do.call(c, lapply(subreddits, getRecentThreads))
head(links)
```

If you have specific threads in mind and do not want to perform a general collection, you need to create a vector of the thread urls beginning with the /r/.

```r
links <- c("/r/politics/comments/8w1me0/record_number_of_native_americans_running_for/", 
"/r/sports/comments/8w2zd6/gareth_southgate_consoling_the_columbian_player/")
```

## Getting Commenter IDs
In order to conduct an online field experiment we need to identify the individuals who will be assigned to the various experimental conditions. Given a vector of Reddit threads, as shown above, we can scrape the top-level commenters for each thread.

```r
commenters <- do.call(c, lapply(links, getCommenters))
commenters <- unique(commenters)
head(commenters)
```

If you already know the commenters you want to assign treatment to, then just store them in a vector.

```r
commenters <- c("awildsketchappeared", "shitty_watercolour")
```

## Getting Commenter Information
It may be helpful for you to collect basic account information such as creation date and the amount of karma accrued before administering treatment. That can be done by passing a the vector of account names to getUserInfo(). The function returns a data frame with the account name, creation date in UTC, link (post) karma, comment karma, whether or not an account has Reddit gold, whether or not an account is a moderator, whether or not an account is verified, whether or not an account has a verified email, the number of comments (up to 100), and the number of submissions (up to 100). As a note, my tests have found that the API can reliably process about 2,500 accounts inside the one hour window an app is appoved for.

```r
commentersInfo <- do.call(rbind, lapply(commenters, getUserInfo))
commentersInfo$createdDate <- as.POSIXct(commenters$created, origin = "1970-01-01")
head(commentersInfo)
library(summarytools)
view(dfSummary(commentersInfo)
```
