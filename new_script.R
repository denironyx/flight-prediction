flight_data <- read.csv2('C:/Users/LENOVO/Documents/Data science project/R/flight_prediction/Dataset/Jan_2015_ontime.csv', sep = ',', header = TRUE, stringsAsFactors = FALSE)
library(caret)


colnames(flight_data)
## Restrict the data to some particular airports
airports <- c('ATL','LAX', 'ORD','DFW','JFK', 'SFO','CLT','LAS', 'PHX')

flight_data <- subset(flight_data, DEST %in% airports & ORIGIN %in% airports)
nrow(flight_data)
head(flight_data)

## Remove the last column with NA
flight_data <- flight_data[,1:23]
head(flight_data)


##Checking and comparing relationship between two variables
cor(flight_data[c("ORIGIN_AIRPORT_ID", "ORIGIN_AIRPORT_SEQ_ID")])
cor(flight_data[c("DEST_AIRPORT_ID", "DEST_AIRPORT_SEQ_ID")])

##So, let's drop the Origin seq ID and DEST seq ID
flight_data$ORIGIN_AIRPORT_SEQ_ID <- NULL
flight_data$DEST_AIRPORT_SEQ_ID <- NULL


## We can observer that carrier and Unique Carrier 
mismatched <- flight_data[flight_data$CARRIER != flight_data$UNIQUE_CARRIER, ]
mismatched

head(flight_data, 2)

## Check for NA or missing rows and store the new rows in a variable called  on

flight <- flight_data[!is.na(flight_data$ARR_DEL15) & flight_data$ARR_DEL15 != "" & !is.na(flight_data$DEP_DEL15) & flight_data$DEP_DEL15 != "",]
nrow(flight)
nrow(flight_data)

(32124 / (32124 + 32716))

nrow(flight_data) - nrow(flight)


##Changing the data types
flight$DISTANCE <- as.integer(flight$DISTANCE)
flight$CANCELLED <- as.integer(flight$CANCELLED)
flight$DIVERTED <- as.integer(flight$DIVERTED)
flight$ARR_DEL15 <- as.factor(flight$ARR_DEL15)  
flight$DEP_DEL15 <- as.factor(flight$DEP_DEL15)
flight$DEST <- as.factor(flight$DEST)
flight$DEST_AIRPORT_ID <- as.factor(flight$DEST_AIRPORT_ID)
flight$DAY_OF_WEEK <- as.factor(flight$DAY_OF_WEEK)
flight$ORIGIN <- as.factor(flight$ORIGIN)
flight$DEP_TIME_BLK <- as.factor(flight$DEP_TIME_BLK)
flight$ARR_TIME_BLK <- as.factor(flight$ARR_TIME_BLK)
flight$CARRIER <- as.factor(flight$CARRIER)
flight$DISTANCE <- as.factor(flight$DISTANCE)

## Split the dataset into various part
featureCols <- c('ARR_DEL15', "DAY_OF_WEEK","CARRIER", "DEST", "ORIGIN", "DEP_TIME_BLK", "DISTANCE", "ARR_TIME_BLK")

flightFiltered <- flight[, featureCols]
head(flightFiltered, 2)
head(flight, 2)

trainRows <- createDataPartition(flightFiltered$ARR_DEL15, p = 0.70, list = FALSE)
head(trainRows)

## Spliting the dataset
trainData <- flightFiltered[trainRows, ]
testData <- flightFiltered[-trainRows, ]


#Checking proportion
(nrow(trainData) / (nrow(trainData) + nrow(testData)))
(nrow(testData) / (nrow(trainData) + nrow(testData)))


##Chosing logistic regression to start with
logisticRegModel <- train(ARR_DEL15 ~., data = trainData, method = 'glm', family = 'binomial')

##Now we can use the model and the test data to check how well we predict flight arrival delays

logRegPrediction <- predict(logisticRegModel, testData)
logRegConfMat <- confusionMatrix(logRegPrediction, testData[,"ARR_DEL15"])
logRegConfMat


## Specificity is really low. Improve model. 
fitControl <- trainControl(method = 'repeatedcv', number = 10, repeats = 10)
gbmFit1 <- train(ARR_DEL15 ~., data = trainData, method = 'gbm', trControl = fitControl,
                 verbose = FALSE)

plot(gbmFit1)
plot(gbmFit1, metric = "Kappa")

gbmPrediction <- predict(gbmFit1, testData)
gbmConfMat <- confusionMatrix(gbmPrediction, testData[,"ARR_DEL15"])
gbmConfMat
