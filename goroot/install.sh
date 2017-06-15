#!/bin/sh -eu
GOVERSION=${1?usage: ./install.sh GOVERSION}
[ ! -e "./go$GOVERSION/bin/go" ] || { echo "./go$GOVERSION/bin/go already exists." >&2; exit 1; }
[ ! -e "./go" ] || { echo "Please remove the ./go directory first." >&2; exit 1; }

if [ ! -e "./go$GOVERSION" ]; then
    wget -c "https://storage.googleapis.com/golang/go$GOVERSION.src.tar.gz"
    tar xf "./go$GOVERSION.src.tar.gz"
    mv ./go "./go$GOVERSION"
fi

if [ -n "${GOVERSION##1.[01234].*}" ]; then
    # Go 1.5+ requires GOROOT_BOOTSTRAP
    GOVERSION_BOOTSTRAP=$(ls ./go1.*/bin/go | sort -nrt. -k3,3 | sort -nrst. -k2,2 | head -n1)
    GOVERSION_BOOTSTRAP=${GOVERSION_BOOTSTRAP%/bin/go}
    GOVERSION_BOOTSTRAP=${GOVERSION_BOOTSTRAP#./go}
    if [ -z "${GOVERSION_BOOTSTRAP##1.[0123].*}" ]; then
        ./install.sh 1.4.3
        export GOROOT_BOOTSTRAP="$PWD/go1.4.3"
    else
        export GOROOT_BOOTSTRAP="$PWD/go$GOVERSION_BOOTSTRAP"
    fi
fi

cd "./go$GOVERSION/src"
if [ "$GOVERSION" = "1.4.3" ]; then
    if [ "$(uname -s)" = "Darwin" ]; then
        cd ..
        for commit in fad2bbdc6a686a20174d2e73cf78f1659722bb39 2da5633eb9091608047881953f75b489a3134cdc; do
            wget -c https://github.com/golang/go/commit/$commit.patch
            patch -p1 < $commit.patch
        done
        cd ./src
    fi
    CGO_ENABLED=0 exec ./all.bash
else
    exec ./all.bash
fi
