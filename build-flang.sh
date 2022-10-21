#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
TARGET="X86"
BUILD_TYPE="Release"
INSTALL_PREFIX="/usr/local"
NPROC=1
USE_CCACHE="0"
USE_SUDO="0"
VERBOSE=""

set -e # Exit the script on first error.

function print_usage {
    echo "Usage: ./build-flang.sh [options]";
    echo "";
    echo "Build and install libpgmath and flang.";
    echo "Run this script in a directory with flang sources.";
    echo "Example:";
    echo "  $ git clone https://github.com/flang-compiler/flang";
    echo "  $ cd flang";
    echo "  $ ./build-flang.sh -t X86 -p /install/prefix/ -n 2 -s";
    echo "";
    echo "Options:";
    echo "  -t  Target to build for (X86, AArch64, PowerPC). Default: X86";
    echo "  -d  CMake build type. Default: Release";
    echo "  -p  Install prefix. Default: /usr/local";
    echo "  -n  Number of parallel jobs. Default: 1";
    echo "  -c  Use ccache. Default: 0 - do not use ccache";
    echo "  -s  Use sudo to install. Default: 0 - do not use sudo";
    echo "  -v  Enable verbose output";
}

while getopts "t:d:p:n:c?s?v" opt; do
    case "$opt" in
        t) TARGET=$OPTARG;;
        d) BUILD_TYPE=$OPTARG;;
        p) INSTALL_PREFIX=$OPTARG;;
        n) NPROC=$OPTARG;;
        c) USE_CCACHE="1";;
        s) USE_SUDO="1";;
        v) VERBOSE="1";;
        ?) print_usage; exit 0;;
    esac
done

CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_CXX_COMPILER=$INSTALL_PREFIX/bin/clang++ \
    -DCMAKE_C_COMPILER=$INSTALL_PREFIX/bin/clang \
    -DLLVM_TARGETS_TO_BUILD=$TARGET"

if [ $USE_CCACHE == "1" ]; then
  echo "Build using ccache"
  CMAKE_OPTIONS="$CMAKE_OPTIONS \
      -DCMAKE_C_COMPILER_LAUNCHER=ccache \
      -DCMAKE_CXX_COMPILER_LAUNCHER=ccache"
fi

# Build and install libpgmath
cd runtime/libpgmath
mkdir -p build && cd build
if [ -n "$VERBOSE" ]; then
  set -x
fi
cmake $CMAKE_OPTIONS ..
set +x
make -j$NPROC VERBOSE=$VERBOSE
if [ $USE_SUDO == "1" ]; then
  echo "Install with sudo"
  sudo make install
else
  echo "Install without sudo"
  make install
fi

cd ../../..

# Build and install flang
mkdir -p build && cd build
if [ -n "$VERBOSE" ]; then
  set -x
fi
cmake $CMAKE_OPTIONS \
      -DCMAKE_Fortran_COMPILER=$INSTALL_PREFIX/bin/flang \
      -DCMAKE_Fortran_COMPILER_ID=Flang \
      -DFLANG_INCLUDE_DOCS=ON \
      -DFLANG_LLVM_EXTENSIONS=ON \
      -DWITH_WERROR=ON \
      ..
set +x
make -j$NPROC VERBOSE=$VERBOSE
if [ $USE_SUDO == "1" ]; then
  echo "Install with sudo"
  sudo make install
else
  echo "Install without sudo"
  make install
fi
