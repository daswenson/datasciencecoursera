# Part 2
# Write a function that reads a directory full of files and reports the number
#of completely observed cases in each data file. The function should return a
#data frame where the first column is the name of the file and the second
#column is the number of complete cases. 


# try this to go through all files in a directory instead.
# specdatafiles <- as.character(list.files(directory))
# specdatapaths <- paste(directory, specdatafiles, sep="")


complete <- function(directory,id = 1:332){
  
  #lists for id column and observation column
  row_names <- c()
  case_list <- c()
  
  #going through each file and appending id # and obs count
  for(i in id){
    pre <- if(i<10){"00"}
    else if(i<100){"0"}
    file_name <- paste0(directory,"/",pre,toString(i),".csv")
    row_names <- append(row_names,i)
    data <- read.csv(file = file_name)
    case_list <- append(case_list,nrow(na.omit(data)))
  }
  
  #making data frame with the two lists
  data.frame(id = row_names,nobs = case_list)
}