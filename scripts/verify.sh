#!/bin/bash
set -e

echo "🔍 [1/4] Checking code formatting (dart format)..."
dart format --output=none --set-exit-if-changed .

echo "🧐 [2/4] Running static analysis (flutter analyze)..."
flutter analyze

echo "🧪 [3/4] Running automated tests (flutter test)..."
flutter test

echo "📏 [4/4] Verifying file line bounds (<= 250 lines in lib/)..."
python3 -c "
import glob, sys
failed = []
for path in glob.glob('lib/**/*.dart', recursive=True):
    if path.endswith('.g.dart') or path.endswith('.freezed.dart'):
        continue
    with open(path) as f:
        count = len(f.readlines())
        if count > 250:
            failed.append((path, count))
if failed:
    print('❌ Files violating AGENTS.md 250-line limit:', failed)
    sys.exit(1)
print('✅ All non-generated files in lib/ comply with <= 250 lines!')
"

echo "🎉 All local quality checks passed! Code is clean for push."

