@echo off
REM ============================================================
REM  PVH Field App - one-click builder
REM  Put this .bat in the same folder as:
REM    build_pvh_field_app.py
REM    All_Active_Vehicles.xlsx
REM    OperatorList.xlsx
REM    All_Vehicle_LastInspection.xlsx   (optional)
REM  Double-click it. Output: PVH_Field_App.html, docs\, PVH_data.json
REM ============================================================

REM Run from this file's own folder no matter where it's launched from
cd /d "%~dp0"

echo.
echo === PVH Field App Builder ===
echo Folder: %cd%
echo.

REM --- locate Python ---
set "PY="
where py >nul 2>nul && set "PY=py"
if not defined PY (
  where python >nul 2>nul && set "PY=python"
)
if not defined PY (
  echo [X] Python was not found on this PC.
  echo     Install Python from python.org, then run this again.
  goto :end
)

REM --- required files ---
set "MISSING="
if not exist "build_pvh_field_app.py"     set "MISSING=1" & echo [X] Missing: build_pvh_field_app.py
if not exist "All_Active_Vehicles.xlsx"   set "MISSING=1" & echo [X] Missing: All_Active_Vehicles.xlsx
if not exist "OperatorList.xlsx"          set "MISSING=1" & echo [X] Missing: OperatorList.xlsx
if defined MISSING (
  echo.
  echo Fix the missing file^(s^) above and run again.
  echo Filenames must match exactly.
  goto :end
)

REM --- optional address file ---
set "ADDR="
if exist "All_Vehicle_LastInspection.xlsx" (
  set "ADDR=All_Vehicle_LastInspection.xlsx"
  echo [ok] Address file found - owner addresses will be included.
) else (
  echo [!] All_Vehicle_LastInspection.xlsx not found - building without owner addresses.
)
echo.

REM --- build ---
%PY% "build_pvh_field_app.py" "All_Active_Vehicles.xlsx" "OperatorList.xlsx" %ADDR% "PVH_Field_App.html"
set "RC=%errorlevel%"
echo.
if not "%RC%"=="0" (
  echo [X] Build failed. Read the message above.
  goto :end
)

echo === Done ===
echo   PVH_Field_App.html   single-file app
echo   docs\                installed-app shell for GitHub Pages
echo   PVH_data.json        data for the installed app  ^(keep private^)
echo.
echo Reminder: never upload PVH_data.json or PVH_Field_App.html to GitHub.

:end
echo.
pause
