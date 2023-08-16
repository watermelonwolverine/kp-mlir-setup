#!/bin/bash

# review this and also user-profile.sh
ROOT_INSTALL_DIR="$HOME/kp-mlir"
JUST_INSTALL_DIR="$HOME/bin"
LLVM_DIR="$ROOT_INSTALL_DIR/llvm-project"

mkdir -p "$JUST_INSTALL_DIR"
mkdir -p "$ROOT_INSTALL_DIR"

sudo apt update
sudo apt install -y clang-14 lld-14 curl unzip zip git vim ccache cmake ninja-build gdb valgrind

cat user-profile.sh >> $HOME/.bash_profile


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

git clone git@github.com:tud-ccc/kp-mlir-sigi-frontend.git "$ROOT_INSTALL_DIR/sigi-frontend"
git clone git@github.com:tud-ccc/kp-mlir-sigi-mlir.git "$ROOT_INSTALL_DIR/sigi-mlir"


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
