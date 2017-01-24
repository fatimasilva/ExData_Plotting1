# Creates plot1.png, including reading the data
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

# Generate plot 1
png(filename = "plot1.png", width = 480, height = 480)
hist(powerdates$Global_active_power, col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()
