## Getting and Cleaning Data -- WK2 QZ -- Dan Swenson


# Question 1
    # used this tutorial 
    # https://github.com/r-lib/httr/blob/master/demo/oauth2-github.r

oauth_endpoints("github")

myapp <- oauth_app("github",
                   key = "f71dc24476ce7a697a2c",
                   secret = "57fbf8d2534129fd06ecdf34a1aa130893d7a415",
                   )

github_token <- oauth2.0_token(oauth_endpoints("github"),myapp)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
output <- content(req)

    # goes through and checks whether the string is in it
datashare <- which(sapply(output, FUN = function(x) "datasharing" %in% x))
datashare # gives 23

output[[23]]$created_at # tells when it is created


# Question 2 and 3
download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv",
  destfile = "./data/Q2Wk2.csv")

acs <- read.csv("./data/Q2Wk2.csv", sep=",", header = TRUE)

# next two checking syntax for Q4
head(sqldf("select pwgtp1 from acs where AGEP<50"))
head(sqldf("select distinct AGEP from acs"))


# Question 4
url <- "http://biostat.jhsph.edu/~jleek/contact.html"

# reading all lines of the html
html <- readLines(url)

# iterates through wanted rows
for( i in c(10,20,30,100)){
  n <-nchar(html[i])
  print(n)
} # prints out answer


# Question 5
  # hint: it is a fixed width file format

dt <- read.fwf(
  url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
         skip=4, widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4))
      # widths had to be counted by hand
head(dt) # checking if read correctly
sum(dt$V4) # answer
