## Programming Assignment 3 -- Dan Swenson -- Part 1 and 2

outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)

## 1 Plot the 30-day mortality rates for heart attack
outcome[,11] <- as.numeric(outcome[,11])
hist(outcome[,11])


## 2 Finding the best hospital in a state
best <- function(state, outcome){
  ##Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  #taking only the columns that are relevant
  best_data <- as.data.frame(cbind(data[, 2], data[, 7], data[, 11],
                                  data[, 17], data[, 23]),
                             stringsAsFactors = FALSE)
  
  #labeling columns for checking purposes
  colnames(best_data) <- c("hospital", "state", "heart attack",
                           "heart failure", "pneumonia")
  
  ## Check that state and outcome are valid
  if(!outcome %in% colnames(best_data)){
    stop("invalid outcome")
  }
  
  if(!(state %in% data$State)){
    stop("invalid state")
  }
  ## Return hospital name in state with low 30day death rate
  bool <- which(best_data[,"state"] == state) #getting bool for rows of state
  state_rows <- best_data[bool,]#get rows using boolean
  state_outcome <- as.numeric(state_rows[,outcome])
  min <- min(state_outcome, na.rm=TRUE)#get min of state
  result <- state_rows[,"hospital"][which(state_outcome == min)]
  return(result)
}