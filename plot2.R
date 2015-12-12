#The script is used to to examine how household electric energy consumption 
#varies over a 2-day period from 02/01/2007 to 02/02/2007
#The data source is obtained from UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/)
# A series of plots are generated to determine variation and draw meaningful conclusions

# This is the script that generates plot 2 (time plot of Global Active Power (kw))
library(data.table)

filename <- "exdata_data_household_power_consumption.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename)
}  
if (!file.exists("household_power_consumption.txt")) { 
  unzip(filename) 
}

#Read the data set
powerVar <- fread("household_power_consumption.txt", na.strings = "?")

#Convert the date variable to R classes (POSIXlt)
powerVar$Date <- as.Date(powerVar$Date, "%d/%m/%Y")


#select the subset from 02/01/2007 - 02/02/2007
selData <- powerVar[Date %between% c("2007-02-01", "2007-02-02")]

#Convert the time variable to R classes (POSIXlt)
properTime <- paste(selData$Date, selData$Time)
strptime(properTime, "%Y-%m-%d %H:%M:%S")
selData$Time <- as.POSIXct(strptime(properTime, "%Y-%m-%d %H:%M:%S")) 

#Create the time plot of active power (plot 2) and format it properly with title and labels 
with(selData, {
       plot(Time, Global_active_power, type = "l", 
            ylab = "Global Active Power (kilowatts)")
  })

#Export to the png file (copy and close the device)
dev.copy(png, file = "plot2.png")
dev.off()

