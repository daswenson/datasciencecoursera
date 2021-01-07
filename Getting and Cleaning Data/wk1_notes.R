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
