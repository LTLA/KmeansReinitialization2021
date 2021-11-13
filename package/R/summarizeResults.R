#' Summarize simulation results
#'
#' Summarize and plot the simulation results.
#' 
#' @param df A data frame of WCSS and Rand statistics, usually generated from \code{\link{simulateScenarios}}.
#'
#' @return For \code{plotResults}, a list of ggplot objects containing scatter and violin plots.
#' 
#' For \code{summarizeResults}, a list of data frames containing the mean and standard error of the Rand index and WCSS for each method.
#'
#' @author Aaron Lun
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
#' summarizeResults(out)
#' 
#' plots <- plotResults(out)
#' plots$both
#' plots$rand
#' plots$wcss
#' 
#' @export
summarizeResults <- function(df) {
    by.method <- split(seq_len(nrow(df)), df$method)
    wcss <- rand <- list()
    for (m in names(by.method)) {
        sub <- df[by.method[[m]],,drop=FALSE]
        wcss[[m]] <- data.frame(mean = sum(sub$wcss), se = sd(sub$wcss) / sqrt(nrow(sub)))
        rand[[m]] <- data.frame(mean = sum(sub$rand), se = sd(sub$rand) / sqrt(nrow(sub))) 
    }

    list(wcss = do.call(rbind, wcss), rand = do.call(rbind, rand))
}

#' @export
#' @rdname summarizeResults
plotResults <- function(df) {
    g <- ggplot2::ggplot(df)
    list(
       both = g + ggplot2::geom_point(ggplot2::aes(x=wcss, y=rand, col=method)), 
       wcss = g + ggplot2::geom_violin(ggplot2::aes(x=method, y=wcss, group=method, fill=method)), 
       rand = g + ggplot2::geom_violin(ggplot2::aes(x=method, y=rand, group=method, fill=method)) 
   )
}


