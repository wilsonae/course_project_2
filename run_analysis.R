library(dplyr)
n <- -1

## pull in pertinent data
features <- read.table("features.txt")
features <- features[,2] # keep only the data column
xtest  <- read.table("test/X_test.txt", nrows = n)
xtrain <- read.table("train/X_train.txt", nrows = n)
xtotal <- rbind(xtest, xtrain) ## combine data

test_labels <- read.table("test/y_test.txt", nrows = n)
train_labels <- read.table("train/y_train.txt", nrows = n)
labels <- rbind(test_labels, train_labels) ## combine data

activity_labels <- read.table("activity_labels.txt")
labels <- activity_labels[unlist(labels),2]

subject_test <- read.table("test/subject_test.txt", nrows = n)
subject_train <- read.table("train/subject_train.txt", nrows = n)
subjects <- rbind(subject_test, subject_train)
subjects <- subjects[,1] # convert subjects to an integer vector

## clean up
rm(xtest)
rm(xtrain)
rm(test_labels)
rm(train_labels)

## get the columns that have the words 'mean' and 'std' in them
mean_indices <- grepl('mean', features)
std_indices  <- grepl('std',  features)
mean_std_indices <- mean_indices | std_indices

xtotal <- xtotal[,mean_std_indices]

names(xtotal) <- features[mean_std_indices]

xtotal$activity <- labels
xtotal$subject  <- subjects

grouped <- group_by(xtotal, activity, subject)
summarised <- summarise_each(grouped, funs(mean))
##rename
names <- names(xtotal)
names(summarised) <- c('activity','subject',paste0('mean_of_',names[1:79]))
summarised