# Check if directory exists

if(!file.exists("C:\\coursera_project")) {
  dir.create("C:\\coursera_project")
}
setwd("C:\\coursera_project")

# Download zip file

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileUrl, destfile = "a1.zip", method="curl")

unzip(zipfile="a1.zip", files = "household_power_consumption.txt", list = FALSE)

# SEarch for the beginning of 1/2/2007 data

temp_dates <- scan("household_power_consumption.txt", what = "", flush = TRUE,sep = ";",nlines = 100000 )

lines_skip <- grep("1/2/2007",temp_dates, fixed=TRUE)[1]-1


l1 <-read.csv("household_power_consumption.txt", skip = lines_skip, nrows = 2880, header = FALSE, sep = ";", quote = "\"", fill = TRUE)


colnames(l1) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")


library("data.table", lib.loc="C:/Program Files/R/R-3.1.0/library")

l1_t = data.table(l1)



l1_t[,datetime_2:=as.POSIXct(strptime(paste(l1_t[,Date],l1_t[,Time]),format='%d/%m/%Y %H:%M:%S'))]


plot(l1_t[,datetime_2],l1_t[,Sub_metering_1],lty=1,type="l", col="black", main="",xlab="",ylab="Energy sub metering")

lines(l1_t[,datetime_2],l1_t[,Sub_metering_2],lty=1,type="l", col="red")

lines(l1_t[,datetime_2],l1_t[,Sub_metering_3],lty=1,type="l", col="blue")

legend( "topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),  col=c("black", "red","blue"),lty=c(1,1,1), cex=1.2)

dev.copy(png,'plot3.png',width=480,height=480)
dev.off()



