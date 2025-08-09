#!/bin/bash

# Check if project name was provided
if [ -z "$1" ]; then
    echo "❌ Please provide a project name."
    echo "Usage: setup.sh my-app"
    exit 1
fi

PROJECT_NAME="$1"

echo "Creating folder $PROJECT_NAME..."
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

echo "Initializing npm..."
npm init -y

echo "Installing express..."
npm install express

echo "Installing dev dependencies..."
npm install --save-dev typescript @types/express ts-node-dev @types/node

echo "Initializing TypeScript..."
npx tsc --init

echo "Overwriting tsconfig.json..."
cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  }
}
EOL

echo "Creating src folder if not exists..."
mkdir -p src

echo "Writing src/index.ts file..."
cat > src/index.ts <<EOL
import express, { Request, Response } from 'express';

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from TypeScript + Express!');
});

app.listen(port, () => {
    console.log('Server running at http://localhost:' + port);
});
EOL

echo "✅ File created at: $(pwd)/src/index.ts"

echo "Updating package.json scripts..."
npx json -I -f package.json -e \
    'this.scripts={dev:"ts-node-dev --respawn --transpile-only src/index.ts",build:"tsc",start:"node dist/index.js"}'

echo "Writing types.ts file with comment..."
echo "// enter your app types here" > src/types.ts

echo "✅ File created at: $(pwd)/src/types.ts"

echo "✅ Setup complete!"
echo "➡ To start: cd $PROJECT_NAME && npm run dev"