library(dplyr)

## Download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "data.zip")
unzip("data.zip")


## Read data
features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
activity[ , 2] <- as.character(activity[ , 2])

stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")

strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")

## Merge data
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
sdata <- rbind(strain, stest)

## Select columns
cols <- grep("-mean|-std", features[ , 2])
colnames <- features[cols, 2]
xdata <- xdata[cols]

## Merge selected columns and name columns
alldata <- cbind (ydata, sdata, xdata)
colnames(alldata) <- c("activity", "subject", colnames)

## Modify variables
alldata$activity <- factor(alldata$activity, levels = 1:6, labels = activity[ , 2])
alldata$subject <- as.factor(alldata$subject)

## Create new data frame with averages
meansdata <- summarise_at(alldata, 3:ncol(alldata), mean)
write.table(meansdata, file = "meansdata.txt", row.names = FALSE)
