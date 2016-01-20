New-Item -Path C:\Users\Sparta-Drew\Desktop\Cleanup -ItemType Directory
Get-ChildItem -Path C:\Users\Sparta-Drew\Desktop\* -Include *.txt, *.png, *.ppt*, *.jpeg, *.jpg, *.pdf, *.csv, *.xls*, *.pot*, *.xml*| Move-Item -Destination C:\Users\Sparta-Drew\Desktop\Cleanup
