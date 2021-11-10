# install.packages("Lahman")
library(tidyverse)

# Load Lahman package
library(Lahman)

#### Get awards data ####
data(AwardsPlayers)
View(AwardsPlayers)

# Subset just MVP data
mvps <- AwardsPlayers[AwardsPlayers$awardID=="Most Valuable Player", ]

# Split by league
# mvps_al <- mvps[mvps$lgID=="AL", ]
# mvps_nl <- mvps[mvps$lgID=="NL", ]

# According to Baseball Reference, "The current incarnation of the MVP award was established in 1931." so we could
# probably start the data there

#### Get cross-refernce IDS
data(People)
View(People)


chadwick <- read_csv("chadwick.csv")
lahman_people <- read_csv("lahman_people.csv")
fan_hitters <- read_csv("All Hitters Since 1911.csv")

fan_hitters <- fan_hitters %>% rename(yearID = Season)
fan_hitters <- fan_hitters %>% rename(key_fangraphs = playerid)



fan_pichers <- read_csv("All Pitchers Since 1911.csv")



### Merge with lahman people
mvps <- merge(mvps, lahman_people, by="playerID")

# Merge in chadwick
mvps <- merge(mvps, chadwick, by.x="bbrefID", by.y="key_bbref")

# Merge in hitters 
mvps_hitters <- merge(mvps, fan_hitters, by=c("key_fangraphs", "yearID"), all=TRUE)

mvps_hitters <- mvps_hitters[order(-mvps_hitters$WAR),]


glimpse(mvps_hitters)
mvps_hitters$WAR <- as.numeric(mvps_hitters$WAR)
mvps_hitters$mvp <- (mvps_hitters$awardID == "Most Valuable Player")
mvps_hitters["mvp"][is.na(mvps_hitters["mvp"])] <- FALSE

war_winners <- mvps_hitters %>%
  filter(mvp == TRUE)

war_winners_al <- war_winners[war_winners$lgID=="AL", ]
war_winners_nl <- war_winners[war_winners$lgID=="NL", ]

for (i in nrow(mvps_hitters))
{
  try(mvps_hitters[i, "war_diff_al"] <- mvps_hitters[i, "WAR"] - war_winners_al[war_winners_al$yearID == mvps_hitters[i, "yearID"], "WAR"])
  try(mvps_hitters[i, "war_diff_nl"] <- mvps_hitters[i, "WAR"] - war_winners_nl[war_winners_nl$yearID == mvps_hitters[i, "yearID"], "WAR"])
}




#war_winners_al["WAR"][war_winners_al$yearID == 1923]



# Merge in pitchers
#mvps_pitchers <- 

