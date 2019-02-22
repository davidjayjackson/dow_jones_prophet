library(data.table)
library(prophet)
DJI <-as.data.table(DJI)
#
# Test data:
DJI<-DJI[,.(Date,Close)]
colnames(DJI) <-c("ds","y")
m <- prophet(DJI)
future <- make_future_dataframe(m, periods = 90)
tail(future)
forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
plot(m, forecast)
prophet_plot_components(m, forecast)
forecast$ds <- as.Date(forecast$ds)