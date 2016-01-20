#This is a script to copy the SER data spreadsheet to another location to ensure that we do not lose the information
Copy-Item "\\is7-server.healthpartners.int\EpicProj\DataCourier\MigrationSpreadsheets\DATA COURIER - SER (As of 4.15.13).xls" "\\isserver\Security Admin\AndrewSchmitt\SERSpreadsheet" -Force 

