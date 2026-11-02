#!/bin/bash
set -e

echo "🔍 [1/4] Checking code formatting (dart format)..."
dart format --output=none --set-exit-if-changed .

echo "🧐 [2/4] Running static analysis (flutter analyze)..."
flutter analyze

echo "🧪 [3/4] Running automated tests (flutter test)..."
flutter test

echo "📏 [4/4] Verifying file line bounds (<= 250 lines in lib/, <= 80 lines for widgets)..."
python3 -c "
import glob, sys
failed_files = []
failed_widgets = []
for path in glob.glob('lib/**/*.dart', recursive=True):
    if path.endswith('.g.dart') or path.endswith('.freezed.dart'):
        continue
    with open(path) as f:
        count = len(f.readlines())
        if count > 250:
            failed_files.append((path, count))
        if count > 80 and '/widgets/' in path:
            failed_widgets.append((path, count))
if failed_files or failed_widgets:
    if failed_files:
        print('❌ Files violating AGENTS.md 250-line limit:', failed_files)
    if failed_widgets:
        print('❌ Widgets violating AGENTS.md 80-line limit:', failed_widgets)
    sys.exit(1)
print('✅ All non-generated files comply with <= 250 lines and widgets <= 80 lines!')
"

echo "🎉 All local quality checks passed! Code is clean for push."

