#!/usr/bin/env bash

set -eux
set -o pipefail

echo 'Start to lint Cocoapods'

gem install cocoapods
pod lib lint
