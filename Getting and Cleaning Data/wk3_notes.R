## Week 3 notes


#----------
  ## Subsetting and Sorting
# creating data frame to use
set.seed(13425)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))

# scramble order then make some values NA
X <- X[sample(1:5),]; X$var2[c(1,3)]=NA
X

    # Logicals, ands, ors
X[(X$var1 <= 3 & X$var3 > 11),]
X[(X$var1 <= 3 | X$var3 > 15),]

    # Dealing with missing values
X[which(X$var2 > 8),] # returns indices where var2>8 w/o NA

    # sorting
sort(X$var1)
sort(X$var1, decreasing = TRUE)
sort(X$var2, na.last = TRUE)

    # ordering
X[order(X$var1),] # orders var1 vertically
X[order(X$var1,X$var3),]

    # can do the same things with plyr package
library(plyr)
      # arrange takes a data frame and orders by variable
arrange(X,var1) # = order(X$var1)
arrange(X,desc(var1))

    # adding rows and columns
X$var4 <- rnorm(5)
      # can also use cbind
Y <- cbind(X,rnorm(5)) # for columns. rows = rbind


#----------
  ## Summarizing Data
    # using Baltimore restaurant data
"https://data.baltimorecity.gov/datasets/restaurants/geoservice?geometry=
  -77.253%2C39.193%2C-75.988%2C39.379"

  # GIVES JSON NOT CSV LIKE VIDEO SAYS
  # fileUrl <- "https://opendata.baltimorecity.gov/egis/rest/services/Hosted/
  # Restaurants/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
  # download.file(fileUrl, destfile = "./data/restaurants.csv")


restData <- read.csv("./data/restaurants.csv")

    # first thing is to look at data set
head(restData, n=3)
tail(restData, n=3)
summary(restData)
str(restData)
quantile(restData$cncldst,na.rm=TRUE) # getting quantiles
quantile(restData$cncldst, probs = c(0.5,0.75,0.9)) # looking at probabilities

    # could also make tables
table(restData$zipcode, useNA = "ifany") # ifany: means NA values get own col
table(restData$cncldst,restData$zipcode) # 2d tables

    # check for missing values
sum(is.na(restData$cncldst)) # sum=0 means no missing values
any(is.na(restData$cncldst)) # checks if any NA exist
all(restData$cncldst > 0) # checks if all cncldst > 0
colSums(is.na(restData)) # sums NAs of each column

  # specific characteristics
table(restData$zipcode %in% c("21212")) # checks if zip is in vector
table(restData$zipcode %in% c("21212","21213"))
      # using logic to subset with this method
restData[restData$zipcode %in% c("21212",'21213'),] # only rest in wanted zips

  # crosstabs
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)

    # left side is displayed var, right is breakdown var
xt <- xtabs(Freq ~ Gender+Admit,data=DF)
xt

warpbreaks$replicate <- rep(1:9, lem=54)
xt <- xtabs(breaks ~.,data=warpbreaks) # . means breakdown by all
xt

  # flat tables
ftable(xt) # summarize in much smaller compact form

  # size of data set
fakeData <- rnorm(1e5)
object.size(fakeData) # gives answer in bytes
print(object.size(fakeData), units="Mb")


#---------
  ## Creating New Variables
    # raw data often won't have what you need
    # will need to transform data to get values
    # usually add the values to data frame

  # using restaurant data from previous video
restData <- read.csv("./data/restaurants.csv")

    # Creating Squences
      # sometimes you need an index for your data
      # sequences are often used to index differnt operations
s1 <- seq(1,10,by=2); s1 # counts by num from min to max
s2 <- seq(1,10,length=3); s2 # creates 3 variables between min/max
x <- c(1,3,8,25,100); seq(along = x) # creats seq of same length as x

    # sub-setting variables
      # might want to create a subset that counts something
# counts restaurants in specified neighborhoods
restData$nearMe <- restData$nghbrhd %in% c("Roland Park", "Homeland")
table(restData$nearMe)

    # Creating Binary variables
restData$zipWrong <- ifelse(as.numeric(restData$zipcode) < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipcode < 0) # one is NA but not False??

    # Creating categorical variables
restData$zipGroups <- cut(as.numeric(restData$zipcode),
                          breaks = quantile(as.numeric(restData$zipcode),
                                            na.rm=TRUE))
table(restData$zipGroups,restData$zipcode)

library(Hmisc) # useful, cuts by # groups you specify
restData$zipGroups <- cut2(as.numeric(restData$zipcode),g=4)
table(restData$zipGroups)

    # Creating factor variables
restData$zcf <- factor(restData$zipcode)
restData$zcf[1:10]
class(restData$zcf)
        # levels of factor variables
yesno <- sample(c("yes","no"), size = 10, replace=TRUE)
yesnofac <- factor(yesno, levels=c("yes","no"))
relevel(yesnofac,ref="yes")
as.numeric(yesnofac) # will change levels to nums

        # cutting produces factor variables
        # can use mutate function to create a new variable and add
        # the new df will be old df with new variables added
library(plyr)
restData2 <- mutate(restData, zipGroups=cut2(as.numeric(zipcode),g=4))
table(restData2$zipGroups)


