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
cd ../

echo '#include <cstdint>' | cat - SBWT/KMC/kmc_tools/kff_info_reader.h > temp && mv temp SBWT/KMC/kmc_tools/kff_info_reader.h
echo '#include <cstdint>' | cat - SBWT/KMC/kmc_core/kff_writer.h > temp && mv temp SBWT/KMC/kmc_core/kff_writer.h
echo '#include <cstdint>' | cat - ggcat/crates/capi/ggcat-cpp-api/src/ggcat.hh > temp && mv temp ggcat/crates/capi/ggcat-cpp-api/src/ggcat.hh

sed 's/g++/$(CXX)/g' ggcat/crates/capi/ggcat-cpp-api/Makefile > tmp_makefile
mv tmp_makefile ggcat/crates/capi/ggcat-cpp-api/Makefile
sed 's/g++/$(CXX)/g' ggcat/crates/capi/ggcat-cpp-api/example/Makefile > tmp_makefile
mv tmp_makefile ggcat/crates/capi/ggcat-cpp-api/example/Makefile
sed 's/g++/$(CXX)/g' integration_tests/reference_implementation/Makefile > tmp_makefile
mv tmp_makefile integration_tests/reference_implementation/Makefile
sed 's/g++/$(CXX)/g' SBWT/KMC/Makefile > tmp_makefile
mv tmp_makefile SBWT/KMC/Makefile
sed 's/g++/$(CXX)/g' SBWT/KMC/tests/kmc_CLI/trivial-k-mer-counter/Makefile > tmp_makefile
mv tmp_makefile SBWT/KMC/tests/kmc_CLI/trivial-k-mer-counter/Makefile

cd build
cmake .. -DMAX_KMER_LENGTH=64 -DCMAKE_BUILD_ZLIB=1 -DCMAKE_BUILD_BZIP2=0 -DROARING_DISABLE_NATIVE=ON
make -j${CPU_COUNT} ${VERBOSE_AT}

cp bin/themisto $PREFIX/bin
