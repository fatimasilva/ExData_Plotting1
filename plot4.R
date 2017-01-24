# Creates plot4.png, including reading the data
# Part of the Exploratory Analysis course, week 1 assignment

# Load libraries
library(data.table)
library(dplyr)

# Create data folder
if(!file.exists("./data")) { dir.create("./data/")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/household_power_consumption.zip", method = "curl")

# Unzip file
unzip("./data/household_power_consumption.zip", exdir = "./data/", list = FALSE)

# Read data into R
powerdf <- fread("./data/household_power_consumption.txt", na.strings = "?",
                    sep = ";", header = TRUE, data.table = FALSE)

# Filter by dates
powerdates <- filter(powerdf, grepl('^1/2/2007$|^2/2/2007$', powerdf$Date, perl = TRUE))

# Convert to data format
powerdates$datetime <- strptime( paste(powerdates$Date, powerdates$Time),
                                 format = "%d/%m/%Y %H:%M:%S" )

# Remove original Date and Time variables
powerdates <- powerdates[,c(-1,-2)]

# Generate png with 4 plots
png(filename = "plot4.png", width = 480, height = 480)
par(mfcol = c(2,2))

## plot1

plot(powerdates$datetime, powerdates$Global_active_power, xaxt="n",
     ylab = "Global Active Power", xlab = "", type = "n")

### Label the x axis
axis.POSIXct(1, x = powerdates$datetime, format = "%a", labels = TRUE)

### Draw the data points
lines(powerdates$datetime, powerdates$Global_active_power)

## plot2
plot(powerdates$datetime, powerdates$Sub_metering_1, xaxt="n",
     ylab = "Energy sub metering", xlab = "", type = "n")

### Label the x axis
axis.POSIXct(1, x = powerdates$datetime, format = "%a", labels = TRUE)

### Draw the data points
lines(powerdates$datetime, powerdates$Sub_metering_1, col = "black")
lines(powerdates$datetime, powerdates$Sub_metering_2, col = "red")
lines(powerdates$datetime, powerdates$Sub_metering_3, col = "blue")

### Add legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lwd = 1, box.lty = 0)

## plot3

plot(powerdates$datetime, powerdates$Voltage, xaxt="n",
     ylab = "Voltage", xlab = "datetime", type = "n")

### Label the x axis
axis.POSIXct(1, x = powerdates$datetime, format = "%a", labels = TRUE)

### Draw the data points
lines(powerdates$datetime, powerdates$Voltage)

## plot4

plot(powerdates$datetime, powerdates$Global_reactive_power, xaxt="n",
     ylab = "Global_reactive_power", xlab = "datetime", type = "n")

### Label the x axis
axis.POSIXct(1, x = powerdates$datetime, format = "%a", labels = TRUE)

### Draw the data points
lines(powerdates$datetime, powerdates$Global_reactive_power)

## Close png device
dev.off()
