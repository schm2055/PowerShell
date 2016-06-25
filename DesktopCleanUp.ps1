New-Item -Path C:\Users\schm2055\Desktop\Cleanup -ItemType Directory
Get-ChildItem -Path C:\Users\schm2055\Desktop\* -Include *.txt, *.png, *.ppt*, *.jpeg, *.jpg, *.pdf, *.csv, *.xls*, *.pot*, *.xml*, *.doc*| Move-Item -Destination C:\Users\schm2055\Desktop\Cleanup
