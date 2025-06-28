@echo off
setlocal

if "%~1"=="" (
    echo ❌ Please provide a project name.
    echo Usage: setup-react-vite.cmd my-app
    exit /b 1
)

set "PROJECT_NAME=%~1"

echo Creating React + Vite app: %PROJECT_NAME%...

call npm create vite@latest %PROJECT_NAME% -- --template react-ts

cd "%PROJECT_NAME%"

echo Installing dependencies...
call npm install


echo ✅ Setup complete!
echo ➡ To start: cd %PROJECT_NAME% && npm run dev

endlocal
