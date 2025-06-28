@echo off
setlocal

:: Check if project name was provided
if "%~1"=="" (
    echo ❌ Please provide a project name.
    echo Usage: setup.cmd my-app
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

echo Installing dev dependencies...
call npm install --save-dev typescript @types/express ts-node-dev @types/node

echo Initializing TypeScript...
call npx tsc --init

echo Overwriting tsconfig.json...
(
echo {
echo   "compilerOptions": {
echo     "target": "ES2020",
echo     "module": "commonjs",
echo     "outDir": "./dist",
echo     "rootDir": "./src",
echo     "strict": true,
echo     "esModuleInterop": true,
echo     "forceConsistentCasingInFileNames": true,
echo     "skipLibCheck": true
echo   }
echo }
) > tsconfig.json

echo Creating src folder if not exists...
if not exist src mkdir src

echo Writing file with PowerShell...

powershell -Command "Set-Content -Path 'src/index.ts' -Value \"import express, { Request, Response } from 'express';`n`nconst app = express();`nconst port = 3000;`n`napp.use(express.json());`n`napp.get('/', (req: Request, res: Response) =^> ^{`n    res.send('Hello from TypeScript + Express!');`n});`n`napp.listen(port, () =^> ^{`n    console.log('Server running at http://localhost:' + port);`n});\""

echo ✅ File created at: %CD%\src\index.ts

echo Updating package.json scripts using PowerShell...
powershell -Command " $p = Get-Content -Raw -Path package.json | ConvertFrom-Json; $p.scripts = @{ dev = 'ts-node-dev --respawn --transpile-only src/index.ts'; build = 'tsc'; start = 'node dist/index.js' }; $p | ConvertTo-Json -Depth 10 | Set-Content -Path package.json "


echo Writing types.ts file with comment...

powershell -Command "Set-Content -Path 'src/types.ts' -Value \"// enter your app types here\""

echo ✅ File created at: %CD%\src\types.ts


echo ✅ Setup complete!
echo ➡ To start: cd %PROJECT_NAME% && npm run dev

endlocal
