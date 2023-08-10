#' Calculate statistical power for a cluster randomized trial with co-primary endpoints using the conjunctive intersection-union test approach.
#'
#' @description
#' Allows user to calculate the statistical power of a hybrid type 2 cluster randomized trial given a set of study design input values, including the number of clusters in each trial arm, and cluster size. Uses the conjunctive intersection-union test approach.
#'
#' @param K Number of clusters in each arm; numeric.
#' @param m Individuals per cluster; numeric.
#' @param alpha Type I error rate; numeric.
#' @param beta1 Effect size for the first outcome; numeric.
#' @param beta2 Effect size for the second outcome; numeric.
#' @param varY1 Total variance for the first outcome; numeric.
#' @param varY2 Total variance for the second outcome; numeric.
#' @param rho01 Correlation of the first outcome for two different individuals in the same cluster; numeric.
#' @param rho02 Correlation of the second outcome for two different individuals in the same cluster; numeric.
#' @param rho1 Correlation between the first and second outcomes for two individuals in the same cluster; numeric.
#' @param rho2 Correlation between the first and second outcomes for the same individual; numeric.
#' @returns A data frame of numerical values.
#' @examples
#' calc_pwr_conj_test(K = 15, m = 300, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_pwr_conj_test <- function(K,            # Number of clusters in each arm
                               m,            # Individuals per cluster
                               alpha = 0.05, # Significance level
                               beta1,        # Effect for outcome 1
                               beta2,        # Effect for outcome 2
                               varY1,        # Variance for outcome 1
                               varY2,        # Variance for outcome 2
                               rho01,        # ICC for outcome 1
                               rho02,        # ICC for outcome 2
                               rho1,         # Inter-subject between-endpoint ICC
                               rho2          # Intra-subject between-endpoint ICC
                               ){

  # Sourcing external function from GitHub
  devtools::source_url("https://github.com/siyunyang/coprimary_CRT/blob/main/powerSampleCal_varCluster_ttest.R?raw=TRUE")
  power <-  calPower_ttestIU(betas = c(beta1, beta2),
                             K = 2, # In this function, K = # of outcomes
                             m = m,
                             deltas = c(0, 0),
                             vars = c(varY1, varY2),
                             rho01 = matrix(c(rho01, rho1,
                                              rho1, rho02),
                                            2, 2),
                             rho2 = matrix(c(1, rho2,
                                             rho2, 1),
                                           2, 2),
                             r = 0.5,
                             N = 2*K, # In this function, N = total clusters
                             alpha = alpha
                             )

  return(round(power, 4))

} # End calc_pwr_conj_test()








#' Calculate required number of clusters per treatment group for a cluster randomized trial with co-primary endpoints using the conjunctive intersection-union test approach.
#'
#' @description
#' Allows user to calculate the required number of clusters per treatment group of a hybrid type 2 cluster randomized trial given a set of study design input values, including the statistical power, and cluster size. Uses the conjunctive intersection-union test approach.
#'
#' @param power Desired statistical power in decimal form; numeric.
#' @param m Individuals per cluster; numeric.
#' @param alpha Type I error rate; numeric.
#' @param beta1 Effect size for the first outcome; numeric.
#' @param beta2 Effect size for the second outcome; numeric.
#' @param varY1 Total variance for the first outcome; numeric.
#' @param varY2 Total variance for the second outcome; numeric.
#' @param rho01 Correlation of the first outcome for two different individuals in the same cluster; numeric.
#' @param rho02 Correlation of the second outcome for two different individuals in the same cluster; numeric.
#' @param rho1 Correlation between the first and second outcomes for two individuals in the same cluster; numeric.
#' @param rho2 Correlation between the first and second outcomes for the same individual; numeric.
#' @returns A data frame of numerical values.
#' @examples
#' calc_K_conj_test(power = 0.8, m = 300, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_K_conj_test <- function(power,        # Desired statistical power
                             m,            # Individuals per cluster
                             alpha = 0.05, # Significance level
                             beta1,        # Effect for outcome 1
                             beta2,        # Effect for outcome 2
                             varY1,        # Variance for outcome 1
                             varY2,        # Variance for outcome 2
                             rho01,        # ICC for outcome 1
                             rho02,        # ICC for outcome 2
                             rho1,         # Inter-subject between-endpoint ICC
                             rho2          # Intra-subject between-endpoint ICC
                             ){

  # Sourcing external function from GitHub
  devtools::source_url("https://github.com/siyunyang/coprimary_CRT/blob/main/powerSampleCal_varCluster_ttest.R?raw=TRUE")
  K <- calSampleSize_ttestIU(betas = c(beta1, beta2),
                             m = m,
                             power = power,
                             deltas = c(0, 0),
                             vars = c(varY1, varY2),
                             rho01 = matrix(c(rho01, rho1,
                                              rho1, rho02),
                                            2, 2),
                             rho2 = matrix(c(1, rho2,
                                             rho2, 1),
                                           2, 2),
                             r = 0.5,
                             K = 2, # In this function, K = # of outcomes
                             alpha = alpha
                             )/2 # Divide by 2 because function returns
                                 # total number of clusters, which is 2K

  return(ceiling(K))
} # End calc_K_conj_test()









