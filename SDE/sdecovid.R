library(JuliaCall)
library(diffeqr)
library(tidyverse)
## World Bank Data on Population
pop<-read.csv("worldbank_population.csv")
## Covid data (datasets github)
covid<-read.csv("countries-aggregated.csv")
## Death Rate Calculation
names(pop)[1]<-"Country"
covid.dr<-covid %>% filter(Date=="30-03-20") %>% inner_join(pop,by="Country") %>% mutate(dr=Deaths/X2018)

##anycountry example
gamma<-0.05 ##assuming a 20 day recovery. Gamma=1/recovery period
countryname<-"Mexico" ##Select any country
mu<-covid.dr$dr[which(covid.dr$Country==countryname)] ## Death Rate
N<-covid.dr$X2018[which(covid.dr$Country==countryname)] ## Population Size
lambda<-25 ##Average number of people coming into contact with one individual
beta<-lambda/N
sig<-1 ##Volatility for beta, making beta stochastic
## looking for optimal solution on sdes

