library(ggplot2)
library(vars)
library(forecast)


data_twitter = read.csv2("./csv/csv-google-2-copy.csv", header=TRUE, sep=",", dec=".")
data_stock = read.csv2("./stocks/google-stock-26-10.csv", header=TRUE, sep=",", dec=".")

data_twitter$NormPos <- data_twitter$Pos / data_twitter$Num
data_twitter$NormNeg <- data_twitter$Neg / data_twitter$Num
data_twitter$Date <- as.Date(data_twitter$Date)

data_stock$Date <- as.Date(data_stock$Date)
data_stock$Diff <- data_stock$Close - data_stock$Open

summary(data_twitter$NormPos)
summary(data_twitter$NormNeg)
summary(data_stock$Diff)
var(data_twitter$NormPos)
var(data_twitter$NormNeg)
var(data_stock$Diff)

plot(data_twitter$Date, data_twitter$NormPos, type='l', col="black", main="Positive Sentiment Evolution",
     xlab="working days", ylab="+ sentiments scores")
abline(h=mean(data_twitter$NormPos))

plot(data_twitter$Date, data_twitter$NormNeg, type='l', col="black", main="Negative Sentiment Evolution",
     xlab="working days", ylab="- sentiments scores")
abline(h=mean(data_twitter$NormNeg))

plot(data_stock$Date, data_stock$Diff, type='l', col="black", main="Daily GOOG Stock Evolution",
     xlab="working days", ylab="difference ($)")
abline(h=0)

pairs(~data_stock$Diff + data_twitter$NormPos + data_twitter$NormNeg)

h<-0
plot(data_stock$NormPos[1:(length(data_stock$NormPos)-h)], data_twitter$Diff[-(1:h)])

fit <- lm(data_stock$Diff ~ data_twitter$NormPos + data_twitter$NormNeg + data_twitter$Num)
summary(fit)
AIC(fit)

fit <- lm(data_stock$Diff ~ data_twitter$NormPos + data_twitter$NormNeg)
summary(fit)
AIC(fit)

df <- data.frame(Diff = data_stock$Diff,Pos = data_twitter$NormPos, Neg = data_twitter$NormNeg)

lin <- lm(Diff ~ . , df)
summary(lin)
lin2 <- step(lin, trace = 0)
summary(lin2)


df2 <- data.frame(Diff = data_stock$Diff,Pos = data_twitter$NormPos)
VARselect(df2, lag.max=2)
var.2c <- VAR(df2, p=2)
plot(var.2c)
summary(var)

acf(residuals(var)[,1])
