#!/usr/bin/env bash

set -eux
set -o pipefail

WORKSPACE=${WORKSPACE:-.swiftpm/xcode/package.xcworkspace}
SCHEME=${SCHEME:-Openpay}
DESTINATION=${DESTINATION:-platform=iOS Simulator,name=iPhone 11,OS=latest}
CONFIGURATION=${CONFIGURATION:-Release}

echo 'Start to build swift package'

xcodebuild \
    -workspace "${WORKSPACE}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -destination "${DESTINATION}" \
    | xcpretty

exit_code="${PIPESTATUS[0]}"

if [[ "${exit_code}" != 0 ]]; then
  die "xcodebuild build swift package exited with non-zero status code: ${exit_code}"
fi
