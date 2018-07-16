#' Randomly assign subjects to treatment conditions
#'
#' @param n The number of subjects
#' @param treatment A vector of available treatment options. Defaults to c("C", "T")
#' @param weights An optional argument that allows users to change the ratio of subjects in each condition
#' @return A vector of treatment assignments
#' @export
#' @examples
#' randomizeToTreatment(20, c("C", "T1", "T2"))
#' randomizeToTreatment(20, c("C", "T1", "T2"), c(0.5, 0.25, 0.25))
randomizeToTreatment <- function(n, treatments = c("C", "T"), weights) {
  if(missing(weights)) {
    weights <- rep(1 / length(treatments), length(treatments))
  }
  if (sum(weights) != 1) {
    error("Weights must sum to 1.")
  }
  treatThresh <- cumsum(weights)
  condition <- character(n)
  for (i in 1:n) {
    number <- (runif(n = 1, min = 0, max = 1))
    dists <- number - treatThresh
    dists <- ifelse(dists > 0, NA, dists)
    thresh <- which.max(dists)
    condition[i] <- treatments[thresh]
  }
  return(condition)
}
