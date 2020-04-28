#!/bin/bash

BASENAME="web_healthcheck"
OUTPUT_DIR=./bin

if [ -d $OUTPUT_DIR ]; then
    rm -rf $OUTPUT_DIR
fi

function build {
    OS=$1
    FILENAME=$2
    echo "Running: 'CGO_ENABLED=0 GOOS=$OS go build -a -installsuffix cgo -o $OUTPUT_DIR/$FILENAME'"
    CGO_ENABLED=0 GOOS=$OS go build -a -installsuffix cgo -o $OUTPUT_DIR/$FILENAME
}


build "linux" $BASENAME
build "windows" $BASENAME.exe

echo "Complete"
