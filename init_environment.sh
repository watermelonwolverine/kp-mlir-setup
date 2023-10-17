
source export_targetdir.sh

# put just in the path
export PATH="$PATH:${targetdir}/bin"
# both of these are use in the different justfiles
export LLVM_INSTALL_DIR="${targetdir}/kp-mlir/llvm-project"