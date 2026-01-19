# Installing from Internal GitHub Repository

## Option 1: Using Install Script (Recommended)

### Unix/Linux/macOS

Update the script variables in `install-scripts/install-safe-chain-internal.sh`:
- `REPO_ORG`: Your GitHub organization
- `REPO_NAME`: Your repository name  
- `BRANCH`: Your default branch (usually `main` or `master`)

Then use:
```bash
curl -fsSL https://github.com/YOUR-ORG/YOUR-REPO/raw/main/install-scripts/install-safe-chain-internal.sh | sh
```

Or if you host the script elsewhere:
```bash
curl -fsSL https://your-internal-server.com/install-safe-chain-internal.sh | sh
```

### Windows (PowerShell)

Create a similar PowerShell script or use npm directly (see Option 2).

## Option 2: Direct npm Install (Simpler, No Script Needed)

### Install from GitHub

```bash
npm install -g git+https://github.com/YOUR-ORG/YOUR-REPO.git#main:packages/safe-chain
```

Replace:
- `YOUR-ORG` with your GitHub organization
- `YOUR-REPO` with your repository name
- `main` with your branch name if different

### Then run setup

```bash
safe-chain setup
```

## Option 3: Install from Specific Branch/Tag

```bash
# From a specific branch
npm install -g git+https://github.com/YOUR-ORG/YOUR-REPO.git#feature-branch:packages/safe-chain

# From a specific tag/commit
npm install -g git+https://github.com/YOUR-ORG/YOUR-REPO.git#v1.0.0:packages/safe-chain
```

## Option 4: Using GitHub Personal Access Token (Private Repos)

If your internal repo is private, you'll need authentication:

```bash
# Using token in URL (less secure)
npm install -g git+https://TOKEN@github.com/YOUR-ORG/YOUR-REPO.git#main:packages/safe-chain

# Or configure git credentials first
git config --global credential.helper store
# Then use regular URL
npm install -g git+https://github.com/YOUR-ORG/YOUR-REPO.git#main:packages/safe-chain
```

## Verification

After installation, verify it works:

```bash
# Check version
safe-chain --version

# Verify changes are present
# Test 1: Check default minimum package age (should be 360)
node -e "import('@aikidosec/safe-chain/config/settings.js').then(m => console.log('Default:', m.getMinimumPackageAgeHours(), 'hours'));"

# Test 2: Check hint message uses writeVerbose
grep -A 3 'To disable this check' $(npm root -g)/@aikidosec/safe-chain/src/main.js | grep writeVerbose && echo "✓ Correct"
```

## Updating

To update to the latest version:

```bash
npm install -g git+https://github.com/YOUR-ORG/YOUR-REPO.git#main:packages/safe-chain
```

## Troubleshooting

### If installation fails:
1. Make sure you have access to the internal repository
2. Verify the branch name is correct
3. Check that `packages/safe-chain` directory exists in the repo
4. Ensure Node.js and npm are installed

### If safe-chain command not found:
1. Check npm global bin path: `npm config get prefix`
2. Add it to your PATH if needed
3. Restart your terminal

