

plot_bill_frequency_piechart <- function(df, survey_year){
  df_distint_util <- df #%>% distinct(utility_name, bill_frequency)
  
  NoBiMonthly <- nrow(df_distint_util %>% 
                        filter(bill_frequency %in% c("bimonthly", "Bimonthly", "Bi-Monthly") ))
  NoMonthly <- nrow(df_distint_util %>% 
                      filter(bill_frequency %in% c("monthly", "Monthly")))
  NoOtherSchedule <- nrow(df_distint_util) - (NoBiMonthly + NoMonthly)
  
  if(NoOtherSchedule > 0)
  {
    Schedule <- c("Monthly", "Bimonthly", "Other")
    Schedule <- factor(Schedule, levels = Schedule)
    Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly, NoOtherSchedule))
    names(Schedule_DF) <- c("Bill_Frequency", "Value")
  } else {
    Schedule <- c("Monthly", "Bimonthly")
    Schedule <- factor(Schedule, levels = Schedule)
    Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly))
    names(Schedule_DF) <- c("Bill_Frequency", "Value")
  }
  #Schedule_DF$Value <- as.numeric(Schedule_DF$Value)
  
  billFrequencyPie <- ggplot(Schedule_DF, aes(x=2, y=Value, fill= Bill_Frequency)) +
    geom_bar( stat = "identity")+
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Blues") + 
    theme_void() +
    geom_text(aes(y = rev(Value)/2 + c(0, cumsum(rev(Value))[-length(Value)]), 
                  label = paste(rev(Value), "\n(", percent(rev(Value)/nrow(df_distint_util)), ")", sep="") ), 
                  size=4) +
    ggtitle(paste("Counts by Bill Frequency", survey_year) )  + 
    theme(plot.title = element_text(lineheight= .5, face="bold")) + 
    labs(fill = "Bill Frequencies")
  
  billFrequencyPie
}


plot_mean_bill_pie <- function(df){
  filtered <- df %>% #filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  meanBill <- round(mean(filtered$service_charge + filtered$commodity_charge), 2)
  meanService <- round(mean(filtered$service_charge), 2)
  meanCommodity <- round(mean(filtered$commodity_charge), 2)
  meanOther <- round(meanBill - (meanService + meanCommodity), 2)
  
  Mean <- c( "Service Charge", "Commodity Charge")#, "Other Charge")
  Mean <- factor(Mean, levels = Mean)
  Mean_DF <- data.frame(Mean, c(meanService, meanCommodity))#, meanOther))
  names(Mean_DF) <- c("Charge_Structure", "Value")
  
  meanBillPie <- ggplot(Mean_DF, aes(x= 2, y=Value, fill= Charge_Structure)) +
    geom_bar( stat = "identity") + 
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Greens") + 
    theme_void() +
    geom_text(aes(y = rev(Value)/2 + c(0, cumsum(rev(Value))[-length(Value)]), 
                  label = printCurrency(rev(Value) ))) +
    ggtitle("Mean Bill by Parts", subtitle = paste("The total mean bill is ", 
                                                   printCurrency(meanBill), sep = ""))  +
    labs(fill = "Charges") +
    theme(plot.title = element_text(lineheight=.8, face="bold"), plot.subtitle = element_text(lineheight = .8))
  
  meanBillPie
}


plot_rate_type_pie <- function(df, survey_year){
  df_distint_util <- df %>% distinct(utility_name, bill_type)
  
  noTiered <- nrow(df_distint_util %>% filter(bill_type == "Tiered"))
  noBudget <- nrow(df_distint_util %>% filter(bill_type == "Budget"))
  noUniform <- nrow(df_distint_util %>% filter(bill_type == "Uniform"))
  noOtherBillType <- nrow(df_distint_util) - (noTiered + noBudget + noUniform)
  
  if(noOtherBillType > 0)
  {
    Structure <- c( "Budget", "Tiered", "Uniform", "Other")
    Structure <- factor(Structure, levels = Structure)
    Structure_DF <- data.frame(Structure, c(noBudget, noTiered, noUniform, noOtherBillType))
    names(Structure_DF) <- c("Rate_Structure", "Value")
  } else {
    Structure <- c( "3. Uniform", "2. Tiered", "1. Budget")
    Structure <- factor(Structure, levels = Structure)
    Structure_DF <- data.frame(Structure, c(noUniform, noTiered, noBudget))
    names(Structure_DF) <- c("Rate_Structure", "Value")
  }
  
  
  rateStructurePie <- ggplot(Structure_DF, aes(x=2, y=Value, fill= Rate_Structure)) +
    geom_bar( stat = "identity") + 
    coord_polar("y", start=0) + xlim(0.3,2.5)+
    scale_fill_brewer(palette="Purples") + 
    theme_void() +
    geom_text(aes(y = rev(Value)/2 + c(0, cumsum(rev(Value))[-length(Value)]), x = c(1.3, 2, 2 , 2),
                  label = paste(rev(Value), "\n(", percent(rev(Value)/nrow(df_distint_util)), ")", sep="") ),
                  size=4) +
    ggtitle(paste("Counts of Rate Structure Types", survey_year) )  + 
    theme(plot.title = element_text(lineheight=.8, face="bold")) + 
    labs(fill = "Rate Structures")
  
  rateStructurePie
}


