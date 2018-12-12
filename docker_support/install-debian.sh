#!/bin/bash

set -euo pipefail

apt-get update
apt-get install -y \
    build-essential libcairo-dev curl libssl1.0-dev \
    zlib1g-dev openssl git cmake libgd-dev \
    libmariadbclient-dev wget libgmp-dev

cpanm --notest Module::CPANfile Carton

