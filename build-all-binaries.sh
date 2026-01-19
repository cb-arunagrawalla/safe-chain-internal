#!/bin/bash
# Build all binaries for different platforms and rename them appropriately

set -e

DIST_DIR="dist"
RELEASE_DIR="release-binaries"

# Create release directory
mkdir -p "$RELEASE_DIR"

echo "Building binaries for all platforms..."
echo ""

# Build and copy each platform
build_and_copy() {
    local target=$1
    local output_name=$2
    
    echo "Building $target..."
    node build.js "$target"
    
    if [ -f "$DIST_DIR/safe-chain" ]; then
        cp "$DIST_DIR/safe-chain" "$RELEASE_DIR/$output_name"
        chmod +x "$RELEASE_DIR/$output_name"
        echo "✓ Created $output_name"
    elif [ -f "$DIST_DIR/safe-chain.exe" ]; then
        cp "$DIST_DIR/safe-chain.exe" "$RELEASE_DIR/$output_name"
        echo "✓ Created $output_name"
    else
        echo "✗ Failed to build $target"
        exit 1
    fi
    echo ""
}

# Build all platforms
build_and_copy "node22-macos-arm64" "safe-chain-macos-arm64"
build_and_copy "node22-macos-x64" "safe-chain-macos-x64"
build_and_copy "node22-linuxstatic-x64" "safe-chain-linuxstatic-x64"
build_and_copy "node22-linuxstatic-arm64" "safe-chain-linuxstatic-arm64"
build_and_copy "node22-win-x64" "safe-chain-win-x64.exe"
build_and_copy "node22-win-arm64" "safe-chain-win-arm64.exe"

echo "✅ All binaries built successfully!"
echo ""
echo "Binaries are in: $RELEASE_DIR/"
ls -lh "$RELEASE_DIR/"