plot_usage_histogram <- function(df){
  filtered <- df %>% #filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  p <- ggplot(filtered, aes(x=usage_ccf)) +
    geom_histogram(binwidth=3, colour="white", fill=cadc_blue)+
    labs(x = "Usage Benchmark (CCF)", y = "Count of Districts")+
    ggtitle(paste("Distribution of Usage Benchmarks"))+
    scale_y_continuous(expand = c(0,0))+
    theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
          axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
          title = element_text(size = 15)) +
    geom_vline(xintercept = mean(filtered$usage_ccf), color = cadc_red)
  
  p
}

plot_ratio_histogram <- function(df){
  filtered <- df %>% #filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  ratio_histogram <- ggplot(filtered, aes(x=percentFixed)) +
    geom_histogram(binwidth=.05, colour="white", fill=cadc_blue)+
    labs(x = "Proportion of Total Bill", y = "Count of Districts")+
    ggtitle(paste("Fixed Service Charge as Proportion of Total Bill"))+
    scale_y_continuous(expand = c(0,0))+
    theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
          axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
          title = element_text(size = 15)) +
    geom_vline(xintercept = mean(filtered$percentFixed), color = cadc_red) 
  
  ratio_histogram
}

plot_bill_histogram <- function(df, axis=TRUE, title=TRUE, title_text="Total Bill"){
  filtered <- df %>% #filter(usage_ccf == demo_ccf) %>%
    distinct(utility_name, .keep_all=TRUE)
  
  bill_histogram <- ggplot(filtered, aes(x=bill)) +
    geom_histogram(binwidth=10, 
                   colour="white", fill=cadc_blue) + 
    scale_y_continuous(expand = c(0,0)) +
    geom_vline(xintercept = mean(filtered$bill), color = cadc_red) +
    xlim(0, 305)
  
  if(axis==TRUE){
    bill_histogram <- bill_histogram + 
      labs(x = "Bill Amount ($)", y = "Count of Districts") +
      theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15), 
            axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15),
          title = element_text(size = 15))
  }
  else{
    bill_histogram <- bill_histogram + 
      labs(x = "Bill Amount ($)", y = "Count of Districts") +
      theme(axis.title.x = element_blank(), axis.title.y = element_text(size = 15), 
            axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15),
            title = element_text(size = 15))
  }
  
  if(title==TRUE){
    bill_histogram <- bill_histogram + ggtitle(paste(title_text))
  }

  bill_histogram
}


plot_year_comparisons <- function(df, colname){
  p <- ggplot(df, aes(`Survey Year`, colname)) + 
    geom_col(fill=cadc_blue) +
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), 
          axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  # + scale_fill_manual(values=c(cadc_blue, cadc_red))  
  # geom_text(aes(label=`Mean Service Charge`)) 
  
  p
}


plot_commodity_charges_vs_usage <- function(df, start, end, interval){
  commodity_scatter <- ggplot(df, aes(x=usage_ccf, y=commodity_charge, color=utility_name)) +
    #geom_point(shape=1) +
    geom_line() +
    labs(x = "Usage CCF", y = "Commodity Charge", color = "Utility") +
    ggtitle("Commodity Charge Vs. Usage", subtitle = paste("At every", interval, "CCF from", start, "to", end)) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  commodity_scatter
}

plot_bill_quantiles_vs_usage <- function(df){
  df <- df %>% group_by(usage_ccf) %>%
    summarise(p95=quantile (bill, probs=0.95),
              p75=quantile (bill, probs=0.75),
              p50=quantile (bill, probs=0.50),
              p25=quantile (bill, probs=0.25),
              p05=quantile (bill, probs=0.05)) %>%
    tidyr::gather(key="percentile", value="value", p95, p75, p50, p25, p05)
  
  p <- ggplot(df, aes(x=usage_ccf, y=value, color=percentile)) +
    scale_color_manual(values=c(cadc_red, cadc_yellow, cadc_blue, cadc_yellow, cadc_red)) +
    #geom_point(shape=1) +
    geom_line() +
    labs(x = "Usage CCF", y = "Total Bill ($)", color = "Percentile") +
    ggtitle("Total Bill Percentiles", subtitle = paste("At every", interval, "CCF from", start, "to", end)) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20))
  
  p
}

