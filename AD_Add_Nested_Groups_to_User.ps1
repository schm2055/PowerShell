#Gather nested distribution groups and add to user
$AllGroups = @()
$NewGroupsFound = @()
$ADGroups = Get-ADPrincipalGroupMembership SamAccountName
$AllGroups += $ADGroups
Foreach($ADGroup in $ADGroups){
    $NewGroupsFound = Get-ADPrincipalGroupMembership $ADGroup
    IF ($NewGroupsFound) {$AllGroups += $NewGroupsFound}
    DO{
    Foreach($NewGroupFound in $NewGroupsFound){
        $SubNewGroupFound = Get-ADPrincipalGroupMembership $NewGroupFound
            IF($SubNewGroupFound){
            $AllGroups += $SubNewGroupFound
            $NewGroupsFound += $SubNewGroupFound}
        }} While ($SubNewGroupFound)}
$AllGroups | out-gridview