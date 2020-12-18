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

##While Loops
count <- 0
while(count < 10) {
  print(count)
  count <- count +1
}

#can put other stuff in while loops, random walk on coin flip
z <- 5
while(z >= 3 && z <= 10) {
  print(z)
  coin <- rbinom(1,1,0.5)
 if(coin==1){
   z <- z+1
 }else{
   z <- z-1
 }
}

##Repeat: infinite until broken. Below is an example
repeat {
  if(a<b){
    break
  } else {
    a <- a-1
  }
}

##Next: when you want to skip something
for(i in 1:100){
  if(i <= 20){
    ##skip first 20 iterations
    next
  }
  ##do something here
}

