#!/bin/bash
set -e
source swift-define

# Compress
rm -rf $INSTALL_TAR
cd $SWIFT_INSTALL_PREFIX
tar -czvf $INSTALL_TAR .
