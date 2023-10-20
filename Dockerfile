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

# RISC-VのGCCツールチェーンをビルドするためのスクリプト等をダウンロード
RUN git config --global http.postBuffer 524288000
RUN git config --global ssh.postBuffer 524288000
RUN git clone --depth=1 --recurse-submodules --shallow-submodules https://github.com/riscv-collab/riscv-gnu-toolchain.git

# RISC-V 32ビット用のツールチェーンをビルド
WORKDIR /riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv32 --with-arch=rv32i --with-abi=ilp32 && \
    make

# 環境変数を設定して、ツールチェーンが見つかるようにする
ENV PATH="/opt/riscv32/bin:${PATH}"

WORKDIR /workspaces/writing-os-in-1000-lines/

ARG USERNAME=mikiken
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER mikiken