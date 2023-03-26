#!/bin/bash


# make sdkman non-interactive
export sdkman_auto_answer=true
# get sdkman
curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"


# get scala
sdk i scala 3.2.1
# get graalvm
sdk i java 22.3.r19-grl
# get native image
gu install native-image

# at this point sbt should have what it needs (or be able to download it)

# create ~/bin
mkdir -p ~/bin

# download and extract just to ~/bin/just
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin
