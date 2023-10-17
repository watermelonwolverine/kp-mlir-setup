#!/bin/bash

# This also deletes all installed candidates
rm -rf $HOME/.sdkman

source export_targetdir.sh

rm -r "${targetdir}/kp-mlir"
rm -r "${targetdir}/just"
