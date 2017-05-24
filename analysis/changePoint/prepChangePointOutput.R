setwd('cptPeel')
## setwd('~/Dropbox/hedgerow_assembly/analysis/changePoint/cptPeel')
source('../src/extractingOutput.R')

args <- commandArgs(trailingOnly=TRUE)
print(args)

w <- 4

samples <- read.csv("../../../data/samples.csv")

## FIXME: later this should be generalized to passing in the
## filename instead of explicitly hard-coding SLURM jobarrays, but
## do what ya gotta do when you're trying to hit a deadline.
SLURM_ARRAY_JOB_ID  <- Sys.getenv('SLURM_ARRAY_JOB_ID')
SLURM_ARRAY_TASK_ID <- Sys.getenv('SLURM_ARRAY_TASK_ID')
filename_suffix     <- paste(SLURM_ARRAY_JOB_ID, SLURM_ARRAY_TASK_ID, sep='_')
results <- read.table(sprintf('results_%s_%s.txt', w, filename_suffix), sep=' ')
logs <- read.table(sprintf('LogLs_%s_%s.txt', w, filename_suffix), sep=' ')

chpts <- makeChangepointData(results=results, logs=logs, samples=samples,
                             value=0.949, w=4, file.name=args[1])
## change the value argument to the "p value" to be considered, like 0.949
