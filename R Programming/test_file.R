myfunction <- function() {
  x <- rnorm(100)
  mean(x)
}

second <- function(x) {
  x+rnorm(length(x))
}

## Run in the top right corner only runs currently selected line.
## Use CTRL + ENTER to run selected line

x <- 1:20
print(x)

y <- list(1, "a", TRUE, 1+4i)
## Line below will display entire list by index [[i]] (starts at 1)
y

##matrix form: matrix(nrow=a,ncol=b), columns get filled then rows
m <- matrix(1:6, nrow =2, ncol =3)
m

## dimension of matrix m; #row then #col
dim(m)

n <- 1:10
## creating matrix from a vector by adding dimensions
dim(n) <- c(2,5)

a <- 1:3
b <- 10:12

##column and row binding to create matrix
cbind(a,b)
rbind(a,b)

## Factor creation with character vector. Levels can be set manually or not
f <- factor(c("yes", "yes", "no", "yes", "no"),levels=c("yes","no"))
f

table(f) ##will give frequencies of levels

unclass(f) ##shows how R processes the factor

##constructing basic data frame
d <- data.frame(foo = 1:4, bar = c(T,T,F,F))
d

## Names can self-describe stuff
l <- list(a=1,b=2,c=3)
l
## Matrices can have rows and columns names
m2 <- matrix(1:4, nrow = 2, ncol = 2)
dimnames(m2) <- list(c("a","b"),c("c","d"))
m2
