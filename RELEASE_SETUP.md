# Complete Release Setup Guide

## Problem
The install script needs to download from release assets, not from the repo. The format should match:
```
https://github.com/YOUR-ORG/YOUR-REPO/releases/latest/download/install-safe-chain-internal.sh
https://github.com/YOUR-ORG/YOUR-REPO/releases/download/v1.0.0/safe-chain-macos-arm64
```

## Solution: Upload Install Script to Release

The install script itself must be uploaded as an asset to each release so it can be downloaded via the `releases/latest/download/` URL.

## Step-by-Step Instructions

### Step 1: Create the Release (if not done)

1. Go to: https://github.com/cb-arunagrawalla/safe-chain-internal/releases/new
2. **Tag**: `v1.0.0` (or create new)
3. **Title**: `v1.0.0 - Updated minimum package age and security fixes`
4. **Description**: 
   ```markdown
   ## Changes
   - Default minimum package age changed from 24 to 360 hours
   - Hint message now only shows in verbose mode
   - Security: Upgraded tar package to 7.5.3 to fix vulnerability
   ```

### Step 2: Upload ALL Assets

**Important**: Upload each file individually (not zipped). Drag and drop all files:

#### Binaries (6 files):
- `release-binaries/safe-chain-macos-arm64`
- `release-binaries/safe-chain-macos-x64`
- `release-binaries/safe-chain-linuxstatic-x64`
- `release-binaries/safe-chain-linuxstatic-arm64`
- `release-binaries/safe-chain-win-x64.exe`
- `release-binaries/safe-chain-win-arm64.exe`

#### Install Script (1 file):
- `install-scripts/install-safe-chain-internal.sh`

**Total: 7 files** should be uploaded as separate assets.

### Step 3: Verify Release Assets

After uploading, your release should show:
- `install-safe-chain-internal.sh` (the install script)
- `safe-chain-macos-arm64`
- `safe-chain-macos-x64`
- `safe-chain-linuxstatic-x64`
- `safe-chain-linuxstatic-arm64`
- `safe-chain-win-x64.exe`
- `safe-chain-win-arm64.exe`

### Step 4: Test Installation

After the release is published, test:

```bash
curl -fsSL https://github.com/cb-arunagrawalla/safe-chain-internal/releases/latest/download/install-safe-chain-internal.sh | sh
```

This should:
1. Download the install script from the release
2. Detect your platform
3. Download the correct binary from the release
4. Install and set up safe-chain

## Why This Format?

The original safe-chain uses this pattern:
- Install script: `releases/latest/download/install-safe-chain.sh`
- Binaries: `releases/download/v1.4.2/safe-chain-macos-arm64`

This allows:
- Users to always get the latest install script: `releases/latest/download/`
- The install script to download the correct binary for the release version

## Troubleshooting

If installation fails:
1. Check that all 7 files are uploaded (not zipped)
2. Verify file names match exactly (case-sensitive)
3. Check that the release is published (not draft)
4. Verify the install script URL in the script matches your repo

