library(data.table)
library(ggplot2)
library(scales)
library(ROCR)
library(boot)

rm(list=ls())
gc()
setwd("~/Dropbox/Stanford/2014-09 Courses/Computational Social Science MS&E331/Homework/Project 2/project5")
pred.times<- fread('test_predictions_lars.txt',sep=" ",header=FALSE)
pred.times.lars<- fread('test_predictions_lars.txt',sep=" ",header=FALSE)
pred.times.multi<- fread('test_predictions_multi.txt',sep=" ",header=FALSE)


names = c('pred','values')

setnames(pred.times.lars,new=names,old= names(pred.times))
setnames(pred.times.multi,new=names,old= names(pred.times))
setnames(pred.times,new=names,old= names(pred.times))

pred=prediction(predictions = inv.logit(pred.times$pred), 
                labels=pred.times$values, label.ordering = NULL)
pred.lars=prediction(predictions = inv.logit(pred.times.lars$pred), 
                labels=pred.times.lars$values, label.ordering = NULL)
pred.multi=prediction(predictions = inv.logit(pred.times.multi$pred), 
                labels=pred.times.multi$values, label.ordering = NULL)


perf <- performance(pred, "sens", "spec") 
perf.lars <- performance(pred.lars, "sens", "spec") 
perf.multi <- performance(pred.multi, "sens", "spec") 

auc <- performance(pred, "auc") 
auc.lars <- performance(pred.lars, "auc") 
auc.multi <- performance(pred.multi, "auc") 

plot(perf)
plot(perf.lars)
plot(perf.multi)

plot(perf,col='red')
plot(perf.multi, add=TRUE,col='blue')


