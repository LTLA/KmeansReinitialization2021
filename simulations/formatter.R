path <- tail(commandArgs(), 1)
df <- read.delim(path)
collated <- vector("list", ncol(df))

# Assembling statistics.
X <- sprintf("$%d \\pm %d$ & $%d \\pm %d$ & $%.02f \\pm %.02f$ & $%.02f \\pm %.02f$ \\\\",
    round((df$wcss.simple.mean - 1)*100), round((df$wcss.simple.se)*100),
    round((df$wcss.fresh.mean - 1)*100), round((df$wcss.fresh.se)*100),
    round(df$rand.simple.mean, 2), round(df$rand.simple.se, 2),
    round(df$rand.fresh.mean, 2), round(df$rand.fresh.se, 2)
)

# Everything else is a parameter column.
is.stat <- grepl("^(wcss|rand)", colnames(df))
collated <- as.list(df[,!is.stat])
collated <- append(collated, list(X))

output <- do.call(paste, c(collated, sep=" & "))
cat(output, sep="\n")
