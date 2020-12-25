### Preamble ###
### Purpose: Preforming sentiment analysis on the collected tweets using VADER
### Author: Khizer Asad
### Date: 15 December 2020
### Contact: k.asad@mail.utoronto.ca
### License: MIT 
### Pre-Requisites: 
## - Require PPP, PTI, and PMLN tweet CSVs collected in 001 

### Workspace setup ###
library(rtweet)
library(tidyverse)
library(vader)
library(Hmisc)
set.seed(777)

# Reading in data 
PTI <- read.csv("PTI.csv",   fileEncoding = "UTF-16")
PPP <- read.csv("PPP.csv",   fileEncoding = "UTF-16")
PMLN <- read.csv("PMLN.csv",   fileEncoding = "UTF-16")

### Sentiment analysis ###
# the VADER package provides us with a sentiment score for a tweet ranging between -1 and 1
# will apply the scoring function on every tweet and then produce a compiled score for each user

# Getting a compund sentiment score for each tweet
PTI_sa <- vader_df(PTI$text)
PTI$sentiment <- PTI_sa$compound
PPP_sa <- vader_df(PPP$text)
PPP$sentiment <- PPP_sa$compound
PMLN_sa <- vader_df(PMLN$text)
PMLN$sentiment <- PMLN_sa$compound

# Compiling users and their sentiment score per tweet
PTI_user <- data.frame(
  ID = PTI$user_id,
  score = PTI_sa$compound
)
PPP_user <- data.frame(
  ID = PPP$user_id,
  score = PPP_sa$compound
)
PMLN_user <- data.frame(
  ID = PMLN$user_id,
  score = PMLN_sa$compound
)
# Giving each user their average sentiment score
PTI_user <- PTI_user %>% group_by(ID)
PTI_user <- PTI_user %>% dplyr::summarise(score = mean(score))

PPP_user <- PPP_user %>% group_by(ID)
PPP_user <- PPP_user %>% dplyr::summarise(score = mean(score))

PMLN_user <- PMLN_user %>% group_by(ID)
PMLN_user <- PMLN_user %>% dplyr::summarise(score = mean(score))

## Figure 3: sentiment scores by party 
# data frame to hold the needed data
box.data <- data.frame(
  party = c(rep("PTI", nrow(PTI_user)), rep("PPP", nrow(PPP_user)), rep("PMLN", nrow(PMLN_user))),
  ss = c(PTI_user$score, PPP_user$score, PMLN_user$score)
)
# violin plot
fig3 <-
  box.data %>% ggplot(aes(x = party, y = ss)) + geom_violin(aes(fill = party)) +
    stat_summary(fun.data="mean_sdl", geom="pointrange", color = "white") + 
    scale_fill_manual(values = c("gray17", "#00acee", "gray17")) +
    theme(legend.position = "none") + 
    labs(x = "Political Party", y = "Sentiment Score", title = "Figure 3",
         subtitle = "Political sentiment scores of Gilgit-Baltistan Twitter users") +
    ylim(-1,1)
fig3    

# Using the sentiment data to estimate what party each user would vote for
compiled <- rbind(PTI_user, PPP_user, PMLN_user)
compiled$party <- c(rep("PTI", nrow(PTI_user)), rep("PPP", nrow(PPP_user)), rep("PMLN", nrow(PMLN_user)))
compiled <- compiled %>% filter(score > 0)
uniques <- data.frame()

# check: not repeated ID + largest value + find all other occurrences
for (i in 1:nrow(compiled)) {
  if (compiled$ID[i] %in% uniques$ID) {
    next
  }
  temp <- filter(compiled, ID == compiled$ID[i])
  temp <- filter(temp, score == max(temp$score))
  if (nrow(temp) > 1) {
    index <- sample(c(1:nrow(temp)), 1)
    temp <- temp[index,]
  }
  uniques <- rbind(uniques, temp)
}


twitter <- plyr::count(uniques$party)

## Figure 4: election results vs. twitter data comparison
results <- read.csv("results.csv") #taken from https://www.electionpakistani.com/gilgit-baltistan-2020/result.html
results_tot <- sum(results$votes)
twitter_tot <- sum(twitter$freq)

voting <- data.frame(results, t = twitter$freq)
voting$votes <- voting$votes/results_tot * 100
voting$t <- voting$t/twitter_tot * 100

fig4 <- 
  voting %>% ggplot() + 
    geom_point(aes(x = votes, y= party, fill= "Election"), size = 4, shape = 18 ) +
    geom_point(aes(x = t, y = party, fill = "Twitter"), shape = 25, size = 4 ) +
    geom_label(aes(x =t, y= party, label = paste(signif(t, digits = 2), "%", sep = "")),
               nudge_x = -1.5, nudge_y = 0.15) +
    geom_label(aes(x =votes, y= party, label = paste(signif(votes, digits = 2), "%", sep = "")),  
               nudge_x = 1.5, nudge_y = -0.15) +
    labs(x= "Proportion of votes (%)", y = "Political Party", title = "Figure 4",
         subtitle = "Gilgit-Baltistan General Assembly election results vs. forecast from tweets") +
    scale_fill_manual(name = "", values = c(Election = "gray17", Twitter = "#00acee")) +
    theme (
      legend.position = c(.97, .35),
      legend.justification = c("right", "top"),
      legend.box.just = "right",
      legend.margin = margin(-6, 6, 6, 6)
    ) 
fig4

### Hypothesis test ###
# Using chi-square goodness of fit to test the validity of the election results against the twitter data
hyp.data <- data.frame(
  party = voting$party, 
  twt = twitter$freq,       # sample vote count
  vote = voting$votes/100   # ratio of actual vote count
  )

chisq.test(hyp.data$twt, p = hyp.data$vote)

