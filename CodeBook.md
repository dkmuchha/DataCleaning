Descriptive Data:
=================

- features_info.txt: Description of several key features. Also explains the process of collecting the observation details  

- features.txt: List of 561 features along with the numerical id

- activity_labels.txt: Activity names corresponding to its id. There are 6 activities defined here.

Variable train Data:
====================

- train/X_train.txt: File contains training data values for features descirbed in features.txt

- train/y_train.txt: List of activities corresponding to each observation row in x_train.txt

- train/train_subject.txt: List of subjects corresponding to each observation row in x_train.txt

Variable test Data:
===================

- test/X_test.txt: File contains test data values for features descirbed in features.txt

- test/y_test.txt: List of activities corresponding to each observation row in x_test.txt

- test/test_subject.txt: List of subjects corresponding to each observation row in x_test.txt

**************************************************************************************************************************************
Output Files:
=============

- output_melt_complete: File contains the entire merged data set

- output_subject: Tidy dataset with variable averages corresponding to each subject

- output_activity: Tidy dataset with variable averages corresponding to each activity

- output_activity_subject: Tidy dataset with variable averages corresponding to each activity and each subject 

**************************************************************************************************************************************
Code Flow:
==========

- Seperate out mean and std deviation measurement coulmns

- Read training data from "x", "y" and "subject" files and combine it into a data.table

- Read test data from "x", "y" and "subject" files and combine it into a data.table

- Combine the enter the test and train data into a single data table

- Remove activities from the activities.txt file and merge with the above dataset to get readable names for each activity

- Melt the newly formed data.table inorder to tidy the dataset as per the instructions

- Use "dcast" to tidy data per activity, per subject and then per activity per subject

- Write the resulting dataset to files