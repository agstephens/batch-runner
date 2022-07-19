#!/bin/bash

batch_size=${1:-100}
input_file=${PWD}/file-list.txt
nfiles=$(wc -l $input_file | cut -d' ' -f1)
duration="00:30:00"

lotus_queue=short-serial
job_name="batch-runner"

njobs=$(( nfiles / batch_size + 1 ))
echo "[INFO] Number of files to process: $nfiles"
echo "[INFO] Batch size: $batch_size"
echo "[INFO] Number of tasks to run: $njobs"
echo "[INFO] Job duration: $duration"
echo "[INFO] Job name: $job_name"

sbatch --partition=$lotus_queue \
       --job-name=$job_name \
       -o ${PWD}/%A_%a.out \
       -e ${PWD}/%A_%a.err \
       --time=$duration \
       --array=1-${njobs} \
       ${PWD}/batch-runner.sh $input_file $batch_size

