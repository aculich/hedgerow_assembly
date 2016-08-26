rm(list=ls())
setwd('~/Dropbox/hedgerow_assembly/analysis/variability')
binary <- FALSE
alpha <- TRUE
## int or pols
type <- "pols"
source('src/initialize_beta.R')

## ************************************************************
## beta diversity as variation between years,
## centroid for each site
## ************************************************************
dis <- mapply(function(a, b, c, d)
              beta.status(comm= a,
                          status= b,
                          dis.method,
                          nulls=c,
                          occ=binary,
                          years=d,
                          sub=type),
              a=comm$comm,
              b=comm$status,
              c= nulls,
              d= comm$comm,
              SIMPLIFY=FALSE)

dats <- data.frame(site=comm$sites,
                   status=unlist(comm$status),
                   year=unlist(comm$years),
                   dist=unlist(sapply(dis, function(x)
                     x$distances)))
rownames(dats) <- NULL

save(dats, file= file.path('saved/speciesTurnover',
             sprintf('%s.pdf', paste(dis.method, alpha, occ, type,
                                     sep='_'))))

## invid nulls all not sig, alpha nulls mature marginally sig less,
## occurrence nulls all not sig

## run model, plot

load(file= file.path('saved/speciesTurnover', sprintf('%s.pdf',
       paste(dis.method, alpha, occ, type, sep='_'))))


mod <- lmer(dist ~ status +  (1|site),
            data=dats)
summary(mod)

plot.beta.div(dis.method =dis.method, dists= dats$dist,
              status= dats$status, type= "time",
              sub= type, occ=occ, ylabel=ylabel)

plot.coeffs(dis.method =dis.method, mod=summary(mod),
            status= dats$status, type= "space",
            sub= type, occ=occ)


plotDistPanels()