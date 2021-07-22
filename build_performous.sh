#!/bin/bash -ex
## Pull in /etc/os-release so we can see what we're running on
. /etc/os-release

## All the git stuff
git clone git://github.com/performous/performous.git
cd performous
if [ ${1} ]; then
  git fetch origin pull/${1}/head:pr
  git checkout pr
fi
git submodule update --init --recursive

## Set up some special cmake flags for fedora
if [ ${ID} == 'fedora' ]; then
  EXTRA_CMAKE_ARGS='-DUSE_BOOST_REGEX=1'
fi

## Standard build
mkdir build.make
cd build.make
cmake ${EXTRA_CMAKE_ARGS} ..
CPU_CORES=$(nproc --all)
make -j${CPU_CORES}
cd ..

## Meson build
meson build
cd build
meson compile
