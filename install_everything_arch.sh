#!/bin/bash

echo "Execute install_system_packages_arch.sh before executing this the first time"

source ./export_targetdir.sh

ROOT_INSTALL_DIR="${targetdir}/kp-mlir"
JUST_INSTALL_DIR="${targetdir}/just"
LLVM_DIR="$ROOT_INSTALL_DIR/llvm-project"

mkdir -p "$JUST_INSTALL_DIR"
mkdir -p "$ROOT_INSTALL_DIR"

# make sdkman non-interactive
export sdkman_auto_answer=true
# get sdkman
curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

# get scala
sdk i scala 3.2.1
sdk i sbt
# get graalvm
sdk i java 22.3.r19-grl
# get native image
gu install native-image

# at this point sbt should have what it needs (or be able to download it)

# download and extract just to ~/bin/just
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$JUST_INSTALL_DIR"

# this is here to access just
PATH="$PATH:$JUST_INSTALL_DIR"

# install LLVM
git clone --single-branch --depth 1 --branch llvmorg-16.0.0 https://github.com/llvm/llvm-project.git "$LLVM_DIR"

cp llvm-justfile "$LLVM_DIR/justfile"

# Build LLVM
pushd "$LLVM_DIR"
export LLVM_BUILD_TYPE=Debug
just cmake
just build
LLVM_BUILD_DIR=$(just printBuildDir)
popd

git clone https://github.com:tud-ccc/kp-mlir-sigi-frontend "$ROOT_INSTALL_DIR/sigi-frontend"
git clone https://github.com:tud-ccc/kp-mlir-sigi-mlir "$ROOT_INSTALL_DIR/sigi-mlir"


pushd "$ROOT_INSTALL_DIR/sigi-frontend"
# Build the frontend
just build
popd

pushd "$ROOT_INSTALL_DIR/sigi-mlir"
# Record location of llvm build directory for the justfile to find it
echo "LLVM_BUILD_DIR=$LLVM_BUILD_DIR" > .env
# Build the repo
just cmake
just build
popd
