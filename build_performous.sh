#!/bin/bash -ex
## Pull in /etc/os-release so we can see what we're running on
. /etc/os-release

## Default Vars
GIT_REPOSITORY='git://github.com/performous/performous.git'

## Function to print the help message
usage() {
  echo "Usage: ${0} -a (build with all build systems)"
  echo ""
  echo "Optional Arguments:"
  echo "  -b <Git Branch>: Build the specified git branch, tag, or sha"
  echo "  -p <Pull Request #>: Build the specified Github Pull Request number"
  echo "  -m : Use Meson to build"
  echo "  -c : Use Cmake to build"
  echo "  -g : Generate Packages"
  echo "  -r <Repository URL>: Git repository to pull from"
  echo "  -h : Show this help message"
  exit 1
}

## Set up getopts
while getopts "ab:p:mcgh" OPTION; do
  case ${OPTION} in
    "a")
      BUILD_MESON=true
      BUILD_CMAKE=true;;
    "b")
      GIT_BRANCH=${OPTARG};;
    "p")
      PULL_REQUEST=${OPTARG};;
    "m")
      BUILD_MESON=true;;
    "c")
      BUILD_CMAKE=true;;
    "g")
      GENERATE_PACKAGES=true;;
    "r")
      GIT_REPOSITORY=${OPTARG};;
    "h")
      HELP=true;;
  esac
done

if ([ -z ${BUILD_MESON} ] && [ -z ${BUILD_CMAKE} ]) || [ ${HELP} ]; then
  usage
  exit 2
fi

## All the git stuff
git clone ${GIT_REPOSITORY}
cd performous
if [ ${PULL_REQUEST} ]; then
  git fetch origin pull/${PULL_REQUEST}/head:pr
  git checkout pr
elif [ ${GIT_BRANCH} ]; then
  git checkout ${GIT_BRANCH}
fi
git submodule update --init --recursive

## Set up some special cmake flags for fedora
if [ "${ID}" == "fedora" ]; then
  EXTRA_CMAKE_ARGS='-DUSE_BOOST_REGEX=1'
fi

## Figure out what type of packages we need to generate
case ${ID} in
  'fedora')
    PACKAGE_TYPE='RPM';;
  'ubuntu')
    PACKAGE_TYPE='DEB';;
  *)
    PACKAGE_TYPE='TAR';;
esac

## Cmake build
if [ ${BUILD_CMAKE} ]; then
  mkdir build.cmake
  cd build.cmake
  cmake ${EXTRA_CMAKE_ARGS} -DENABLE_WEBSERVER=ON -DCMAKE_VERBOSE_MAKEFILE=1 -DENABLE_WEBCAM=ON ..
  CPU_CORES=$(nproc --all)
  make -j${CPU_CORES}
  if [ ${GENERATE_PACKAGES} ]; then
    cpack -G ${PACKAGE_TYPE}
  fi
  cd ..
fi

## Meson build
if [ ${BUILD_MESON} ]; then
  meson setup build.meson -Dusewebcam=true -Dusemididrum=true -Dusewebserver=true -Dstoponwarning=true
  meson compile -C build.meson
  cd ..
fi
