Import-Module ActiveDirectory
$Userslist=import-csv "[path]"
$Domain='@[domain]'
ForEach ($User in $Userslist){
    $User.FN
    $User.MA
    $User.LN
    $User.Account
    $User.Company
    $User.Department
    $User.Description
    $User.Email
    $User.Phone
    $User.Manager
    $User.Title
    $User.Copy
    $User.OU
    $User.Pass
    $FullName=$User.FN+" "+$User.LN
    $UPN=$User.Email
    $UNC='\\[FILESERVER UNC]\'
    $HomeDirectory=$UNC+$User.Account+'$'

###############
##Create User##
###############
New-ADUser -Name $FullName -GivenName $User.FN -Surname $User.LN -SamAccountName $User.Account -DisplayName                 $FullName -UserPrincipalName $UPN  -Company $user.Company`
   -Department $user.Department -Description $user.Description -EmailAddress $user.Email  -Title $user.Title  -HomeDirectory $HomeDirectory -HomeDrive 'P:'`
-PasswordNeverExpires $False -Enabled $True -StreetAddress $ADDRESS -City $CITY -State $STATE -PostalCode $ZIP -Country 'US' `
      -Path $User.OU -AccountPassword (ConvertTo-SecureString -AsPlainText "P@ssword1" -Force) -passThru -Manager $user.Manager -OfficePhone $User.Phone
Set-ADUser -Identity $User.Account -ChangePasswordAtLogon $False
##########################
##Set Group Memberships.##
##########################
# Retrieve group memberships.
$SourceUser = Get-ADUser $User.Copy -Properties memberOf
$TargetUser = Get-ADUser $User.Account -Properties memberOf
$List = @{}
ForEach ($SourceDN In $SourceUser.memberOf){
    # Add this group to hash table.
    $List.Add($SourceDN, $True)
    # Bind to group object.
    $SourceGroup = [ADSI]"LDAP://$SourceDN"
    # Check if target user is already a member of this group.
    If ($SourceGroup.IsMember("LDAP://" + $TargetUser.distinguishedName) -eq $False){
        # Add the target user to this group.
        Add-ADGroupMember -Identity $SourceDN -Members $User.Account
      }
    }
    # Enumerate direct group memberships of target user.
ForEach ($TargetDN In $TargetUser.memberOf){
    # Check if source user is a member of this group.
    If ($List.ContainsKey($TargetDN) -eq $False){
        # Source user not a member of this group.
        # Remove target user from this group.
        Remove-ADGroupMember $TargetDN $User.Account
    }
}
####################
##Create UserShare##
####################
$CreateShare={
#Variables

$User=import-csv "$ServerPATHTO\enrollment.csv"
$User.Account
$SharePath='F:\Users\Shares\'+$User.Account
$ShareName=$User.Account+'$'
$Description='Personal Share for '+$User.Account

#Create Folder
IF (!(test-path $SharePath)){
write-host "Creating folder: " $SharePath -ForegroundColor green
New-Item -Path $SharePath -ItemType directory
} else {
write-host "The folder already exists: "$SharePath -ForegroundColor Yellow
    }

#Set NFTS Permissions
$Acl = Get-Acl $SharePath
$acl.SetAccessRuleProtection($True, $False)
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($User.Account,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("Administrators","FullControl", "ContainerInherit,     ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $SharePath $Acl
write-host "Settings NTFS Permissions on:" $SharePath "for" $User.Account -ForegroundColor green

# Create Share Server 2012
Import-Module Smb*
IF (!(Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
write-host "Creating share: " $ShareName -ForegroundColor Yellow
New-SmbShare –Name $ShareName –Path $SharePath –Description $Description –FullAccess 'Domain Admins',$User.Account
write-host "The Share has been created: " $ShareName -ForegroundColor Green
} else {
write-host "The share already exists: " $ShareName -ForegroundColor Green
    }
}
Invoke-Command -ComputerName $FILESERVER -scriptblock $CreateShare

##########################
##Start AAD Connect Sync##
##########################
#AADConnect Sync
Write-Host "Initializing Azure AD Delta Sync..." -ForegroundColor Yellow
Invoke-Command -Computername $AADCONNECTSERVER -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }

#Connect to O365
Connect-MSolService

#Pause until account synced
while (!( Get-MsolUser -UserPrincipalName $upn -ErrorAction SilentlyContinue )){
    Write-Output "Waiting for Azure sync: $WaitTime"
    Start-Sleep -Seconds 5
    $WaitTime += 5
}
Write-Host " | Azure AD Delta Sync Complete!" -ForegroundColor Green
#Set UsageLocation
Get-MsolUser -UserPrincipalName $upn | Set-MsolUser -UsageLocation "US"
Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses "litwareinc:ENTERPRISEPACK" 
   }