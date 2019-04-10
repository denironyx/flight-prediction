OrigData <- read.csv2('C:/Users/LENOVO/Documents/Data science project/R/flight_prediction/Dataset/Jan_2015_ontime.csv', sep = ',', header = TRUE, stringsAsFactors = FALSE)

nrow(OrigData)

ncol(OrigData)

colnames(OrigData)

head(OrigData)

##To speed things up, I will be restrick the data to some particular airports

airports <- c('ATL', 'LAX', 'ORD','DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')

OrigData <- subset(OrigData, DEST %in% airports & ORIGIN %in% airports)
nrow(OrigData) ## Less and more accessible

          ## Data Rule

#Data will never be in the format you need. There is data that need to be removed, alter or created to meet our needs
head(OrigData, 2) # The last column has NA, that's suspicious. I t was created, while importing data in Rstudio

#To be sure, let check the tail of the data set.
tail(OrigData,2) #Perfect, we are dropping the las column

OrigData <- OrigData[, 1:23]
head(OrigData, 2)

#Eliminate columns, that  wouldn't be useful for our prediction
#Not Used, No values, Duplicates, correlated columns


#Using Cor() function to  compare function if it is correlated.

cor(OrigData[c("ORIGIN_AIRPORT_ID", "ORIGIN_AIRPORT_SEQ_ID")])# The closer the value to 1 the more correlated

cor(OrigData[c("DEST_AIRPORT_ID", "DEST_AIRPORT_SEQ_ID")])

##So let's drop the ORIGIN_AIRPORT_SEQ_ID, DEST_AIRPORT_SEQ_ID

OrigData$ORIGIN_AIRPORT_SEQ_ID <- NULL
OrigData$DEST_AIRPORT_SEQ_ID <- NULL


## We can observed that Carrier and Unique Carrier
mismatched <- OrigData[OrigData$CARRIER != OrigData$UNIQUE_CARRIER,] #Check if there is no row when Unique Carrier is not equal to Carrier

#Let drop Unique Carrier
OrigData$UNIQUE_CARRIER <- NULL

head(OrigData, 2)














