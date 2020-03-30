#!/bin/sh
curl -sS https://golang.org/dl/ | grep -o 'go1\.[0-9.]*.src' | sed -e 's/\.src$//' | sort -uV
