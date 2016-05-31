#This is a script to copy a file from one location to the next. This can be run as a scheduled task to ensure data is not lost.
Copy-Item "[original file path goes here]" "[destination file path goes here]" -Force 

