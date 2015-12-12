#The script is used to to examine how household electric energy consumption 
#varies over a 2-day period from 02/01/2007 to 02/02/2007
#The data source is obtained from UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/)
# A series of plots are generated to determine variation and draw meaningful conclusions

# This is the script that generates plot 3 (time plot of Energy sub metering)
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

#*********************************************************************#
#Specific section used to generate Plot 3
#Use melt to transform the submetering measures
subMeter = melt(selData, id.vars = c("Date", "Time"), 
             measure.vars = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Export directly to the png file to preserve the aspect ratio
png(filename = "plot3.png")

#Create the time plot of submetering measurements (plot 3) 
#and format it properly with title. legend and labels 
with(subMeter, {
  plot(Time, value, type = "n", 
       ylab = "Energy sub metering")
})

with(subset(subMeter, variable == "Sub_metering_1"), {
  points(Time, value, type = "l", col = "black")
})

with(subset(subMeter, variable == "Sub_metering_2"), {
  points(Time, value, type = "l", col = "red")
})

with(subset(subMeter, variable == "Sub_metering_3"), {
  points(Time, value, type = "l", col = "blue")
})

legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Close the png file device
dev.off()