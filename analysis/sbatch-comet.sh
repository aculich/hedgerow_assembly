#!/bin/bash

#SBATCH --job-name="hedgerow_assembly"
#SBATCH --output="hedgerow_assembly.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --export=ALL
#SBATCH -t 2:00:00

#This job runs with 1 nodes, 24 cores per node for a total of 24 cores.

module load R/3.2.3 python/2.7.10 scipy/2.7
cd /oasis/scratch/comet/aculich/temp_project/hedgerow_assembly/analysis/

bash -x changePoint/mainChangePoint.sh
