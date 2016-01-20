reset password x
Auto logon AD account x 
first namex 
last namex 
display name x
Description (AutoLogon User Account- Maple Grove (Jabber))x
IP phone

$users = import-csv C:\Users\admin\Desktop\ext.csv
foreach ($column in $users) {
    set-aduser $column.user -OfficePhone "800 555 $($column.ext)"
}

$users = import-csv <path>
foreach ($column in $users) {
    set-aduser $column.user -OfficePhone "800 555 $($column.ext)"
}

=============================================================================

$users = import-csv <path>
foreach ($column in $users) {
    set-aduser $column.user -GivenName $column.FirstName -Surname $column.LastName -Description $column.Description -DisplayName $column.DisplayName -Add @{ipPhone=$column.IPPhone}
}

foreach ($column in $users) {
	Set-ADAccountPassword $column.user -NewPassword $column.ResetPassword -Reset
}

========================================

Import-Module ActiveDirectory
$users = import-csv [path]
foreach ($column in $users) {
    set-aduser -Identity $column."user" -GivenName $column."FirstName" -Surname $column."LastName" -Description $column."Description" -DisplayName $column."DisplayName" -Add @{ipPhone="$column.IPPhone"}
} 
foreach ($column in $users) {
	Set-ADAccountPassword -Identity $column."user" -NewPassword $column.ResetPassword -Reset
}