#' Calculate cluster size for a cluster randomized trial with co-primary endpoints using the conjunctive intersection-union test approach.
#'
#' @description
#' Allows user to calculate the cluster size of a hybrid type 2 cluster randomized trial given a set of study design input values, including the number of clusters in each trial arm, and statistical power. Uses the conjunctive intersection-union test approach.
#'
#' @param power Desired statistical power in decimal form; numeric.
#' @param K Number of clusters in each arm; numeric.
#' @param alpha Type I error rate; numeric.
#' @param beta1 Effect size for the first outcome; numeric.
#' @param beta2 Effect size for the second outcome; numeric.
#' @param varY1 Total variance for the first outcome; numeric.
#' @param varY2 Total variance for the second outcome; numeric.
#' @param rho01 Correlation of the first outcome for two different individuals in the same cluster; numeric.
#' @param rho02 Correlation of the second outcome for two different individuals in the same cluster; numeric.
#' @param rho1 Correlation between the first and second outcomes for two individuals in the same cluster; numeric.
#' @param rho2 Correlation between the first and second outcomes for the same individual; numeric.
#' @returns A data frame of numerical values.
#' @examples
#' calc_m_conj_test(power = 0.8, K = 15, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_m_conj_test <- function(power,        # Desired statistical power
                             K,            # Number of clusters in each arm
                             alpha = 0.05, # Significance level
                             beta1,        # Effect for outcome 1
                             beta2,        # Effect for outcome 2
                             varY1,        # Variance for outcome 1
                             varY2,        # Variance for outcome 2
                             rho01,        # ICC for outcome 1
                             rho02,        # ICC for outcome 2
                             rho1,         # Inter-subject between-endpoint ICC
                             rho2          # Intra-subject between-endpoint ICC
                             ){

  # Sourcing external function from GitHub
  devtools::source_url("https://github.com/siyunyang/coprimary_CRT/blob/main/powerSampleCal_varCluster_ttest.R?raw=TRUE")

  # Initialize m and predictive power
  m <- 0
  pred.power <- 0
  while(pred.power < power){
    m <- m + 1
    pred.power <- calPower_ttestIU(
                                   betas = c(beta1, beta2),
                                   K = 2, # In this function, K = # of outcomes
                                   m = m,
                                   deltas = c(0, 0),
                                   vars = c(varY1, varY2),
                                   rho01 = matrix(c(rho01, rho1,
                                                    rho1, rho02),
                                                  2, 2),
                                   rho2 = matrix(c(1, rho2,
                                                   rho2, 1),
                                                 2, 2),
                                   r = 0.5,
                                   N = 2*K, # In this function, N = total clusters
                                   alpha = alpha
                                   )
    if(m > 1000000){
      m <- Inf
      break
    }
  }
  return(ceiling(m))

} # End calc_m_conj_test
