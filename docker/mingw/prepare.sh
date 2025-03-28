#!/bin/bash
#
# Functions for building MinGW port in Docker
#
# This file is part of the shadowsocks-libev.
#
# shadowsocks-libev is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# shadowsocks-libev is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with shadowsocks-libev; see the file COPYING. If not, see
# <http://www.gnu.org/licenses/>.
#

# Exit on error
set -e

# Build options
BASE="/build"
PREFIX="$BASE/stage"
SRC="$BASE/src"
DIST="$BASE/dist"

# Project URL
PROJ_SITE=$REPO   # Change REPO in Makefile
PROJ_REV=$REV     # Change REV in Makefile
PROJ_URL=https://github.com/${PROJ_SITE}/shadowsocks-libev.git

# Libraries from project

## libev for MinGW
LIBEV_VER=mingw
LIBEV_SRC=libev-${LIBEV_VER}
LIBEV_URL=https://github.com/shadowsocks/libev/archive/${LIBEV_VER}.tar.gz

# Public libraries

## mbedTLS
MBEDTLS_VER=2.16.5
MBEDTLS_SRC=mbedtls-${MBEDTLS_VER}
MBEDTLS_URL=https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-${MBEDTLS_VER}.tar.gz
## Sodium
SODIUM_VER=1.0.18
SODIUM_SRC=libsodium-stable
SODIUM_URL=http://download.libsodium.org/libsodium/releases/libsodium-${SODIUM_VER}-stable.tar.gz

## PCRE
PCRE_VER=8.44
PCRE_SRC=pcre-${PCRE_VER}
PCRE_URL=https://altushost-swe.dl.sourceforge.net/project/pcre/pcre/${PCRE_VER}/${PCRE_SRC}.tar.gz?viasf=1

## c-ares
CARES_VER=1.16.0
CARES_SRC=c-ares-${CARES_VER}
CARES_URL=https://github.com/c-ares/c-ares/releases/download/cares-1_16_0/${CARES_SRC}.tar.gz

# Build steps

dk_download() {
    mkdir -p "${SRC}"
    cd "${SRC}"
    DOWN="aria2c --file-allocation=trunc -s10 -x10 -j10 -c"
    for pkg in LIBEV SODIUM MBEDTLS PCRE CARES; do
        src=${pkg}_SRC
        url=${pkg}_URL
        out="${!src}".tar.gz
        $DOWN ${!url} -o "${out}"
        echo "Unpacking ${out}..."
        tar zxf ${out}
    done
    # fix MBEDTLS package
    mv /build/src/mbedtls-mbedtls-2.16.5 /build/src/mbedtls-2.16.5
    ls -l /build/src
}
