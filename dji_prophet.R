library(data.table)
library(prophet)
library(lubridate)
library(RMySQL)
DJI <-fread("DJI.csv")
DJI$Date <-as.Date(DJI$Date)
DJI$Year <-year(DJI$Date)

#
summary(DJI)
# Predict the past: 2015 - Present
#
DJI1<-DJI[1:4714,.(Date,Close)]
colnames(DJI1) <-c("ds","y")
summary(DJI1)
plot(DJI1$ds,DJI1$y,'l')

m <- prophet(DJI1)
future <- make_future_dataframe(m, periods = 100)
tail(future)
forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
plot(m, forecast)
prophet_plot_components(m, forecast)
forecast$ds <- as.Date(forecast$ds)
# Merge predict and actual close
DJI2 <-DJI[,.(Date,Close)]
colnames(DJI2) <-c("ds","y")
merged.data <-merge(DJI2,forecast, key="ds")


mydb <- dbConnect(MySQL(),user='root',password='dJj12345',dbname="dji",
                  host='localhost')
dbListTables(mydb)
dbRemoveTable(mydb,"merged")
dbWriteTable(mydb, "merged",merged.data, row.names = FALSE)
dbSendStatement(mydb, "ALTER TABLE merged MODIFY COLUMN ds date")
dbDisconnect(mydb)
