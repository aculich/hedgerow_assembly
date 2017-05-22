#!/usr/bin/env bash

## FIXME: compilation should happen only once, so we move this
##        outside the batch script, into the package install.
##        also, BOTH binaries for have a `make cleanall; make`

# ## compile the python functions for the change point analysis
# cd changePoint/cptPeel/fitHRG_GPL_Bayes/
# make cleanall; make
# cd ../consensusHRG_GPL_Bayes/
# make
# cd ../../


##
RScript dataPrep.R

for i in `seq 1 100`; do
    ## runs in parallel on 2 cores
    python hedgerows.py

    ## convert data to a helpful form
    filename=run_${i}.csv
    RScript prepChangePointOutput.R $filename --save

    ## FIXME: this approach does not play nicely in an HPC batch environment,
    ##        so just commenting out for now and will check other parts of the
    ##        code to make sure it is reading/writing correct filenames.
    #mv cptPeel/LogLs_4.txt  cptPeel/LogLs_4.{$i}.txt
    #mv cptPeel/results_4.txt  cptPeel/results_4.{$i}.txt
    #rm cptPeel/LogLs_4.txt cptPeel/results_4.txt
done


# ## create consensus trees
Rscript consensusChangePoints.R
python postChangePoint.py saved/consensus.txt
# python convertConsensusTrees.py saved/lastyr_consensus.txt

