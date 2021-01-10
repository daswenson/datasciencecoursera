## Week 2 testing

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
df = data.frame(1L:5L,seq(0,1, length.out = 5),
                c("ab","cde","fghi","a","s"),
                stringsAsFactors = FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

  # reading data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5", "foo/foobaa/B")
readdf = h5read("example.h5", "df")
readA

  # reading and writing in chunks
    # writing to dataset A 
h5write(c(12,13,14),"example.h5","foo/A", index = list(1:3,1))
h5read("example.h5","foo/A") # can pass index argument to this also


  ## Readign from the web

## SWIRL
  # dplyr
    # useful for manipulating data
    # select, filter -  can get required col/row faster
    # arrange - sort rows by value in col
    # mutate -  lets you create new variable based on existing
    # summarize - collapses data set to single row