---
title: "California Water Rate Survey Results 2017"
output:
  html_document:
    keep_md: true
---



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



![Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.](owrs_analysis_files/figure-html/bill_frequency_pie-1.png)

![Figure  2: Average bill by parts for all agencies, considering a consumption of 10 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%).](owrs_analysis_files/figure-html/mean_bill_by_parts_pie-1.png)



![](owrs_analysis_files/figure-html/rate_structure_type_pie-1.png)<!-- -->

![](owrs_analysis_files/figure-html/commodity_charge_vs_usage_line-1.png)<!-- -->



![](owrs_analysis_files/figure-html/commodity_charge_vs_usage_boxplot-1.png)<!-- -->




![](owrs_analysis_files/figure-html/service_charge_ratio_histogram-1.png)<!-- -->

![](owrs_analysis_files/figure-html/total_bill_histogram-1.png)<!-- -->

# Rates x Efficiency
## Define Period of Analysis
Average water rates history:



## Calculate Efficiency
Load suppliers report info and join with the Utilities list from the OWRS files



![](owrs_analysis_files/figure-html/efficiency_goal_time_series_boxplot-1.png)<!-- -->

![](owrs_analysis_files/figure-html/gpcd_time_series_boxplot-1.png)<!-- -->
## Compare Rates and efficiency


Scatter plot of Efficiency (pct_above_target) vs Rates (Total Bill for 15 CCF)
![](owrs_analysis_files/figure-html/efficiency_goal_vs_total_bill_scatter_trend-1.png)<!-- -->



## Joining Data from the Qualitative Survey

```
## Warning: NAs introduced by coercion

## Warning: NAs introduced by coercion
```

Scatter plot of Efficiency vs Rates Structure (% Fixed  - for 15 CCF)
![](owrs_analysis_files/figure-html/efficiency_goal_vs_percent_fixed_scatter_trend-1.png)<!-- -->

![](owrs_analysis_files/figure-html/fixed_cost_percentage_histogram-1.png)<!-- -->



![](owrs_analysis_files/figure-html/fixed_revenue_percentage_histogram-1.png)<!-- -->

![](owrs_analysis_files/figure-html/fixed_costs_vs_fixed_rev_scatter-1.png)<!-- -->


