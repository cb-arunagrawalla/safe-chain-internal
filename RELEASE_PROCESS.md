# Release Process for safe-chain-internal

This document describes the complete process for creating a new release of safe-chain-internal.

## When to Create a Release

Create a new release when:
- New features are added
- Bug fixes are made
- Configuration changes are made (like default exclusions)
- Security updates are applied
- Documentation is significantly updated

## Version Numbering

Follow Semantic Versioning (semver):
- **Major** (x.0.0): Breaking changes
- **Minor** (1.x.0): New features, backward compatible
- **Patch** (1.0.x): Bug fixes, backward compatible

## Complete Release Checklist

### 1. Code Changes and Testing

- [ ] Make your code changes
- [ ] Update tests if needed
- [ ] Run tests: `npm test`
- [ ] Update README.md if needed
- [ ] Update version number in `packages/safe-chain/package.json`

### 2. Commit and Push Changes

```bash
cd /path/to/safe-chain
git add .
git commit -m "Your descriptive commit message"
git push origin main
```

### 3. Build Binaries for All Platforms

**Important:** Binaries must be rebuilt after ANY code changes!

```bash
# Build for all platforms
node build.js node22-macos-arm64
cp dist/safe-chain release-binaries-new/safe-chain-macos-arm64

node build.js node22-macos-x64
cp dist/safe-chain release-binaries-new/safe-chain-macos-x64

node build.js node22-linux-arm64
cp dist/safe-chain release-binaries-new/safe-chain-linux-arm64

node build.js node22-linux-x64
cp dist/safe-chain release-binaries-new/safe-chain-linux-x64

node build.js node22-linuxstatic-arm64
cp dist/safe-chain release-binaries-new/safe-chain-linuxstatic-arm64

node build.js node22-linuxstatic-x64
cp dist/safe-chain release-binaries-new/safe-chain-linuxstatic-x64

node build.js node22-win-arm64
cp dist/safe-chain.exe release-binaries-new/safe-chain-win-arm64.exe

node build.js node22-win-x64
cp dist/safe-chain.exe release-binaries-new/safe-chain-win-x64.exe
```

**Or use the automated script (recommended):**

```bash
# Create build-all.sh script
cat > build-all.sh << 'EOF'
#!/bin/bash
set -e

echo "Building binaries for all platforms..."
mkdir -p release-binaries-new

platforms=(
  "node22-macos-arm64:safe-chain:safe-chain-macos-arm64"
  "node22-macos-x64:safe-chain:safe-chain-macos-x64"
  "node22-linux-arm64:safe-chain:safe-chain-linux-arm64"
  "node22-linux-x64:safe-chain:safe-chain-linux-x64"
  "node22-linuxstatic-arm64:safe-chain:safe-chain-linuxstatic-arm64"
  "node22-linuxstatic-x64:safe-chain:safe-chain-linuxstatic-x64"
  "node22-win-arm64:safe-chain.exe:safe-chain-win-arm64.exe"
  "node22-win-x64:safe-chain.exe:safe-chain-win-x64.exe"
)

for platform in "${platforms[@]}"; do
  IFS=':' read -r target source dest <<< "$platform"
  echo "Building $target..."
  node build.js "$target"
  cp "dist/$source" "release-binaries-new/$dest"
  echo "✅ $dest built successfully"
done

echo "🎉 All binaries built successfully!"
ls -lh release-binaries-new/
EOF

chmod +x build-all.sh
./build-all.sh
```

### 4. Create Git Tag

```bash
# Create and push tag
git tag v1.5.1  # Use appropriate version number
git push origin v1.5.1
```

### 5. Create GitHub Release

```bash
# Set your GitHub token
export GH_TOKEN=your_github_token_here

# Create release with notes
gh release create v1.5.1 \
  --repo cb-arunagrawalla/safe-chain-internal \
  --title "v1.5.1 - [Brief Description]" \
  --notes "$(cat <<'EOF'
## 🚀 New Features
- Feature 1
- Feature 2

## 🐛 Bug Fixes
- Fix 1
- Fix 2

## 📝 Changes
- Change 1
- Change 2

## 📚 Documentation
- Doc update 1

**Full Changelog**: https://github.com/cb-arunagrawalla/safe-chain-internal/compare/v1.5.0...v1.5.1
EOF
)"
```

### 6. Upload Binaries to Release

```bash
# Upload all binaries
GH_TOKEN=your_github_token_here gh release upload v1.5.1 \
  release-binaries-new/* \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber
```

### 7. Upload Installation Scripts

