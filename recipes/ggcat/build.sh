#!/bin/sh

git submodule update --init --recursive

cargo build --release --target-dir .

mkdir -p $PREFIX/bin
cp ggcat $PREFIX/bin
