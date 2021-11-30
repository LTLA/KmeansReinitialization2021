generator <- function(sd = 1, exclude = 0.5, ncells = 1000) {
    force(sd)
    force(exclude)
    force(ncells)
    function() {
        i <- seq_len(ncells)
        theta <- i / ncells * 2 * pi
        x <- sin(theta)
        y <- cos(theta)

        stuff <- rbind(x, y)
        stuff <- stuff + rnorm(length(stuff), sd=sd)
        keep <- i <= (1-exclude) * ncells

        list(data=stuff, subset=keep)
    }
}

set.seed(984241)

settings <- expand.grid(
    sd = c(0.1, 0.5),
    exclude = c(0.1, 0.25, 0.5),
    k = c(5, 10)
)

library(KmeansReinitialization2021)
collated <- list()

for (i in seq_len(nrow(settings))) {
    current <- settings[i,]
    FUN <- generator(exclude = current$exclude, sd = current$sd)
    out <- simulateScenario(FUN, k=current$k)
    collated[[i]] <- summarizeResults(out, collapse=TRUE, ref.method="reinit")
}

df <- do.call(rbind, collated)
for (j in seq_len(ncol(df))) {
    df[,j] <- signif(df[,j], 4)
}

df <- cbind(settings, df)
dir <- "results"
write.table(df, file=file.path(dir, "circle.tsv"), row.names=FALSE, sep="\t")

#hist(log2(df$wcss.simple.mean))
#hist(df$rand.fresh.mean)
