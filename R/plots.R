

plot_bill_frequency_piechart <- function(df){
  df_distint_util <- df %>% distinct(utility_name, bill_frequency)
  
  NoBiMonthly <- nrow(df_distint_util %>% 
                        filter(bill_frequency %in% c("bimonthly", "Bimonthly", "Bi-Monthly") ))
  NoMonthly <- nrow(df_distint_util %>% distinct(utility_name, bill_frequency) %>% 
                      filter(bill_frequency %in% c("monthly", "Monthly")))
  NoOtherSchedule <- nrow(df_distint_util %>% distinct(utility_name, bill_frequency)) - (NoBiMonthly + NoMonthly)
  
  if(NoOtherSchedule > 0)
  {
    Schedule <- c("Monthly", "Bimonthly", "Other")
    Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly, NoOtherSchedule))
    names(Schedule_DF) <- c("Bill_Frequency", "Value")
  } else {
    Schedule <- c("Monthly", "Bimonthly")
    Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly))
    names(Schedule_DF) <- c("Bill_Frequency", "Value")
  }
  #Schedule_DF$Value <- as.numeric(Schedule_DF$Value)
  
  billFrequencyPie <- ggplot(Schedule_DF, aes(x=2, y=Value, fill= Bill_Frequency)) +
    geom_bar( stat = "identity")+
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Blues") + 
    theme_void() +
    geom_text(aes(y = Value/2 + c(0, cumsum(Value)[-length(Value)]), 
                  label = paste(Value, "\n(", percent(Value/nrow(df_distint_util)), ")", sep="") ), 
                  size=4) +
    ggtitle("Analysis of Bill Frequency")  + 
    theme(plot.title = element_text(lineheight= .5, face="bold")) + 
    labs(fill = "Bill Frequencies")
  
  billFrequencyPie
}


plot_mean_bill_pie <- function(df, demo_ccf){
  filtered <- df %>% filter( (bill_frequency %in% c("monthly", "Monthly") & usage_ccf == demo_ccf) | 
                               (bill_frequency %in% c("bimonthly", "Bimonthly", "Bi-Monthly") & usage_ccf == 2*demo_ccf) | 
                               (bill_frequency %in% c("Quarterly") & usage_ccf == 3*demo_ccf)) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  meanBill <- round(mean(filtered$bill), 2)
  meanService <- round(mean(filtered$service_charge), 2)
  meanCommodity <- round(mean(filtered$commodity_charge), 2)
  meanOther <- round(meanBill - (meanService + meanCommodity), 2)
  
  Mean <- c( "3. Service Charge", "2. Commodity Charge", "1. Other Charge")
  Mean_DF <- data.frame(Mean, c(meanService, meanCommodity, meanOther))
  names(Mean_DF) <- c("Charge_Structure", "Value")
  
  meanBillPie <- ggplot(Mean_DF, aes(x= 2, y=Value, fill= Charge_Structure)) +
    geom_bar( stat = "identity") + 
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Greens") + 
    theme_void() +
    geom_text(aes(y = Value/2 + c(0, cumsum(Value)[-length(Value)]), 
                  label = printCurrency(Value))) +
    ggtitle("Mean Bill by Parts", subtitle = paste("The total mean bill for ", 
                                                   demo_ccf, " usage ccf is ", 
                                                   printCurrency(meanBill), "0", sep = ""))  +
    labs(fill = "Charges") +
    theme(plot.title = element_text(lineheight=.8, face="bold"), plot.subtitle = element_text(lineheight = .8))
  
  meanBillPie
}


plot_rate_type_pie <- function(df){
  df_distint_util <- df %>% distinct(utility_name, bill_type)
  
  noTiered <- nrow(df_distint_util %>% filter(bill_type == "Tiered"))
  noBudget <- nrow(df_distint_util %>% filter(bill_type == "Budget"))
  noUniform <- nrow(df_distint_util %>% filter(bill_type == "Uniform"))
  noOtherBillType <- nrow(df_distint_util) - (noTiered + noBudget + noUniform)
  
  if(noOtherBillType > 0)
  {
    Structure <- c( "Budget", "Tiered", "Uniform", "Other")
    Structure_DF <- data.frame(Structure, c(noBudget, noTiered, noUniform, noOtherBillType))
    names(Schedule_DF) <- c("Rate_Structure", "Value")
  } else {
    Structure <- c( "3. Uniform", "2. Tiered", "1. Budget")
    Structure_DF <- data.frame(Structure, c(noUniform, noTiered, noBudget))
    names(Structure_DF) <- c("Rate_Structure", "Value")
  }
  
  
  rateStructurePie <-ggplot(Structure_DF, aes(x=2, y=Value, fill= Rate_Structure)) +
    geom_bar( stat = "identity") + 
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Purples") + 
    theme_void() +
    geom_text(aes(y = Value/2 + c(0, cumsum(Value)[-length(Value)]), 
                  label = paste(Value, "\n(", percent(Value/nrow(df_distint_util)), ")", sep="") ), 
                  size=4) +
    ggtitle("Analysis of Rate Structure")  + 
    theme(plot.title = element_text(lineheight=.8, face="bold")) + 
    labs(fill = "Rate Structures")
  
  rateStructurePie
}





