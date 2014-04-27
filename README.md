DataCleaning
============

Aim: The purpose of the code is to take the "Samsung" data as input and produce tidy human readable data

Before running the run_analysis.R script make sure that you have the data.table and reshape2 packages in the library.
This can be done using the "install.packages(<package-name>)" command followed by the "library(<package-name>)" command.

Steps to run the code correctly:

Step 1: Download the dataset folder and run_analysis.R in the working directory
Step 2: Run: source("run_analysis.")
Step 3: Run: run_analysis(<directory-name>)

The expected output:

Once the code completes there should be 4 tab delimited output files in the working directory. The files will be named as follows:
1) output_activity_subject.txt
2) output_activity.txt
3) output_subject.txt
4) output_melt_complete.txt

Descriptions of all the files is present in CodeBook.md file
