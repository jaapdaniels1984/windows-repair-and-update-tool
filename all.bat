@echo off
:menu
cls
echo "This is a simple cleanup and repair utility. Please select an option:"
echo "1 - HardDrive Check and repair"
echo "2 - System File Checker"
echo "3 - Tool to repair the local image of Windows"
echo "4 - Update Drivers"
echo "5 - Clear Windows Store and update Cache"
echo "6 - Clear Icon Cache"
echo "7 - Clear thumbnail Cache"
echo "8 - Force clear print tasks"
echo "9 - Exit"

choice /n /c:123456789 /M "Choose an option (1-9)"
If %ErrorLevel%==1 goto CheckDisk
If %ErrorLevel%==2 goto SFC
If %ErrorLevel%==3 goto Dism
If %ErrorLevel%==4 goto Update
If %ErrorLevel%==5 goto WSReset
If %ErrorLevel%==6 goto Icon
If %ErrorLevel%==7 goto thumbcache
If %ErrorLevel%==8 goto Printspool
If %ErrorLevel%==9 goto Exit

:CheckDisk
chkdsk /f /r /c:
timeout /t 10 >nul
goto menu
:SFC
sfc /scannow
timeout /t 10 >nul
goto menu
:Dism
DISM.exe /Online /Cleanup-Image /ScanHealth
DISM.exe /Online /Cleanup-Image /CheckHealth
DISM.exe /Online /Cleanup-Image /RestoreHealth
DISM.exe /Online /Cleanup-Image /startcomponentcleanup
timeout /t 10 >nul
goto menu
:Update
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\update\update.ps1""' -Verb RunAs}
timeout /t 10 >nul
goto menu
:WSReset
WSReset.exe
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
Del /F /Q "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\*.*"
rmdir %systemroot%\SoftwareDistribution /S /Q
rmdir %systemroot%\system32\catroot2 /S /Q
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
regsvr32.exe /s %windir%\system32\atl.dll
regsvr32.exe /s %windir%\system32\urlmon.dll
regsvr32.exe /s %windir%\system32\mshtml.dll
regsvr32.exe /s %windir%\system32\shdocvw.dll
regsvr32.exe /s %windir%\system32\browseui.dll
regsvr32.exe /s %windir%\system32\jscript.dll
regsvr32.exe /s %windir%\system32\vbscript.dll
regsvr32.exe /s %windir%\system32\scrrun.dll
regsvr32.exe /s %windir%\system32\msxml.dll
regsvr32.exe /s %windir%\system32\msxml3.dll
regsvr32.exe /s %windir%\system32\msxml6.dll
regsvr32.exe /s %windir%\system32\actxprxy.dll
regsvr32.exe /s %windir%\system32\softpub.dll
regsvr32.exe /s %windir%\system32\wintrust.dll
regsvr32.exe /s %windir%\system32\dssenh.dll
regsvr32.exe /s %windir%\system32\rsaenh.dll
regsvr32.exe /s %windir%\system32\gpkcsp.dll
regsvr32.exe /s %windir%\system32\sccbase.dll
regsvr32.exe /s %windir%\system32\slbcsp.dll
regsvr32.exe /s %windir%\system32\cryptdlg.dll
regsvr32.exe /s %windir%\system32\oleaut32.dll
regsvr32.exe /s %windir%\system32\ole32.dll
regsvr32.exe /s %windir%\system32\shell32.dll
regsvr32.exe /s %windir%\system32\initpki.dll
regsvr32.exe /s %windir%\system32\wuapi.dll
regsvr32.exe /s %windir%\system32\wuaueng.dll
regsvr32.exe /s %windir%\system32\wuaueng1.dll
regsvr32.exe /s %windir%\system32\wucltui.dll
regsvr32.exe /s %windir%\system32\wups.dll
regsvr32.exe /s %windir%\system32\wups2.dll
regsvr32.exe /s %windir%\system32\wuweb.dll
regsvr32.exe /s %windir%\system32\qmgr.dll
regsvr32.exe /s %windir%\system32\qmgrprxy.dll
regsvr32.exe /s %windir%\system32\wucltux.dll
regsvr32.exe /s %windir%\system32\muweb.dll
regsvr32.exe /s %windir%\system32\wuwebv.dll
netsh winsock reset
netsh winsock reset proxy
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
timeout /t 10 >nul
goto menu
:Icon
taskkill /f /im explorer.exe
timeout /t 10 >nul
set iconcache=%localappdata%\IconCache.db
set iconcache_x=%localappdata%\Microsoft\Windows\Explorer\iconcache*
ie4uinit.exe -show
attrib –h "%iconcache%"
attrib -h "%iconcache_x%"
del /F /Q "%iconcache%"
del /F /Q "%iconcache_x%"
start explorer.exe
set iconcache=
set iconcache_x=
timeout /t 10 >nul
goto menu
:thumbcache
taskkill /f /im explorer.exe
set thumbcache_x=%localappdata%\Microsoft\Windows\Explorer\thumbcache*
ie4uinit.exe -show
attrib –h "%thumbcache%"
del /A /F /Q "%thumbcache%"
set thumbcache=
start explorer.exe
timeout /t 10 >nul
goto menu
:Printspool
net stop spooler
del %systemroot%\System32\spool\printers\* /Q
net start spooler
timeout /t 10 >nul
goto menu
:Exit
echo "Please save all your work, and reboot your computer for changes to fully apply."
timeout /t 10 >nul
exit
