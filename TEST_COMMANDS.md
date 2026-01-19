# Test Commands for Changes

## 1. Test Minimum Package Age Default (360 hours)

### Check the default value:
```bash
cd safe-chain/packages/safe-chain
node -e "
import('./src/config/settings.js').then(m => {
  console.log('Default minimum package age:', m.getMinimumPackageAgeHours(), 'hours');
  console.log('Expected: 360 hours');
});
"
```

### Test with a package that has very new versions (will be suppressed):
```bash
# This will suppress versions newer than 360 hours (15 days)
# Most packages are older, so this might not trigger suppression
# To test suppression, use a very small threshold temporarily:
npm install express --safe-chain-minimum-package-age-hours=1 --safe-chain-logging=verbose
```

## 2. Test Hint Message is Verbose-Only

### Test in NORMAL mode (hint should NOT appear):
```bash
# Try installing a package with a very new version using a small threshold
# The informational message should appear, but NOT the hint
npm install express --safe-chain-minimum-package-age-hours=1
```

### Test in VERBOSE mode (hint SHOULD appear):
```bash
# Same command but with verbose logging - hint should appear
npm install express --safe-chain-minimum-package-age-hours=1 --safe-chain-logging=verbose
```

### Expected output in verbose mode:
```
ℹ Safe-chain: Some package versions were suppressed due to minimum age requirement.
  To disable this check, use: --safe-chain-skip-minimum-package-age
```

### Expected output in normal mode:
```
ℹ Safe-chain: Some package versions were suppressed due to minimum age requirement.
```
(No hint message)

## 3. Test Tar Package Upgrade

### Check tar version:
```bash
cd safe-chain
npm list tar
```

### Check for vulnerabilities:
```bash
npm audit --production=false | grep -A 5 tar
```

### Verify tar is in package.json:
```bash
cat package.json | grep -A 1 '"tar"'
```

## 4. Comprehensive Test Script

Run this to test all changes at once:

```bash
cd safe-chain

# Test 1: Verify default is 360
echo "=== Test 1: Default minimum package age ==="
node -e "
import('./packages/safe-chain/src/config/settings.js').then(m => {
  const hours = m.getMinimumPackageAgeHours();
  console.log('Default:', hours, 'hours');
  console.log(hours === 360 ? '✓ PASS' : '✗ FAIL - Expected 360');
});
"

# Test 2: Verify tar version
echo -e "\n=== Test 2: Tar package version ==="
npm list tar 2>/dev/null | grep tar || echo "Run 'npm install' first"

# Test 3: Check hint message uses writeVerbose
echo -e "\n=== Test 3: Hint message uses writeVerbose ==="
grep -A 3 'To disable this check' packages/safe-chain/src/main.js | grep -q 'writeVerbose' && echo "✓ PASS" || echo "✗ FAIL"

# Test 4: Check default is 360 in settings.js
echo -e "\n=== Test 4: Default value in settings.js ==="
grep 'defaultMinimumPackageAge = 360' packages/safe-chain/src/config/settings.js && echo "✓ PASS" || echo "✗ FAIL"
```

