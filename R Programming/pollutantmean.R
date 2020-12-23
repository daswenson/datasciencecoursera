##Part 1

pollutantmean <- function(directory, pollutant, id = 1:332){
  #making list of file paths to call
  #Concatenates id list to list with elements of form "#.csv"
  file_list <- c()
  for(i in id){
    pre <- if(i<10){"00"}
    else if(i<100){"0"}
    else {next}
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