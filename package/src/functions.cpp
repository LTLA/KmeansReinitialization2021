#include "Rcpp.h"
#include "kmeans/Kmeans.hpp"
#include "kmeans/Reinitialize.hpp"

template<class Info>
Rcpp::List create_output(Rcpp::NumericMatrix centers, Rcpp::IntegerVector clusters, const Info& info) {
    return Rcpp::List::create(
        Rcpp::Named("centers") = centers, 
        Rcpp::Named("clusters") = clusters,
        Rcpp::Named("size") = Rcpp::wrap(info.sizes),
        Rcpp::Named("wcss") = Rcpp::wrap(info.withinss),
        Rcpp::Named("status") = info.status,
        Rcpp::Named("iterations") = info.iterations
    );
}

// [[Rcpp::export(rng=false)]]
Rcpp::List run_kmeans_simple(Rcpp::NumericMatrix x, int k, int seed) {
    Rcpp::NumericMatrix output(x.nrow(), k);
    Rcpp::IntegerVector clusters(x.ncol());
    auto info = kmeans::Kmeans<>().set_seed(seed).run(x.nrow(), x.ncol(), x.begin(), output.ncol(), output.begin(), clusters.begin());
    return create_output(output, clusters, info);
}

// [[Rcpp::export(rng=false)]]
Rcpp::List run_kmeans_centers(Rcpp::NumericMatrix x, Rcpp::NumericMatrix centers) {
    Rcpp::NumericMatrix output = Rcpp::clone(centers);
    Rcpp::IntegerVector clusters(x.ncol());
    auto info = kmeans::HartiganWong<>().run(x.nrow(), x.ncol(), x.begin(), output.ncol(), output.begin(), clusters.begin());
    return create_output(output, clusters, info);
}

// [[Rcpp::export(rng=false)]]
Rcpp::List run_kmeans_reinit(Rcpp::NumericMatrix x, Rcpp::NumericMatrix centers, int seed) {
    Rcpp::NumericMatrix output = Rcpp::clone(centers);
    Rcpp::IntegerVector clusters(x.ncol());

    kmeans::Reinitialize runner;
    runner.set_seed(seed);
    runner.run(x.nrow(), x.ncol(), x.begin(), output.ncol(), output.begin(), clusters.begin());
    auto info = kmeans::HartiganWong<>().run(x.nrow(), x.ncol(), x.begin(), output.ncol(), output.begin(), clusters.begin());

    return create_output(output, clusters, info);
}