#----------
  ## Reshaping Data
    # data will often not be tidy
    # goal is tidy data
      # each var forms a col
      # each obs forms a row
      # each table/file stores data about 1 kind of obs

library(reshape2)
head(mtcars) # looking at data set

    # Melting data frames
      # takes which variables are id and measure variables
      # all measure variables are in same column
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname","gear","cyl"),
                measure.vars = c("mpg","hp"))
head(carMelt, n=3)
tail(carMelt, n=3)

      # can recast it in many ways
cylData <- dcast(carMelt, cyl ~ variable)
cylData # this summarizes data set by length

cylData <- dcast (carMelt, cyl ~ variable,mean)
cylData # this summarizes data by mean

    # Average Values
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum) # sum with each value of spry

      # another way: split, apply, combine
spIns <- split(InsectSprays$count,InsectSprays$spray)
spIns # splits count by sprays

sprCount <- lapply(spIns, sum)
sprCount # sums each element of list

unlist(sprCount) # combines list to vector 
sapply(spIns,sum) # same as sum then combine

    # plyr Package
ddply(InsectSprays,.(spray), summarise, sum=sum(count))

                        # summarize counts by summing
spraysums <- ddply(InsectSprays,.(spray),summarise,sum=ave(count,FUN=sum))
dim(spraysums) # returns same dimensions as original data set

### plyr tutorial - http://plyr.had.co.nz/09-user/


#----------
  ## Managing DF with dplyr
    # package is about working with df as they are key structures
    # optimized and distilled version of plyr package
    # is very fast, most key operations are in C++

    # select - returns a subset of the columns of a data frame
    # Filter - extracts a subset of rows
    # arrange - allows to reorder rows while preserving col order
    # rename - rename the variable
    # mutate - transforms or adds new variables
    # summarize - generate summary statistics of the data frame.

    # first argument is always DF, next describes what do
        # can refer to col without $ operator
    # DF must be properly formatted and annotated to be useful

library(dplyr)

chicago <- readRDS("./data/chicago.rds")
dim(chicago)  
str(chicago)  # looking at variable names

      # select
head(select(chicago,city:dptp)) # looking at cols city through dptp
head(select(chicago,-(city:dptp))) # all cols except those stated

      # filter
chic.f <- filter(chicago,pm25tmean2 > 30) # subset with 1 argument
head(chic.f,10)

chic.f <- filter(chicago,pm25tmean2 > 30 & tmp > 80) # subset w/ 2 args
head(chic.f,10)

      # arrange
chicago <- arrange(chicago,date) # arranges rows by date
head(chicago)
tail(chicago)

chicago <- arrange(chicago, desc(date)) # descending order
head(chicago)

      # rename - hard to do without a function like this
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp) # new then old
head(chicago)

      # mutate
chicago <- mutate(chicago, pm25detrend = pm25-mean(pm25,na.rm = TRUE))
head(select(chicago,pm25,pm25detrend))

      # groupby
# creates a new var that determines whether it is hot or cold
chicago <- mutate(chicago, tempcat = factor(1*(tmpd > 80), 
                                            labels= c("cold","hot")))
hotcold <- group_by(chicago, tempcat)
hotcold

# summarises hotcold with each of the given arguments
summarise(hotcold, pm25 = mean(pm25, na.rm=TRUE),
          o3 = max(o3tmean2),no2 = median(no2tmean2))

# grouping by years
chicago <- mutate(chicago, year = as.POSIXlt(date)$year +1900)
years <- group_by(chicago,year)
summarise(years,pm25 = mean(pm25, na.rm=TRUE),
          o3 = max(o3tmean2),no2 = median(no2tmean2))

# %>% allows us to pipeline functions together
chicago %>% mutate(month = as.POSIXlt(date)$mon +1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm=TRUE), o3 = max(o3tmean2),no2 = median(no2tmean2))


#----------
  ## Merging Data
    # using the merge() fnc
    # parameters x,y,by,by.x,by.y,all

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://s3.amazonaws.com/csvpastebin/uploads/e70e9c289adc4b87c900fdf69093f996/reviews.csv"
fileUrl2 = "https://s3.amazonaws.com/csvpastebin/uploads/0863fd2414355555be0260f46dbe937b/solutions.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)

names(reviews)
names(solutions)

  # default is to merge all common col names
mergedData <- merge(reviews, solutions, by.x="solution_id",by.y="id",all=TRUE)
head(mergedData)

intersect(names(solutions),names(reviews))
mergedData2 <- merge(reviews,solutions,all=TRUE)
head(mergedData2)

  # can also use join in plyr package
    # faster then merge but with less features, only merge by common names
library(plyr)
df1 <- data.frame(id=sample(1:10), x=rnorm(10))
df2 <- data.frame(id=sample(1:10), y=rnorm(10))
arrange(join(df1,df2),id)

  # using join_all to merge everything
df3 <- data.frame(id=sample(1:10), z=rnorm(10))
dfList <- list(df1,df2,df3)
join_all(dfList)


  #### Look at tidyr package / swirl tidyr lesson for more