library(data.table)
library(prophet)
library(lubridate)
library(forecastLM)
library(tidyverse)
DJI <-fread("../db/DJI.csv")
DJI$Date <-as.Date(DJI$Date)
DJI$Year <-year(DJI$Date)

#
summary(DJI)
# Predict the past: Jan 1999 - Present
#
DJI1<-DJI[,.(Date,Close)]
colnames(DJI1) <-c("ds","y")
summary(DJI1)
ggplot(DJI1) + geom_line(aes(x=ds,y=y))
#
DJI2 <- DJI1[ds <="2019-01-01"]
ggplot(DJI2) + geom_line(aes(x=ds,y=y))
m <- prophet(DJI2)
future <- make_future_dataframe(m, periods = 500)
tail(future)
forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
plot(m, forecast)
prophet_plot_components(m, forecast)
forecast %>% filter(ds >="2019-01-01") %>%
  ggplot(aes(x=ds,y=yhat)) + geom_line() 
forecast$ds <- as.Date(forecast$ds)
##
## forecastLM
##
df <- as_tibble(DJI2,index=ds)
# Training a model
md <- trainLM(input = df,
              y = "y",
              trend = list(linear = TRUE),
              seasonal = "yday",
              lags = c(1, 12))

# Forecasting the future observations
fc <- forecastLM(model = md,
                 h = 60)

# Plotting the forecast
plot_fc(fc)