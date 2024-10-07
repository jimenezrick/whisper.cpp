#!/bin/bash

set -eu

# See: https://github.com/ggerganov/whisper.cpp/tree/master/models
# https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin?download=true
MODEL=models/ggml-large-v3-turbo-q5_0.bin
CUDAENV=~/bin/cuda.env

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

(
	cd $SCRIPT_DIR

	source $CUDAENV
	env GGML_CUDA=1 make -j8 server

	./server --model $MODEL
)
