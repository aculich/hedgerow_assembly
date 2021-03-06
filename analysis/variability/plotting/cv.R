library(RColorBrewer)
setwd('variability')
source("plotting/src/predictIntervals.R")
source("plotting/src/CIplotting.R")
source("plotting/src/plotPanels.R")
source('../networkLevel/src/misc.R')
load('saved/contMods.Rdata')

## ************************************************************
## persistence closeness
## ************************************************************
dd.occ.pol <- expand.grid(occ.date=seq(
                              from= min(pol.cv$lm.data$occ.date,
                                        na.rm=TRUE),
                              to= max(pol.cv$lm.data$occ.date,
                                      na.rm=TRUE),
                              length=20),
                          r.degree= mean(pol.cv$lm.data$r.degree),
                          SiteStatus="all",
                          cv= 0)

## pols
pol.cv$lm.data$SiteStatus <- "all"
pol.occ.pi.close <- predict.int(mod= pol.mod,
                                dd=dd.occ.pol,
                                y="cv",
                                family="gaussian")

## plants
dd.occ.plant <- expand.grid(occ.plant.date=seq(
                                from= min(plant.cv$lm.data$occ.plant.date,
                                          na.rm=TRUE),
                                to= max(plant.cv$lm.data$occ.plant.date,
                                        na.rm=TRUE),
                                length=20),
                            plant.r.degree= mean(plant.cv$lm.data$plant.r.degree),
                            SiteStatus="all",
                            cv= 0)

## plants
plant.cv$lm.data$SiteStatus <- "all"
plant.occ.pi.close <- predict.int(mod= plant.mod,
                                  dd=dd.occ.plant,
                                  y="cv",
                                  family="gaussian")


## ************************************************************
## degree closeness
## ************************************************************
dd.degree.pol <- expand.grid(r.degree=seq(
                                 from= min(pol.cv$lm.data$r.degree,
                                           na.rm=TRUE),
                                 to= max(pol.cv$lm.data$r.degree,
                                         na.rm=TRUE),
                                 length=20),
                             occ.date= mean(pol.cv$lm.data$occ.date),
                             SiteStatus="all",
                             cv= 0)

## pols

pol.degree.pi.close <- predict.int(mod= pol.mod,
                                   dd=dd.degree.pol,
                                   y="cv",
                                   family="gaussian")

## plants
dd.degree.plant <- expand.grid(plant.r.degree=seq(
                                   from= min(plant.cv$lm.data$plant.r.degree,
                                             na.rm=TRUE),
                                   to= max(plant.cv$lm.data$plant.r.degree,
                                           na.rm=TRUE),
                                   length=20),
                               occ.plant.date= mean(plant.cv$lm.data$occ.plant.date),
                               SiteStatus="all",
                               cv= 0)

## plants
plant.cv$lm.data$SiteStatus <- "all"
plant.degree.pi.close <- predict.int(mod= plant.mod,
                                     dd=dd.degree.plant,
                                     y="cv",
                                     family="gaussian")



plot.panels()


## ************************************************************
## residual plots

resid.plot <- function(){
    layout(matrix(1:6, nrow=2, byrow=TRUE))
    plot(fitted(pol.mod), residuals(pol.mod),
         xlab = "Fitted Values", ylab = "Residuals",
         main="Pollinators")
    abline(h=0, lty=2)
    lines(smooth.spline(fitted(pol.mod),
                        residuals(pol.mod)))

    qqnorm(residuals(pol.mod), abline(0,1))

    plot(density(residuals(pol.mod)))

    plot(fitted(plant.mod),
         residuals(plant.mod),
         xlab = "Fitted Values", ylab = "Residuals",
         main="Plants")
    abline(h=0, lty=2)
    lines(smooth.spline(fitted(plant.mod),
                        residuals(plant.mod)))
    qqnorm(residuals(plant.mod), abline(0,1))

    plot(density(residuals(plant.mod)))
}

## passable
resid.plot()



