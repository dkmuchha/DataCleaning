run_analysis <- function(directory)
{	
	
	## Note: Using the crude way of reading and converting to data.table 
	##       as "fread" does not work for latest versions of R if the first 
	##       row has empty character. 
	##       https://r-forge.r-project.org/tracker/index.php?func=detail&aid=5413&group_id=240&atid=975  
	
	# Read features from the feature file 
	mean_std_cols <- read.table(paste(directory, "/features.txt", sep=""), header=FALSE)

	# Only feature names with mean()
	 mean_measurements <- subset(mean_std_cols, grepl("mean()", mean_std_cols$V2, fixed=TRUE), drop = FALSE)
    
	# Only feature names with std()
	std_measurements <- subset(mean_std_cols, grepl("std()", mean_std_cols$V2, fixed=TRUE), drop = FALSE)

	tot_filtered_measurements <- rbind(mean_measurements, std_measurements)

	# Read training data and extract only above columns from "X"
	x_train <- read.table(paste(directory, "/train/X_train.txt", sep=""), header=FALSE)[,sort(tot_filtered_measurements$V1)]
	y_train <- read.table(paste(directory, "/train/y_train.txt", sep=""), header=FALSE, col.names="Position")
	subject_train <- read.table(paste(directory, "/train/subject_train.txt", sep=""), header=FALSE, col.names="Subject")
	setnames(x_train, c(paste("V", tot_filtered_measurements$V1,sep="")),c(as.character(tot_filtered_measurements$V2)))
	
	# Converting the read "train" data to tables
	dt_train_x <- data.table(x_train)
	dt_train_y <- data.table(y_train)
	dt_train_subject <- data.table(subject_train)
	
	# Combining "train" data to a single data.table
	dt_train <- cbind(dt_train_x, dt_train_y, dt_train_subject)
	
	# Read test data and extract only above columns from "X"
	x_test  <- read.table(paste(directory, "/test/X_test.txt", sep=""), header=FALSE)[,sort(tot_filtered_measurements$V1)]
	y_test  <- read.table(paste(directory, "/test/y_test.txt", sep=""), header=FALSE, col.names="Position")
	subject_test  <- read.table(paste(directory, "/test/subject_test.txt", sep=""), header=FALSE, col.names="Subject")
	setnames(x_test, c(paste("V", tot_filtered_measurements$V1,sep="")),c(as.character(tot_filtered_measurements$V2)))
	
	# Converting the read "test" data to tables
	dt_test_x  <- data.table(x_test)
	dt_test_y  <- data.table(y_test)
	dt_test_subject  <- data.table(subject_test)
	 
	# Combining "test" data to a single data.table
	dt_test  <- cbind(dt_test_x, dt_test_y, dt_test_subject)
	
	# Q1) Combine the test and train datasets 
	dt_complete_data <- rbind(dt_train, dt_test)
	 
	# Q2) Give logical names to the columns and rows
	activity_lables <- read.table(paste(directory, "/activity_labels.txt", sep=""), header=FALSE)
	dt_activity <- data.table(activity_lables)
	
	# Giving same name to the "Position" column so as to facilitate smooth merging of two data.tables
	setnames(dt_activity,c(1,2),c("Position", "Activity"))

	# Setting the same key for both data.table
	setkey(dt_complete_data, Position); 
	setkey(dt_activity,Position);
	dt_merge <- merge(dt_complete_data, dt_activity)
	
	# Q5) Make a tidy dataset
	dt_melt <- melt(dt_merge, id=c("Activity", "Position", "Subject"), measure.vars=c(as.character(tot_filtered_measurements$V2)))
	
	# Writing the data into a tab seperated file
	write.table(dt_merge, file = "output_melt_complete.txt", append = FALSE, quote = TRUE, sep = "\t", eol = "\n", 
				na = "NA", dec = ".", row.names = FALSE, col.names = TRUE, qmethod = c("escape", "double"))
	
	# Tidying data per position
	dt_position <- dcast(dt_melt, variable ~ Activity, mean)
	
	# Writing the data into a tab seperated file
	write.table(dt_position, file = "output_activity.txt", append = FALSE, quote = TRUE, sep = "\t", eol = "\n", 
				na = "NA", dec = ".", row.names = FALSE, col.names = TRUE, qmethod = c("escape", "double"))
	
	# Tidying data per subject
	dt_subject <- dcast(dt_melt, variable ~ Subject, mean)

	# Writing the data into a tab seperated file
	write.table(dt_subject, file = "output_subject.txt", append = FALSE, quote = TRUE, sep = "\t", eol = "\n", 
				na = "NA", dec = ".", row.names = FALSE, col.names = TRUE, qmethod = c("escape", "double"))

	# Tidying data per activity per subject
	dt_activity_subject <- dcast(dt_melt, variable ~ Activity + Subject, mean)

	# Writing the data into a tab seperated file
	write.table(dt_activity_subject, file = "output_activity_subject.txt", append = FALSE, quote = TRUE, sep = "\t", eol = "\n", 
				na = "NA", dec = ".", row.names = FALSE, col.names = TRUE, qmethod = c("escape", "double"))

}

