#' Evaluate a subsetting scenario
#'
#' Evaluate a subsetting scenario by computing WCSS and Rand indices to compare clusterings.
#'
#' @param x Numeric matrix containing the dataset of interest.
#' Rows are dimensions while columns are observations.
#' @param subset Vector specifying the subset of observations in \code{x} to use as the initial dataset.
#' @param k Integer scalar specifying the number of clusters.
#'
#' @return Numeric vector containing the WCSS and Rand indices for each strategy.
#'
#' @details
#' The idea is to obtain an initial clustering on \code{x[,subset]} and then apply various strategies to obtain a clustering on \code{x}.
#' This can be:
#' \itemize{
#' \item \code{rest}, where the centers from the initial clustering are used directly for Hartigan-Wong iterations with the full dataset.
#' \item \code{full}, where a fresh initialization is performed with all observations (not using any information from the initial clustering).
#' Hartigan-Wong iterations are then performed as usual.
#' \item \code{reinit}, where a reinitialization strategy is applied that attempts to preserve information from the existing clustering. 
#' Hartigan-Wong iterations are then performed as usual.
#' }
#' We compute the WCSS of the clusterings obtained with each strategy.
#' We also compute the Rand index of each clustering with the initial clustering of the subset.
#'
#' @examples
#' populations <- matrix(rnorm(100, sd=5), ncol=10)
#' sampled <- sample(ncol(populations), 1000, replace=TRUE)
#' stuff <- populations[,sampled]
#' stuff <- stuff + rnorm(length(stuff))
#'                                                          
#' sub <- sampled < ncol(populations)
#' evaluateScenario(stuff, sub, 20)
#'
#' @export
#' @importFrom bluster pairwiseRand
evaluateScenario <- function(x, subset, k) {
    sub <- x[,subset,drop=FALSE]

    first <- runKmeans(sub, centers=k)

    rest <- runKmeans(x, centers=first$centers)
    full <- runKmeans(x, centers=k)
    reinit <- runKmeans(x, centers=first$centers, reinitialize=TRUE)

    c(
        wcss.rest = sum(rest$wcss),
        rand.rest = randIndex(first$clusters, rest$clusters[subset]),
        
        wcss.full = sum(full$wcss),
        rand.full = randIndex(first$clusters, full$clusters[subset]),

        wcss.reinit = sum(reinit$wcss),
        rand.reinit = randIndex(first$clusters, reinit$clusters[subset])
    )
}
