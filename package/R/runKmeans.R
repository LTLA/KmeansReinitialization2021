#' Run k-means with existing centers
#'
#' Run k-means with various strategies for handling existing centers.
#'
#' @param x Numeric matrix of dimensions (rows) and observations (columns).
#' @param centers Numeric matrix of dimensions (rows) and centers (columns).
#' Alternatively a numeric scalar specifying the number of centers to use.
#' @param reinitialize Logical scalar indicating whether reinitialization should be used when \code{centers} is a matrix.
#' Otherwise, the provided centers are used directly for further iterations.
#'
#' @return A list containing the result of k-means clustering on observations of \code{x}.
#'
#' @author Aaron Lun
#'
#' @examples
#' mat <- t(as.matrix(iris[,1:4]))
#' sub <- mat[,1:100]
#' 
#' # Initial run:
#' ref <- runKmeans(sub, centers=5)
#'
#' # Using the existing clusters for the full dataset.
#' rest <- runKmeans(mat, centers=ref$centers)
#'
#' # Using the reinitialization strategy instead.
#' reinit <- runKmeans(mat, centers=ref$centers, reinitialize=TRUE)
#' 
#' @export
runKmeans <- function(x, centers, reinitialize=FALSE) {
    if (is.matrix(centers)) {
        if (reinitialize) {
            seed <- sample(.Machine$integer.max, 1)
            run_kmeans_reinit(x, centers, seed=seed)
        } else {
            run_kmeans_centers(x, centers)
        }
    } else {
        seed <- sample(.Machine$integer.max, 1)
        run_kmeans_simple(x, centers, seed=seed)
    }
}
