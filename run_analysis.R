# Coursera - Getting and Cleaning Data Project
# ref.: README.md, CodeBook.md
#       http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# -----------------------------------------------------------------------------------------

# Download the dataset zip file from the given address into zippedData folder
zipFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./zippedData")) {dir.create("./zippedData")}
download.file(zipFile, destfile="./zippedData/data.zip", method="curl")

# Extract the zipped dataset into the data folder
datadir <- "./data"
if(!file.exists(datadir)) {dir.create(datadir)}
unzip(zipfile = "./zippedData/data.zip", exdir = datadir)

# Load the dplyr library
library(dplyr)

# Load the training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)

# Combine the train data into one
df_train <- data.frame(subject_train, y_train, x_train)

# Load the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# Combine the test data into one
df_test <- data.frame(subject_test, y_test, x_test)

# 1. Merge the test and training datasets
# ---------------------------------------
df <- rbind(df_train, df_test)

# Load the features (will use these to make column headers for the feature values)
features <- read.table("./data/UCI HAR Dataset/features.txt", header=FALSE)
features <- rbind( "subject", "activity", features)    # the 2 first columns

# Set features as column names for df
colnames(df) <- features[[2]]

# 2. Extract only measurements on the mean and standard deviation for each measurement
# ------------------------------------------------------------------------------------
df <- select(df, subject, activity, contains("mean"), contains("std"))

# 3. Use descriptive activity names to name the activities in the data set
# ------------------------------------------------------------------------
labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", 
                     col.names=c("activity","activity_description"),header=FALSE)
# joining the labels (since the column 'activity' has the same name in both a left join will bind on 'activity')
df <- left_join(df, labels)
# Moving the activity desription to be column 2, then removing the activity column
df <- select(df, subject, activity_description, everything())
df <- select(df, -activity)

# 4. Clean up the feature names (more descriptive names for the column headers)
# -----------------------------------------------------------------------------
# By studying the column names we see several changes we want to do with the names:
#   those starting with 't' we will change 't' to 'Time'
#                       'f' we will change 'f' to 'Frequency'
#   those with 'bodybody'   we will change 'bodybody' to 'body'
#                       ',' we will change ',' to '-'
#   We see no need to lengthen column names for those that are understandable,
#   like for instance: gyro = gyroscope, mag = magnitude, acc = accelerometer etc.
#   But we will remove the parantheses, commas etc. from the names.
#   Also change to pascal-casing (all words start with uppercase letters).
names(df)<-gsub("^t", "Time", names(df))
names(df)<-gsub("^f", "Frequency", names(df))
names(df)<-gsub("^angle", "Angle", names(df))
names(df)<-gsub("^subject", "Subject", names(df))
names(df)<-gsub("^activity_description", "ActivityDescription", names(df))
names(df)<-gsub("-mean", "Mean", names(df))
names(df)<-gsub("-std", "STD", names(df))
names(df)<-gsub("\\(", "", names(df))
names(df)<-gsub("\\)", "", names(df))
names(df)<-gsub("gravity", "Gravity", names(df))
names(df)<-gsub(",", "-", names(df))

# 5. Create a data set (from the one above) with the average of each variable
#    for each activity and each subject.
# ---------------------------------------------------------------------------
df_final <- df %>% group_by(Subject,ActivityDescription) %>% summarise_all(mean)

# Writing the df_final to a text file we can put at gitub together with this project
write.table(df_final, "FinalProjectDataset.txt", row.name = FALSE)

