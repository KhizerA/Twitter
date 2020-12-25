### Preamble ###
### Purpose: Collecting raw data (tweets) from people in Gilgit-Baltistan for analysis
### Author: Khizer Asad
### Date: 15 December 2020
### Contact: k.asad@mail.utoronto.ca
### License: MIT 
### Pre-Requisites: 
## - Need to request for developer access to the Twitter API to gain access to Twitter Data
## - Need to purchase premium API to use the premium search operators for geolocated data

### Workspace setup ###
library(rtweet)
library(tidyverse)

### Data collection ###
### The goal is to compare the attitudes towards the three major parties PTI, PPP, and PMLN
### To do this we need to search by variations of the parties names and also their leadership/representatives

## Will start with making a key terms directory for each party including party names, leaders, and nominees
## Formatted as a string to be compatible with the API search function
# Pakistan Tehreek-e-Insaf keywords
PTI <- 'profile_region:Gilgit-Baltistan lang:en ("PTI" OR "Tehreek-e-Insaf" OR @ImranKhanPTI OR "Tehreek Insaf" OR "Imran Khan" OR "IK" OR "Johar Ali" OR "Fatta Ullah Khan" OR "Syed Sohail Abbas" OR "Muhammad Khalid Khursheed" OR "Shams Ul Haq Lon" OR "Raja Muhammad Zakeria Khan" OR "Fida Muhammad Nashad" OR "Wazir Hassan" OR "Syed Amjad Ali" OR "Raja Azam Khan" OR "Zaffar Muhammad" OR "Nazir Ahmed" OR "Raja Jahanzaib" OR "Haider Khan" OR "Noushad Alam" OR "Gulbar Khan" OR "Muhammad Ibrahim Sanai" OR "Amina Bibi" OR "Syed Shamsudin" OR "Abaidullah Baig")'
# Pakistan Peoples Party keywords
PPP <- 'profile_region:Gilgit-Baltistan lang:en ("PPP" OR "Peoples Party" OR @BBhuttoZardari OR "Zardari" OR "Bilawal Bhutto" OR "BBZ" OR "Amjad Hussain" OR "Jamil Ahmed" OR "Muzaffar Ali" OR "Syed Mehdi Shah" OR "Syed Muhammad Ali Shah" OR "Wazir Waqar" OR "Wazir Muhammad Khan" OR "Niaz Ali Siam" OR "Imran Nadeem" OR "Syed Jalal Shah" OR "Ali Madad Sher" OR "Muhammad Ayub Shah" OR "Ghaffar Khan" OR "Bashir Ahmed" OR "Dilbar Khan" OR "Sadia Danish" OR "Muhammad Jaffer" OR "Ghulam Ali Haidri" OR "Muhammad Ismail" OR "Mirza Hussain" OR "Zahoor Karim")'
# Pakistan Muslim League Nawaz keywords
PMLN <- 'profile_region:Gilgit-Baltistan lang:en ("PMLN" OR "PML(N)" OR @MaryamNSharif OR "Noon league" OR "Nawaz Sharif" OR "NS" OR "Maryam Nawaz" OR "MNS" OR "Jaffarullah Khan" OR "Hafiz-Ur-Rahman" OR "Rana Farman Ali" OR "Rana Farooq" OR "Muhammad Akbar" OR "Muhammad Saeed" OR "Ghulam Abbas" OR "Shabbir Hussain" OR "Tahir Shigri" OR "Atif Salman" OR "Muhammad Nazar Khan" OR "Ghulam Muhammad" OR "Sadar Alam" OR "Abdul Wajid" OR "Muhammad Anwar" OR "Raza-Ul-Haq" OR "Ghulam Hussain" OR "Manzoor Hussain" OR "Arif Hussain" OR "Sajjad Hussain" OR "Rehan Shah")'
# Pakistan Democratic Movement keywords 
PDM <- 'profile_region:Gilgit-Baltistan lang:en ("PDM" OR "Democratic Movement")'

## Now we run the searches using the key terms 
## We want to look at a 4 week period leading up to the election
## 5 separate searches are being run so to fit within the APIs rate limits

# PTI search
PTI_1 <- search_fullarchive(q = PTI, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010190000",
                            toDate = "202010260000") #376 results
