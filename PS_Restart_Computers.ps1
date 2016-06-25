#batch restart of computers on a network

function restart_eis
{
    Write-host "Restarting all inactive DEPT_NAME_HERE computers"
    #grab all the computers from a dept
    $dept = Get-ADComputer -Filter { Name -like "DEPT_NAME_*PC" -or Name -like "DEPT_NAME_*PC_TYPE_2" } | select -Expand Name
    foreach($pc in $dept) {
        $computerName = $pc
        $loginCheck = Get-WMIObject -class Win32_computerSystem -ComputerName $computerName | select -expand username

        $loginCheck

        #check if null
        if (!$loginCheck) {
            restart-computer $computerName -force
        }
    }
}



"Type help for help"
Do{
    $input = Read-Host "Enter a command"
    if($input -eq "exit")
        {"Exiting..."}
    elseif($input -eq "help"){
        "This will restart all unused PCs and BMWs prefaced by EED"
    }
    elseif($input -eq "dept1"){
        restart_dept1
    }
    else{
        "Not a recognized command"    
    }

}#end of input loop
Until($input -eq "exit")
restart_inactive_eis_dept.txtOpen