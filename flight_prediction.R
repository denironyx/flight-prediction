
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


## Let drop CARRIER, DIVERTED AND TAIL_NUM: Since carrier and Diverted has no values and tailnum is has no significant to the model
onTimeData$CARRIER <- NULL
onTimeData$DIVERTED <- NULL
onTimeData$TAIL_NUM <- NULL

head(OrigData, 2)

str(OrigData)#$ Moldingg data

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

table(onTimeData$ARR_DEL15) ##
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
    



                ##Training the model

##CARET Classification and Regression Training


##Create the training and test datasets



##################################################
##                                              ##
## Predictive modelling from initial tutorial   ##
##                                              ##    
##################################################

library(caret)
set.seed(123456)

newfeature <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
modelfeature <- train(ARR_DEL15 ~., data = onTimeData, method = "lvq", preProcess = "scale", trControl = newfeature)
featureImportance <-
  
  
  featureCols <- c("ARR_DEL15", "DAY_OF_WEEK","CARRIER","DEST","ORIGIN","DEP_TIME_BLK")

onTimeDataFiltered <- onTimeData[, featureCols]
inTrainRows <- createDataPartition(onTimeDataFiltered$ARR_DEL15, p = 0.70, list = FALSE)
head(inTrainRows, 10)


## Training dataset
trainDataFiltered <- onTimeDataFiltered[inTrainRows,]
testDataFiltered <- onTimeDataFiltered[-inTrainRows,]

##Checking if the data was correctly slitted into 70:30 
nrow(trainDataFiltered) / (nrow(trainDataFiltered) + nrow(testDataFiltered))
nrow(testDataFiltered) / (nrow(trainDataFiltered) + nrow(testDataFiltered))


##Make the prediction
logisticRegModel <- train(ARR_DEL15 ~ ., data = trainDataFiltered, method = "glm", family = "binomial")
logisticRegModel


##Evaluate the model against test data, interpret results
logRegPrediction <- predict(logisticRegModel, testDataFiltered)
logRegConfMat <- confusionMatrix(logRegPrediction, testDataFiltered[, "ARR_DEL15"])
logRegConfMat



#CROSS VALIDATION


## Working with memory in R
memory.limit(size = 160000)

library(magrittr)
sapply(ls, function(x) object.size(get(x))) %>% sort %>% tail(5)


## Random forest
library(randomForest)
rfModel <- randomForest(trainDataFiltered[-1], trainDataFiltered$ARR_DEL15, proximity = TRUE, importance = TRUE)
rfValidation <- predict(rfModel, testDataFiltered)
rfConfMat <- confusionMatrix(rfValidation, testDataFiltered[, "ARR_DEL15"])
rfConfMat



##Options for improving performance

## Rethinking the problem


################################################
##                                            ##
## Improved Predictive modelling with feature ##
##  elimination method and cross validation   ##    
################################################



set.seed(100)

inTrainRow <- onTimeData 
library(caret)

inTrainRow <- createDataPartition(onTimeData$ARR_DEL15, p = 0.8, list = FALSE)

##Step 2: Create the training data
trainData <- onTimeData[inTrainRow,]

##Step 3: Create the test dataset
testData <- onTimeData[-inTrainRow,]

## Store X and Y for later use
x = trainData[,2:20]
y = trainData$ARR_DEL15


##Exploring the skimr package for descriptive statistics
library(skimr)
skimmed <- skim_to_wide(trainData)
skimmed

###########################################################
## Feature selection using recursive feature elimination ##  
###########################################################

set.seed(10)
options(warn = -1)## Reduce the number of warning displayed to 1


#Keeps priority to the most important variables, iterate through by building models of given subset sizes

# subsets <- c(1:7,13:17)

library(dplyr)

##Check through to see if there is any character datatype

flight_data = trainData %>% mutate_if(is.character, as.factor)

ctrl <- rfeControl(functions = rfFuncs,
                   method = "repeatedcv",
                   repeats = 3,
                   verbose = FALSE)

lmProfile <- rfe(x = flight_data[,1:17], y = flight_data$ARR_DEL15,
                 sizes = 17,
                 rfeControl = ctrl)

lmProfile



set.seed(12)
#Train the model using random forest and predict on the training data itself
model_flight <- train(ARR_DEL15 ~., data = trainData, method = "earth")
fitted <- predict(model_flight)

model_flight

plot(model_flight, main = "Model Accuracy")

## How to compute the number of importance
varimp_flight <- varImp(model_flight)
plot(varimp_flight, main = "Variable Importance of Flight Prediction")


##Prediction
predicted <- predict(model_flight, testData)
head(predicted)

confusionMatrix(reference = testData$ARR_DEL15, data = predicted, mode = 'everything')

#############################################################################
## Performing an hyper tuning to optimize the model for better performance ##
##################################################################3##########

## Define the training control
fitControl <- trainControl(
  method = 'cv',
  number = 5,
 savePredictions = 'final',
  classProbs = T,
  summaryFunction = twoClassSummary
)

trainData$ARR_TIME_BLK <- as.factor(trainData$ARR_TIME_BLK)
## Hyper parameter tunning using  - tunelength
set.seed(2019)

trainData2 <- trainData
trainData2$ARR_DEL15 <- make.names(trainData2$ARR_DEL15)
model_flight2 = train(ARR_DEL15 ~., data = trainData2, method = 'earth', 
                     tuneLength = 5, metric = 'ROC', trControl = fitControl)


model_flight2

## To prevent Error: `data` and `reference` should be factors with the same levels.
testData2$ARR_DEL15 <- make.names(testData2$ARR_DEL15)
testData2$ARR_DEL15 <- as.factor(testData2$ARR_DEL15)

##Step 2: Predict on testData and Compute the confusion matrix
predicted2 <- predict(model_flight2,testData2)
confusionMatrix(reference = testData2$ARR_DEL15, data = predicted2, mode = 'everything', positive = 'X1.00')



















