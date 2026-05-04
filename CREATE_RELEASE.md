# How to Create a GitHub Release

## Step 1: Create a Git Tag

First, create a version tag:

```bash
cd safe-chain
git tag v1.0.0
git push origin v1.0.0
```

## Step 2: Create Release via GitHub Web UI

1. Go to: https://github.com/cb-arunagrawalla/safe-chain-internal/releases/new
2. **Tag**: Select `v1.0.0` (or create new tag)
3. **Title**: `v1.0.0 - Updated minimum package age and security fixes`
4. **Description**:
   ```markdown
   ## Changes
   - Default minimum package age changed from 24 to 360 hours
   - Hint message now only shows in verbose mode
   - Security: Upgraded tar package to 7.5.3 to fix vulnerability

   ## Installation
   ```bash
   curl -fsSL https://github.com/cb-arunagrawalla/safe-chain-internal/raw/main/install-scripts/install-safe-chain-internal.sh | sh
   ```
   ```

5. **Attach binaries**: Drag and drop all 6 files from `release-binaries/`:
   - `safe-chain-macos-arm64`
   - `safe-chain-macos-x64`
   - `safe-chain-linuxstatic-x64`
   - `safe-chain-linuxstatic-arm64`
   - `safe-chain-win-x64.exe`
   - `safe-chain-win-arm64.exe`

6. Click **"Publish release"**

## Step 3: Upload Install Script (Optional but Recommended)

Also upload the install script to the release so users can download a specific version:

1. In the release page, click **"Edit"**
2. Scroll to **"Attach binaries"**
3. Upload: `install-scripts/install-safe-chain-internal.sh`
4. Save

## Alternative: Using GitHub CLI (if you refresh auth)

If you want to use CLI, refresh auth with workflow scope:

```bash
gh auth refresh -h github.com -s workflow
gh release create v1.0.0 \
  --title "v1.0.0 - Updated minimum package age and security fixes" \
  --notes "## Changes
- Default minimum package age changed from 24 to 360 hours
- Hint message now only shows in verbose mode
- Security: Upgraded tar package to 7.5.3 to fix vulnerability" \
  release-binaries/*
```

## Verify Installation Works

After creating the release, test the installation:

```bash
curl -fsSL https://github.com/cb-arunagrawalla/safe-chain-internal/raw/main/install-scripts/install-safe-chain-internal.sh | sh
```

The script will:
1. Fetch the latest release version (v1.0.0)
2. Download the appropriate binary for your platform
3. Install it to `~/.safe-chain/bin/`
4. Run `safe-chain setup`

