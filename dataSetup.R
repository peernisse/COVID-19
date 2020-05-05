#'peter.eernisse@stantec.com
#'this project is practice for me to do graphics of covid-19 data
#'
#'
#
library(tidyverse)
library(data.table)

#Get time series data----------------
tsDataCases<-fread('./csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
tsDataDeaths<-fread('./csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv')

#setdiff(names(tsDataCases),names(tsDataDeaths))

#Reorganize data
casesL<-tsDataCases %>% 
  gather(DATE,COUNT,5:ncol(.)) %>% 
  mutate(Parameter = 'Cases')

deathsL<-tsDataDeaths %>% 
  gather(DATE,COUNT,5:ncol(.)) %>% 
  mutate(Parameter = 'Deaths')

tsData<-bind_rows(casesL,deathsL) %>% 
  mutate(DATE2=as.Date(DATE,format='%m/%d/%y')) %>% 
  arrange(`Country/Region`,DATE2,Parameter)

mdata<-tsData %>%
  mutate(
    `Province/State` = case_when(
      `Province/State` == '' ~ `Country/Region`,
      TRUE ~ `Province/State`
    )
  ) %>% 
  group_by(`Province/State`,Parameter,Lat,Long) %>% 
  summarize(Result=max(COUNT))

#str(tsData)

#Get US daily report data---------------
files<-list.files('./csse_covid_19_data/csse_covid_19_daily_reports_us/',
                  pattern='.csv',full.names = TRUE)
files

usData<-data.frame()

for(i in 1:length(files)){
  
  #Testing
  #i<-1
  ####
  
    inData<-fread(files[i])
    
    usData<-usData %>% bind_rows(inData)
  
}

#Shape into long format
usDataL<-usData %>% 
  gather(Parameter,Result,6:ncol(usData)) %>% 
  mutate(
    Date = as.Date(Last_Update,format="%Y-%m-%d %H:%M:%S"),
    Result = as.numeric(Result)
  ) %>% 
  filter(!is.na(Lat))

  
  
  
  
  
  



