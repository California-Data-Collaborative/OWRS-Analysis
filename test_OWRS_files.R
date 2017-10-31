library(dplyr)
library(ggplot2)
library(scales)
library(raster)
library(rgdal)
library(RateParser)
library(yaml)
library(purrr)

source("R/utils.R")
source("R/plots.R")



#The usage_ccf to evaluate for the histograms and bar chart
singleTargetValue <- 15;


#Declare the customer classes to be tested for each utility
customer_classes <- c("RESIDENTIAL_SINGLE"
                      #"RESIDENTIAL_MULTI",
                      #"COMMERCIAL"
)
#End

#import sample data and give the data parameters used in the owrs files that are not in the original data
df_smc <- santamonica
names(df_smc) <- c( "cust_id", "usage_ccf", "usage_month", "usage_year",  "cust_class", "usage_date", "cust_class_from-utility")

df_sample <- tbl_df(df_smc) %>%
  mutate(hhsize = 4, meter_size = '3/4"', usage_zone = 1, landscape_area = 2000,
         et_amount = 2.0, wrap_customer = "No", irr_area = 2000, carw_customer = "No",
         season = "Winter", tax_exemption = "granted", lot_size_group = 3,
         temperature_zone = "Medium", pressure_zone = 1, water_font = "city_delivered",
         area = "inside_city", water_type = "potable", rate_class = "C1",
         dwelling_units = 10, elevation_zone = 2, greater_than = "False",
         usage_indoor_budget_ccf = .3, meter_type = "compound", block = 1,
         tariff_area = 1, turbine_meter = "No", senior = "no") %>%
  group_by(cust_class)

df_adjustable_sample <- tbl_df(data.frame (usage_month = 7, days_in_period = 30,
                                           hhsize = 4, meter_size = '3/4"', usage_zone = 1, landscape_area = 2000,
                                           et_amount = 7.0, wrap_customer = "No", irr_area = 2000, carw_customer = "No",
                                           season = "Winter", tax_exemption = "granted", lot_size_group = 3,
                                           temperature_zone = "Medium", pressure_zone = 1, water_font = "city_delivered",
                                           city_limits = "inside_city", water_type = "potable", rate_class = "C1",
                                           dwelling_units = 10, elevation_zone = 2, greater_than = "False",
                                           usage_indoor_budget_ccf = .3, meter_type = "Turbine", block = 1,
                                           tariff_area = 1, turbine_meter = "No", senior = "no", cust_class = customer_classes[1]))

#change for The scatter plots (If start = end the process will be a lot faster if only concerned with histograms and bar/pie charts)
start <- 0;
end <- 10;
interval <- 5;
df_usage <- as.data.frame(list("usage_ccf"=1:10, "cust_class"="RESIDENTIAL_SINGLE"))
df_sample <-  left_join(df_usage, df_adjustable_sample, by="cust_class")



#Retrieve the directories and files in the directores from the Open-Water-Specification-File directory
owrs_path <- "../Open-Water-Rate-Specification/full_utility_rates/California";

#TODO insert the filename gathering functioon here
df_OWRS <- tbl_df(as.data.frame(list("filepath"=getFileNames(owrs_path)), stringsAsFactors=FALSE)) %>% 
  
  mutate(owrs_directory = map(filepath, strsplit, split="/") %>% map(c(1,1))) %>%
  
  mutate(filename = map(filepath, strsplit, split="/") %>% map(c(1,2))) %>%
  
  mutate(utility_id = map(owrs_directory, strsplit, split=" ") %>%  
                      map(1) %>%map(tail, n=1) %>%
                      map(gsub, pattern="\\D", replacement="") %>%
                      map(as.numeric)) %>%
  
  mutate(effective_date = sapply(filename, extract_date) ) %>% 
  mutate(utility_name = sapply(as.character(owrs_directory), extract_utility_name) )



#Declare Null Data Set
df_NA <- data.frame(
  usage_ccf = NA,
  #usage_month = NA,
  #usage_year = NA,
  cust_class = NA,
  #usage_date = NA,
  service_charge = NA,
  commodity_charge = NA,
  percentFixed = NA,
  bill = NA
)
#End

#Run through all the OWRS files and test if they are Readable and add the information to the data frame

