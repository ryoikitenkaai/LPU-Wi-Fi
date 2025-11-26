Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get username
username = InputBox("Enter your LPU username (without @lpu.com):", "LPU WiFi Login Creator")
If username = "" Then
    WScript.Quit
End If

' Get password
password = InputBox("Enter your password:", "LPU WiFi Login Creator")
If password = "" Then
    WScript.Quit
End If

' Confirmation
confirm = MsgBox("Please confirm your details:" & vbCrLf & vbCrLf & _
                 "Username: " & username & "@lpu.com" & vbCrLf & _
                 "Password: " & password & vbCrLf & vbCrLf & _
                 "Is this correct?", vbYesNo + vbQuestion, "Confirmation")

If confirm = vbNo Then
    WScript.Quit
End If

' Create the batch file content
batchContent = "@echo off" & vbCrLf & _
"title LPU WiFi Login" & vbCrLf & _
":: --- Get IP ---" & vbCrLf & _
"for /f %%i in ('powershell -NoProfile -Command ""(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*vEthernet*'} | Select -First 1).IPAddress""') do set IP=%%i" & vbCrLf & _
":: --- Get MAC ---" & vbCrLf & _
"for /f %%j in ('powershell -NoProfile -Command ""(Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select -First 1).MacAddress""') do set MAC=%%j" & vbCrLf & _
"echo IP: %IP%" & vbCrLf & _
"echo MAC: %MAC%" & vbCrLf & _
"curl -k -s ""https://10.10.0.1/24online/servlet/E24onlineHTTPClient"" ^" & vbCrLf & _
" -d ""mode=191"" ^" & vbCrLf & _
" -d ""username=" & username & "@lpu.com"" ^" & vbCrLf & _
" -d ""password=" & password & """ ^" & vbCrLf & _
" -d ""ipaddress=%IP%"" ^" & vbCrLf & _
" -d ""macaddress=%MAC%"" ^" & vbCrLf & _
" -d ""logintype=2"" ^" & vbCrLf & _
" -d ""checkClose=1""" & vbCrLf & _
"echo." & vbCrLf & _
"echo ✔ Logged in!" & vbCrLf & _
"exit"

' Write to file
Set objFile = objFSO.CreateTextFile("lpu-login.bat", True)
objFile.Write batchContent
objFile.Close

' Success message
MsgBox "Success! Created 'lpu-login.bat'" & vbCrLf & vbCrLf & _
       "You can now use 'lpu-login.bat' to automatically login to LPU WiFi.", _
       vbInformation, "Success"

' Self-deletion
confirm = MsgBox("This creator script will now delete itself. Continue?", vbYesNo + vbQuestion, "Self-Delete")
If confirm = vbYes Then
    Set objFSO = Nothing
    Set objShell = Nothing
    
    ' Create a temporary batch file to delete this script
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    scriptPath = WScript.ScriptFullName
    tempBat = objFSO.GetParentFolderName(scriptPath) & "\temp_delete.bat"
    
    Set objFile = objFSO.CreateTextFile(tempBat, True)
    objFile.WriteLine "@echo off"
    objFile.WriteLine "timeout /t 1 /nobreak >nul"
    objFile.WriteLine "del """ & scriptPath & """"
    objFile.WriteLine "del ""%~f0"""
    objFile.Close
    
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run """" & tempBat & """", 0, False

End If
