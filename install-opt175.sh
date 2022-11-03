#!/bin/bash
# Installs environment to run OPT-175B training benchmarks.

set -o errexit
set -o nounset
set -o pipefail

SRC_DIR=`readlink -f .`

printf "Downloading and installing software in ${SRC_DIR}"

printf "Installing Python requirements"
pip install -r requirements.txt  -f https://download.pytorch.org/whl/torch_stable.html

printf "Installing Apex"
git clone https://github.com/NVIDIA/apex
pushd apex
# Avoid CUDA extension + Pytorch complaint.  This is okay on Azure VMs. 
sed -i "s/(bare_metal_version != torch_binary_version)/False/g" setup.py
python -m pip install -v --no-cache-dir --global-option="--cpp_ext" \
    --global-option="--cuda_ext" \
    --global-option="--deprecated_fused_adam" \
    --global-option="--xentropy" \
    --global-option="--fast_multihead_attn" .
popd

printf "Installing NCCL"
git clone https://github.com/NVIDIA/nccl.git
pushd nccl
make clean && make -j src.build
popd

printf "Installing Megatron fork"
git clone https://github.com/ngoyal2707/Megatron-LM.git
pushd Megatron-LM
git checkout fairseq_v3
pip install -e .
popd

printf "Installing Fairscale"
git clone https://github.com/facebookresearch/fairscale.git
pushd fairscale
git checkout fixing_memory_issues_with_keeping_overlap
pip install .
popd

printf "Installing Metaseq"
git clone https://github.com/facebookresearch/metaseq.git
pushd metaseq
git log | grep "a1a4e733"
python setup.py build_ext --inplace
pip install -e .
popd

