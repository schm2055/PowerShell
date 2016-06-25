#Update the password for multiple users based on a .csv file
#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv [path to CSV]
#Run loops to set values for ResetPassword
##Need a .csv with columns: User, and ResetPassword
foreach ($column in $users) {
	Set-ADAccountPassword -Identity $column."user" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $column."ResetPassword" -Force)
}
Read-Host -Prompt "Success! Press Enter to exit"