#!/bin/sh

git submodule update --init --recursive

cargo build --release --target-dir .

path=$(find . -iname "ggcat")

mkdir -p $PREFIX/bin
cp $path $PREFIX/bin
