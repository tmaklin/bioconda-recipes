#!/bin/sh

git submodule update --init --recursive

sed 's/ar/$(AR)/g' ggcat/crates/capi/ggcat-cpp-api/Makefile > tmp_makefile
mv tmp_makefile ggcat/crates/capi/ggcat-cpp-api/Makefile

sed 's/g++/$(CXX)/g' ggcat/crates/capi/ggcat-cpp-api/example/Makefile > tmp_makefile
mv tmp_makefile ggcat/crates/capi/ggcat-cpp-api/example/Makefile

cargo build --release --target-dir .

path=$(find . -iname "ggcat")

mkdir -p $PREFIX/bin
cp $path $PREFIX/bin
