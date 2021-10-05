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

### Merge with lahman people
mvps <- merge(mvps, lahman_people, by="playerID")
mvps <- merge(mvps, chadwick, by.x="bbrefID", by.y="key_bbref")