plot_bills_vs_usage <- function(df, start, end, interval){
  bill_scatter <- ggplot(df_final_bill, aes(x=usage_ccf, y=bill, color=utility_name)) +
    #geom_point(shape=1) +
    geom_line()  +
    labs(x = "Usage (CCF)", y = "Bill", color = "Utility") +
    ggtitle("Total Bill Vs. Usage", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  bill_scatter
}

boxplot_bills_vs_usage <- function(df, start, end, interval){
  df <- df %>% filter(bill < 500)
  
  bill_box <- ggplot(df, aes(x=usage_ccf, y=bill, group=usage_ccf)) +
    geom_boxplot()  +
    labs(x = "Usage (CCF)", y = "Total Bill (Dollars)", color = "Utility") +
    # scale_x_discrete(name = "Usage (CCF)") +
    # scale_y_continuous(name = "Total Bill (Dollars)")+
    ggtitle("Total Bill Vs. Usage", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), 
          axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  bill_box
}

boxplot_bill_by_region <- function(df){
  df <- df %>% filter(is.na(report_hydrologic_region)==FALSE)
  
  medians <- df %>% group_by(report_hydrologic_region) %>% 
    summarise(median_bill=median(bill), counts = n()) %>%
    arrange(median_bill) %>%
    mutate(report_hydrologic_region = factor(report_hydrologic_region, levels = report_hydrologic_region))
  
  df <- df %>% mutate(report_hydrologic_region = factor(report_hydrologic_region, levels = medians$report_hydrologic_region))
  
  
  p1 <- ggplot(df, aes(x=report_hydrologic_region, y=bill, group=report_hydrologic_region)) +
    geom_boxplot(color=cadc_blue)  + coord_flip() + 
    scale_x_discrete(name = "Hydrologic Region") +
    scale_y_continuous(name = "Total Bill (Dollars)", limits = c(0,200)) +
    # ggtitle("Total Bill Vs. Usage", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none") 
  
  
  p2 <- ggplot(medians, aes(report_hydrologic_region, counts)) + 
    geom_col(fill=cadc_lightblue) + geom_text(aes(label=counts)) +coord_flip() +
    scale_y_continuous(name = "# Districts") +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          axis.text.x = element_text(size = 14),
          axis.title = element_text(size = 20))
  
  plot_grid(p1, p2, align = "h", nrow = 1, rel_widths = c(3/4, 1/4))
}


barchart_average_charge_by_region <- function(df){
  
  df <- df %>% group_by(report_hydrologic_region) %>%
    filter(is.na(report_hydrologic_region)==FALSE) %>%
    summarise("Average Service Charge" = mean(service_charge, na.rm = TRUE),
              "Average Variable Charge" = mean(commodity_charge, na.rm = TRUE)) %>% 
    mutate(total_bill = `Average Service Charge` + `Average Variable Charge`) %>%
    arrange(total_bill) %>%
    mutate(report_hydrologic_region = factor(report_hydrologic_region, levels=report_hydrologic_region)) %>%
    tidyr::gather(key="Charge", "mean_amount", "Average Service Charge", "Average Variable Charge")
  
  p <- ggplot(df, aes(x=report_hydrologic_region, y=mean_amount, fill=Charge)) +
    scale_fill_manual(values=c(cadc_red, cadc_blue)) +
    geom_col() + coord_flip() +
    labs(y="Average Charge", x="Hydrologic Region") +
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "bottom")
  
  p
}


plot_avg_price_history <- function(df){
  avg_price_hist <- ggplot(df,
                           aes(x=as.Date(reference_date), y=bill, group=as.Date(reference_date))) +
    geom_boxplot()  +
    scale_x_date(name = "")+
    scale_y_continuous(name = "Total Bill (Dollars)", limits = c(0,200)) +
    ggtitle("Average Price History")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
          legend.position = "none")
  
  avg_price_hist
  
}

plot_efficiency_ts <- function(df){
  
  eff_ts <- ggplot(df, 
                   aes(x=as.Date(report_date), y=pct_above_target, group=report_monthyear)) +
    geom_boxplot()  +
    scale_x_date(name="Date")+
    scale_y_continuous(name = "Efficiency Ratio (Use/Goal)")+
    ggtitle("Efficiency of all Districts", subtitle = "Relative to Their Efficiency Goal")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  
  eff_ts
}

plot_gpcd_ts <- function(df){
  
  gpcd_ts <- ggplot(df, 
                    aes(x=as.Date(report_date), y=report_gpcd_calculated, group=report_monthyear)) +
    geom_boxplot()  +
    scale_x_date(name = "")+
    scale_y_continuous(name = "Residential GPCD (calculated)") +
    ggtitle("Residential GPCD of all Districts")+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  gpcd_ts
}

