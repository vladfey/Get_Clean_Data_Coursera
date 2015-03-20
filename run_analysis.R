# Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1. Merge training and the test data sets.
a1 <- read.table("train/X_train.txt")
a2 <- read.table("test/X_test.txt")
X <- rbind(a1, a2)
b1 <- read.table("train/subject_train.txt")
b2 <- read.table("test/subject_test.txt")
S <- rbind(b1, b2)
c1 <- read.table("train/y_train.txt")
c2 <- read.table("test/y_test.txt")
Y <- rbind(c1, c2)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, indices_of_good_features]
names(X) <- features[indices_of_good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

# 3. Use descriptive activity names to name the activities in the data set.
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"

# 4. Appropriately label the data set with descriptive activity names.
names(S) <- "subject"
merge <- cbind(S, Y, X)
write.table(merge, "merged_data.txt")

# 5. Create a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
uniqueSubjects = unique(S)[,1]
numSubjects = length(unique(S)[,1])
numActivities = length(activities[,1])
numCols = dim(merge)[2]
final = merge[1:(numSubjects*numActivities), ]
row = 1
for (s in 1:numSubjects) {
for (a in 1:numActivities) {
final[row, 1] = uniqueSubjects[s]
final[row, 2] = activities[a, 2]
tmp <- merge[merge$subject==s & merge$activity==activities[a, 2], ]
final[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
row = row+1
}
}
write.table(final, "dataset_averages.txt")
