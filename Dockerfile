
FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

RUN apt update
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y clang-14 lld-14 curl unzip zip git vim ccache cmake ninja-build



# setup user 
RUN useradd -u 8787 student
COPY dockerstuff/bootstrap.sh /home/student/
RUN chown -R student:student /home/student
RUN chmod 755 /home/student/bootstrap.sh

USER student
WORKDIR /home/student
CMD /bin/bash --login

COPY dockerstuff/user-profile.sh /home/student/.bash_profile

# Run bootstrap script, install Scala, native image, just.
RUN /home/student/bootstrap.sh

# this is here to access just
ENV PATH="$PATH:/home/student/bin"

# install LLVM
RUN git clone --single-branch --depth 1 --branch llvmorg-16.0.0  https://github.com/llvm/llvm-project.git

COPY dockerstuff/llvm-justfile /home/student/llvm-project/justfile

RUN cd /home/student/llvm-project && just cmake
RUN cd /home/student/llvm-project && just build
RUN cd /home/student/llvm-project && LLVM_BUILD_TYPE=Debug just build

ENV LLVM_INSTALL_DIR="/home/student/llvm-project"

# clone project files

RUN --mount=target=/var/context \
    git clone /var/context/sigi-frontend \
    && git clone /var/context/sigi-mlir 


RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install sbt



