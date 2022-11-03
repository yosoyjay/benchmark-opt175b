#!/bin/bash
# Example of launched experiments using customized MetaSeq for CLI config of envvars

for test_number in {1..10}; do
    test_name=$(printf "%03d" $(( $test_number + 10)))
    opt-baselines --model-size 125m --benchmark -t 3 -g 8 -n 2 -p azure-test-${test_name} --azure-test-number $test_number --azure > azure-test-${test_name}.log
done
