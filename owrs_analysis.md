# California Water Rate Survey Results 2017



# Introduction

The [California Data Collaborative ("CaDC")](http://californiadatacollaborative.org/) is a coalition of water utilities that have pioneered a new data infrastructure non-profit 501 (c) (3) to support water managers in meeting their reliability objectives and serve the public good.

One important contribution of the CaDC was to establish a standard format and to provide the infrastructure for storage and maintainance of an open database for water rates, facilitating the work of analysts, economists and software developers interested in analyzing and understanding the differences in water rate structures and prices across many different agencies and locations. The water rate structures were organized in [Open-Water-Rate-Specification (OWRS)](https://github.com/California-Data-Collaborative/Open-Water-Rate-Specification) files, a format based on [YAML](http://yaml.org/), which is designed to be easy to store, transmit, and parse in any programming language while also being easy for humans to read.

This report presents a summary of the types of analyses and insights that can be obtained from analyzing the OWRS, especially when this information is combined with the water consumption data from water agencies and Census Data.

# Data

This report provides the combined analysis of data from 4 different sources:

* Water Rates from the [Open-Water-Rates-Specification](https://github.com/California-Data-Collaborative/Open-Water-Rate-Specification).
* Water Consumption data reported by the water agencies [ADD MORE DETAIL] 
* Demographic Data from the American Community Survey [??]
* Qualitative Data from a Survey realized by the California Data Collaborative with water agencies in 2017. 








# Summary Statistics

This section discusses general characteristics of the rates for utilities analyzed in this survey.



![Figure  1: Bill Frequency Pie Chart.](owrs_analysis_files/figure-html/bill_frequency_pie-1.png)


![Figure  2: Average bill by parts for all agencies, considering a consumption of 15 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%).](owrs_analysis_files/figure-html/mean_bill_pie-1.png)



![Figure  3: Types of rate structures.](owrs_analysis_files/figure-html/rate_type_pie-1.png)

![Figure  4: Commodity Charge vs Usage.](owrs_analysis_files/figure-html/commodity_charge_vs_usage-1.png)

![Figure  5: Total Bill vs Usage.](owrs_analysis_files/figure-html/total_bill_vs_usage-1.png)

![Figure  6: Boxplot of Total Bill vs Usage.](owrs_analysis_files/figure-html/total_bill_vs_usage_box-1.png)




![Figure  7: Ratio of Service charge to total bill at 15 CCF.](owrs_analysis_files/figure-html/ratio_histogram-1.png)

![Figure  8: Total bill at 15 CCF.](owrs_analysis_files/figure-html/bill_histogram-1.png)

# Rates x Efficiency

This section provides an analysis of the relationships between the rates charged by each water agency and the efficiency in water use in the areas served by those agencies.


The period considered for the analysis is 1/2017 to 12/2017.


## Rates in the period

Average water rates history:
![Figure  9: Average price charged for 15 CCF across all agencies included in the survey.](owrs_analysis_files/figure-html/avg_price_history-1.png)


## Efficiency in the period
Load suppliers report info and join with the Utilities list from the OWRS files




![Figure  10: Efficiency measured as percentage above target.](owrs_analysis_files/figure-html/efficiency_ts-1.png)


## Comparing Rates and Efficiency



![Figure  11: Efficiency vs Total Bill.](owrs_analysis_files/figure-html/eff_vs_total_bill-1.png)


![Figure  12: Efficiency vs Percentage of Service Charge in Total Bill.](owrs_analysis_files/figure-html/eff_vs_pctFixed-1.png)

## Operational Costs and Revenue in the Water Agencies



![Figure  13: Percentage of costs that are fixed for an Agency.](owrs_analysis_files/figure-html/pct_fixed_costs-1.png)



![Figure  14: Percentage of an Agency's revenues that are fixed.](owrs_analysis_files/figure-html/pct_fixed_rev-1.png)

![Figure  15: Ratio of Percentage of Fixed Revenue per Percentage of Fixed Costs.](owrs_analysis_files/figure-html/fixedRev_per_fixedCosts-1.png)

