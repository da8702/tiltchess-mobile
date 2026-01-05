#!/usr/bin/env bash
set -euo pipefail

# Usage: ./run_ios_clean.sh [device name]
DEVICE="${1:-iPhone 16e}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

env -i \
  HOME="$HOME" USER="$USER" \
  PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/share/flutter/bin" \
  DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer" \
  /bin/zsh -lc "
    set -euo pipefail
    cd \"$ROOT\"
    flutter clean
    flutter pub get
    cd ios
    pod deintegrate || true
    rm -rf Pods Podfile.lock
    pod install
    cd ..
    flutter run -d \"$DEVICE\"
  "
