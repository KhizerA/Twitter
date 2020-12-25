library(tidyverse)
election <- read.csv('election.csv')

election <- election %>% group_by(Party.Name)
election <- election %>% dplyr::summarise(Votes = sum(Votes))

ifelse(election$Party.Name == "PPP" | election$Party.Name == "PTI", election$Party.Name == "PML-N")

votes <- data.frame(filter(election, Party.Name == "PTI"))
votes <- rbind(votes, filter(election, Party.Name == "PPP"), filter(election, Party.Name == "PML-N"))

write.csv(votes, "results.csv")
