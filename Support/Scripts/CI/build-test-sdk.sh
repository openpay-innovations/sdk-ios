#!/usr/bin/env bash

set -eux
set -o pipefail

WORKSPACE=${WORKSPACE:-Openpay.xcworkspace}
SDK_SCHEME=${SDK_SCHEME:-Openpay}
DESTINATION=${DESTINATION:-platform=iOS Simulator,name=iPhone 11,OS=latest}
CONFIGURATION=${CONFIGURATION:-Debug}

echo 'Start to build the SDK project'

xcodebuild build-for-testing \
	-workspace "${WORKSPACE}" \
	-scheme "${SDK_SCHEME}" \
	-configuration "${CONFIGURATION}" \
	-destination "${DESTINATION}" \
	| xcpretty

exit_code="${PIPESTATUS[0]}"

if [[ "${exit_code}" != 0 ]]; then
  die "xcodebuild build-for-testing exited with non-zero status code: ${exit_code}"
fi

echo 'Start to test the SDK project'

xcodebuild test-without-building \
    -workspace "${WORKSPACE}" \
    -scheme "${SDK_SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -destination "${DESTINATION}"

exit_code="${PIPESTATUS[0]}"

if [[ "${exit_code}" != 0 ]]; then
  die "xcodebuild test-without-building exited with non-zero status code: ${exit_code}"
fi
