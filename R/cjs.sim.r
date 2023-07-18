#' operating model for CJS mark recapture data
#'
#' @description Produces a tagged list of CJS objects
#'
#' @param phi Survival by location
#' @param p Detection probability by location
#' @param nInd Number of individuals
#' @param nLoc Number of locations
#' @param initLoc Tributary origin
#' @param Sigma_Loc Covariance for the locations
#' @param distMat River distance between locations
#' @param nYear Number of years of data
#' @param beta Covariate parameters
#' @param X Covariates
#' @param Sigma_X Covariate covariance matrix
#'
#' @return Tagged list with c_i, z_i, and y_i
#' @export cjs.sim
#'
#' @examples
## Simulated data set
cjs.sim <- function(phi,
                    p,
                    nInd = 1,
                    nYear = 1,
                    nLoc = NA,
                    Sigma_Loc = NA,
                    distMat = NA,
                    beta = NA,
                    X = NA,
                    Sigma_X = NA,
                    locBoolean = NA){


  #number of locations
  if(is.na(nLoc)) nLoc <- max(length(phi),length(p))

  #Fixed effects
  bX = X%*%(as.matrix(beta))

  #Observations
  c_i <- matrix(0, ncol = nLoc, nrow = nInd * nYear)

  #True state
  z_i <- matrix(0, ncol = nLoc, nrow = nInd * nYear)

  y_i <- rep(0, nInd)

  ii <- 1
  # Define a vector with the occasion of marking
  for(y in 1:nYear){
    for (i in 1:nInd){
      #First state and observations at tributary
      z_i[ii, 1] = stats::rbinom(1,1,1)
      c_i[ii, 1] = stats::rbinom(1,z_i[ii, 1],1)
      for (loc in 2:(nLoc)){
        phi_tmp = stats::plogis(stats::qlogis(phi_y[y,loc-1]) + bX[ii])
        p_tmp = stats::plogis(stats::qlogis(p_y[y,loc-1]))
        # Bernouloci trial: does individual survive occasion?
        z_i[ii, loc] = stats::rbinom(1,
                                      z_i[ii, loc-1],
                                      phi_tmp * z_i[ii, loc-1])

        c_i[ii, loc] = stats::rbinom(1,
                                      z_i[ii, loc],
                                      p_tmp)
        y_i[ii] <- y
      } #loc
      ii <- ii + 1
    } #i
  }#y

  get.last <- function(x){return(max(which(x!=0)))}
  # #tagged list of what you need
  return(list(c_i = c_i[,locBoolean==1],
              z_i = z_i[,locBoolean==1],
              y_i = y_i))
}
