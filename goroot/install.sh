#!/bin/sh -efu
GOVERSION=${1?usage: ./install.sh GOVERSION}
wget "https://storage.googleapis.com/golang/go$GOVERSION.src.tar.gz"
tar xf "./go$GOVERSION.src.tar.gz"
mv ./go "./go$GOVERSION"