for(i in 1:nrow(df_OWRS))
{
  if(i==1){
    df_bill <- NULL
  }
  print(i)
  #Open OWRS file and retrieve important data
  owrs_file <- tryCatch({
    #Open OWRS file
    getFileData(owrs_path, df_OWRS[i,]$filepath)
  },
  error = function(cond){
    #Display Error Message for specific files
    message(paste("Format error in file:", df_OWRS[i,]$filepath, "\n", cond, "\n"))
    return(NULL)
  })
  
  
  #If there is an error format the row data accordingly
  if(!is.null(owrs_file))
  {
    for(j in 1:length(customer_classes))
    {
      current_class <- customer_classes[j]
  
      df_temp <- tryCatch({
        singleUtilitySim(df_sample, df_OWRS, owrs_file, current_class)
      },
      error = function(cond){
        #Display Error Message for specific files
        message(paste("Format error in file:", df_OWRS[i,]$filepath, "\n", cond, "\n"))
        return(NULL)
      }) 

      if(is.null(df_bill)){
        df_bill <- df_temp
      }else{
        df_bill <- bind_rows(df_bill, df_temp)
      }
    }
  }else{
    # utility <- data.frame(utility_id = df_OWRS[i,]$utility_id, 
    #                       utility_name = df_OWRS[i,]$filename, 
    #                       bill_frequency = "NA")
    # df_temp <- data.frame(utility, df_NA)
    # df_bill <- rbind(df_bill, df_temp)
  }
}
#End


#Format the Bill Information so that only valid data entries are presented, the decimal points are rounded, and the data is arranged by utility
df_final_bill <- tbl_df(df_bill) %>% filter(!is.na(bill))
df_final_bill$bill <- round(as.numeric(df_final_bill$bill), 2)
df_final_bill$commodity_charge <- round(as.numeric(df_final_bill$commodity_charge), 2)
df_final_bill$service_charge <- round(df_final_bill$service_charge, 2)
df_final_bill$utility_name <- as.character(df_final_bill$utility_name)
df_final_bill$bill_frequency <- as.character(df_final_bill$bill_frequency)
df_final_bill <- df_final_bill %>% arrange(utility_name)
#End

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


billFrequencyPie <- plot_bill_frequency_piechart(df_final_bill)

meanBillPie <- plot_mean_bill_pie(df_final_bill,10)

rateTypePie <- plot_rate_type_pie(df_final_bill)


meanpercentFixed <- round(mean(as.numeric(df_final_bill$percentFixed[df_final_bill$usage_ccf == singleTargetValue])), 3)

commodity_scatter <- ggplot(df_final_bill, aes(x=usage_ccf, y=commodity_charge, color=utility_name)) +
                            #geom_point(shape=1) +
                            geom_line() +
                            labs(x = "Usage CCF", y = "Commodity Charge", color = "Utility") +
                            ggtitle("Commodity Charge Vs. Usage CCF", subtitle = paste("At every", interval, "CCF from", start, "to", end)) +
                            theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
                                  legend.position = "none")

bill_scatter <- ggplot(df_final_bill, aes(x=usage_ccf, y=bill, color=utility_name)) +
                            #geom_point(shape=1) +
                            geom_line()  +
                            labs(x = "Usage CCF", y = "Bill", color = "Utility") +
                            ggtitle("Total Bill Vs. Usage CCF", subtitle = paste("At every", interval, "CCF from", start, "to", end))+
                            theme(axis.text = element_text(size = 14), axis.title = element_text(size = 20), title = element_text(size = 25),
                            legend.position = "none")

temp_df <- subset(df_final_bill, usage_ccf == singleTargetValue);

ratio_histogram <- ggplot(temp_df, aes(x=percentFixed)) +
                   geom_histogram(binwidth=.05, colour="black", fill="white")+
                   labs(x = "Percent of Total Bill", y = "Number of utilities in that range")+
                   ggtitle(paste("Ratio of Service Charge to Total Bill at", singleTargetValue, "Usage CCF"))+
                   scale_y_continuous(expand = c(0,0))+
                   theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
                         axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
                         title = element_text(size = 25)) +
                   geom_vline(xintercept = mean(temp_df$percentFixed), color = "red")

bill_histogram <- ggplot(temp_df, aes(x=bill)) +
                          geom_histogram(binwidth=(max(temp_df$bill)- min(temp_df$bill))/ round(length(temp_df$bill)/6), colour="black", fill="white")+
                          labs(x = "Bill Amount", y = "Number of Utilities in that Range")+
                          ggtitle(paste("Total Bill at", singleTargetValue, "Usage CCF"))+
                          scale_y_continuous(expand = c(0,0))+
                          scale_x_continuous(breaks=seq(round(min(temp_df$bill)), round(max(temp_df$bill)), round((max(temp_df$bill)- min(temp_df$bill))/ (length(temp_df$bill)/8), 0)))+
                          theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
                                axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15),
                                title = element_text(size = 25)) +
                          geom_vline(xintercept = mean(temp_df$bill), color = "red")
