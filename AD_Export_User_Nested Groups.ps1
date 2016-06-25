#Import CSV user list, gather all groups and nested groups for user into CSV output
Function Get-NestedGroups 
{
param ($strGroup)
$currentGroupGroups = (Get-ADGroup –Identity $strGroup –Properties Memberof).Memberof
ForEach ($memGroup in $currentGroupGroups)
    {
    $strMemGroup = ($memGroup -split ",*..=")[1] 
    $strMemGroup | Select-Object @{name='name';Expression={$_}} | export-csv -Append -NoTypeInformation -Path $StrName
    Get-NestedGroups -strGroup $strMemGroup
    } 
}

$list = Import-Csv "C:\path\users.csv"
foreach($user in $list)
{
$usersGroups = (Get-ADUser –Identity $user.name –Properties MemberOf).MemberOf
ForEach ($group in $usersGroups) 
    {
    $strGroup = ($group -split ",*..=")[1] 
    $StrName="C:\path\" + $user.name + ".csv"
    $strGroup | Select-Object @{name='name';Expression={$_}} | export-csv -Append -NoTypeInformation -Path $StrName
    Get-NestedGroups -strGroup $strGroup
    }
 $strGroup
 }