#!/bin/bash

# In this configuration, the following dependent libraries are compiled:
#
# * zlib
# * c-ares
# * expat
# * sqlite3
# * openSSL
# * libssh2

#COMPILER AND PATH
mkdir -p /build/build_libs

PREFIX=/build/build_libs
C_COMPILER="x86_64-alpine-linux-musl-gcc"
CXX_COMPILER="x86_64-alpine-linux-musl-g++"

#CHECK TOOL FOR DOWNLOAD
 DOWNLOADER="wget -c"

## DEPENDENCES ##
ZLIB=http://sourceforge.net/projects/libpng/files/zlib/1.2.11/zlib-1.2.11.tar.gz
OPENSSL=https://www.openssl.org/source/openssl-1.1.1l.tar.gz
EXPAT=https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.bz2
SQLITE3=https://sqlite.org/2021/sqlite-autoconf-3360000.tar.gz
C_ARES=https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.17.2.tar.gz
SSH2=https://github.com/libssh2/libssh2/releases/download/libssh2-1.10.0/libssh2-1.10.0.tar.gz
ARIA2=https://github.com/aria2/aria2/releases/download/release-${ARIA2_VER}/aria2-${ARIA2_VER}.tar.xz

## CONFIG ##
BUILD_DIRECTORY=/build

## BUILD ##
cd $BUILD_DIRECTORY
#
 # zlib build
  $DOWNLOADER $ZLIB
  tar zxvf zlib-1.2.11.tar.gz
  cd zlib-1.2.11/
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./configure --prefix=$PREFIX --static
  make
  make install
#
 # expat build
  cd ..
  $DOWNLOADER $EXPAT
  tar jxvf expat-2.4.1.tar.bz2
  cd expat-2.4.1/
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./configure --prefix=$PREFIX --enable-static --enable-shared
  make
  make install
#
 # c-ares build
  cd ..
  $DOWNLOADER $C_ARES
  tar zxvf c-ares-1.17.2.tar.gz
  cd c-ares-1.17.2/
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./configure --prefix=$PREFIX --enable-static --disable-shared
  make
  make install
#
 # Openssl build
  cd ..
  $DOWNLOADER $OPENSSL
  tar zxvf openssl-1.1.1l.tar.gz
  cd openssl-1.1.1l/
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./Configure --prefix=$PREFIX linux-x86_64 shared
  make
  make install
#
 # sqlite3
  cd ..
  $DOWNLOADER $SQLITE3
  tar zxvf sqlite-autoconf-3360000.tar.gz
  cd sqlite-autoconf-3360000/
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./configure --prefix=$PREFIX --enable-static --enable-shared
  make
  make install
#
 # libssh2
  cd ..
  $DOWNLOADER $SSH2
  tar zxvf libssh2-1.10.0.tar.gz
  cd libssh2-1.10.0/
  rm -rf $PREFIX/lib/pkgconfig/libssh2.pc
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ LD_LIBRARY_PATH=$PREFIX/lib/ CC="$C_COMPILER" CXX="$CXX_COMPILER" ./configure --without-libgcrypt --with-openssl --without-wincng --prefix=$PREFIX --enable-static --disable-shared
  make
  make install
#
 # aria2
  cd ..
  $DOWNLOADER $ARIA2
  tar xf aria2-${ARIA2_VER}.tar.xz
  cd aria2-${ARIA2_VER}
  sed -i '78a \      << "\\n"\n      << _("** Compile For Auska **") << "\\n"\n      << _("[My Blog] https://blog.auska.win/") << "\\n"' src/version_usage.cc
  sed -i 's/"1", 1, 16/"1", 1, 128/g' src/OptionHandlerFactory.cc
  sed -i 's/"60", 0, 600/"60", 0, 3600/g' src/OptionHandlerFactory.cc
  sed -i 's/builtinHds.emplace_back("Want-Digest:", wantDigest);//g' src/HttpRequest.cc
  PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/ \
  LD_LIBRARY_PATH=$PREFIX/lib/ \
  ./configure \
    --without-libxml2 \
    --without-libgcrypt \
    --with-openssl \
    --without-libnettle \
    --without-gnutls \
    --without-libgmp \
    --with-libssh2 \
    --with-sqlite3 \
    --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' \
    ARIA2_STATIC=yes \
    --enable-shared=no
    make install-strip
#
 #cleaning
  cd ..
  rm -rf c-ares*
  rm -rf sqlite-autoconf*
  rm -rf zlib-*
  rm -rf expat-*
  rm -rf openssl-*
  rm -rf libssh2-*
  rm -rf aria2-*
#
 echo "finished!"