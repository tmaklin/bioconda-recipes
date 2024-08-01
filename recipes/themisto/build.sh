#!/bin/sh

export CFLAGS="$C -no-pie -lrt"
export CXXFLAGS="$CXXFLAGS -std=c++20 -no-pie -lrt"

CC=$CC
CXX=$CXX
LINK=$CC

mkdir -p $PREFIX/bin

export RUSTFLAGS="-C linker=$CC"

git submodule update --init --recursive

cd ggcat
git checkout a91ecc9

## Rewrite the C api makefile
echo -e '.PHONY: all ggcat-capi ggcat-source

all: lib/libggcat_api.a

clean:
\tcargo clean
\trm -r build/ lib/

lib/libggcat_api.a: ./lib/libggcat_cpp_bindings.a
\tmkdir -p build/
\t$(CXX) -std=c++11 -fPIE -O3 -Wno-unused-command-line-argument -I./include -I./src -c ./src/ggcat.cc -lggcat_cpp_bindings -lggcat_cxx_interop -o build/ggcat.o -Wall -Wextra -Werror
\t$(AR) cr lib/libggcat_api.a build/ggcat.o

./lib/libggcat_cpp_bindings.a: ggcat-source
\tcargo build --release --package ggcat-cpp-bindings
\tcp $(shell cargo check --release --message-format=json | grep libggcat_cpp_bindings | jq '"'"'.filenames'"'"' | jq -r '"'"'.[0]'"'"' | sed '"'"'s/deps.*$$/libggcat_cpp_bindings.a/g'"'"') ./lib/' > crates/capi/ggcat-cpp-api/Makefile
cd ../

echo '#include <cstdint>' | cat - SBWT/KMC/kmc_tools/kff_info_reader.h > temp && mv temp SBWT/KMC/kmc_tools/kff_info_reader.h
echo '#include <cstdint>' | cat - SBWT/KMC/kmc_core/kff_writer.h > temp && mv temp SBWT/KMC/kmc_core/kff_writer.h
echo '#include <cstdint>' | cat - ggcat/crates/capi/ggcat-cpp-api/src/ggcat.hh > temp && mv temp ggcat/crates/capi/ggcat-cpp-api/src/ggcat.hh

sed 's/g++/$(CXX)/g' SBWT/KMC/Makefile > tmp_makefile
mv tmp_makefile SBWT/KMC/Makefile
sed 's/g++/$(CXX)/g' SBWT/KMC/tests/kmc_CLI/trivial-k-mer-counter/Makefile > tmp_makefile
mv tmp_makefile SBWT/KMC/tests/kmc_CLI/trivial-k-mer-counter/Makefile

cd build
cmake .. -DMAX_KMER_LENGTH=64 -DCMAKE_BUILD_ZLIB=1 -DCMAKE_BUILD_BZIP2=0 -DROARING_DISABLE_NATIVE=ON
make -j${CPU_COUNT} ${VERBOSE_AT}
