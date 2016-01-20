#Import AD Module
Import-Module ActiveDirectory
#Import CSV Spreadsheet
$users = import-csv "\\isserver\SHARED\rick\Dental\Jabber_Update_10132015.csv"
#Run loops to set values for First Name, Last Name, Description, Display Name, and IP Phone
foreach ($column in $users) {
    set-aduser -Identity $column."user" -GivenName $column."FirstName" -Surname $column."LastName" -Description $column."Description" -DisplayName $column."DisplayName" -Add @{ipPhone=$column."IPPhone"}
} 
Read-Host -Prompt "Press Enter to exit"