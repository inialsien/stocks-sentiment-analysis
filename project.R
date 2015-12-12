library(ggplot2)

data_twitter = read.csv2("./csv/csv_google_1.csv", header=TRUE, sep=",", dec=".")
data_stock = read.csv2("./google_stock.csv", header=TRUE, sep=",", dec=".")

data_twitter$Pos_norm <- data_twitter$Pos / data_twitter$Number
data_twitter$Neg_norm <- data_twitter$Neg / data_twitter$Number
data_twitter$Date <- as.Date(data_twitter$Date)
data_twitter = data_twitter[-6,]
data_twitter = data_twitter[-6,]

data_stock$Date <- as.Date(data_stock$Date)
data_stock$Diff <- data_stock$Close - data_stock$Open
data_stock = data_stock[-1,]

data_stock$Date
data_twitter$Date

summary(data_twitter)
summary(data_stock)

diff <- rev(data_stock$Diff)

fit <- lm(diff ~ data_twitter$Pos_norm + data_twitter$Neg_norm)
summary(fit)


plot(c(diff, data_twitter$Pos_norm, data_twitter$Neg_norm), y = NULL)
ggplot(diff,aes(x,y))+geom_line(aes(color="First line"))+geom_line(data=data_twitter$Pos_norm,aes(color="Second line"))
