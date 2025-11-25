@echo off
title LPU WiFi Login
:: --- Get IP ---
for /f %%i in ('powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*vEthernet*'} | Select -First 1).IPAddress"') do set IP=%%i
:: --- Get MAC ---
for /f %%j in ('powershell -NoProfile -Command "(Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select -First 1).MacAddress"') do set MAC=%%j
echo IP: %IP%
echo MAC: %MAC%
curl -k -s "https://10.10.0.1/24online/servlet/E24onlineHTTPClient" ^
 -d "mode=191" ^
 -d "username=12407370@lpu.com" ^
 -d "password=1711@Satyam" ^
 -d "ipaddress=%IP%" ^
 -d "macaddress=%MAC%" ^
 -d "logintype=2" ^
 -d "checkClose=1"
echo.
echo ✔ Logged in!
pause