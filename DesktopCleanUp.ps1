#Script to run as a scheduled task on a regular basis to declutter your desktop
#input path you would like to use for the clean up directory
$clean_directory = <Path where you would the clean up directory to exist>
#input path to your/user desktop
$desktop = <path to user desktop>
New-Item -Path $clean_directory -ItemType Directory
Get-ChildItem -Path $desktop -Include *.txt, *.doc*, *.png, *.ppt*, *.jpeg, *.jpg, *.pdf, *.csv, *.xls*, *.pot*, *.xml*| Move-Item -Destination $clean_directory
