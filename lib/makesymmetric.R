makesymmetric <- function(data){
  data[!upper.tri(data)] <- 0
  data.f <- data + t(data)
  diag(data.f)  <- 0
  return(data.f)
}