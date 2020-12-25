library(rtweet)
library(tidyverse)


api_key <- "bd3PBlADvOyZroPm5SxApcRYG"
api_sk <- "G40ozhDkc3BpOVlIGmJez0TpyzqD9zF7E0ZF1y4Y3M2NdLw3Mg"
access_token <- "919748498-WHFobk3VJj5vCPU3K4Fm6QXBb12HGs9Zp0VWKoOB"
access_ts <- "He3wpF2EwJYJi8OYtPBCR7BnvllIk1TtJccmmKZJgggUE"

token <- create_token(app = "azadi", consumer_key = api_key, consumer_secret = api_sk,
                      access_token = access_token, access_secret = access_ts)

skrt <- search_fullarchive("profile_country:PK", n=10, token = token, env_name = "paak" )
#try searching in GB 
gb <- search_fullarchive("place:Gilgit-Baltistan", token = token, env_name = "paak" )
pti <- search_fullarchive(("place:Gilgit-Baltistan PTI"), token = token, env_name = "paak" )
pti2 <- search_fullarchive(("profile_region:Gilgit-Baltistan PTI"), token = token, env_name = "paak" )

compiled <- rbind(skrt, gb, pti, pti2)
#write_as_csv(compiled, file_name  = "prelim.csv")

