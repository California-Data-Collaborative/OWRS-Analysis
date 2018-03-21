

# #generating csv with rates for merge with demographics
# 
# #getting rid of the more recent years
# df_final_bill$effective_date <- as.Date(df_final_bill$effective_date)        #convert effective_date to Date
# df_final_bill <- df_final_bill[year(df_final_bill$effective_date) < 2018,]   # drop years >= 2018
# 
# #getting rid of duplicates
# #making sure to keep the most recent values
# df_final_bill <- df_final_bill[rev(order(df_final_bill$utility_name, df_final_bill$effective_date)),]
# #drop duplicates
# df_final_bill <- df_final_bill[ !duplicated(df_final_bill$utility_name), ]
# df_final_bill <- df_final_bill[order(df_final_bill$utility_name),] #reorder alphabetically
# 
# #adding pwsid
# supplier_pwsid <- read.csv('data/utilities_for_OWRS.csv', stringsAsFactors=FALSE)
# df_final_bill$fuzzy_match <- as.character(sapply(df_final_bill$utility_name, GetCloseMatches,
#                               sequence_strings = supplier_pwsid$Agency_Name, n=1L, cutoff = 0.85))
# df_final_bill <- merge(df_final_bill, supplier_pwsid, by.x = "fuzzy_match", by.y = "Agency_Name", all.x=TRUE, all.y=FALSE)
# 
# #write csv with the df_final_bill data frame
# df_final_bill$utility_id <- as.character(df_final_bill$utility_id)
# write.csv(df_final_bill, "data/bill_15ccf_residential.csv")



#library(rgdal)

#shape <- readOGR(dsn = "../Shapefiles", layer = "service_areas_cadc_with_utility_id")
#shape <- merge(shape, df_final_bill, by = "utility_id")

#setwd("../../Dropbox/CSV/")
#Output The Final Bill information to a  shapefile
#writeOGR(shape, ".", "service_areas_cadc_with_billing_info", driver="ESRI Shapefile", overwrite_layer = TRUE)
#End
#zipDemFiles <- list.files(recursive = TRUE)
#setwd("../")
#zip(zipfile = "../Dropbox/CSV/shapefileZip", files = paste("TempShapeFiles", zipDemFiles, sep = "/"))

#setwd("../../Documents/WaterRateTester/")