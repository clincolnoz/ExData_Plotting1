## plot 1: Global Active Power
## Explorartory Data Analysis: Week 1 Assignment 1

# Vars:
# fileList = list of files to be downloaded
# outFileList = filename of downloaded file stripped from fileList path

source("downloadFile.R") # dowwnloads files to ./data
library(data.table)
library(dplyr)
library(lubridate)

# Download data from source
fileList <- c("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
outFileList <- paste0("./data/",basename(fileList))
# Download zip file
downloadFile(fileList)

# Unzip file if not already done 
if(!file.exists("./data/household_power_consumption.txt")) {
    print("Unzipping contents")
    unzip(outFileList)
}

# Readin data, select date range 2007/02/01-2007/02/02, combine and change DAte & Time To posixct, assign to mydatasub and remove original data. For some wierd reason i cannot chain the commands.
if(!exists("mydatasub")) {
    mydata <- tbl_df(fread("household_power_consumption.txt", na.strings = "?"))     
    mydatasub <- filter(mydata,dmy(mydata$Date) == ymd("2007/02/01") | dmy(mydata$Date) == ymd("2007/02/02"))
    mydatasub <- mutate(mydatasub,date_time = dmy_hms(paste(mydatasub$Date, mydatasub$Time)))
    remove("mydata")
}

# Make plot and send to file plot3.png
plot(mydatasub$date_time,mydatasub$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
points(mydatasub$date_time,mydatasub$Sub_metering_1, type = "l")
points(mydatasub$date_time,mydatasub$Sub_metering_2, type = "l", col = "red")
points(mydatasub$date_time,mydatasub$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = 1, col = c("black","red","blue"))
dev.copy(png,"plot3.png", width=480, height = 480)
dev.off()
