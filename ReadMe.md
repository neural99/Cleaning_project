#Getting and Cleaning Data - Course Project

The script `run_analysis.R` is a processing script transforming the raw
UCI HAR Dataset. Note that the script expect the data downloaded and 
unpacked in a folder called `UCI HAR Dataset`. The script does the following,

1. Reads the activity labels from `activity_labels.txt`
2. Reads the features labels `features.txt`
3. Reads both the training data from the subdirectory `train` and the test data
from the subdirectory `test` and merges the datasets
4. Extracts only the variables with `mean()` or `std()` in the name from the combined dataset
5. Changes the abbreviations the variable names (found in `features.txt`) to full length names
6. Creates a new tidy dataset consisting of the average of each variable for each activity and each subject.

**NOTE: You need to read in the dataset with `check.names = F` otherwise the 
column names will be mangled by R!**