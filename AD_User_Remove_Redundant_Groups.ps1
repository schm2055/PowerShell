#Compare two sets of group members and remove users from one group that are in the other

$AutoGroup = Get-ADGroupMember Test-M-Group1
$ManualGroup = Get-ADGroupMember Test-A-Group1

$InBothGroups = diff $AutoGroup $ManualGroup -IncludeEqual -ExcludeDifferent | select -exp inputobject

$InBothGroups | % {Remove-ADGroupMember $ManualGroup}