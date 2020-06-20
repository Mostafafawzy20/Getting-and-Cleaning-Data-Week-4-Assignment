# Peer-graded assignment: Getting and cleaning Data course project 

# 1.1 loading required packages

library(dplyr)


# 1.2 check if archieve already exists:

file <- "Coursera_w4_project.zip"
if(!file.exists(file)){
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl,file)
}

# 1.3 check if folder was created:

if(!file.exists("UCI HAR Dataset")){
  unzip(file)
}

# 1.4 assigning data frames:

activity <- read.table("UCI HAR Dataset//activity_labels.txt", col.names = c("serial", "activity"))
features <- read.table("UCI HAR Dataset//features.txt", col.names = c("serial", "function"))
test <- read.table("UCI HAR Dataset//test//subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset//test//X_test.txt", col.names = features$function.)
y_test <- read.table("UCI HAR Dataset//test//y_test.txt", col.names = "code")
train <- read.table("UCI HAR Dataset//train//subject_train.txt", col.names = "subject")
X_train <- read.table("UCI HAR Dataset//train//X_train.txt", col.names = features$function.)
y_train <- read.table("UCI HAR Dataset//train//y_train.txt", col.names = "code")

# 2.1 creating run_analysis.R script:
# 2.2 to merge training and test data sets in one:

x <- rbind(X_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(test, train)
data_merged <- cbind(subject,y,x)

# 2.3 Subset the mean and Std data:

mean_data <- data_merged%>%
  select(subject, code , contains("mean"), contains("std"))


# 2.4 replacing the numbers with activities name in activity column:

mean_data$code <- activity[mean_data$code, 2]



# 2.5 renaming the labels to descriptive names

names(mean_data)[2] = "activity"
names(mean_data) <- gsub("Acc", "Accelerometer", names(mean_data))
names(mean_data) <- gsub("Gyro", "Gyroscope", names(mean_data))
names(mean_data) <- gsub("BodyBody", "Body", names(mean_data))
names(mean_data) <- gsub("Mag", "Magnitude", names(mean_data))
names(mean_data) <- gsub("^t", "Time", names(mean_data))
names(mean_data) <- gsub("^f", "Frequency", names(mean_data))
names(mean_data) <- gsub("tBody", "TimeBody", names(mean_data))
names(mean_data) <- gsub("-mean()", "Mean", names(mean_data), ignore.case = TRUE)
names(mean_data) <- gsub("-std()", "STD", names(mean_data), ignore.case = TRUE)
names(mean_data) <- gsub("-freq()", "Frequency", names(mean_data), ignore.case = TRUE)
names(mean_data) <- gsub("angle", "Angle", names(mean_data))
names(mean_data) <- gsub("gravity", "Gravity", names(mean_data))

# 3.1 Creating a new data set contains the average of each variable for each activity and each subject 

new_data <- mean_data%>%
  group_by(subject,activity)%>%
  summarise_all(funs(mean))
write.table(new_data, "newdata.txt", row.names = FALSE)








