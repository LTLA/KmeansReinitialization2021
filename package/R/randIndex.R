#' Compute the adjusted rand index
#'
#' Compute the adjusted Rand index to quantify the similarity between two clusterings.
#' 
#' @param x Vector or factor containing the first clustering.
#' @param y Vector or factor containing the second clustering, of the same length as \code{x}.
#'
#' @return Numeric scalar containing the adjusted Rand index.
#'
#' @examples
#' mat <- t(as.matrix(iris[,1:4]))
#'
#' first <- runKmeans(mat, centers=5)
#' second <- runKmeans(mat, centers=5)
#' randIndex(first$clusters, second$clusters)
#'
#' third <- runKmeans(mat, centers=10)
#' randIndex(first$clusters, third$clusters)
#' 
#' @export 
randIndex <- function(x, y) {
    tab <- table(x, y)
    same1 <- sum(choose(table(x), 2))
    same2 <- sum(choose(table(y), 2))
    total <- choose(length(x), 2)

    expected <-  same1 * same2 / total
    (sum(choose(tab, 2)) - expected) / (0.5 * (same1 + same2) - expected)
}