plot_eff_vs_bill <- function(df){
  
  # df <- df %>% filter(usage_ccf == target_ccf) 
  
  chart_count <- nrow(df %>% filter(!is.na(bill)&!is.na(pct_above_target) ))
  
  eff_vs_bill <- ggplot(df, 
                        aes(x=bill, y=pct_above_target)) +
    geom_point(color=cadc_blue) +
    labs(x = "Total Bill (Dollars)", y = "Efficiency Ratio (Use/Goal)") +
    ggtitle( paste("Efficiency vs Total Bill", subtitle = paste(chart_count,"Districts Total")) )+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")+
    geom_smooth(method='lm', color=cadc_red, size=0.8)
  eff_vs_bill
  
}

plot_eff_vs_pctFixed <- function(df){
  
  chart_count <- nrow(df %>% filter(!is.na(percentFixed)&!is.na(pct_above_target) ))
  
  eff_vs_pctFixed <- ggplot(df, 
                            aes(x=percentFixed, y=pct_above_target)) +
    geom_point(color=cadc_blue) +
    labs(x = "Percentage of Service Charge in Total Bill", y = "Percent above target") +
    ggtitle("Efficiency vs Percent of Fixed Rate", subtitle = paste(chart_count,"Districts Total"))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")+
    geom_smooth(method='lm', color=cadc_red, size=0.8)
  
  eff_vs_pctFixed
}

plot_fixed_costs_percentage_histogram <- function(df){
  p <- ggplot(df, aes(costs_pct_fixed)) + 
    geom_histogram(bins = 10, colour="white", fill=cadc_blue) +
    xlab("Fixed Costs Percentage")+
    ylab("Count of Districts") +
    ggtitle("Distribution of Fixed Costs")+#, subtitle = paste(chart_count,"Districts Total"))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  p
}

plot_fixed_revenue_percentage_histogram <- function(df){
  p <- ggplot(df, aes(rev_pct_fixed)) + 
    geom_histogram(bins = 10, colour="white", fill=cadc_blue) +
    xlab("Fixed Revenue Percentage")+
    ylab("Count of Districts") +
    ggtitle("Distribution of Fixed Revenue")+#, subtitle = paste(chart_count,"Districts Total"))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  p
}

plot_fixed_costs_vs_fixed_rev_scatter <- function(df){
  p <- ggplot(df, aes(x=costs_pct_fixed, y=rev_pct_fixed)) + geom_point(color=cadc_blue) +
    xlab("Fixed Cost Percentage")+
    ylab("Fixed Revenue Percentage") +
    ggtitle("Fixed Revenue vs. Fixed Costs")+#, subtitle = paste(chart_count,"Districts Total"))+
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20),
          legend.position = "none")
  
  p
}


income_bracket_barchart <- function(df){
  tmp <- df %>% group_by(median_category) %>% summarise(counts=length(median_category))
  
  p <- ggplot(tmp, aes(median_category, counts)) + 
    geom_col(fill=cadc_lightblue) + coord_flip() +
    geom_text(aes(label=counts)) + 
    labs(x="Median Income Bracket", y="Count of Districts") +
    theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 20))
  
  p
}

plot_affordability_histogram <- function(df){
  filtered <- df %>%
    distinct(utility_name, .keep_all=TRUE)
  
  p <- ggplot(filtered, aes(x=100*bill_over_income*12)) +
    geom_histogram(binwidth=.8, colour="white", fill=cadc_blue)+
    labs(x = "Percent of Median Monthly Household Income", y = "Count of Districts")+
    ggtitle(paste("July Bill as a Percent of Median Monthly Household Income"))+
    scale_y_continuous(expand = c(0,0))+
    theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
          axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
          title = element_text(size = 15)) +
    geom_vline(xintercept = mean(100*filtered$bill_over_income*12), color = cadc_red) 
  
  p
}


plot_bill_vs_income_scatter <- function(df){
  tmp <- df %>% distinct(report_pwsid, .keep_all = TRUE)
  
  p <- ggplot(tmp, aes(x=income_placeholder, y=bill, color=bill_type)) + 
    scale_colour_manual(values=c(cadc_red, cadc_blue, cadc_yellow)) +
    geom_point() + geom_jitter() +
    geom_abline(intercept = 0, slope = 0.02/12, color='darkgrey') +  # line at 3% of income
    xlim(0, 150000) +
    labs(x="Approximate Median Household Income ($)", y="Total Bill at Average Usage ($)", 
         color="Rate Type", title="Total Bill and Median Annual Household Income",
         subtitle="Grey line indicates 3% of income used for water") 
  
  p
}
