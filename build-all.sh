#!/bin/bash
set -e

echo "🔨 Building binaries for all platforms..."
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
  echo "📦 Building $target..."
  node build.js "$target"
  cp "dist/$source" "release-binaries-new/$dest"
  echo "   ✅ $dest built successfully"
done

echo ""
echo "🎉 All binaries built successfully!"
echo ""
echo "📊 Binary sizes:"
ls -lh release-binaries-new/
