#!/bin/sh

git submodule update --init --recursive

cargo build --release

cp target/release/ggcat $PREFIX/bin
