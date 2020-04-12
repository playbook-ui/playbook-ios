#!/bin/bash

set -eu

ROOT=$(cd $(dirname $0)/.. && pwd)
PACKAGE_NAME=${1?"USAGE: $(basename $0) <package name> <parameter>"}
ARGS=${@:2}
PACKAGE_PATH="$ROOT/Tools"
SWIFT_BUILD="swift build -c release --package-path $PACKAGE_PATH"
BIN_DIR=$($SWIFT_BUILD --show-bin-path)
BIN="$BIN_DIR/$PACKAGE_NAME"
CHECKSUM="$BIN_DIR/$PACKAGE_NAME.sha256"

if [[ ! -e $BIN || ! -e $CHECKSUM || $($(shasum -a 256 -c $CHECKSUM >/dev/null) echo $0) != 0 ]]; then
    echo "$PACKAGE_NAME is not installed"
    echo "Installing ..."
    $SWIFT_BUILD --product $PACKAGE_NAME
    shasum -a 256 "$PACKAGE_PATH/Package.resolved" >$CHECKSUM
fi

$BIN $ARGS
