library(dplyr)
library(reshape2)

## Step 1
## Merge the training and the test sets to create one data set.

# Read data from "UCI HAR Dataset" directory
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
varNames <- read.table("UCI HAR Dataset/features.txt")

Xdata <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"),
              read.table("UCI HAR Dataset/train/X_train.txt"))
Ydata <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"),
               read.table("UCI HAR Dataset/train/y_train.txt"))
subjects <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"),
                  read.table("UCI HAR Dataset/train/subject_train.txt"))

# Set variable names
names(Xdata) <- varNames$V2

# Combine data frames
df <- cbind(Xdata, activity_id=Ydata$V1, subject = subjects$V1)

## Step 2
# We only want variables with "mean()" or "std()" in the name!
# Find the indicies of the columns 
varIndicies <- which(grepl("mean\\(\\)|std\\(\\)", names(df)))

# Append indicies for "activity", "activity_id" and "subject"
varIndicies <- c(varIndicies, 
                 match("activity_id", names(df)), 
                 match("subject", names(df)))

# Select the columns we want
df <- df[,varIndicies]

## Step 3
# Merge in descriptive names for activity_id:s
df <- inner_join(df, activityLabels, by = c("activity_id" = "V1"))
df <- rename(df, activity = V2)

## Step 4
# Appropriately labels the data set with descriptive variable names
# Replace some abbreviations in the names with easier to understand names
names(df)<-gsub("^t", "time", names(df))
names(df)<-gsub("^f", "frequency", names(df))
names(df)<-gsub("Acc", "Accelerometer", names(df))
names(df)<-gsub("Gyro", "Gyroscope", names(df))
names(df)<-gsub("Mag", "Magnitude", names(df))

## Step 5
# From the data set, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.

molten <- melt(df, id.vars=c("activity_id", "activity", "subject"))
casted <- dcast(molten, subject + activity ~ variable, mean)

# Write output file = tidy data file!
write.table(casted, "tidy.txt", row.names = F, quote = F)
