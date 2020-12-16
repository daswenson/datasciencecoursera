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
