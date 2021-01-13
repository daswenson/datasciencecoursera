## Week 2 testing

#-----------
## Reading from MySQL
  # data is structure in data bases
  # tables within
  #fields within
  # each row is called a record

library(RMySQL)
  
  # accessing genome database
  # ALWAYS disconnect from the database
ucscDb <- dbConnect(MySQL(), user="genome",
                      host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb)
  
  # connecting to hg29 genome and listing tables
hg19 <- dbConnect(MySQL(), user="genome", db= "hg19",
                    host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

  # looking at the fields of a specific table in the database
dbListFields(hg19, "affyU133Plus2")
  
  # counts all the records (rows) in a table
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
  
  # get data from table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)
  
  # selecting a specific subset
query <- dbSendQuery(hg19,
              "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

  # how to see a little amount of data, NEED to clear query after
affyMisSmall <- fetch(query,n=10); dbClearResult(query);
dim(affyMisSmall)

# REMEMBER TO CLOSE CONNECTION ASAP
dbDisconnect(hg19)


  ## Reading from HDF5
    # used for storing large and/or structured data sets
    # lecture is similar to r hdf5 tutorial

if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager")
BiocManager::install()
BiocManager::install("rhdf5")

library(rhdf5)
created = h5createFile("example.h5")
created

    # creating groups within the file
created <- h5createGroup("example.h5", "foo")
created <- h5createGroup("example.h5", "baa")
created <- h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")  #lists out components of file

  # write to specific groups
A <- matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5", "foo/A")
B <- array(seq(0.1,2.0, by=0.1), dim=c(5,2,2))
attr(B,"scale") <- "liter"  # adding attributes to array
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

  # can write data set directly
df <- data.frame(1L:5L,seq(0,1, length.out = 5),
                c("ab","cde","fghi","a","s"),
                stringsAsFactors = FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

  # reading data
readA <- h5read("example.h5","foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df")
readA

  # reading and writing in chunks
    # writing to dataset A 
h5write(c(12,13,14),"example.h5","foo/A", index = list(1:3,1))
h5read("example.h5","foo/A") # can pass index argument to this also


#-----------
  ## Reading from the web
    # focus on web site scraping
      # programatically extracting data from websites

  # example using his google scholar page
con <- url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con) # be sure to close connection afterwards
htmlCode # MAKES RSTUDIO FREEZE?? 

  # parsing with XML
library(XML)
library(RCurl)
url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
fileurl <- getURL(url) # use this for https links to work
html <- htmlTreeParse(fileurl, useInternalNodes = T)

xpathSApply(html,"//title", xmlValue)
xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)

  # another approach to getting data
library(httr); html2 <- GET(url)
content2 <- content(html2, as="text") # extracts content
parsedHtml <- htmlParse(content2, asText = TRUE) # looks like XML package
xpathSApply(parsedHtml,"//title", xmlValue)

  # accessing websites with passwords
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1 # returns status 401 cause we need password

pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
           authenticate("user","passwd"))
pg2 # status:200 means we have accesss
names(pg2)

  # using handles prevents from having to authenticate many times
google <- handle("https://google.com")
pg1 <- GET(handle=google,path="/")
pg2 <- GET(handle = google, path="search")
  # r-bloggers has good examples of web scraping


#----------
  ## Reading from APIs
    # most tech companies (twitter/facebook) have APIs
    # able to get data using GET requests
    # most cases you have to create an API account
          # using twitter as example, NEED DEV ACCOUNT
      
library(httr)

myapp <- oauth_app("twitter",
                   key="yourConsumerKey", secret = "yourconsumer secret")
sig <- sign_oauth1.0(myapp, token = "yourToken",
                    token_secret = "yourTokenSecret")

    # specific url that corresponds to what you want
        # ver: 1.1, Components: statuses of home timeline in json, auth:sig
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)

json1 <- content(homeTL) # extracts data

# reformats as dataframe, each row=tweet
json2 <- jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

  # go into twitter API documentation to get what url you need

#----------
  ## Reading from other sources
    # brief review of useful packages
    # can also google or R package

    # interacting files directly
      # file - open a connection to a text file
      # url - open connection to url
      # gzfile - connection to gzfile
      # ?connection for more information
      # REMEMBER TO CLOSE CONNECTIONS

    # foreign package
      # loads data from Minitab, S, SAS, SPSS, Stata, Systat
      # basic functions read.extension - look in documentation
    
    # large number of database packages
      # RPostresSQL - DBI-compliant connection
      # RODBC - interfaces to multiple databases
      #Rmongo - interfaces to MongoDb

    # Reading Images
      # jpeg
      # readbitmap
      # png
      # EBIMage - bioconductor

    # GIS Data
      # rdgal
      # rgeos
      # raster
    
    # Music data (MP3)
      # tuneR
      # seewave