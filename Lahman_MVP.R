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
if (mvps_hitters$mvp.isna()==TRUE) {
  mvps_hitters$mvp <- FALSE 
}



# Merge in pitchers
mvps_pitchers <- 





