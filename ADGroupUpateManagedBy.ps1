#A script to update group managers when a change of manager occurs

#Prompt user for current manager
$CurrentManager = read-host "Enter the name of the current manager Ex: SamAccount Name (NT Logon UserName)"
#Prompt user for new manager
$NewManager = read-host "Enter the name of the new manager Ex: SamAccount Name (NT Logon UserName)"

Get-Adgroup -LDAPFilter "(ManagedBy=$((Get-ADUser -Identity "$CurrentManager").distinguishedname))" | Set-Adgroup -ManagedBy "$NewManager"

