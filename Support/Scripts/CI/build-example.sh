#!/usr/bin/env bash

set -eux
set -o pipefail

WORKSPACE=${WORKSPACE:-Openpay.xcworkspace}
EXAMPLE_SCHEME=${EXAMPLE_SCHEME:-Example}
DESTINATION=${DESTINATION:-platform=iOS Simulator,name=iPhone 11,OS=latest}
CONFIGURATION=${CONFIGURATION:-Debug}

echo 'Start to build the Example project'

xcodebuild build \
	-workspace "${WORKSPACE}" \
	-scheme "${EXAMPLE_SCHEME}" \
	-configuration "${CONFIGURATION}" \
	-destination "${DESTINATION}" \
	| xcpretty

exit_code="${PIPESTATUS[0]}"

if [[ "${exit_code}" != 0 ]]; then
  die "xcodebuild build exited with non-zero status code: ${exit_code}"
fi
