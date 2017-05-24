#!/bin/bash

#SBATCH --job-name="hedgerow_assembly"
#SBATCH --output="logs/hedgerow_assembly.%j.%N.out"
#SBATCH --error="logs/hedgerow_assembly.%j.%N.err"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --export=ALL
#SBATCH -t 2:00:00
#SBATCH --array=1-10
#SBATCH --mail-user=aculich@berkeley.edu,lponisio@berkeley.edu
#SBATCH --mail-type=ALL

# To run this job on XSEDE Comet you'll need to do the following
# manually:
#     cd /oasis/scratch/comet/$USER/temp_project/hedgerow_assembly/analysis
#     mkdir changePoint/logs
#     sbatch  -A ucb152 sbatch-comet.sh

module load R/3.2.3 python/2.7.10 scipy/2.7
cd changePoint

python hedgerows.py
Rscript prepChangePointOutput.R ${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID} --save
