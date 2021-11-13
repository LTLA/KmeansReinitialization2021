#' Simulate scenarios and evaluate them
#'
#' Generate simulated data and collate statistics for them.
#'
#' @param FUN Function that accepts no arguments and returns a list with 
#' \code{data}, a numeric data matrix with dimensions and observations in rows and columns, respectively;
#' and \code{subset}, a logical vector specifying the subset to retain in the initial clustering.
#' @param k Integer scalar specifying the number of clusters to return.
#' @param iterations Integer scalar specifying the number of iterations to perform.
#' 
#' @return A matrix of WCSS and Rand indices for each strategy (columns) in each iteration (row).
#'
#' @author Aaron Lun
#'
#' @examples
#' FUN <- function() {
#'     populations <- matrix(rnorm(100, sd=5), ncol=10)
#'     sampled <- sample(ncol(populations), 1000, replace=TRUE)
#'     stuff <- populations[,sampled]
#'     stuff <- stuff + rnorm(length(stuff))
#'     list(data=stuff, subset=(sampled < ncol(populations)))
#' }
#' 
#' out <- simulateScenario(FUN, 10)
#' plot(out$wcss, out$rand, col=factor(out$method))
#' 
#' @export
simulateScenario <- function(FUN, k, iterations=100) {
    collated <- vector("list", iterations)
    for (i in seq_len(iterations)) {
        out <- FUN()
        res <- evaluateScenario(out$data, out$subset, k=k)        
        res$iteration <- i
        collated[[i]] <- res
    }
    do.call(rbind, collated)
}
