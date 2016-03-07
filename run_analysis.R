###############################################################################
##Mission Description :                                                      ##
##1.Merges the training and the test sets to create one data set.            ##
##2.Extracts only the measurements on the mean and standard deviation        ##
##  for each measurement.                                                    ##
##3.Uses descriptive activity names to name the activities in the data set   ##
##4.Appropriately labels the data set with descriptive variable names.       ##
##5.From the data set in step 4, creates a second, independent tidy data set ##
##  with the average of each variable for each activity and each subject.    ##
###############################################################################
## Load Package
library(dplyr)
library(tidyr)

#########################################################################
##STEP1 : Download Data and Unzip                                      ##
##1. Check if the data was already downloaded                          ##
##2. If not, download the zip file and unzip all                       ##
#########################################################################
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("UCI HAR Dataset")) {
  download.file(url,"UCI.zip")
  unzip("UCI.zip")
}

#########################################################################
##STEP2 : Read all required file                                       ##
##1.Includes activity_labels,subjects, features, Test, Train data      ##
##2.Tansfter to tbl_df format by dplyr package                         ##
#########################################################################
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE) %>% tbl_df()
features<-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE) %>% tbl_df()
test_labels<-read.table("./UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE) %>% tbl_df()
test_data<-read.table("./UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE) %>% tbl_df()
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE) %>% tbl_df()
train_labels<-read.table("./UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE) %>% tbl_df()
train_data<-read.table("./UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE) %>% tbl_df()
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE) %>% tbl_df()

#########################################################################
##STEP3 : Merge files                                                  ##
##1.Merge the row of both test and train data set                      ##
#########################################################################
all_df<-bind_rows(test_data,train_data)  
##Mission 1 completed - Merge the test and train data set

#########################################################################
##STEP4 : Get only "mean" and "std" variables                          ##
##1.Look up the "features" table and extract names having "mean","std" ##
##2.Keep only "mean" and "std" data                                    ##
#########################################################################
index_mean_std<-grep("mean|std",features$V2)
mean_std_df<-select(all_df,index_mean_std)  
##Mission 2 completed - Extracts only the measurements on the mean and standard deviation
  
#########################################################################
##STEP5 : name the vactivity according to the activity_label.txt       ##
##1. Merge the test/train labels.txt and subject.txt into the data set ##
#########################################################################
if(names(test_labels)=="V1"){test_labels<-rename(test_labels, Activity=V1)}
if(names(test_subject)=="V1"){test_subject<-rename(test_subject, Subject=V1)}
if(names(train_labels)=="V1"){train_labels<-rename(train_labels, Activity=V1)}
if(names(train_subject)=="V1"){train_subject<-rename(train_subject, Subject=V1)}
mean_std_df<-bind_cols(bind_rows(test_subject,train_subject),bind_rows(test_labels,train_labels),mean_std_df)

mean_std_df$Activity=as.character(mean_std_df$Activity)
for(i in 1:nrow(mean_std_df)){
  mean_std_df$Activity[i]=
  as.character(activity_labels[as.numeric(mean_std_df$Activity[i]),2])
}                                                      
##Mission 3 completed - Activity named

#########################################################################
##STEP6 : name the variables according to the features.txt             ##
##1. look up the variable names in features.txt                        ##
##2. Rename the only mean and std columns                              ##
#########################################################################
mean_std_df<-as.data.frame(mean_std_df)
for(i in 3:ncol(mean_std_df)){
  colnames(mean_std_df)[i]<-features[index_mean_std[i-2],2]
} 
## Mission 4 completed - Column variable named(Not tidy data yet)

#########################################################################
##STEP7 : get average data of each activity and subject                ##
##1. Arrange the data set by subject and activity order                ##
##2. Split the variable name for tidy process                          ##
##3. Calculate the mean for each subject and activity                  ##
##4. Create tidy data set                                              ##
#########################################################################
mean_std_df<-tbl_df(mean_std_df)
mean_std_df$Subject<-as.integer(mean_std_df$Subject)
mean_std_df_sorted<-arrange(mean_std_df,Subject,Activity)
mean_std_df_sorted=as.data.frame(mean_std_df_sorted)

variableNames<-names(mean_std_df_sorted[3:ncol(mean_std_df_sorted)])
splitVNames<-strsplit(variableNames,"\\-")

avg_df=data.frame(Subject=NULL,
                  Activity=NULL,
                  Features=NULL,
                  Type=NULL,
                  Direction=NULL,
                  Average=NULL)

for(i in 1:30){
  print(c("Processing Subject :",i))
  for(j in sort(unlist(activity_labels[,2]))){
      
    tmp<-which(mean_std_df_sorted$Subject==i&mean_std_df_sorted$Activity==j)
      tmp_mean<-sapply(mean_std_df_sorted[tmp,3:ncol(mean_std_df_sorted)],mean)
      tmp_mean_df<-as.data.frame(tmp_mean)%>% as.list()
      print(c(j,length(tmp_mean)))
      tmp_df=data.frame(Subject=rep(i,length(tmp_mean)),
                    Activity=rep(j,length(tmp_mean)),
                    Features=sapply(splitVNames,function(x) x[1]),
                    Type=sub("\\()","",sapply(splitVNames,function(x) x[2])),
                    Direction=sapply(splitVNames,function(x) x[3]),
                    Average=tmp_mean_df)
      avg_df<-rbind(avg_df,tmp_df)
  } 
}
names(avg_df[6])<-"Average"


#########################################################################
##STEP8 : write table as txt file                                      ##
#########################################################################
