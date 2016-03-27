@echo off

:: add bin directory to PATH
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "PATH" /d "%PATH%;%cd%\tool" /f >NUL 2>NUL

:: desktop path
::for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do (
::	set desk=%%j
::)
