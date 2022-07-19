#!/bin/bash 

input_file=$1
batch_size=$2
cmd="md5sum"

if [ ! -f "$input_file" ]; then
    echo "[ERROR] Input file does not exist: $input_file"
    exit
fi

if [[ ! $batch_size =~ ^[0-9]+$ ]] ||  [ "$batch_size" -lt 1 ]; then
    echo "[ERROR] Batch size must be an integer greater than zero."
    exit
fi

workdir=$(dirname $(realpath $input_file))

# Set "n" as a variable representing the SLURM job array number
# This defaults to 1 if running locally (for testing/calculating duration)
n=${SLURM_ARRAY_TASK_ID:-1}

# Work out which files to operate on from initial list
start_line=$(( ($n - 1) * $batch_size + 1 ))
end_line=$(( $start_line + $batch_size - 1 ))

files_to_process=$(sed -n "${start_line},${end_line}p" $input_file)
fbase=batch_$(printf "%05g" $n)

output_file=${workdir}/${fbase}.output
rm -f $output_file

cd $workdir/..

for fpath in $files_to_process; do
    echo "[INFO] Checking: $fpath"
    $cmd $fpath >> $output_file
done

echo "[INFO] Completed for batch ${n}: written to: $output_file"

