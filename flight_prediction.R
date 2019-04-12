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

mismatched
#Let drop Unique Carrier
OrigData$UNIQUE_CARRIER <- NULL

head(OrigData, 2)

#$ Moldingg data

#Checkinng for NA or missing rows and store the new rows in a variable called onTimeData
onTimeData <- OrigData[!is.na(OrigData$ARR_DEL15) & OrigData$ARR_DEL15 != "" & !is.na(OrigData$DEP_DEL15) & OrigData$DEP_DEL15 != "",]

##Changing the data types
onTimeData$DISTANCE <- as.integer(onTimeData$DISTANCE)
onTimeData$CANCELLED <- as.integer(onTimeData$CANCELLED)
onTimeData$DIVERTED <- as.integer(onTimeData$DIVERTED)
onTimeData$ARR_DEL15 <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 <- as.factor(onTimeData$DEP_DEL15)
onTimeData$DEST <- as.factor(onTimeData$DEST)
onTimeData$DEST_AIRPORT_ID <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$DAY_OF_WEEK <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$ORIGIN <- as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER <- as.factor(onTimeData$CARRIER)



## Accurately Predicting rare events is difficult, the basic issue with rare event is that.
                                #They are rare


#Using tapply funtion to see the number of time flight was delayed 
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length) ## We can see the number of arrival delay.

#3 Let's compute the preverance of the number of flight delay
(6460 / (25664 + 6460))


##Data Rule #4 Track how you manipulate


        ##Role of algorithm

  #Perform algortihm selection

##Compare factor dor algorithm function
# 1. Learning Type
# 2. Result type the algorithm produces
# 3. Complexity of the algorithm
# 4. Basic or enhanced data

## Learning type, our prediction is a supervised learning. 
## Result type, regression and classification. - Classification, discrete values, true or false, small, medium or large
## Complexity of the algorithm, keep it simple, eliminate 'ensemble' algorithms
## Enhanced or basic, 

          ## Candidate algorithms
#Naive Bayes, #Logictic regression, #Decision rule -  logistic regression

## Initial selected algorithm - Logistic regression
# 1. Simple - easy to understand
# 2. Fast -  up to 100x faster
# 3. Stable to data changes























