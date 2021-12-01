generator <- function(npop = 10, sd = 5, holdout=1, ncells = 1000, ndim = 5) {
    force(npop)
    force(ndim)
    force(sd)
    force(ncells)
    function() {
        populations <- matrix(rnorm(npop * ndim, sd=sd), ncol=npop)
        sampled <- sample(ncol(populations), ncells, replace=TRUE)
        stuff <- populations[,sampled]
        stuff <- stuff + rnorm(length(stuff))
        list(data=stuff, subset=(sampled <= ncol(populations) - holdout))
    }
}

set.seed(984241)

settings <- expand.grid(
    npop = c(5, 10),
    sd = c(1, 5),
    holdout = c(1, 3),
    k = c(5, 10)
)

library(KmeansReinitialization2021)
collated <- list()

for (i in seq_len(nrow(settings))) {
    current <- settings[i,]
    FUN <- generator(npop = current$npop, sd = current$sd, holdout = current$holdout)
    out <- simulateScenario(FUN, k=current$k)
    collated[[i]] <- summarizeResults(out, collapse=TRUE, ref.method="reinit")
}

df <- do.call(rbind, collated)
for (j in seq_len(ncol(df))) {
    df[,j] <- signif(df[,j], 4)
}

df <- cbind(settings, df)
dir <- "results"
write.table(df, file=file.path(dir, "newpop.tsv"), row.names=FALSE, sep="\t")

#hist(log2(df$wcss.simple.mean))
#hist(df$rand.fresh.mean)
