#!/bin/bash

dirs=$@
output_file=file-list.txt
rm -f $output_file

for dr in $dirs; do
    find -L $dr -type f >> $output_file
done

echo "[INFO] Wrote: $output_file"
echo "[INFO] Number of files: $(wc -l $output_file | cut -d' ' -f1)"
 
