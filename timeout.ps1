###################################################################
#     Script to check if screen saver is working as intended
#
#     11/22/2016 - script completion
#     11/28/2016 - added option for user to select what time the script would run
#
####################################################################


$userInput = Read-Host "please type Yes for a single system query or No to read multiple systems."
if (($userInput -eq 'Yes') -or ($userInput -eq 'Y'))
#full script logic for single system test
{
$computer = Read-Host 'Enter the computer you would like to find information about'
Write-Host "attempting ping test on $computer"
if (Test-Connection -computername $computer -erroraction Continue) {
        Write-Host "Ping test was successful on $computer"
        Write-Host "`n"
        Write-Host "Attempting to find username"
    try { 
        $user = $null 
        $user = gwmi -Class win32_computersystem -ComputerName $computer -ErrorAction Stop -timeout 1 | Select-Object -ExpandProperty username
        write-host "Found user: $user"
        if ($user -eq $null) {
         "$computer is awake, but no logged on user found"
        } #end if
        } #end Try
    catch {"$computer is awake, but not logged onto"; return  } #end catch
    try { 
        if ((Get-Process logonui -ComputerName $computer -ErrorAction Stop) -and ($user))
        { 
            "$computer system locked by $user" 
            } #end if
        } #end Try
    catch { if ($user) {"$user currently logged onto $computer";  } } 
    } #end if loop
else { "$computer currently offline or asleep" }
}#end single test loop