```bash
# Upload install/uninstall scripts
GH_TOKEN=your_github_token_here gh release upload v1.5.1 \
  install-scripts/install-safe-chain-internal.sh \
  install-scripts/install-safe-chain-internal.ps1 \
  install-scripts/uninstall-safe-chain-internal.sh \
  install-scripts/uninstall-safe-chain-internal.ps1 \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber
```

### 8. Verify Release

```bash
# View release
GH_TOKEN=your_github_token_here gh release view v1.5.1 \
  --repo cb-arunagrawalla/safe-chain-internal

# Test installation
curl -fsSL https://github.com/cb-arunagrawalla/safe-chain-internal/releases/latest/download/install-safe-chain-internal.sh | sh
```

### 9. Cleanup

```bash
# Remove temporary binaries folder
rm -rf release-binaries-new
```

## Quick Release Script

Create `release.sh` for automation:

```bash
#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./release.sh <version> [release-notes-file]"
  echo "Example: ./release.sh v1.5.1 release-notes.md"
  exit 1
fi

VERSION=$1
NOTES_FILE=${2:-""}

echo "🚀 Starting release process for $VERSION"

# Step 1: Build all binaries
echo "📦 Building binaries..."
./build-all.sh

# Step 2: Create and push tag
echo "🏷️  Creating tag $VERSION..."
git tag $VERSION
git push origin $VERSION

# Step 3: Create release
echo "🎉 Creating GitHub release..."
if [ -n "$NOTES_FILE" ] && [ -f "$NOTES_FILE" ]; then
  gh release create $VERSION \
    --repo cb-arunagrawalla/safe-chain-internal \
    --title "$VERSION" \
    --notes-file "$NOTES_FILE"
else
  gh release create $VERSION \
    --repo cb-arunagrawalla/safe-chain-internal \
    --title "$VERSION" \
    --generate-notes
fi

# Step 4: Upload binaries
echo "📤 Uploading binaries..."
gh release upload $VERSION \
  release-binaries-new/* \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber

# Step 5: Upload install scripts
echo "📤 Uploading install scripts..."
gh release upload $VERSION \
  install-scripts/install-safe-chain-internal.sh \
  install-scripts/install-safe-chain-internal.ps1 \
  install-scripts/uninstall-safe-chain-internal.sh \
  install-scripts/uninstall-safe-chain-internal.ps1 \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber

# Step 6: Cleanup
echo "🧹 Cleaning up..."
rm -rf release-binaries-new

echo "✅ Release $VERSION completed successfully!"
echo "🔗 View release: https://github.com/cb-arunagrawalla/safe-chain-internal/releases/tag/$VERSION"
```

Make it executable:
```bash
chmod +x release.sh
```

Usage:
```bash
./release.sh v1.5.1
```

## Important Notes

1. **Always rebuild binaries** after code changes - the binaries contain the compiled code
2. **Test locally first** before creating a release
3. **Use `latest` in README** - installation commands use `/latest/download/` which automatically points to the newest release
4. **Python MPA not supported** - Minimum package age is only available for npm packages, not Python/pip
5. **Binary sizes** - Typical sizes range from 60-75 MB per binary
6. **GitHub token** - Ensure your `GH_TOKEN` has `repo` and `workflow` scopes

## Troubleshooting

### Binaries not updating
- Make sure you rebuilt ALL binaries after code changes
- Verify binaries were uploaded with `--clobber` flag
- Check binary timestamps: `ls -lh release-binaries-new/`

### Release fails
- Verify `GH_TOKEN` is set and has correct permissions
- Check that tag doesn't already exist: `git tag -l`
- Ensure you're on the correct branch: `git branch`

### Installation issues
- Clear old installation: `safe-chain teardown`
- Remove cached binary: `rm -rf ~/.safe-chain/bin/safe-chain`
- Reinstall: `curl -fsSL https://github.com/cb-arunagrawalla/safe-chain-internal/releases/latest/download/install-safe-chain-internal.sh | sh`

## Updating Existing Release

If you need to update binaries for an existing release:

```bash
# Delete old binaries
for asset in safe-chain-linux-arm64 safe-chain-linux-x64 safe-chain-linuxstatic-arm64 safe-chain-linuxstatic-x64 safe-chain-macos-arm64 safe-chain-macos-x64 safe-chain-win-arm64.exe safe-chain-win-x64.exe; do
  gh release delete-asset v1.5.1 "$asset" --repo cb-arunagrawalla/safe-chain-internal --yes
done

# Upload new binaries
gh release upload v1.5.1 release-binaries-new/* --repo cb-arunagrawalla/safe-chain-internal --clobber
```
