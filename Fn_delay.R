# Data <- read.csv()
# Line <- 10
# day <- "Monday"
Final <- function(Data, Line, day){
  DF <- subset(Data, Data$linie == Line)
  DF$date_from <- as.Date(DF$datum_von, format = "%d.%m.%y")
  DF$arrival_delay <- (DF$soll_an_von - DF$ist_an_von)
  DF$Time <- floor(DF$soll_an_von/3600)
  DF$Day <- weekdays(DF$date_from)
  Summary <- aggregate(arrival_delay ~ Time + Day, data = DF, mean)
  Summary$State <- ifelse(Summary$arrival_delay <= 0, "Late", "Early")
  Summary$colour <- ifelse(Summary$arrival_delay <= 0, "firebrick1", "steelblue")
  ggplot(Summary[Summary$Day == day,], aes(Time, arrival_delay, label = "")) +
    geom_text(aes(y = 0)) +
    geom_bar(stat = "identity", position = "identity", aes(fill = State)) +
    labs(x = "Time of the day", y = "Arrival to stop(sec)", title = paste0(day)) +
    scale_fill_manual(values=c("steelblue","firebrick1"))
}