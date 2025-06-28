@echo off
setlocal

:: Check if project name was provided
if "%~1"=="" (
    echo ❌ Please provide a project name.
    echo Usage: setup-node.cmd my-app
    exit /b 1
)

set "PROJECT_NAME=%~1"

echo Creating folder %PROJECT_NAME%...
mkdir "%PROJECT_NAME%"
cd "%PROJECT_NAME%"

echo Initializing npm...
call npm init -y

echo Installing express...
call npm install express

echo Installing dev dependencies (nodemon)...
call npm install --save-dev nodemon

echo Creating src folder if not exists...
if not exist src mkdir src

echo Writing index.js file with PowerShell...

powershell -Command "Set-Content -Path 'src/index.js' -Value \"const express = require('express');`n`nconst app = express();`nconst port = 3000;`n`napp.use(express.json());`n`napp.get('/', (req, res) =^> ^{`n    res.send('Hello from Express!');`n});`n`napp.listen(port, () =^> ^{`n    console.log('Server running at http://localhost:' + port);`n});\""

echo ✅ File created at: %CD%\src\index.js

echo Updating package.json scripts using PowerShell...
powershell -Command " $p = Get-Content -Raw -Path package.json | ConvertFrom-Json; $p.scripts = @{ dev = 'nodemon src/index.js'; start = 'node src/index.js' }; $p | ConvertTo-Json -Depth 10 | Set-Content -Path package.json "

echo ✅ Setup complete!
echo ➡ To start: cd %PROJECT_NAME% && npm run dev

endlocal
