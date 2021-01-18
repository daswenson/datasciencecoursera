## Week 4 Notes

#----------
  ## Editing Text Variables
if(!file.exists("./data")){dir.create("./data")}

#link in video gives JSON, use link below to get csv file
#https://data.baltimorecity.gov/datasets/fixed-speed-cameras?geometry=-77.044%2C39.192%2C-76.199%2C39.378

cameraData <- read.csv("./data/Fixed_Speed_Cameras.csv")
names(cameraData)
tolower(names(cameraData)) # make every lowercase

splitNames <- strsplit(names(cameraData),"\\.") # splits names on period

    # quick aside about lists
mylist <- list(letters = c("A","b", "c"), numbers=1:3, matrix(1:25,ncol=5))
mtlist[[1]] # can subset by index
mylist$letters # can subset by named variables

  # fixing character vecots - sapply()
firstElement <- function(x){x[1]}
sapply(splitNames,firstElement) # will get first value out of the list

  # Peer review data
fileUrl1 = "https://s3.amazonaws.com/csvpastebin/uploads/e70e9c289adc4b87c900fdf69093f996/reviews.csv"
fileUrl2 = "https://s3.amazonaws.com/csvpastebin/uploads/0863fd2414355555be0260f46dbe937b/solutions.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews<- read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)

names(reviews)
sub("_","",names(reviews),) # replacing _ with spaces in names

testName <- "this_is_a_test"
sub("_","",testName) # only replaces first
gsub("_","",testName) # replaces all 

  # finding values
grep("Alameda",cameraData$intersecti) # gets index
table(grepl("Alameda",cameraData$intersecti)) # gets bool
cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersecti),]

grep("Alameda", cameraData$intersecti, value=TRUE) # returns values
grep("JeffStreet", cameraData$intersecti) # looking for values that dont appear
  
  # more useful functions
library(stringr)
nchar("Jeffery Leek")
substr("Jeffery Leek",1,7) # get substring
paste("Jeffery","Leek") # concatenate
str_trim("Jeff      ") # trims excess


#----------
  ## Regular Expressions
    # Regular expressions have literal and meta characters
        # literal means exact letter match
    # Regular expressions consist of only literals
    # need a way to express
        # whitespace, set of literals, beginning or end of line

    # Metacharacters
        # ^i think --- Start of line
        # morning$ --- end of line
        # Character Classes
          # [Bb][Uu][Ss][Hh] --- either upper or lowercase match
          # ^[Ii] am --- can combine 
          # ^[0-9][a-zA-Z] --- match any numbers 0-9 and letters a-zA-Z
          # [^?.]$ --- ^ inside means NOT, ex: not ? or .
          # "." --- refers to any character
          # "|" --- or character, can be any amount (A|B|C|D)
              # can also be expressions 
          # ^(good|bad) --- and character ()
          # ( w\.) --- optional notation
          # "*" --- any number, including none
          # "+" --- at least one ex: [0-9]+ <= at least one #
          # "{}" --- specify min or max amount of matches for expression
              # {m,n} --- at least m but not more than n
              # {m} --- exactly m matches
              # {m,} --- at least m matches


#-----------
  ## Working with Dates
d1 <- date() # gives date and time
d1

d2 <- Sys.Date() # just y/m/d  class=date
d2
    # formatting dates
      # %d = day as number
      # %a = abbreviated weekday
      # %A = unabbreviated weekday
      # %m = month (00-12)
      # %b = abbreviated month
      # %B = unabbreviated month
      # %y = 2 digit year
      # %Y = 4 digit year
format(d2,"%a %b %d")

    # creating dates
x <- c("1jan1960", "2jan1960", "31mar1960"); z <- as.Date(x, "%d%b%Y")
z

      # time difference
z[1]-z[2]; as.numeric(z[1]-z[2])

weekdays(d2)
months(d2)
julian(d2) # num of days since origin, gives origin

library(lubridate)
ymd("20140108")
mdy("08/04/2013")
dmy("03-04-2013")

ymd_hms("2011-08-03 10:15:03")
ymd_hms("2011-08-03 10:15:03", tz="Pacific/Auckland")

x <- dmy(c("1jan2013","2jan2013","31mar2013"))
wday(x[1]) # get weekday
wday(x[1],label=TRUE)
