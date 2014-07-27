# ReadMe for run_analysis.R

The script has only been tested with R version 3.1.0 (64bit) on Windows 7 (64bit).
*Run at your own risk!*

## Description of raw data and its source
The raw data are derived from accelerometer and gyroscope sensor signals from a Samsung Galaxy S 
smartphone. 
The data for this project was obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## How to use the script
Running the script requires that the raw dataset has been obtained, e.g. 
from the above-mentioned source. The archive should be unzipped - preferably 
in a separate directory - keeping the original directory structure in the archive 
intact. The directory where the archive has been unzipped should be set as the
working directory using the `setwd()` command in R. 

## Short description of the working of the script
From the raw data, the script produces a wide-form tidy intermediate and final 
dataset, tidy and wide-form being defined as per Hadley Wickham's article 
'Tidy Data' (Journal of Statistical Software, Vol. VV, Issue II).

Deriving tidy data from the raw data is done with the following steps:

-Getting variable names from the `features.txt` file.

-Determining which variables are means and standard deviations using the search strings 'mean()' 
 and 'std()' on variable names. Variables with only 'mean' (without brackets) in their name were 
 not considered to be true means in the statistical sense and are therefore discarded. 
 This step produces a logical vector for subsetting the original dataset.

-Reading the variable data from (`test/X_test.txt`), discarding unwanted variables by subsetting
 and combining it with the subject data (from `test/subject_test.txt`) and activity data (from 
 `test/y_test.txt`) data.  

-Reading the variable data (from `train/X_train.txt`), discarding unwanted variables by subsetting
 and combining it with the subject data (from `train/subject_train.txt`) and activity data (from 
 `train/y_train.txt`) data.

-Combining the train and test data.

-Replacing the numerical activity IDs by descriptive names. 

-Expanding abbreviations ('Mag' to 'Magnitude', 'Acc' to 'Accelerometer' etc.). The element 'BodyBody' in variable names has been
 left unchanged.

-Producing the final summary dataset containing the average of each variable for each activity and each 
 subject using the `aggregate` command and writing it to disk.
 
The resulting tidy dataset can be read into R using the `read.table` command.

Michael Gierhake 
<michael@xindaya.de>
2014-07-27