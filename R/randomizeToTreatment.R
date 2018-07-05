#' Randomly assign subjects to treatment conditions
#' 
#' @param n The number of subjects
#' @param treatment A vector of available treatment options. Defaults to c("C", "T")
#' @param weights An optional argument that allows users to change the ratio of subjects in each condition
#' @return A vector of treatment assignments
#' @examples 
#' randomizeToTreatment(20, c("C", "T1", "T2"))
#' randomizeToTreatment(20, c("C", "T1", "T2"), c(0.5, 0.25, 0.25))
randomizeToTreatment <- function(n, treatments = c("C", "T"), weights) {
  if(missing(weights)) {
    weights <- rep(1 / length(treatments), length(treatments))
  }
  condition <- character(length(users))
  for (i in 1:length(users)) {
    condition[i] <- sample(treatments, 1, prob = weights)
  }
  return(condition)
}