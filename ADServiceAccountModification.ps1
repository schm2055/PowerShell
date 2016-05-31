#Script used to modify the user accounts of several service based accounts in a .csv

#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv [path]
#Run loops to set values for First Name, Last Name, Description, Display Name, and IP Phone
#Need a .csv with columns: User, First Name, Last Name, Description, DisplayName, IP Phone, and ResetPassword
foreach ($column in $users) {
    set-aduser -Identity $column."user" -GivenName $column."FirstName" -Surname $column."LastName" -Description $column."Description" -DisplayName $column."DisplayName" -Add @{ipPhone="$column.IPPhone"}
} 
foreach ($column in $users) {
	Set-ADAccountPassword -Identity $column."user" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $column."ResetPassword" -Force)
}
Read-Host -Prompt "Success! Press Enter to exit"