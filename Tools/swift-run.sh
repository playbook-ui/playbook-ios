#!/bin/bash

set -e

PACKAGE_NAME=${1?"USAGE: swift_run.sh #{package name} #{parameter}"}
PARAMETERS=${@:2}
SWIFT_BUILD="swift build -c release --package-path $(dirname $0)"
PACKAGE_PATH=$($SWIFT_BUILD --show-bin-path)
CHECKSUM_PATH="$PACKAGE_PATH/checksum.sha256"
PACKAGE="$PACKAGE_PATH/$PACKAGE_NAME"

if [[ -e $PACKAGE && -e $CHECKSUM_PATH && $(shasum -a 256 -c $CHECKSUM_PATH) ]]; then
    echo "$PACKAGE_NAME already installed"
else
    echo "$PACKAGE_NAME has not been installed"
    $SWIFT_BUILD --product $PACKAGE_NAME
    shasum -a 256 $(dirname $0)/Package.resolved >$CHECKSUM_PATH
    echo "Build succeeded"
fi

$PACKAGE $PARAMETERS
