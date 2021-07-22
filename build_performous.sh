#!/bin/bash -ex
git clone git://github.com/performous/performous.git
cd performous
if [ ${1} ]; then
  git fetch origin pull/${1}/head:pr
  git checkout pr
fi
git submodule update --init --recursive

## Standard build
mkdir build
cd build
cmake ..
CPU_CORES=$(nproc --all)
make -j${CPU_CORES}
cd ..

## Meson build
mv build build.make
apt install -y libaubio-dev
meson build
cd build
meson compile
