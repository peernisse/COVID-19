#'peter.eernisse@stantec.com
#'this project is practice for me to do graphics of covid-19 data
#'
#'
#
library(tidyverse)
library(data.table)

#Get time series data
tsDataCases<-fread('./csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
tsDataDeaths<-fread('./csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv')

setdiff(names(tsDataCases),names(tsDataDeaths))

#Reorganize data
casesL<-tsDataCases %>% 
  gather(DATE,COUNT,5:ncol(.)) %>% 
  mutate(Parameter = 'Cases')

deathsL<-tsDataCases %>% 
  gather(DATE,COUNT,5:ncol(.)) %>% 
  mutate(Parameter = 'Deaths')

tsData<-bind_rows(casesL,deathsL) %>% 
  mutate(DATE2=as.Date(DATE,format='%m/%d/%y'))

str(tsData)


