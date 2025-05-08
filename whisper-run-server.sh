#!/bin/bash

set -eu

#MODEL=large-v3-turbo-q5_0
#MODEL=large-v3-turbo-q8_0
MODEL=large-v3-turbo
CUDAENV=~/bin/cuda.env
SERVER=./build/bin/whisper-server

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

(
	cd $SCRIPT_DIR

	source $CUDAENV
	cmake -B build -DGGML_CUDA=1
	cmake --build build -j8 --config Release

	./models/download-ggml-model.sh $MODEL || true
	$SERVER --model models/ggml-$MODEL.bin
)
