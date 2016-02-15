# Coursera Assignment: Getting and Cleaning Data Course Project
This file explains the analysis process. 

## Goal-1: Merge the training and the test sets to create one data set.
Lets look at the data organization. There are 2 files - features.txt and 
activity_labels.txt that we need for both training and test data. The
test and the training data are in respective folders. 

First, read the features and activity_labels text files. We need the
content from features file to name columns in the test and training
data. We also need activity_labels to map activity id to names. 

Second, read data in the train folder. Use the data from features data
frame to name the columns of the test data frame. Combine the data from
each of the data frames to create a training_data DF. 

Repeat the procedure on test data as well. The output of this stage is
test_data DF. 

Combine training_data and test_data using rbind. Write the combined DF 
to a txt file.  

## Goal-2: Extracts only the measurements on the mean and standard deviation for each measurement.
Use grepl to filter out only those columns that have "mean" or "std"
characters. For simplicity we should grepl "activity_id" and
"subject_id" as well as we'll be using aggregation on these two
attributes later. 

## Goal-3: Use descriptive activity names
Use factor() to convert activity levels to activity labels. Also rename
activity_id to activity_name.

## Goal-4: Appropriately labels the data set with descriptive variable names. 
Use gsub and regular expressions to rename some of the columns. Some of
the easy pickings are dropping (), replacing 't' with 'time', 'f' with
'frequency' etc. Also, few of the abbreviations like 'Mag', 'Gyro' can
also be expanded. 

## Goal-5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Use aggregate() function to find means of all columns and group by
subject_id and activity_name. Use subset() to remove the older columns
from the output of aggregate() function. Write this data to
'tidy_data.txt'
