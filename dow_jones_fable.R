library(forecastLM)
library(tidyverse)
library(tsibble)
DJI <-read.csv("../db/DJI.csv")
DJI$Date <-as.Date(DJI$Date)
DJI<-DJI %>% filter(Date <="2019-01-01") %>% select(Date,Close)
df <- as_tsibble(DJI,index=Date)
md <- trainLM(input = df,
              y = "Close",
              trend = list(linear = TRUE),
              seasonal = "yday",
              lags = c(1, 12))

fc <- forecastLM(model = md,
                 h = 100)

plot_fc(fc)

DJI <-read.csv("../db/DJIWeekly.csv")
DJI$Date <-as.Date(DJI$Date)
DJI<-DJI %>% filter(Date <="2019-01-01") %>% select(Date,Close)
df <- as_tsibble(DJI,index=Date)
md <- trainLM(input = df,
              y = "Close",
              trend = list(linear = TRUE),
              seasonal = "week",
              lags = c(1, 12))

fc <- forecastLM(model = md,
                 h = 24)

plot_fc(fc)