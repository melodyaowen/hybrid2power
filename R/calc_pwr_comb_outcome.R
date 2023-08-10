#' Calculate statistical power for a cluster randomized trial with co-primary endpoints using a combined outcomes approach.
#'
#' @description
#' Allows user to calculate the statistical power of a hybrid type 2 cluster randomized trial given a set of study design input values, including the number of clusters in each trial arm, and cluster size. Uses a combined outcomes approach where the two outcome effects are summed together.
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
#' calc_pwr_comb_outcome(K = 15, m = 300, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_pwr_comb_outcome <- function(K,            # Number of clusters in each arm
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

  # Calculate combined outcome effect size
  betaC <- beta1 + beta2

  # Calculate variance for combined outcome
  varYC <- round(varY1 + varY2 + 2*rho2*sqrt(varY1)*sqrt(varY2), 2)

  # Calculate ICC for combined outcome
  rho0C  <- (rho01*varY1 + rho02*varY2 + 2*rho1*sqrt(varY1*varY2))/
    (varY1 + varY2 + 2*rho2*sqrt(varY1*varY2))

  # Find critical value
  cv <- qchisq(p = alpha, df = 1, lower.tail = FALSE)

  # Power for Method 2
  lambda <- (betaC^2)/(2*(varYC/(K*m))*(1 + (m - 1)*rho0C))
  power <- round(1 - pchisq(cv, 1, ncp = lambda, lower.tail = TRUE), 4)

  return(power)
} # End calc_pwr_comb_outcome()








#' Calculate required number of clusters per treatment group for a cluster randomized trial with co-primary endpoints using a combined outcomes approach.
#'
#' @description
#' Allows user to calculate the number of clusters per treatment arm of a hybrid type 2 cluster randomized trial given a set of study design input values, including the number of clusters in each trial arm, and cluster size. Uses a combined outcomes approach where the two outcome effects are summed together.
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
#' calc_K_comb_outcome(power = 0.8, m = 300, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_K_comb_outcome <- function(power,        # Desired statistical power
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

  # Calculate combined outcome effect size
  betaC <- beta1 + beta2

  # Calculate variance for combined outcome
  varYC <- round(varY1 + varY2 + 2*rho2*sqrt(varY1)*sqrt(varY2), 2)

  # Calculate ICC for combined outcome
  rho0C  <- (rho01*varY1 + rho02*varY2 + 2*rho1*sqrt(varY1*varY2))/
    (varY1 + varY2 + 2*rho2*sqrt(varY1*varY2))

  # Find non-centrality parameter corresponding to desired power
  ncp <- calc_ncp_chi2(alpha, power, df = 1)

  # K for Method 2
  K <- ceiling((2*ncp*varYC*(1 + (m - 1)*rho0C))/(m*(betaC^2)))

  return(K)
} # End calc_K_comb_outcome()









#' Calculate cluster size for a cluster randomized trial with co-primary endpoints using a combined outcomes approach.
#'
#' @description
#' Allows user to calculate the cluster size of a hybrid type 2 cluster randomized trial given a set of study design input values, including the number of clusters in each trial arm, and statistical power. Uses a combined outcomes approach where the two outcome effects are summed together.
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
#' calc_m_comb_outcome(power = 0.8, K = 15, alpha = 0.05, beta1 = 0.1, beta2 = 0.1, varY1 = 0.23, varY2 = 0.25, rho01 = 0.025, rho02 = 0.025, rho1 = 0.01, rho2  = 0.05)
calc_m_comb_outcome <- function(power,        # Desired statistical power
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

  # Calculate combined outcome effect size
  betaC <- beta1 + beta2

  # Calculate variance for combined outcome
  varYC <- round(varY1 + varY2 + 2*rho2*sqrt(varY1)*sqrt(varY2), 2)

  # Calculate ICC for combined outcome
  rho0C  <- (rho01*varY1 + rho02*varY2 + 2*rho1*sqrt(varY1*varY2))/
    (varY1 + varY2 + 2*rho2*sqrt(varY1*varY2))

  # Find non-centrality parameter corresponding to desired power
  ncp <- calc_ncp_chi2(alpha, power, df = 1)

  # m for Method 2
  m <- ceiling((2*ncp*varYC*(1 - rho0C))/((betaC^2)*K - (2*ncp*varYC*rho0C)))

  return(m)
} # End calc_m_comb_outcome()