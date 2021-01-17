## Week 3 Quiz -- Dan Swenson

# Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "./data/wk3qz.csv")
data <- read.csv("./data/wk3qz.csv")

  ## assign a logical vector for households>10acres w/ >$10,000 products
agricultureLogical <- data$AGS==6 & data$ACR==3

which(agricultureLogical)


# Question 2
library(jpeg)

  ## download JPEG, find 30% and 80%
jpg <- readJPEG("./data/getdata_jeff.jpg",native=TRUE)
quantile(jpg, probs=c(0.3,0.8))


# Question 3
library(dplyr)
library(data.table)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edurl <- 
  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url, destfile = "./data/q3.csv")
download.file(edurl, destfile = "./data/edq3.csv")

q3 <- fread("./data/q3.csv",skip="USA", nrows = 190, select = c(1,2,4,5),
            col.names = c("CountryCode", "Rank", "Economy", "GDP"))
edq3 <- fread("./data/edq3.csv")
    
  ## merge by country shortcode, find row matches, rank desc(GDP), what is #13?
mergedData <- merge(q3, edq3, by = "CountryCode")

rankedDesc <- arrange(mergedData, desc(Rank))
rankedDesc$Economy[[13]]


# Question 4

  ## what is average GDP for "High income: OECD" and "High income: nonOCED"
mergedData %>% group_by(`Income Group`) %>%
  filter("High income: OECD" %in% `Income Group` | "High income: nonOECD" %in% `Income Group`) %>%
  summarize(Average = mean(Rank, na.rm = T)) %>%
  arrange(desc(`Income Group`))


# Question 5

  ##Cut GDP rank into 5 quantile groups. Make table versus Income.Group.
    #How many countries in Lower middle income but in 38 nations w/ highest GDP?

mergedData$groups <- cut(mergedData$Rank, breaks = 5)
tab <- table(mergedData$groups, mergedData$`Income Group`)
tab
