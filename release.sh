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
echo ""

# Step 1: Build all binaries
echo "📦 Building binaries..."
./build-all.sh
echo ""

# Step 2: Create and push tag
echo "🏷️  Creating tag $VERSION..."
git tag $VERSION
git push origin $VERSION
echo ""

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
echo ""

# Step 4: Upload binaries
echo "📤 Uploading binaries..."
gh release upload $VERSION \
  release-binaries-new/* \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber
echo ""

# Step 5: Upload install scripts
echo "📤 Uploading install scripts..."
gh release upload $VERSION \
  install-scripts/install-safe-chain-internal.sh \
  install-scripts/install-safe-chain-internal.ps1 \
  install-scripts/uninstall-safe-chain-internal.sh \
  install-scripts/uninstall-safe-chain-internal.ps1 \
  --repo cb-arunagrawalla/safe-chain-internal \
  --clobber
echo ""

# Step 6: Cleanup
echo "🧹 Cleaning up..."
rm -rf release-binaries-new
echo ""

echo "✅ Release $VERSION completed successfully!"
echo "🔗 View release: https://github.com/cb-arunagrawalla/safe-chain-internal/releases/tag/$VERSION"
