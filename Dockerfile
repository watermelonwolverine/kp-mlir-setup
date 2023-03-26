

FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y clang-14 curl unzip zip git vim 

RUN useradd -u 8787 student

ADD dockerstuff/bootstrap.sh /home/student/
RUN chown -R student:student /home/student
RUN chmod 755 /home/student/bootstrap.sh


USER student
WORKDIR /home/student

RUN /home/student/bootstrap.sh

RUN --mount=target=/var/context \
    git clone /var/context/sigi-frontend \
    && git clone /var/context/sigi-mlir \

ENV PATH="$PATH:/home/student/bin"
