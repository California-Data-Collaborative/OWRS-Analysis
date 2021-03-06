---
title: "California Water Rate Survey Results 2017"
output:
  html_document:
    keep_md: yes
  pdf_document: default
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



Load suppliers report info and join with the Utilities list from the OWRS files












<img src="img/service_charge_15_vs_17.png" width="600px" />

<img src="img/commodity_charge_15_vs_17.png" width="600px" />


<img src="img/total_bill_15_vs_17.png" width="600px" />




# Analysis Using Customized Usage Benchmarks from Supplier Report





## Summary Statistics

This section discusses general characteristics of the rates for utilities analyzed in this survey.

<div class="figure">
<img src="img/bill_frequency_pie.png" alt="Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system." width="600px" />
<p class="caption">Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.</p>
</div>

<div class="figure">
<img src="img/bill_frequency_pie_2015.png" alt="Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system." width="600px" />
<p class="caption">Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.</p>
</div>

<div class="figure">
<img src="img/bill_frequency_pie_2013.png" alt="Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system." width="600px" />
<p class="caption">Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.</p>
</div>


<div class="figure">
<img src="img/mean_bill_by_parts_pie.png" alt="Figure  2: Average bill by parts for all agencies, considering a consumption of 10 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%)." width="600px" />
<p class="caption">Figure  2: Average bill by parts for all agencies, considering a consumption of 10 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%).</p>
</div>


<img src="img/rate_structure_type_pie.png" width="600px" />


<div class="figure">
<img src="img/rate_structure_type_pie_2015.png" alt="Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system." width="600px" />
<p class="caption">Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.</p>
</div>

<div class="figure">
<img src="img/rate_structure_type_pie_2013.png" alt="Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system." width="600px" />
<p class="caption">Figure  1: Bill Frequency Pie Chart. About three quarters of the water agencies use a monthly billing system.</p>
</div>


<img src="img/usage_histogram.png" width="600px" />


<img src="img/service_charge_ratio_histogram.png" width="600px" />

<img src="img/total_bill_histogram.png" width="600px" />

## Variation in Bills at Different Use Levels

<img src="img/bill_quantiles_vs_usage.png" width="600px" />


<img src="img/commodity_charge_vs_usage_boxplot.png" width="600px" />


## Interaction between Rates and Efficiency

<img src="img/efficiency_goal_time_series_boxplot.png" width="600px" />


<img src="img/gpcd_time_series_boxplot.png" width="600px" />


<img src="img/boxplot_bill_by_region.png" width="600px" />


<img src="img/average_bill_part_by_region.png" width="600px" />


<img src="img/efficiency_goal_vs_total_bill_scatter_trend.png" width="600px" />

## Joining Data from the Qualitative Survey

<img src="img/efficiency_goal_vs_percent_fixed_scatter_trend.png" width="600px" />

<img src="img/fixed_cost_percentage_histogram.png" width="600px" />


<img src="img/fixed_revenue_percentage_histogram.png" width="600px" />


<img src="img/fixed_costs_vs_fixed_rev_scatter.png" width="600px" />

## Affordability

<img src="img/income_bracket_barchart.png" width="600px" />


<img src="img/affordability_histogram.png" width="600px" />


<img src="img/bill_vs_income_scatter.png" width="600px" />




# Analysis Using 15 CCF Usage Benchmark for comparison with previous years





## Summary Statistics

This section discusses general characteristics of the rates for utilities analyzed in this survey.


<div class="figure">
<img src="img/15ccf/mean_bill_by_parts_pie_15.png" alt="Figure  2: Average bill by parts for all agencies, considering a consumption of 10 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%)." width="600px" />
<p class="caption">Figure  2: Average bill by parts for all agencies, considering a consumption of 10 CCF in a month. The average total bill is $60.68. With an average service charge (fixed) of $24.63 (40.6%) and an average commodity charge (variable) of $35.61 (58.7%).</p>
</div>


<img src="img/15ccf/service_charge_ratio_histogram_15.png" width="600px" />

<img src="img/comparisons/total_bill_histograms.png" width="600px" height="800px" />


## Interaction between Rates and Efficiency

<img src="img/15ccf/efficiency_goal_time_series_boxplot_15.png" width="600px" />


<img src="img/15ccf/gpcd_time_series_boxplot_15.png" width="600px" />


<img src="img/15ccf/boxplot_bill_by_region_15.png" width="600px" />


<img src="img/15ccf/average_bill_part_by_region_15.png" width="600px" />


<img src="img/15ccf/efficiency_goal_vs_total_bill_scatter_trend_15.png" width="600px" />

## Joining Data from the Qualitative Survey

<img src="img/15ccf/efficiency_goal_vs_percent_fixed_scatter_trend_15.png" width="600px" />


## Affordability

<img src="img/15ccf/affordability_histogram_15.png" width="600px" />


<img src="img/15ccf/bill_vs_income_scatter_15.png" width="600px" />




