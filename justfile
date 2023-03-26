
image_name := "ubuntu-kp-mlir"


build:
    docker build -t {{image_name}} -f ./Dockerfile ..

alias b := build

run:
    docker container run -ti {{image_name}} /bin/bash
