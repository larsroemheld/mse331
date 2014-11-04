library(data.table)
library(ggplot2)
library(scales)
library(ROCR)
library(boot)

rm(list=ls())
gc()

calibration<-function(pred,nbins){
  pred.bins<- round(pred@predictions[[1]]*nbins)/nbins
  bins<-seq(0,99,100/nbins)/100
  y<-c()
  s<-c()
  for (i in bins){
    y[(as.integer(i*nbins)+1)]<-(sum((as.numeric(levels(pred@labels[[1]][pred.bins==i])
                                         [pred@labels[[1]][pred.bins==i]])+1)/2)/
                           length(pred@labels[[1]][pred.bins==i]))
    s[(as.integer(i*nbins)+1)]<-length(pred@labels[[1]][pred.bins==i])
  }
  return (data.table(bins=bins,values = y,size=s))
}

perf.plot<- function(pred1,pred2,pred3,m,x.m="cutoff"){
  perf1 <- performance(pred1, m,x.m) 
  perf2 <- performance(pred2,m,x.m) 
  perf3 <- performance(pred3,m,x.m) 
  
  plot(perf1,col='red')
  plot(perf2, add=TRUE,col='blue')
  plot(perf3,add=TRUE, col='green')
  
  legend(0.1,0.6,c('Words','All','Media'),lty=c(1,1,1),lwd=c(2.5,2.5),col=c("red","blue","green"))
  
  
  
}

setwd("~/Dropbox/Stanford/2014-09 Courses/Computational Social Science MS&E331/Homework/Project 2/project5/seeded data")
test.pred.times<- fread('test_predictions_word.txt',sep=" ",header=FALSE)
test.pred.times.lars<- fread('test_predictions_all.txt',sep=" ",header=FALSE)
test.pred.times.multi<- fread('test_predictions_media.txt',sep=" ",header=FALSE)

train.pred.times<- fread('training_predictions_word.txt',sep=" ",header=FALSE)
train.pred.times.lars<- fread('training_predictions_all.txt',sep=" ",header=FALSE)
train.pred.times.multi<- fread('training_predictions_media.txt',sep=" ",header=FALSE)

names = c('pred','values')

setnames(test.pred.times.lars,new=names,old= names(test.pred.times.lars))
setnames(test.pred.times.multi,new=names,old= names(test.pred.times.multi))
setnames(test.pred.times,new=names,old= names(test.pred.times))

setnames(train.pred.times.lars,new=names,old= names(train.pred.times.lars))
setnames(train.pred.times.multi,new=names,old= names(train.pred.times.multi))
setnames(train.pred.times,new=names,old= names(train.pred.times))

test.pred=prediction(predictions = inv.logit(test.pred.times$pred), 
                labels=test.pred.times$values, label.ordering = NULL)
test.pred.lars=prediction(predictions = inv.logit(test.pred.times.lars$pred), 
                labels=test.pred.times.lars$values, label.ordering = NULL)
test.pred.multi=prediction(predictions = inv.logit(test.pred.times.multi$pred), 
                labels=test.pred.times.multi$values, label.ordering = NULL)

train.pred=prediction(predictions = inv.logit(train.pred.times$pred), 
                     labels=train.pred.times$values, label.ordering = NULL)
train.pred.lars=prediction(predictions = inv.logit(train.pred.times.lars$pred), 
                          labels=train.pred.times.lars$values, label.ordering = NULL)
train.pred.multi=prediction(predictions = inv.logit(train.pred.times.multi$pred), 
                           labels=train.pred.times.multi$values, label.ordering = NULL)

# Performance on Testing Set

perf.plot(test.pred,test.pred.lars,test.pred.multi,"sens","spec")
perf.plot(test.pred,test.pred.lars,test.pred.multi,"prec")
perf.plot(test.pred,test.pred.lars,test.pred.multi,"rec")
perf.plot(test.pred,test.pred.lars,test.pred.multi,"acc")


test.auc <- performance(test.pred, "auc") 
test.auc.lars <- performance(test.pred.lars, "auc") 
test.auc.multi <- performance(test.pred.multi, "auc") 

test.cali<-calibration(test.pred,20)
p <- ggplot(data=test.cali,aes(x=bins,y=values))+geom_point(aes(size=size))+geom_abline()
p <- p + xlab('Estimated Probability') + ylab('Real Frequency')
p
# Performance on Training Set

perf.plot(train.pred,train.pred.lars,train.pred.multi,"sens","spec")
perf.plot(train.pred,train.pred.lars,train.pred.multi,"prec")
perf.plot(train.pred,train.pred.lars,train.pred.multi,"rec")
perf.plot(train.pred,train.pred.lars,train.pred.multi,"acc")


train.auc <- performance(train.pred, "auc") 
train.auc.lars <- performance(train.pred.lars, "auc") 
train.auc.multi <- performance(train.pred.multi, "auc") 

train.cali<-calibration(train.pred,nbins=20)
p <- ggplot(data=train.cali,aes(x=bins,y=values))+geom_point(aes(size=size))+geom_abline()
p <- p + xlab('Estimated Probability') + ylab('Real Frequency')
p

