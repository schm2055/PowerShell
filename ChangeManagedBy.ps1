#Prompt user for current manager
$CurrentManager = read-host "Current Manager Ex: SamAccount Name (NT Logon UserName)"
#Prompt user for new manager
$NewManager = read-host "New Manager Ex: SamAccount Name (NT Logon UserName)"

Get-Adgroup -LDAPFilter "(ManagedBy=$((Get-ADUser -Identity "$CurrentManager").distinguishedname))" | Set-Adgroup -ManagedBy "$NewManager"

