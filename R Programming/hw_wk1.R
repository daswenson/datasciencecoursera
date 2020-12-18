##reading in csv file
data <- read.csv("R Programming/hw1_data.csv")

## Finding all NA values in a logical
clean <- complete.cases(data)

##applying logical to only have complete values
clean_data <- data[clean,]

##finding Ozone column and the sum on NA values
oz <- data$Ozone
sum(is.na(oz))

##Taking only the clean Ozone column
cloz <- clean_data$Ozone

##Finding mean of Ozone column
mean(cloz)

##Finding clean columns in which Ozone>31 and Temp>90
oz_tmp <- data[data$Ozone>31|data$Temp>90,]
oz_tmp

##Finding mean of wanted rows from directly above
mean(oz_tmp$Solar.R, na.rm=TRUE) ##Returns wrong value, doesn't match

##Finding the mean of Temp when month=6
m6 <- data[data$Month==6,]
m6
mean(m6$Temp)

##max ozone value when May(month=5)
may <- data[data$Month==5,]
max(may$Ozone, na.rm=TRUE)
