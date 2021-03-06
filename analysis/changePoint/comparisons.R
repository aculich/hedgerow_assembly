## rm(list=ls())
library(lme4)

setwd("changePoint")
## setwd("~/Dropbox/hedgerow_assembly/analysis/changePoint")
source('../../dataPrep/src/misc.R')
load('cptPeel/baci/graphs.Rdata')
load('../../data/networks/allSpecimens.Rdata')
samples <- read.csv("../../data/samples.csv")
dats <- read.csv('saved/consensusChangePoints.csv')
BACI.site <- c('Barger', 'Butler', 'Hrdy', 'MullerB', 'Sperandio')

## drop change points that do not occur in 95% of runs
dats <- dats[dats$num.runs >= 0.8,]

## **********************************************************
## binomial tests
## **********************************************************

chpt.trial <- aggregate(spec$Year, list(Site=spec$Site),
                           FUN=function(x) length(unique(x)))
chpt.trial$x <- chpt.trial$x - 1

chpt.trial <- chpt.trial[chpt.trial$x >= 4,]

change.points.site <- tapply(dats$cp, dats$sites, length)

chpt.trial$chpts <- change.points.site[match(chpt.trial$Site,
                                                rownames(change.points.site))]
chpt.trial$chpts[is.na(chpt.trial$chpts)] <- 0
colnames(chpt.trial) <- c("Site", "trial", "chpts")

chpt.trial$status <- spec$SiteStatus[match(chpt.trial$Site, spec$Site)]
chpt.trial$status[chpt.trial$Site %in% BACI.site] <- "maturing"

chpt.trial <- chpt.trial[order(chpt.trial$status),]

## write.table(chpt.trial,
##             file='~/Dropbox/hedgerow_assembly_ms/ms/tables/changingPoints.txt',
##             row.names=FALSE,
##             sep="&")

## binomial model with change points as successes
chpt.trial$status <- factor(chpt.trial$status,
                            levels=c("maturing", "mature", "control"))
## @knitr external_binomialreg
mod.chpt <- glm(cbind(chpt.trial$chpts,
                      chpt.trial$trial - chpt.trial$chpts) ~
    chpt.trial$status, family="binomial")
print(summary(mod.chpt))

print(exp(cbind(coef(mod.chpt), confint(mod.chpt))))

## @knitr external_otherCalc

# controls with change points
nrow(chpt.trial[chpt.trial$status == "control" &
                chpt.trial$chpts != 0,])/
  nrow(chpt.trial[chpt.trial$status == "control",])

nrow(chpt.trial[chpt.trial$status == "mature" &
                chpt.trial$chpts != 0,])/
  nrow(chpt.trial[chpt.trial$status == "mature",])


nrow(chpt.trial[chpt.trial$status != "maturing" &
                chpt.trial$chpts != 0,])/
  nrow(chpt.trial[chpt.trial$status != "maturing",])


nrow(chpt.trial[chpt.trial$chpts != 0,])/
  nrow(chpt.trial)


## proportions

chpt.trial$prop <- chpt.trial$chpts/chpt.trial$trial
tapply(chpt.trial$prop, chpt.trial$status, mean)

tapply(chpt.trial$trial, chpt.trial$status, sum)

## **********************************************************
## some methodological tests: are years with larger differences in the
## number of samples more likely to have a change point?
## **********************************************************

diff.samp <- matrix(NA, nrow=nrow(samples),
                    ncol=ncol(samples) -2)
colnames.prep <- character(ncol(diff.samp))

for(i in 3:ncol(samples)){
    diff.samp[,i -2] <- abs(samples[, i] -  samples[, i -1])
    colnames.prep[i-2] <- paste(colnames(samples)[i -1], "-",
                                colnames(samples)[i], sep="")
}

rownames(diff.samp) <- samples$X
colnames.prep <- gsub("X", "", colnames.prep)

colnames(diff.samp) <- colnames.prep

diff.dats <- comm.mat2sample(diff.samp)

diff.dats$cp <- match(paste(diff.dats$Site,
                                        diff.dats$Date),
                      paste(dats$sites, dats$cp))

diff.dats.cp <- diff.dats[diff.dats$Site %in% chpt.trial$Site,]
diff.dats.cp <- diff.dats.cp[diff.dats.cp$Samp !=0,]

diff.dats.cp$cp[is.na(diff.dats.cp$cp)] <- 0
diff.dats.cp$cp[diff.dats.cp$cp > 1] <- 1

mod.samp <- glmer(cp ~ Samp + (1|Site), data=diff.dats.cp, family="binomial")
summary(mod.samp)


