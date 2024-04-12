#!/bin/bash

# https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-q5_0.bin?download=true
MODEL=models/ggml-large-v3-q5_0.bin
CUDAENV=/mnt/scratch-nvme/ricardo/CUDA12/cuda.env

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

(
	cd $SCRIPT_DIR

	source $CUDAENV
	env WHISPER_CUDA=1 make -j server

	./server --model $MODEL
)
