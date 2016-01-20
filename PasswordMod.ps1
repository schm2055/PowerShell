#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv C:\Users\a3699\Desktop\Testing.csv
#Run loops to set values for First Name, Last Name, Description, Display Name, and IP Phone
foreach ($column in $users) {
	Set-ADAccountPassword -Identity $column."user" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$column.ResetPassword" -Force)
}