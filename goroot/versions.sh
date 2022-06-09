#!/bin/sh
curl -sS https://go.dev/dl/ | grep -o 'go1\.[0-9.]*.src' | sed -e 's/\.src$//' | sort -uV
