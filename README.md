# batch-runner - package up lots of jobs and run them on LOTUS

The purpose of these scripts is to enable easy conversion of a serial job, that you would run on one file, 
to a set of batch jobs that can therefore run on thousands or millions of files (using LOTUS).

Here is how it works:

```
# Check the batch-runner.sh script is executing the command you expect
# E.g. "md5sum" for checksumming
$ grep cmd= batch-runner.sh
cmd="md5sum"

# Define a set of input directories under which you want to process all the files
input_dirs="/badc/ukcp18/data/land-prob/uk/25km/rcp26 /badc/ukcp18/data/land-prob/uk/25km/rcp45 /badc/ukcp18/data/land-prob/uk/25km/rcp60 /badc/ukcp18/data/land-prob/uk/25km/rcp85"

# Make a single output file listing all the input files
./make-file-list.sh $input_dirs

# NOTE: The above might include duplicates if you have symlinks in your directory structure
#       that point to the same file, so you might want to tidy those up.

# Submit a test job locally - running three tasks
$ ./batch-runner.sh file-list.txt 3

# Check it produced output file(s), and they include correct content
$ cat batch_*.output

# Submit jobs to LOTUS, with 100 per batch
$ ./submit-jobs.sh 100

# Monitor with
$ squeue -u $USER

# When all have run, check if any errors were reported in SLURM error files
find . -type f -name "*.err" -not -empty

# If they are all empty, then you can delete them
find . -type f -name "*.err" -empty -exec rm {} \;

# Look at the number of lines in the SLURM "*.out" output files
$ wc -l *.out | head
     101 3194564_100.out
     101 3194564_101.out
     101 3194564_102.out
     101 3194564_103.out
     101 3194564_104.out
     101 3194564_105.out
     101 3194564_106.out
     101 3194564_107.out
     101 3194564_108.out
     101 3194564_109.out

# And check any that are not the usual size (in this case: 101 lines)
$ wc -l *.out | grep -v "101 " | grep -v total
      59 3194564_691.out

# Check those files 
$ tail -1 3194564_691.out
[INFO] Completed for batch 691: written to: /home/users/astephen/checksit/land-eurocordex-checks-2022-06-09/batch_00691.output

- all good.

# Check the output files as well
# Has everything been scanned? Match up the total of output lines with the 
# length of the original file list.

$ wc -l *.output | tail -5
     100 batch_00688.output
     100 batch_00689.output
     100 batch_00690.output
      58 batch_00691.output
   69058 total

$ wc -l file-list.txt
69058 file-list.txt

