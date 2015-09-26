#Load the raw data
testraw<-read.table("./test/X_test.txt")
trainraw<-read.table("./train/X_train.txt")
datas<-rbind(testraw,trainraw)

#Load the Subject data and combine into a single dataset
testSubjects<-read.table("./test/subject_test.txt")
trainSubjects<-read.table("./train/subject_train.txt")
subject<-rbind(testSubjects,trainSubjects)

#Load the Activity data and combine into a single dataset
testActivities<-read.table("./test/y_test.txt")
trainActivities<-read.table("./train/y_train.txt")
activities<-rbind(testActivities,trainActivities)

#Combine all three datasets into one data frame (subject, activities, raw data)
datas<-cbind(datas,subject,activities)

#Read in the column names from features.txt
features<-read.table("features.txt")

#Set the column names for the entire dataset.  Use make.names() to make them R-friendly.
names(datas)<-c(make.names(features$V2),"Subject","Activity")

#Narrow dataset down to just mean and std measurements.  Grepping for 'mean' and 'std' fetches all such measurement columns.
sub<-datas[ ,grepl("mean", names(datas)) | grepl("std", names(datas)) | names(datas)=="Subject" | names(datas)=="Activity"]

#Let's make the Activity column more friendly by  merging it with the Activity Labels
activitylables<-read.table("activity_labels.txt")
names(activitylables)<-c("Activity", "ActivityLabel")
results<-merge(sub,activitylables, by="Activity")

#Load dplyr so we can summarise_each
library("dplyr")
#Create a new data frame that contains the results of grouping the dataset by Subject and Activity and taking mean of every value.
MeanResults<-group_by(results, Subject, ActivityLabel) %>% summarise_each(c("mean"))

write.table(MeanResults, file="tidymeandata.txt", row.name=FALSE)

