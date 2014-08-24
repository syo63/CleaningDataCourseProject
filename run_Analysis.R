# Course Project
#syo63

library(reshape2)

#Read in Data Files for Train. Assumes WD is set to folder UCI HAR Dataset
x = read.table("train/X_train.txt", header=FALSE)
y = read.table("train/y_train.txt", header=FALSE)
z = read.table("train/subject_train.txt", header=FALSE)
header = read.table("features.txt", header=FALSE) # vector of 2

# set column names for Train
colnames(x) <- header[,2]   #Assigns 2nd column of features.txt as column names

#Add subject and activity to data frame
x["Subject"]<-z
x["Activity"]<-y

#Read in data files for Test and tidy up
a = read.table("test/X_test.txt", header=FALSE)
b = read.table("test/y_test.txt", header=FALSE)
c = read.table("test/subject_test.txt", header=FALSE)
colnames(a) <- header[,2]   #Assigns 2nd column of features.txt as column names

a["Subject"]<-c
a["Activity"]<-b

#Merge Data into Tidy Data Set
tidyData <- merge(x,a,all=TRUE)

#Subset Mean and Standard Deviation data
columnNames <- colnames(tidyData)
meanCol = grep("mean", columnNames, ignore.case=TRUE)
stdCol = grep("std", columnNames, ignore.case=TRUE)
subjectCol = grep("Subject", columnNames, ignore.case=TRUE)
activityCol = grep("Activity", columnNames, ignore.case=TRUE)
subsetData <- sort(append(meanCol,c(stdCol,subjectCol,activityCol)))
meanSTDdata<-tidyData[subsetData]

#Assign labels to Activity
labels = read.table("activity_labels.txt", header = FALSE)
activity = as.character(labels$V2)

for (n in 1:6)
{
  meanSTDdata$Activity[meanSTDdata$Activity==n]<-activity[n]
}

#reshape data by Subject, then Activity type
attach(meanSTDdata)
aggdata<-aggregate(meanSTDdata, by=list(Subject,Activity), FUN=mean, simplify=TRUE)
write.table(aggdata, "CourseProjectTidyData.txt", sep = "\t", row.names=FALSE)
detach(meanSTDdata)
