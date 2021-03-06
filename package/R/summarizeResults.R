#' Summarize simulation results
#'
#' Summarize and plot the simulation results.
#' 
#' @param df A data frame of WCSS and Rand statistics, usually generated from \code{\link{simulateScenarios}}.
#' @param collapse Logical scalar indicating whether the results should be collapsed ito a single data frame.
#' @param ref.method String containing the name of the method to use as the reference.
#'
#' @return 
#' For \code{summarizeResults}, a list of data frames containing the mean and standard error of the Rand index and WCSS for each method.
#' If \code{collapse=TRUE}, the statistics are rearranged into a single data.frame with a single row. 
#'
#' If \code{ref.method} is supplied, the data frames instead contain the mean and standard error of the \emph{ratio} of each method's WCSS to that of the reference method,
#' and the difference between each method's Rand index and that of the reference method.
#'
#' For \code{plotResults}, a list of ggplot objects containing scatter and violin plots.
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
summarizeResults <- function(df, collapse=FALSE, ref.method=NULL) {
    by.method <- split(seq_len(nrow(df)), df$method)
    wcss <- rand <- list()

    if (is.null(ref.method)) {
        for (m in names(by.method)) {
            sub <- df[by.method[[m]],,drop=FALSE]
            wcss[[m]] <- data.frame(mean = mean(sub$wcss), se = sd(sub$wcss) / sqrt(nrow(sub)))
            rand[[m]] <- data.frame(mean = mean(sub$rand), se = sd(sub$rand) / sqrt(nrow(sub))) 
        }
    } else {
        refsub <- df[by.method[[ref.method]],,drop=FALSE]
        for (m in setdiff(names(by.method), ref.method)) {
            sub <- df[by.method[[m]],,drop=FALSE]
            stopifnot(nrow(sub) == nrow(refsub))
            wcss.ratio <- sub$wcss/refsub$wcss
            wcss[[m]] <- data.frame(mean = mean(wcss.ratio), se = sd(wcss.ratio) / sqrt(nrow(sub)))
            rand.delta <- sub$rand - refsub$rand
            rand[[m]] <- data.frame(mean = mean(rand.delta), se = sd(rand.delta) / sqrt(nrow(sub))) 
        }
    }

    if (!collapse) {
        list(wcss = do.call(rbind, wcss), rand = do.call(rbind, rand))
    } else {
        cbind(wcss=do.call(cbind, wcss), rand=do.call(cbind, rand))
    }
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


