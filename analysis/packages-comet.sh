#/bin/bash

module load R/3.2.3
module load python/2.7.10

Rscript -e 'paste(Sys.getenv("R_LIBS_USER"))'
Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'

Rscript -e 'install.packages("igraph", repos="http://cran.r-project.org", lib=Sys.getenv("R_LIBS_USER"))'
Rscript -e 'install.packages("bipartite", repos="http://cran.r-project.org", lib=Sys.getenv("R_LIBS_USER"))'
Rscript -e 'install.packages("ape", repos="http://cran.r-project.org", lib=Sys.getenv("R_LIBS_USER"))'
Rscript -e 'install.packages("reshape", repos="http://cran.r-project.org", lib=Sys.getenv("R_LIBS_USER"))'
Rscript -e 'install.packages("tidyr", repos="http://cran.r-project.org", lib=Sys.getenv("R_LIBS_USER"))'

pip install --user dendropy==4.0.3

## compile the python functions for the change point analysis
(cd changePoint/cptPeel/fitHRG_GPL_Bayes/ && make cleanall; make)
(cd changePoint/cptPeel/consensusHRG_GPL_Bayes/ && make cleanall; make)

