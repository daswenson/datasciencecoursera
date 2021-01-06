## Programming Assignment 3 -- Dan Swenson -- Part 3
rankhospital <- function(state, outcome, num = "best"){
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  rank_data <- as.data.frame(cbind(data[, 2], # hospital name
                                   data[, 7], # state
                                   data[, 11], # heart attack rates
                                   data[, 17], # heart failure rates
                                   data[, 23]), # pneumonia rates
                             stringsAsFactors = FALSE)
  
  colnames(rank_data) <- c("hospital", "state", "heart attack",
                           "heart failure", "pneumonia")
  
  ##Check that state and outcome are valid
  if(!outcome %in% colnames(rank_data)){
    stop("invalid outcome")
  }
  
  else if(!(state %in% data$State)){
    stop("invalid state")
  }
  ## Return hospital name in that state with the given rank
  else {
    
    # getting set of outcomes for the state
    bool <- which(rank_data[,"state"] == state) # getting bool for rows of state
    state_rows <- rank_data[bool,] # get rows of state using boolean
    state_rows[,outcome] <- as.numeric(state_rows[,outcome])
    
    #taking only the complete observations
    state_rows <- state_rows[complete.cases(state_rows[,outcome]),]
    
   
    
    # setting the wanted rank to the required integer
    if(!is.numeric(num)){ # if longer, data = NA
      if(num == "worst"){
      #ordering rows by outcome then name in decending order
      outcome_order <- state_rows[
        order(state_rows[,outcome],state_rows$hospital, decreasing = TRUE),]
      return(outcome_order$hospital[1])
      } else if (num == "best"){
        num <-1
      } 
    } else {
      if(num>nrow(state_rows)){return(NA)} 
      }
  }
  
  #ordering rows by outcome then name
  outcome_order <- state_rows[
    order(state_rows[,outcome],state_rows$hospital),]
    
  return(outcome_order$hospital[num]) 
  
  }
}