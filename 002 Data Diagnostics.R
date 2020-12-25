### Preamble ###
### Purpose: Running diagnostics on our collected data
### Author: Khizer Asad
### Date: 15 December 2020
### Contact: k.asad@mail.utoronto.ca
### License: MIT 
### Pre-Requisites: 
## - Need to obtain PTI, PPP, and PMLN tweet data CSVs from processes shown in 001


### Workspace setup ###
library(rtweet)
library(tidyverse)
library(ggplot2)
library(forcats)
library(waffle)

# Reading in cleaned data
PTI <- read.csv("PTI.csv",   fileEncoding = "UTF-16")
PPP <- read.csv("PPP.csv",   fileEncoding = "UTF-16")
PMLN <- read.csv("PMLN.csv",   fileEncoding = "UTF-16")

### Data diagnostics ###
## Figure 1: Frequency histogram
# number of tweets
lens <- c(length(PTI$text), length(PPP$text), length(PMLN$text))
# number of users
uniques <- c(length(unique(PTI$user_id)), length(unique(PPP$user_id)), length(unique(PMLN$user_id)))
# congregating previous two variables to graph 
hist.data <- data.frame(
  tweets = c(rep("PTI", lens[1]), rep("PPP", lens[2]), rep("PMLN", lens[3])),
  users = c(
    rep("Users", uniques[1]), rep("Tweets", (lens[1]-uniques[1])),
    rep("Users", uniques[2]), rep("Tweets", (lens[2]-uniques[2])),
    rep("Users", uniques[3]), rep("Tweets", (lens[3]-uniques[3])))
)
# Graph function 
agg <- dplyr::count(hist.data, tweets, users)
agg_ord <- mutate(agg, tweets = reorder(tweets, -n, sum),
                  users = reorder(users, -n, sum))
fills <- c(Users = "#00acee", Tweets = "gray17" )
fig1 <- agg_ord %>% ggplot() + geom_col(aes(x= tweets, y=n, fill = users), width = 0.5) + 
          scale_fill_manual(values = fills, name = "") +
          labs(x = "Political Party", y = "Quantity", title = "Figure 1", 
          subtitle = "Twitter activity leading up to the Gilgit-Baltistan elections")
fig1

## Figure 2: Tweets per user 
# number of unique users and their respective number of tweets in the data set
people <- c(PTI$user_id, PPP$user_id, PMLN$user_id)
people <- as.data.frame(table(people))
# formatting ranges to manage number of tweets
people$ranges <- 
  ifelse(people$Freq == 1, 1, 
         ifelse(people$Freq == 2, 2, 
                ifelse(people$Freq == 3, 3,
                       ifelse(people$Freq == 4, 4,
                              ifelse(people$Freq >= 5 & people$Freq < 10, "5-10", "10+")
                              ))))
for.diag <- as.data.frame(table(people$ranges))
colnames(for.diag) <- c("range", "freq")
ordered <- c(1,2,3,4,"5-10","10+")
for.diag <- for.diag %>% slice(match(ordered, range))
# Graph function
fig2 <- waffle(for.diag, rows = 14,
               colors = c("#1b85b8", "#5a5255", "#559e83", "#ae5a41", "#c3cb71", "#d27575"),
               size = 1, title = "Figure 2: Number of political tweets per user")
fig2
