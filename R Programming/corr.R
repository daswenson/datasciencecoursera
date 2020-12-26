# Part 3
# Write a function that takes a directory of data files and a threshold for
# complete cases and calculates the correlation between sulfate and nitrate for
# monitor locations where the number of completely observed cases (on all
# variables) is greater than the threshold. The function should return a vector
# of correlations for the monitors that meet the threshold requirement. If no
# monitors meet the threshold requirement, then the function should return a
# numeric vector of length 0.


# try this to go through all files in a directory instead.
# specdatafiles <- as.character(list.files(directory))
# specdatapaths <- paste(directory, specdatafiles, sep="")


corr <- function(directory, threshold = 0){
  
  #setting up vector for the correlation values
  corr_vect <- c()
  
  #going through each file to get complete case values
  for(i in 1:332){
    pre <- if(i<10){"00"}
    else if(i<100){"0"}
    file_name <- paste0(directory,"/",pre,toString(i),".csv")
    data <- read.csv(file = file_name)
    cln_data <- na.omit(data)
    cases <- nrow(cln_data)
    
    #Appending values to vector if they exceed the threshold
    if(cases >= threshold){
      corr_vect <- append(corr_vect,cor(cln_data$nitrate,cln_data$sulfate))
    }
  }
  if(length(corr_vect)<1){
    corr_vect <- numeric()
  }
  corr_vect
}