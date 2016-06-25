If (Get-ADSyncConnectorRunStatus) {Write-Warning "A sync is already in progress"}
Else {
    Write-Host "Initializing Azure AD Delta Sync..." -ForegroundColor Yellow
    Try {
        Start-ADSyncSyncCycle -PolicyType Delta -ErrorAction Stop

        #Wait 10 seconds for the sync connector to wake up.
        Start-Sleep -Seconds 10

        #Display a progress indicator and hold up the rest of the script while the sync completes.
        While(Get-ADSyncConnectorRunStatus){
            Write-Host "." -NoNewline
            Start-Sleep -Seconds 10
        }

        Write-Host " | Complete!" -ForegroundColor Green

    }
    Catch {Write-Error $_}
    Write-Host "Press any key to continue."
    $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
    $HOST.UI.RawUI.Flushinputbuffer()
}