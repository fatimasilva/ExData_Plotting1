# Creates plot2.png, including reading the data
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

# Generate plot 2
png(filename = "plot2.png", width = 480, height = 480)

plot(powerdates$datetime, powerdates$Global_active_power, xaxt="n",
     ylab = "Global Active Power (kilowatts)", xlab = "", type = "n")

# Label the x axis
axis.POSIXct(1, x = powerdates$datetime, format = "%a", labels = TRUE)

# Alternative way of labeling the x axis (with at)
#daterange <- c(min(powerdates$datetime), max(powerdates$datetime))
#axis.POSIXct(1, at=seq( daterange[1], daterange[2], by = "day"), format = "%a", labels = TRUE)

# Draw the data points
lines(powerdates$datetime, powerdates$Global_active_power)

dev.off()