PTI_2 <- search_fullarchive(q = PTI, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010260000",
                            toDate = "202011020000") #372 results
PTI_3 <- search_fullarchive(q = PTI, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011020000",
                            toDate = "202011090000") #283 results
PTI_4 <- search_fullarchive(q = PTI, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011090000",
                            toDate = "202011130000") #171 results
PTI_5 <- search_fullarchive(q = PTI, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011130000",
                            toDate = "202011160000") #483 results

# PPP search
PPP_1 <- search_fullarchive(q = PPP, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010190000",
                            toDate = "202010260000") #182 results
PPP_2 <- search_fullarchive(q = PPP, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010260000",
                            toDate = "202011020000") #129 results
PPP_3 <- search_fullarchive(q = PPP, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011020000",
                            toDate = "202011090000") #143 results
PPP_4 <- search_fullarchive(q = PPP, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011090000",
                            toDate = "202011130000") #85 results
PPP_5 <- search_fullarchive(q = PPP, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011130000",
                            toDate = "202011160000") #175 results

# PMLN search
PMLN_1 <- search_fullarchive(q = PMLN, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010190000",
                            toDate = "202010260000") #196 results
PMLN_2 <- search_fullarchive(q = PMLN, n = 10000, token = token, env_name = "paak",
                            fromDate = "202010260000",
                            toDate = "202011020000") #145 results
PMLN_3 <- search_fullarchive(q = PMLN, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011020000",
                            toDate = "202011090000") #309 results
PMLN_4 <- search_fullarchive(q = PMLN, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011090000",
                            toDate = "202011130000") #238 results
PMLN_5 <- search_fullarchive(q = PMLN, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011130000",
                            toDate = "202011160000") #136 results

# PDM search
PDM_1 <- search_fullarchive(q = PDM, n = 10000, token = token, env_name = "paak",
                            fromDate = "202011090000",
                            toDate = "202011160000") #19 results

## Congregating the data 
PTI_combine <- rbind(PTI_1, PTI_2, PTI_3, PTI_4, PTI_5)
PPP_combine <- rbind(PPP_1, PPP_2, PPP_3, PPP_4, PPP_5)
PMLN_combine <- rbind(PMLN_1, PMLN_2, PMLN_3, PMLN_4, PMLN_5)

### Exporting raw data as CSV ###
# Want to save the raw data as we don't want to run the searches again to conserve twitter bandwidth
write_as_csv(PTI_combine, file_name = "PTI_tweets", fileEncoding = "UTF-16")
write_as_csv(PPP_combine, file_name = "PPP_tweets", fileEncoding = "UTF-16")
write_as_csv(PMLN_combine, file_name = "PMLN_tweets", fileEncoding = "UTF-16")

### Data Cleaning ###
# Reading in the PTI tweets
PTI_raw <- read.csv("PTI_tweets.csv",   fileEncoding = "UTF-16")
# Selecting only the variables we want to use 
PTI_reduced <- PTI_raw %>% 
  select(user_id,
         status_id,
         created_at,
         screen_name,
         text,
         is_retweet,
         favorite_count,
         retweet_count,
         retweet_favorite_count,
         followers_count)

PMLN_raw <- read.csv("PMLN_tweets.csv",   fileEncoding = "UTF-16")
PMLN_reduced <- PMLN_raw %>% 
  select(user_id,
         status_id,
         created_at,
         screen_name,
         text,
         is_retweet,
         favorite_count,
         retweet_count,
         retweet_favorite_count,
         followers_count)

PPP_raw <- read.csv("PPP_tweets.csv",   fileEncoding = "UTF-16")
PPP_reduced <- PPP_raw %>% 
  select(user_id,
         status_id,
         created_at,
         screen_name,
         text,
         is_retweet,
         favorite_count,
         retweet_count,
         retweet_favorite_count,
         followers_count)

### Exporting condensed data ###
write_as_csv(PTI_reduced, file_name = "PTI", fileEncoding = "UTF-16")
write_as_csv(PPP_reduced, file_name = "PPP", fileEncoding = "UTF-16")
write_as_csv(PMLN_reduced, file_name = "PMLN", fileEncoding = "UTF-16")
