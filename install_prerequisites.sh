#!/usr/bin/env bash

set -x
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7.0 main"
sudo apt-get update
sudo apt-get install -y clang-7.0
