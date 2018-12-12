#!/bin/bash

set -euo pipefail

tar -zxf extension-config.tar.gz
perl Makefile.PL &>/dev/null
make cpanfile
carton install --deployment
