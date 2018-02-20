

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
  filtered <- df %>% filter(usage_ccf == demo_ccf) %>%
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
    names(Structure_DF) <- c("Rate_Structure", "Value")
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


plot_commodity_charges_vs_usage <- function(df, start, end, interval){
  commodity_scatter <- ggplot(df, aes(x=usage_ccf, y=commodity_charge, color=utility_name)) +
    #geom_point(shape=1) +
    geom_line() +
    labs(x = "Usage CCF", y = "Commodity Charge", color = "Utility") +
    ggtitle("Commodity Charge Vs. Usage CCF", subtitle = paste("At every", interval, "CCF from", start, "to", end)) +
    theme(axis.text = element_text(size = 12), axis.title = element_text(size = 16), title = element_text(size = 20),
          legend.position = "none")
  
  commodity_scatter
}

plot_bills_vs_usage <- function(df, start, end, interval){
  bill_scatter <- ggplot(df_final_bill, aes(x=usage_ccf, y=bill, color=utility_name)) +
    #geom_point(shape=1) +
    geom_line()  +
    labs(x = "Usage CCF", y = "Bill", color = "Utility") +
    ggtitle("Total Bill Vs. Usage CCF", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  bill_scatter
}

boxplot_bills_vs_usage <- function(df, start, end, interval){
  bill_box <- ggplot(df, aes(x=usage_ccf, y=bill, group=usage_ccf)) +
    geom_boxplot()  +
    scale_x_discrete(name = "Usage (CCF)") +
    scale_y_continuous(name = "Total Bill (Dollars)")+
    ggtitle("Total Bill Vs. Usage CCF", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  bill_box
}

plot_ratio_histogram <- function(df, demo_ccf){
  filtered <- df %>% filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  ratio_histogram <- ggplot(filtered, aes(x=percentFixed)) +
    geom_histogram(binwidth=.05, colour="black", fill="white")+
    labs(x = "Proportion of Total Bill", y = "Number of utilities in that range")+
    ggtitle(paste("Ratio of Service Charge to Total Bill at", demo_ccf, "Usage CCF"))+
    scale_y_continuous(expand = c(0,0))+
    theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
          axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
          title = element_text(size = 12)) +
    geom_vline(xintercept = mean(filtered$percentFixed), color = "red")
  
  ratio_histogram
}

plot_bill_histogram <- function(df, demo_ccf){
  filtered <- df %>% filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  bill_histogram <- ggplot(filtered, aes(x=bill)) +
    geom_histogram(binwidth=(max(filtered$bill)- min(filtered$bill))/ round(length(filtered$bill)/6), colour="black", fill="white")+
    labs(x = "Bill Amount ($)", y = "Number of Utilities in that Range")+
    ggtitle(paste("Total Bill at", singleTargetValue, "Usage CCF"))+
    scale_y_continuous(expand = c(0,0))+
    #scale_x_continuous(breaks=seq(round(min(filtered$bill)), round(max(filtered$bill)), round((max(filtered$bill)- min(filtered$bill))/ (length(filtered$bill)/8), 0)))+
    theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
          axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15),
          title = element_text(size = 15)) +
    geom_vline(xintercept = mean(filtered$bill), color = "red")
  
  
  bill_histogram
}

plot_avg_price_history <- function(df){
  avg_price_hist <- ggplot(df,
                           aes(x=as.Date(reference_date), y=bill, group=as.Date(reference_date))) +
    geom_boxplot()  +
    scale_x_date(name = "")+
    scale_y_continuous(name = "Total Bill (Dollars)") +
    ggtitle("Average Price History for 15 CCF")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  avg_price_hist
  
}

plot_efficiency_ts <- function(df){
  
  eff_ts <- ggplot(df, 
                   aes(x=as.Date(report_date), y=pct_above_target, group=report_monthyear)) +
    geom_boxplot()  +
    scale_x_date(name="")+
    scale_y_continuous(name = "Percentage above target")+
    ggtitle("Efficiency Time Series")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  
  eff_ts
}

plot_gpcd_ts <- function(df){
  
  gpcd_ts <- ggplot(df, 
                    aes(x=as.Date(report_date), y=report_gpcd_calculated, group=report_monthyear)) +
    geom_boxplot()  +
    scale_x_date(name = "")+
    scale_y_continuous(name = "Residential GPCD (calculated)") +
    ggtitle("GPCD (calculated) Time Series")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  gpcd_ts
}

plot_eff_vs_bill <- function(df){
  
  eff_vs_bill <- ggplot(df, 
                        aes(x=bill, y=pct_above_target)) +
    geom_point(shape=1) +
    labs(x = "Total Bill (Dollars)", y = "Percentage Above Target") +
    ggtitle("Efficiency vs Total bill")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")+
    geom_smooth(method='lm')
  eff_vs_bill
  
}

plot_eff_vs_pctFixed <- function(df){
  
  eff_vs_pctFixed <- ggplot(df, 
                            aes(x=percentFixed, y=pct_above_target)) +
    geom_point(shape=1) +
    labs(x = "Percentage of Service Charge in Total Bill", y = "Percent above target") +
    ggtitle("Efficiency vs Percent of Fixed Rate")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")+
    geom_smooth(method='lm')
  
  eff_vs_pctFixed
}
