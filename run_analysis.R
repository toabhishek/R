# read X_test, X_train datasets and merging the two datasets in dataframe 'xmerge'
xtest = read.table("X_test.txt")
xtrain = read.table("X_train.txt")


xmerge = merge(xtest, xtrain, all = TRUE)

#read name of the variable from feature.txt file and add the names as column headers in 'xmerge
features = read.table("features.txt")
names(xmerge) = as.character(features$V2)

# adding subject IDs together
subtest = read.table("subject_test.txt")
subtrain = read.table("subject_train.txt")
subjectID = rbind(subtest, subtrain)

# select variables containing mean and standard deviation from xmerge and store in dataframe 'mean_std_data'
mean_std_data = select(xmerge, contains("mean"), contains("std"))
mean_std_data$studentID = subjectID$V1

# reading y_test and y_train datasets adding the two datasets in row-wise in dataframe 'ymerge' 
ytest = read.table("y_test.txt")
ytrain = read.table("y_train.txt")
ymerge = rbind(ytest, ytrain)

# reading activity labels and replace ymerge variables with activity descriptions
activitylabel <- read.table("activity_labels.txt")
label <- activitylabel$V2
ymerge$V1 <- factor(ymerge$V1, labels = label)

# adding column in mean_std_data with activity descriptions
mean_std_data$activity = ymerge$V1

#grouping data by activity and studentID, and averaging each variable
grpd_data <- group_by(mean_std_data, activity, studentID)
final_data = summarise_each(grpd_data, funs(mean))
return(final_data)

#writing data to a txt file
write.table(final_data, file="final_data.txt", row.name = FALSE)





