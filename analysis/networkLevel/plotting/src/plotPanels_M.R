plot.panelsM <- function(){
  f <- function(){
    col.lines <- brewer.pal(3, "Dark2")[2]
    col.fill <- add.alpha(col.lines, alpha=0.2)
    layout(matrix(1:5, ncol=1))
    par(oma=c(6, 7, 2, 1),
        mar=c(0.5, 0, 0.5, 1), cex.axis=1.5)
    ## nodf
    plot.panel(new.dd=nodf.pi,
               dats=cor.dats,
               y1="zNODF",
               xs="ypr",
               col.fill=col.fill,
               col.lines=col.lines,
               plotPoints=TRUE)
    mtext("Nestedness", 2, line=5, cex=1.5)
    ## modularity
    plot.panel(new.dd=mod.pi,
               dats=cor.dats,
               y1="zmodD",
               xs="ypr",
               col.fill=col.fill,
               col.lines=col.lines,
               plotPoints=TRUE)
    mtext("Modularity", 2, line=4, cex=1.5)
    ## diversity
    plot.panel(new.dd=h2.pi,
               dats=cor.dats,
               y1="zH2",
               xs="ypr",
               col.fill=col.fill,
               col.lines=col.lines,
               plotPoints=TRUE)
    mtext("Specialization", 2, line=5, cex=1.5)
	## niche overlap - Plants
    plot.panel(new.dd= nop.pi,
               dats=cor.dats,
               y1="niche.overlap.plants",
               xs="ypr",
               col.fill=col.fill,
               col.lines=col.lines,
               plotPoints=TRUE)
    mtext("Niche Overlap - Plants", 2, line=5, cex=1.5)
    ## niche overlap - Polinators
    plot.panel(new.dd=nopol.pi,
               dats=cor.dats,
               y1="niche.overlap.pol",
               xs="ypr",
               col.fill=col.fill,
               col.lines=col.lines,
               plotPoints=TRUE)
    mtext("Niche Overlap - Polinators", 2, line=5, cex=1.5)
    axis(1, pretty(cor.dats$ypr), labels=pretty(cor.dats$ypr))
    mtext("Years Post Restoration", 1, line=3.5, cex=1.5)
  }
  path <- 'figures'
  pdf.f(f, file=file.path(path,
             sprintf("%s.pdf", "baci")),
        width=5, height=12)

}

