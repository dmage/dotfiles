#!/bin/sh
curl -sS https://golang.org/dl/ | grep -Po 'go1\.[0-9.]*(?=\.src)' | sort -uV
