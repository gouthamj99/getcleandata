# Coursera: Getting and cleaning data course project. 
# Date: 2016-Feb-14
# 
# * Program Goals *
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject.
# * Program Output *
# This program combines test and training data to generate
# a combined data file. It also genererates a second file 
# which has aggregated data for a subset of features from the 
# first file. 
# * Assumption *
# The project data is available in the working directory. 

## Goal-1: Merge the training and the test sets to create one data set.

# Read data from the files that are common to both test and training data. 
features = read.table("UCI HAR Dataset/features.txt")

activities = read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) = c("activity_id", "activity_name")

# Read training data
training_subjects = read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(training_subjects) = "subject_id"

training_observations = read.table("UCI HAR Dataset/train/x_train.txt")
colnames(training_observations) = features[, 2]

training_activities = read.table("UCI HAR Dataset/train/y_train.txt")
colnames(training_activities) = "activity_id"

# Combine data from training data
training_data = cbind(training_subjects, training_activities, training_observations)

# Repeat the above procedure on test data as well. 

# Read test data
test_subjects = read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(test_subjects) = "subject_id"

test_observations = read.table("UCI HAR Dataset/test/x_test.txt")
colnames(test_observations) = features[, 2]

test_activities = read.table("UCI HAR Dataset/test/y_test.txt")
colnames(test_activities) = "activity_id"

# Combine data from test data
test_data = cbind(test_subjects, test_activities, test_observations)

# Combine test_data and training_data
combined_data = rbind(training_data, test_data)

# Now write combined_data to a file. 
write.table(combined_data, 'full_data.txt', row.names=TRUE, sep="\t")

## Goal-2: Extracts only the measurements on the mean and standard deviation for each measurement.
columns_combined_data = colnames(combined_data)

# Select columns from combined data that we need for further processing: subject_id, activity_id, colnames with "mean" and colnames with "std"
required_columns = grepl("activity_id", columns_combined_data) | grepl("subject_id", columns_combined_data) | grepl("[Mm]ean", columns_combined_data) | grepl("[Ss]td", columns_combined_data)

# Get the required data
required_data = combined_data[required_columns]

## Goal-3: Use descriptive activity names
required_data$activity_id = factor(required_data$activity_id, levels = activities[, 1], labels = activities[, 2])
colnames(required_data) = gsub("activity_id", "activity_name", colnames(required_data))

## Goal-4: Appropriately labels the data set with descriptive variable names.
colnames_required_data = colnames(required_data)

colnames_required_data = gsub("\\()", "", colnames_required_data)
colnames_required_data = gsub("^(t)", "time", colnames_required_data)
colnames_required_data = gsub("^(f)", "frequency", colnames_required_data)
colnames_required_data = gsub("Mag", "Magnitude", colnames_required_data)
colnames_required_data = gsub("Acc", "Acceleration", colnames_required_data)
colnames_required_data = gsub("Gyro", "Gyroscope", colnames_required_data)
colnames_required_data = gsub("-mean", "Mean", colnames_required_data)
colnames_required_data = gsub("-std", "StandardDeviation", colnames_required_data)

colnames(required_data) = colnames_required_data

## Goal-5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Find means of all columns
aggregate_data = aggregate(required_data, by=list(subject_id=required_data$subject_id, activity_name=required_data$activity_name), mean, na.rm=TRUE)

# Drop the repeated subject_id and activity_name column
aggregate_data = subset(aggregate_data, , -c(3, 4))

# Now write aggregate_data to a file. 
write.table(aggregate_data, 'tidy_data.txt', row.names=TRUE, sep="\t")

