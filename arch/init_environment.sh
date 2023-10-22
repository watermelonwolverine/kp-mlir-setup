script_dir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")

source "${script_dir}/export_targetdir.sh"

# put just in the path
export PATH="$PATH:${targetdir}/just"
# both of these are use in the different justfiles
export LLVM_INSTALL_DIR="${targetdir}/kp-mlir/llvm-project"