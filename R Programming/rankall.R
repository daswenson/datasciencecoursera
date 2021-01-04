## Programming Assignment 3 -- Dan Swenson -- Part 4

rankall <- function(outcome, num = "best") {

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
  
  ##Check to see if outcome is valid
  if(!outcome %in% colnames(rank_data)){
    stop("invalid outcome")
  }
  
  # lists for the columns of the final dataframe
  hospital_col <- list()
  state_list <- unique(rank_data$state[order(rank_data$state)])
  
  # setting the wanted rank to the required integer
  for(state in state_list){
    bool <- which(rank_data$state == state) # getting bool for rows of state
    state_rows <- rank_data[bool,] # get rows of state using boolean
    state_rows[,outcome] <- suppressWarnings(as.numeric(state_rows[,outcome]))
    
    #taking only the complete observations
    state_rows <- state_rows[complete.cases(state_rows[,outcome]),]
    
    if(!is.numeric(num)){
      if(num == "worst"){
        outcome_order <- state_rows[
          order(state_rows[,outcome],state_rows$hospital, decreasing = TRUE),]
        hospital_col <- append(hospital_col,outcome_order$hospital[1])
        
      } else if (num == "best"){
        num <-1
        outcome_order <- state_rows[
          order(state_rows[,outcome],state_rows$hospital),]
        hospital_col <- append(hospital_col,outcome_order$hospital[num])
      }
      
    } else {
      outcome_order <- state_rows[
        order(state_rows[,outcome],state_rows$hospital),]
      hospital_col <- append(hospital_col,outcome_order$hospital[num])
    }
  }
  
  col_names = c("hospital", "state")
  output <- as.data.frame(cbind(hospital_col,state_list), col.names = col_names)
  rownames(output) <- output[,2]
  return(output)
}
