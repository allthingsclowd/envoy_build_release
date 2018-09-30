#!/usr/bin/env bash

set -x

wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main'
sudo apt-get -qq update
sudo apt-get -qq --force-yes install clang-7 clang-modernize-7 # clang-format-3.5
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-7 1
sudo apt-get -qq --force-yes install clang-format-7

