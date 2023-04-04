
FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

RUN apt update
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y clang-14 lld-14 curl unzip zip git vim ccache cmake ninja-build gdb valgrind



# setup user 
RUN useradd -u 8787 student
COPY bootstrap.sh /home/student/
RUN chown -R student:student /home/student
RUN chmod 755 /home/student/bootstrap.sh

USER student
WORKDIR /home/student
CMD /bin/bash --login

COPY user-profile.sh /home/student/.bash_profile

# Run bootstrap script, install Scala, native image, just.
RUN /home/student/bootstrap.sh

# this is here to access just
ENV PATH="$PATH:/home/student/bin"

# install LLVM
RUN git clone --single-branch --depth 1 --branch llvmorg-16.0.0 https://github.com/llvm/llvm-project.git

COPY llvm-justfile /home/student/llvm-project/justfile

RUN cd /home/student/llvm-project && just cmake
# note that these commands will take a while
RUN cd /home/student/llvm-project && just build
RUN cd /home/student/llvm-project && LLVM_BUILD_TYPE=Debug just build

ENV LLVM_INSTALL_DIR="/home/student/llvm-project"

# clone project files
# note that these are not accessible if you aren't in the teaching group
# todo put them on github
ADD --keep-git-dir=true git@cc.inf.tu-dresden.de:teaching/kp-mlir-sigi-frontend.git
ADD --keep-git-dir=true git@cc.inf.tu-dresden.de:teaching/kp-mlir-sigi-mlir.git


