##Part 1
# Write a function named 'pollutantmean' that calculates the mean of a pollutant
# (sulfate or nitrate) across a specified list of monitors. The function
# 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'.
# Given a vector monitor ID numbers, 'pollutantmean' reads that monitors'
# particulate matter data from the directory specified in the 'directory'
# argument and returns the mean of the pollutant across all of the monitors,
# ignoring any missing values coded as NA


pollutantmean <- function(directory, pollutant, id = 1:332){
  #making list of file paths to call
  #Concatenates id list to list with elements of form "#.csv"
  file_list <- c()
  for(i in id){
    pre <- if(i<10){"00"}
    else if(i<100){"0"}
    file_list <- append(file_list,paste0(directory,"/",pre,toString(i),".csv"))
  }
  
  #reading data into a single list for further use
  file_data = list()
  for(i in seq_along(file_list)){
    file_data[[i]] <- read.csv(file = file_list[[i]])
  }
  
  #Creating lists of the means and weights for each file
  mean_list <- c()
  weight_list <- c()
  for(i in seq_along(file_data)){
    #Removing missing data
    clndata <- file_data[[i]][complete.cases(file_data[[i]]),]
    
    #adds length of data to for weighted mean
    fileweight <- nrow(clndata)
    weight_list <- append(weight_list,fileweight)
    
    #adds mean to list for weighted mean
    filemean <- mean(clndata[[pollutant]],na.rm=TRUE)
    mean_list <- append(mean_list,filemean)
    
  }
  
  #getting the weighted mean for the whole data set
    weighted.mean(mean_list,weight_list)
}