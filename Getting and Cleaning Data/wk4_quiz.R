## Week 4 Quiz -- Dan Swenson


# Question 1

#Apply strsplit() to split all the names of the data frame on the characters
#"wgtp". What is the value of the 123 element of the resulting list?

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "./data/wk4q1.csv")
q1 <- read.csv("./data/wk4q1.csv")
colnames <- names(q1)
strsplit(colnames, "^wgtp")[[123]]


# Question 2

# Remove the commas from the GDP numbers in millions of dollars and
#average them. What is the average?

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
q2 <- read.csv(url, nrows = 190, skip =4)

q2$x.4 <- as.numeric(gsub(",","",q2$X.4))
mean(q2$x.4)


# Question 3

# n the data set from Question 2 what is a regular expression that would
# allow you to count the number of countries whose name begins with "United"?

q2$X.3 <- as.character(q2$X.3)
q2$X.3[grep("^United", q2$X.3)] # gives 3 countries


# Question 4

#Match the data based on the country shortcode. Of the countries for which
#the end of the fiscal year is available, how many end in June?

library(data.table)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edurl <- 
  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url, destfile = "./data/wk4q4.csv")
download.file(edurl, destfile = "./data/edwk4q4.csv")
q4 <- fread("./data/wk4q4.csv", nrows = 190, skip = 4,
               select = c(1,2,4,5),
               col.names = c("CountryCode", "Rank", "Economy", "Total"))
edq4 <- fread("./data/edwk4q4.csv")
q4_merge <- merge(q4,edq4, by = "CountryCode")

length(grep("Fiscal year end: June", q4_merge$`Special Notes`))


# Question 5

# Code given

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

# How many values were collected in 2012? How many values were collected 
# on Mondays in 2012?

library(lubridate)
amznDates <- sampleTimes[grep("^2012", sampleTimes)] # gets first half
NROW(amznDates)
NROW(amznDates[weekdays(amznDates)=="Monday"])
       