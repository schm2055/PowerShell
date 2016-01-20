#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv <path>
#Run loop to set values for First Name, Last Name, Display Name
foreach ($column in $users) {
    set-aduser -Identity $column."user" -GivenName $column."FirstName" -Surname $column."LastName" -DisplayName $column."DisplayName" 
} 
Read-Host -Prompt "The Script has Finished"