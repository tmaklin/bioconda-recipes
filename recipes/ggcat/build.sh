#!/bin/sh


unamestr=`uname`

if [ "$unamestr" == 'Darwin' ];
then
  export MACOSX_DEPLOYMENT_TARGET=10.15
  export CFLAGS="${CFLAGS} -fcommon -D_LIBCPP_DISABLE_AVAILABILITY"
  export CXXFLAGS="${CXXFLAGS} -fcommon -D_LIBCPP_DISABLE_AVAILABILITY"
else
  export CFLAGS="${CFLAGS} -fcommon"
  export CXXFLAGS="${CXXFLAGS} -fcommon"
  export C_INCLUDE_PATH="${C_INCLUDE_PATH}:${PREFIX}/include"
  export CPLUS_INCLUDE_PATH="${CPLUS_INCLUDE_PATH}:${PREFIX}/include"
fi

git submodule update --init --recursive

sed 's/ar cr/$(AR) cr/g' crates/capi/ggcat-cpp-api/Makefile > tmp_makefile
mv tmp_makefile crates/capi/ggcat-cpp-api/Makefile

sed 's/g++/$(CXX)/g' crates/capi/ggcat-cpp-api/example/Makefile > tmp_makefile
mv tmp_makefile crates/capi/ggcat-cpp-api/example/Makefile

cargo build --release
