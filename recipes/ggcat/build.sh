#!/bin/sh

git submodule update --init --recursive

rustup toolchain install 1.78.0
rustup default 1.78.0

cargo build --release

cp target/release/ggcat $PREFIX/bin
