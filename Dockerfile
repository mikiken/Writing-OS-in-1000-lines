FROM ubuntu:20.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    build-essential \
    git \
    wget \
    gawk \
    texinfo \
    bison \
    autoconf \
    cmake automake autotools-dev \
    python3 python3-pip \
    libmpc-dev libmpfr-dev libgmp-dev flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build libglib2.0-dev

RUN apt-get install -y \
    clang \
    llvm \
    lld \
    qemu-system-riscv32 \
    curl

WORKDIR /workspaces/writing-os-in-1000-lines/src
RUN curl -LO https://github.com/qemu/qemu/raw/v8.0.4/pc-bios/opensbi-riscv32-generic-fw_dynamic.bin

RUN useradd -m -d /home/mikiken -s /bin/bash mikiken
USER mikiken
