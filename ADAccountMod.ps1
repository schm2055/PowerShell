#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv [path]
#Run loops to set values for First Name, Last Name, Description, Display Name, and IP Phone
foreach ($column in $users) {
    set-aduser -Identity $column."user" -GivenName $column."FirstName" -Surname $column."LastName" -Description $column."Description" -DisplayName $column."DisplayName" -Add @{ipPhone="$column.IPPhone"}
} 
foreach ($column in $users) {
	Set-ADAccountPassword -Identity $column."user" -NewPassword $column."ResetPassword" -Reset
}