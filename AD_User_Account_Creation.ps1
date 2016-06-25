#Create AD User Accounts

#Import AD silently
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
 
#Grab dynamic variables
$firstName = Read-Host "First Name"
$firstInitial = Read-Host "First Initial"
$lastName = Read-Host "Last Name"
$title = Read-Host "Title"
$team = Read-Host "Team"
 
#Set static variables
$homePath = "\\this\is\home\"
$domain = '@' + (Get-ADDomain).dnsroot
$lowerLN = $lastName.ToLower()
$lowerFI = $firstInitial.ToLower()
$logon = $lowerLN + $lowerFI
 
#Add our user
$mkUser = {
New-ADUser `
-Name "$firstName $lastName" `
-GivenName $firstName `
-Surname $lastName `
-SamAccountName "$logon" `
-UserPrincipalName "$logon$domain" `
-DisplayName "$firstName $lastName" `
-Department $team `
-Title $title `
-AccountPassword (ConvertTo-SecureString "MyPassw0rd1%" -AsPlainText -Force) `
-ScriptPath "logonscript.whatever" `
-HomeDrive "Z:" `
-HomeDirectory "$homePath$logon" `
-ChangePasswordAtLogon $true `
-Enabled $true `
-PassThru
}
 
#Add them to the basic groups
$mkGroups = {
Get-ADGroup  -filter {Name -like "NeededGroup1"} | Add-ADGroupMember -Members "$logon"
Get-ADGroup  -filter {Name -like "NeededGroup2"} | Add-ADGroupMember -Members "$logon"
Get-ADGroup  -filter {Name -like "NeededGroup3"} | Add-ADGroupMember -Members "$logon"
Get-ADGroup  -filter {Name -like "NeededGroup4"} | Add-ADGroupMember -Members "$logon"
}
 
$complete = {
Write-Host "User has been created and added to the following groups:"
Get-ADUser -Properties memberof $logon | select -expand memberof | Get-ADGroup | sort name | select name
}
 
#Find existing users
if ( -not (Get-ADUser -LDAPFilter “(sAMAccountName=$logon)”))
{
& $mkUser
& $mkGroups
& $complete
 }
else
 {
Write-Host "The username already exists"
$logon = Read-Host "Please enter a new username in lowercase"
& $mkUser
& $mkGroups
& $complete
}