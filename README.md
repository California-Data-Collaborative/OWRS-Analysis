# Open Water Rate Analysis
Analysis of water rates collected in the OWRS format through the 2017 CaDC / Cal-Nevada water rate survey.

### [See the analysis](owrs_analysis.md) 

## [Get the Data](summary_table.csv)

The summary data provides streamlined access to water rate data in CSV format. The summary table is derived from the [OWRS data]() maintained by the CaDC combined with publicly available data sources from the California SWRCB, DWR and the United States Census.

The fields in the data are as follows:

| Field Name  | Definition |
| ------------- | --------------------------------------------------------------- |
| utility_name            | Name of the water supplier  |
| pwsid                   | Public Water System ID  |
| effective_date          | Date the rate structure came into effect  |
| bill_frequency          | Billing frequency  |
| bill_unit               | Unit of measure for which customers are billed  |
| usage_ccf               | Amount of water use used for calculating the customer bill. Where possible this value adjusts to local water use context and is derived from the GPCD provided in the SWRCB reporting. When this is not possible a default of 15 CCF is used. This value is given in CCF but usage is converted to the `bill_unit` specified above before the bill is calculated  |
| avg_household_size      | Average household size within the agency as derived from the American Community Survey 2016 5-Year  |
| et_amount               | Monthly evapotranspiration in July 2017 derived as a weighted average of CIMIS station readings near to the agency  |
| bill_type               | Type of commodity billing used, e.g. Uniform, Tiered (inclining tiers) or Budget (inclining tiers with tier width based on a household water budget)  |
| service_charge          | Fixed service charge, in dollars. Where the charge is based on meter size a size of 3/4" is assumed  |
| commodity_charge        | Variable commodity charge for water consumption, in dollars  |
| bill                    | Total bill charged to a customer under the assumptions used in the analysis (usage, meter size, household size, etc). In some cases the bill may not equal a sum of the service and commodity charges. This would be the case when other charges are present (e.g. pressure/elevation charge, readiness-to-serve charge, etc)  |
| tier_starts             | The unit (defined above) where each tier starts. For example if `tier_starts = 0 5 10` then the rate structure has 3 tiers, the first applies to units 0-4 the second rate applies to units 5-9, and the third rate applies to units 10+ |
| tier_prices             | Prices charged to each tier as detailed above.  |
| median_income_category         | The ACS income category in which the median household in the district resides  |
| approximate_median_income      | Approximate median income calculated as the mid-point of the `median_income_category`  |
