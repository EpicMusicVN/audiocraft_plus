@echo off

if not defined PYTHON (set PYTHON=python)
if not defined VENV_DIR (set "VENV_DIR=%~dp0%venv")

where ffmpeg >nul 2>&1
if %errorlevel% equ 0 (
    echo ffmpeg is installed.
    ffmpeg -version
    goto :install_python
) else (
    echo Python is not installed.
    winget install ffmpeg
    goto :install_python
)

:install_python
echo Have you installed Python 3.10.11 yet? (Y/N)
choice /c YN /n /m "Press Y for Yes or N for No: "
if errorlevel 2 (
    echo You chose No.
    goto :end
) else (
    goto :start_venv
)

:start_venv
if exist "%VENV_DIR%\Scripts\Python.exe" (
    goto :activate_venv
) else (
    echo Creating venv in directory %VENV_DIR%
    python -m venv "%VENV_DIR%" 2>NUL
    goto :activate_venv
)

:activate_venv
echo Activating venv...
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
echo venv %PYTHON%

:install_packages
echo Do you want to re-install app dependencies? (Y/N)
echo For first time setup, you have to choose Yes.
choice /c YN /n /m "Press Y for Yes or N for No: "
if errorlevel 2 (
    echo You chose No.
    goto :launch
) else (
    echo Installing packages...
    "%VENV_DIR%\Scripts\pip" install torch torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
    "%VENV_DIR%\Scripts\pip" install -r "%~dp0%requirements.txt"
    "%VENV_DIR%\Scripts\pip" install xformers
    goto :launch
)

:launch
echo Launching app...
%PYTHON% "%~dp0\app.py" --inbrowser
goto :end

:end
pause
exit /b