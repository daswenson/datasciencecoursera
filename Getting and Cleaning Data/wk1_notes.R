## Week1 Testing

  ## file.exists()
    # tells whether a file with the specified name exists in the 
    # specified directory
    # returns boolean

# this checks if a directory exists or otherwise creates it
if(!file.exists("data")){
  dir.create("data")
}

  ## download.file()
    # parameters: url,destfile, method
    # helps with reproducability
    # useful fortab-delimited, csv and others
# example with Balitmore speed cameras

### THIS FILE DOES NOT GIVE A CSV FILE TYPE
fileUrl <- "https://opendata.baltimorecity.gov/egis/rest/services/Hosted/
Fixed_Speed_Cameras/FeatureServer/0/
query?where=1%3D1&outFields=*&outSR=4326&f=json"

download.file(fileUrl, destfile = "./data/cameras.csv")
dateDownLoaded <- date() # always specify when you get the data

  ## reading local files
    # just like we learned before
    # read.table()
    # read.csv()
    # biggest trouble with readin are ' or " placed in data
      # setting quote="" often resolves it

### DOES NOT WORK CAUSE DOWNLOAD FILE IS NOT CSV
data <- read.csv("./data/cameras.csv", sep = ",", header = TRUE)
head(data)


  ## Reading Excel Files
    # find package or use format below
### DOES NOT WORK CAUSE DOWNLOAD LINK
download.file(fileUrl, destfile = "./data/cameras.xlsx")
cameraData <- read.table("./data/cameras.xlsx", sep = "\t", header=TRUE)
head(cameraData)

  ## Reading XML
    # frequently used ot store structured data
    # used a lot in web scraping
    # components: Markup - labels for structure, Content - Content
    # has tags, elements, and attributes

library(XML)
library(xml2)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
download_xml(fileUrl, file = "simpledata.xml")    ## include .xml in name
doc <- xmlTreeParse("simpledata.xml",useInternalNodes=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode) # gives name of root menu
names(rootNode) # names of the nodes in the root element

    # can access elements the same way as a list
rootNode[[1]]
rootNode[[1]][[1]]

xmlSApply(rootNode,xmlValue) # iterate through root Node to extract values

    #learn XPath to help get right tags
xpathSApply(rootNode, "//name", xmlValue) # get all name tags
xpathSApply(rootNode, "//price", xmlValue) # get all price tags

  # html is similar, just html instead of xml for functions\
fileUrl <- "http://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
download_html(fileUrl,file="RavenData.html")
doc <- htmlTreeParse("RavenData.html",useInternalNodes = TRUE)

# gets the score values in the left column
scores <- xpathSApply(doc,"//div[@class='score']", xmlValue)

# gets the name of the teams in the left column (includes next scheduled game)
teams <- xpathSApply(doc, "//div[@class='game-info']", xmlValue)

  ## Reading JSON 
    # Javascript Object notation
    # data as numbers, strings, boolean, array, object
    # structed like XML but different syntax

library(jsonlite) # nice package for reading JSON data
    # file with data about repos he contributed to
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner) # can store data frames in lists
jsonData$owner$login

    # can also take data sets and write them to JSON
myjson <- toJSON(iris, pretty = TRUE)
myjson
    
    # turning it back into data frame
iris2 <- fromJSON(myjson)
head(iris2)

  ## data tables
    # built using C so is much faster
    # requires some C syntax

library(data.table)
DF = data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)

DT = data.table(x=rnorm(9), y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)

# see all data tables in memory
tables()

    # subsetting rows is just like a data frame
DT[2,]
DT[DT$y=="a",]
    # subsetting col is differenet
    # argument after comma is an "expression"
DT[,c(2,3)] # getting columns 2 and 3
DT[,list(mean(x),sum(z))] # get mean of x and sum of z

    # adding new columns
    # adding a new variable to a data frame R copies everything
      # thus takes a lot of memory
DT[,w:=z^2] # adds column w that is z^2

DT2 <- DT
DT[,y:=2]
head(DT,3)
head(DT2,3) # since no copy was made, both were changed, uses copy()

    # able to use multiple expressions, last thing gets returned 
DT[,m:= {tmp<- (x+z); log2(tmp+5)}]
DT[,a:=x>0] # can also do plyr operations
DT[,b:= mean(x+w), by=a] # groups by when a=TRUE or a=FALSE

    # special variables are present
      # .N - integer containing the number of times something appears
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5,TRUE))
DT[,.N, by=x]
    
    # keys
      # possible subset and sort much faster
      # use them to faciliate joins
DT <- data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
setkey(DT,x)
DT['a'] # thus subsets on the basis x

DT1 <- data.table(x=c('a','a','b','dt1'),y=1:4)
DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
setkey(DT1,x); setkey(DT2,x) # as long as same key
merge(DT1,DT2)

    # fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE,
            col.names=TRUE, sep="\t", quote=FALSE)
# compare the two
system.time(fread(file))
system.time(read.table(file, header = TRUE, sep = "\t"))
