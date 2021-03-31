#!/usr/bin/env bash

set -eux
set -o pipefail

echo 'Start to lint Cocoapods'

gem install cocoapods

export LIB_VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
pod lib lint
pod spec lint
