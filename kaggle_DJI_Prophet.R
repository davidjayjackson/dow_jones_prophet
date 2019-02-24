## Importing packages
library(data.table)
library(prophet)
library(lubridate)
# Read Down Jones Daily average: 2000 - 2019
dji <-fread("DJI.csv")
dji$Date <- as.Date(dji$Date)
dji$Year <-year(dji$Date)
# str(dji)
# plot(dji$Date,dji$Close,'l')
data <-dji[Year <=2017,.(Date,Close)]
colnames(data) <-c("ds","y")
# summary(data)
# Begin Prophet on compleat data set: 2000-01-01 to 2019-02-21
m <- prophet(data)
future <- make_future_dataframe(m, periods = 365)
tail(future)
forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
# plot(m, forecast)
# prophet_plot_components(m, forecast)
dyplot.prophet(m, forecast)
#
# Predict Sunspots Activity : 1850 - 2019-01
#
# Import daily sunspot data from http://sidc.be
A <-fread("sun_data.csv")
colnames(A) <-c("ds","y")
A$ds <-as.Date(A$ds)
A <- A[ds >="1947-01-01",]
m1 <- prophet(A)
future <- make_future_dataframe(m1, periods = 24,freq= "month")
tail(future)
forecast <- predict(m1, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
dyplot.prophet(m1, forecast)
#
