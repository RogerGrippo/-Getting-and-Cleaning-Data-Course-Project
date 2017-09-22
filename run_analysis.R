# get train data
X_train <- read.table("c:/1Datascience/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("c:/1Datascience/UCI HAR Dataset/train/Y_train.txt")
Subtrain <- read.table("c:/1Datascience/UCI HAR Dataset/train/subject_train.txt")

# get test data
X_test <- read.table("c:/1Datascience/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("c:/1Datascience/UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("c:/1Datascience/UCI HAR Dataset/test/subject_test.txt")

# get data description
variable_names <- read.table("c:/1Datascience/UCI HAR Dataset/features.txt")

# get activity labels
activity_labels <- read.table("c:/1Datascience/UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test sets to create one data set.
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

# Extracts the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# Label the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
library(dplyr)
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "c:/1DataScience/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
