#'peter.eernisse@stantec.com
#'this project is practice for me to do graphics of covid-19 data
#'
#'
#
library(tidyverse)
library(data.table)

#Download data---------------------------
download.file('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv',
              destfile = './data/cases.csv')

download.file('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv',
              destfile = './data/deaths.csv')

#Get time series data----------------
#tsDataCases<-fread('C:/R_Projects/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
#tsDataDeaths<-fread('C:/R_Projects/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv')


tsDataCases<-fread('./data/cases.csv')
tsDataDeaths<-fread('./data/deaths.csv')

#setdiff(names(tsDataCases),names(tsDataDeaths))

#Reorganize data
casesL<-tsDataCases %>% 
  gather(DATE,COUNT,12:ncol(.)) %>% 
  mutate(Parameter = 'Cases')

deathsL<-tsDataDeaths %>% 
  gather(DATE,COUNT,13:ncol(.)) %>% 
  mutate(Parameter = 'Deaths')

tsData<-bind_rows(casesL,deathsL) %>% 
  mutate(DATE2=as.Date(DATE,format='%m/%d/%y')) %>% 
  arrange(`Country_Region`,DATE2,Parameter)

mdata<-tsData %>%
  mutate(
    `Province_State` = case_when(
      `Province_State` == '' ~ `Country_Region`,
      TRUE ~ `Province_State`
    )
  ) %>% 
  group_by(`Province_State`,Parameter,Lat,Long_) %>% 
  summarize(Result=max(COUNT))

#str(tsData)

#Get US daily report data---------------

#Read in data
files<-list.files('C:/R_Projects/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports_us/',
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

  
  
  
  
  
  



