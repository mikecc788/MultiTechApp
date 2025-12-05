#!/usr/bin/env bash
set -euo pipefail

PROJECT="BleToolsKit.xcodeproj"   # 你的工程文件
SCHEME="BleToolsKit"              # ✅ 使用工程里的实际 Scheme 名
CONFIG="Release"

DERIVED="./DerivedBuild"
OUT="./ReleaseArtifacts"

rm -rf "$DERIVED" "$OUT"
mkdir -p "$DERIVED" "$OUT"

echo "👉 Schemes in project:"
xcodebuild -list -project "$PROJECT"

# 设备（iOS）
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -destination "generic/platform=iOS" \
  -archivePath "$DERIVED/ios" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 模拟器（iOS Simulator）
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$DERIVED/sim" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 生成 XCFramework
xcodebuild -create-xcframework \
  -framework "$DERIVED/ios.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$DERIVED/sim.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -output "$OUT/$SCHEME.xcframework"

echo "✅ XCFramework ready at: $OUT/$SCHEME.xcframework"