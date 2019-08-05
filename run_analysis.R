library(dplyr)
library(reshape2)

## download the zip file from given url ##
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "dataset"
if (!file.exists(file_name)) {
        download.file(fileUrl, file_name)
}

## unzip the downloaded zip file ##
path <- "UCI HAR Dataset"
if (!file.exists(path)) {
        unzip(file_name)
}

## read data from "test" folder and "train" folder ##
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
features_list <- read.table("UCI HAR Dataset/features.txt")
label_test <- read.table("UCI HAR Dataset/test/y_test.txt")
label_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activity_list <- read.table("UCI HAR Dataset/activity_labels.txt")

## set the names for the columns ##
names(subject_test) <- c("Subject")
names(subject_train) <- c("Subject")

## Name each column with feature
## (Step 4: Appropriately labels the data set with descriptive variable names) ##
names(x_test) <- features_list[,2]
names(x_train) <- features_list[,2]

## convert the labels into the the activity names ##
length_test <- nrow(label_test)
length_train <- nrow(label_train)
activity_test <- data.frame()
activity_train <- data.frame()
for (i in 1:length_test){
        code <- label_test[i,1]
        activity_test[i,1] <- as.character(activity_list[code,2])
}
for (i in 1:length_train){
        code <- label_train[i,1]
        activity_train[i,1] <- as.character(activity_list[code,2])
}
names(activity_test) <- c("Activity")
names(activity_train) <- c("Activity")

## add subjects and activity names into the dataset; 
##(Step 3: Uses descriptive activity names to name the activities in the data set) ##
test_data <- cbind(subject_test,activity_test,x_test)
train_data <- cbind(subject_train,activity_train,x_train)

## Step 1: Merge the test and the training data ##
total_data <- rbind(train_data,test_data)

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement ##
needed_features <- grep(".*mean.*|.*std",as.character(features_list[,2]), value = TRUE)
needed_data <- total_data[,c("Subject","Activity",needed_features)]

## Step 3 is completed at Line33-52 ##

## Step 4 is completed at Line31-34 ##

## Step 5: From the data set in step 4, creates a second, independent tidy data 
##         set with the average of each variable for each activity and each subject

molten_data <- melt(needed_data,id = c("Subject","Activity"))
tidy_data <- dcast(molten_data,Subject+Activity~variable,mean)
write.table(tidy_data,file = "tidy_data.txt",row.names = FALSE)

