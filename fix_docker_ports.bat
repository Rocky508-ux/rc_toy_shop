@echo off
echo ==========================================
echo  Fixing Docker Port 8080 Conflict (Winnat)
echo ==========================================
echo.
echo This script will restart the Windows NAT service to clear reserved ports.
echo It requires Administrator privileges (User Account Control).
echo.
echo Please click "Yes" if asked for permission.
echo.

powershell -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c net stop winnat && net start winnat && echo Success! Port 8080 should be free now. && pause'"
