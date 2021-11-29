df <- read.delim("results/populations/stats.tsv")
X <- sprintf("%s & %s & %s & %s & $%d \\pm %d$ & $%s \\pm %s$ & $%s \\pm %s$ & $%s \\pm %s$ \\\\",
    df$npop, df$sd, df$holdout, df$k,
    round((df$wcss.simple.mean - 1)*100), round((df$wcss.simple.se)*100),
    round((df$wcss.fresh.mean - 1)*100), round((df$wcss.fresh.se)*100),
    round(df$rand.simple.mean, 2), round(df$rand.simple.se, 2),
    round(df$rand.fresh.mean, 2), round(df$rand.fresh.se, 2)
)
cat(X, sep="\n")
