Our original data (that is downloaded and used in run_analysis.R)
comes from the project in the following link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

In this project we prepare the data obtained for use in a summarised dataset:
FinalProjectDataset.txt


The the following modifications was done to the data in this project:
 (The changes are also documented with cde comments in run_analysis.R)
 
 - merged the training set data with the test set.
 - extracted only variables/columns concerning mean and standard deviation
 - included the description of activity in the dataset instead of the activity ID
 - removed parantheses, commas etc. from the column names
 - changed t to Time in parts of column names where applicable
 - changed f to Frequency in parts of column names where applicable
 - removed surplus dashes from the column names
 - Changen the column names to use Pascal casing (all words start with uppercase letter inside column names)
 - Did not change Mag to Magnitude, Gyro to Gyroscope etc. since these are self explaining
   (no need to make the column names to long).

Then in the end the dataset was summarised by Subject and Activity and mean of all measurements.

