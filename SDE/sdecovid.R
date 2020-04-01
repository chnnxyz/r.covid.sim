library(matrixStats)
library(tidyverse)
library(reshape2)
## World Bank Data on Population
pop<-read.csv("worldbank_population.csv")
## Covid data (datasets github)
covid<-read.csv("countries-aggregated.csv")
## Death Rate Calculation
names(pop)[1]<-"Country"
covid.dr<-covid %>% filter(Date=="30-03-20") %>% inner_join(pop,by="Country") %>% mutate(dr=Deaths/X2018)


############## Ordinary Differential Equation ##############
# To be used for comparison when SDE notation is fixed     #
# Model can be found at SIAM.org in Gray, Greenhalgh, Hu's #
# A Stochastic Differential Equation SIS Epidemic Model    #
############################################################
## Deterministic model using SIR. (recovered includes dead)
## Initialize variables
countryname<-"Mexico"
N<-covid.dr$X2018[which(covid.dr$Country==countryname)] ## Population Size
beta<-0.5 ## Infection probability. Needs to be in (0,1)
gamma<-0.05 ##1/gamma is the days it takes for a patient to recover
mu<-2005.23/N ##Death rate
I0<-covid.dr$Confirmed[which(covid.dr$Country==countryname)] ##Current infected
R0<-covid.dr$Recovered[which(covid.dr$Country==countryname)]+covid.dr$Deaths[which(covid.dr$Country==countryname)] ## Current dead or recovered
S0<-N-I0-R0 ## Current susceptible
dt<-1 ##time interval for modelling
lambda<-6326.826/N ##bitrth rate, daily
t<-180 ##days

################### SIR Model ODE System ###################
dS.dt<-function(S,I,beta,N){
  return(-1*beta*S*I/N+(lambda-mu)*S)
}
dI.dt<-function(S,I,beta,N,gamma,mu){
  return((beta*S*I/N)-((gamma+mu)*I))
}
dR.dt<-function(I,R,gamma,mu){
  return(gamma*I-mu*R)
}

################### Euler Method Solution ##################
# Code will be polished to provide a list-like object      #
# Storing the parameters so plotter function can read for  #
# subtitle and axis labels                                 #
############################################################

euler.sir<-function(t,dt,S0,I0,R0,beta,N,gamma,mu){
  tt<-seq(0,t,by=dt)
  a<-data.frame(ti=tt)
  a$Si<-S0
  a$Ii<-I0
  a$Ri<-R0
  a$dS.dt[1]<-dS.dt(S0,I0,beta,N)
  a$dI.dt[1]<-dI.dt(S0,I0,beta,N,gamma,mu)
  a$dR.dt[1]<-dR.dt(I0,R0,gamma,mu)
  for(i in 2:nrow(a)){
    a$Si[i]<-a$Si[i-1]+dt*a$dS.dt[i-1]
    a$Ii[i]<-a$Ii[i-1]+dt*a$dI.dt[i-1]
    a$Ri[i]<-a$Ri[i-1]+dt*a$dR.dt[i-1]
    a$dS.dt[i]<-dS.dt(a$Si[i],a$Ii[i],beta,N)
    a$dI.dt[i]<-dI.dt(a$Si[i],a$Ii[i],beta,N,gamma,mu)
    a$dR.dt[i]<-dR.dt(a$Ii[i],a$Ri[i],gamma,mu)
  }
  return(a)
}

euler.sir.plotter<-function(df){
  df2<-df[,1:4]
  names(df2)<-c("Time","Susceptible","Infected","Recovered")
  m<-melt(df2,id.vars="Time")
  ggplot(m,aes(x=Time,y=value,col=variable))+geom_line()+xlab(paste("Time (in units of ",dt," days)"))+ylab("Number of people")+ggtitle("Simulated pandemic plot",subtitle = paste("Infection probability=",beta,", Recovery rate=",1/gamma,"days , death rate=",mu,", Pop. Size=",N))
}

############# Stochastic Differential Equation #############
# Recovery rates and infection probability have a          #
# stochastic component so that g_t=gdt+sig_gdW             #
# For any coefficient g. W is standard wiener process      #
############################################################

############# Only one Simulation ##########################
euler.sir.stoc<-function(t,dt,S0,I0,R0,beta,sigb,N,gamma,sigg,mu){
  tt<-seq(0,t,by=dt)
  a<-data.frame(ti=tt)
  a$Si<-S0
  a$Ii<-I0
  a$Ri<-R0
  for(i in 2:nrow(a)){
    set.seed(i)
    a$Si[i]<-a$Si[i-1]+dt*((lambda-mu)*a$Si[i-1]-beta*a$Si[i-1]*a$Ii[i-1]/N)+sigb*a$Si[i-1]*a$Ii[i-1]*rnorm(n=1,mean=0,sd=sqrt(dt))/N
    set.seed(i)
    a$Ii[i]<-a$Ii[i-1]+dt*(beta*a$Si[i-1]*a$Ii[i-1]/N-(gamma+mu)*a$Ii[i-1])+(sigb*a$Si[i-1]*a$Ii[i-1]/N+sigg*a$Ii[i-1])*rnorm(n=1,mean=0,sd=sqrt(dt))
    set.seed(i)
    a$Ri[i]<-a$Ri[i-1]+dt*(gamma*a$Ii[i-1]-mu*a$Ri[i-1])+sigg*a$Ii[i-1]*rnorm(n=1,mean=0,sd=sqrt(dt))
  }
  return(a)
}
teststoc<-euler.sir.stoc(180,0.01,S0,I0,R0,beta,0.05,N,gamma,0.05,mu)
euler.sir.plotter(teststoc)
