##If/Else

if(x>3){
  y<-10
} else {
  y<-0
}

#In R it can be written as
y <- if(x>3){
  10
}else{
  0
}


##For
x <- c("a","b","c","d")

#common for other languages
for(i in 1:4){
  print(x[i])
}

#creates integer seq with length of vector input
for (i in seq_along(x)){
  print(x[i])
}

#prints each value of vector
for(letter in x){
  print(letter)
}

#If for loop single expression you can put on one line
for(i in 1:4) print(x[1])

#Can be nested, this prints whole matrix 
y <- matrix(1:6,2,3)

for(i in seq_len(nrows(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i,j])
  }
}