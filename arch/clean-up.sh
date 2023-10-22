#!/bin/bash

script_dir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")

# This also deletes all installed candidates
rm -rf $HOME/.sdkman

source "${script_dir}/export_targetdir.sh"

rm -r "${targetdir}/kp-mlir"
rm -r "${targetdir}/just"

echo "============================================"
echo "You have to manually remove sdkman from PATH"
echo "============================================"