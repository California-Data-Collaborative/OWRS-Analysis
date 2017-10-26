library(dplyr)
library(ggplot2)
library(scales)
library(raster)
library(rgdal)
library(RateParser)
library(yaml)
library(purrr)

source("R/utils.R")

#change for The scatter plots (If start = end the process will be a lot faster if only concerned with histograms and bar/pie charts)
start <- 0;
end <- 0;
interval <- 5;

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

df_adjustable_sample <- tbl_df(data.frame (usage_ccf = 0, usage_month = 3, hhsize = 4, meter_size = '3/4"', usage_zone = 1, landscape_area = 2000,
                                           et_amount = 2.0, wrap_customer = "No", irr_area = 2000, carw_customer = "No",
                                           season = "Winter", tax_exemption = "granted", lot_size_group = 3,
                                           temperature_zone = "Medium", pressure_zone = 1, water_font = "city_delivered",
                                           area = "inside_city", water_type = "potable", rate_class = "C1",
                                           dwelling_units = 10, elevation_zone = 2, greater_than = "False",
                                           usage_indoor_budget_ccf = .3, meter_type = "Turbine", block = 1,
                                           tariff_area = 1, turbine_meter = "No", senior = "no", cust_class = customer_classes[1]))
test_usage_ccfs <- c(1, 10, 25, 50, 100, 200, 300)
#End

#Retrieve the directories and files in the directores from the Open-Water-Specification-File directory
owrs_path <- "../Open-Water-Rate-Specification/full_utility_rates/California";
directory_names <- list.files(path=owrs_path)

#TODO insert the filename gathering functioon here
df_OWRS <- tbl_df(as.data.frame(list("filepath"=getFileNames(owrs_path)), stringsAsFactors=FALSE)) %>% 
  
  mutate(owrs_directory = map(filepath, strsplit, split="/") %>% map(c(1,1))) %>%
  
  mutate(filename = map(filepath, strsplit, split="/") %>% map(c(1,2))) %>%
  
  mutate(utility_id = map(owrs_directory, strsplit, split=" ") %>%  
                      map(1) %>%map(tail, n=1) %>%
                      map(gsub, pattern="\\D", replacement="") %>%
                      map(as.numeric)) %>%
  
  mutate(effective_date = extract_date(filename) ) %>% 
  mutate(utility_name = sapply(as.character(owrs_directory), extract_utility_name) )
  

for(x in df_OWRS$owrs_directory)
  print(extract_utility_name(x))


#Remove Previous Data and reinitialize the df_bill data frame
rm(df_bill)
df_bill <- data.frame(integer(), character(), character(), character(), double(), character(), double(), double(), double(), double())
names(df_bill) <- c( "utility_id" ,"utility_name", "bill_frequency", "bill_type", "usage_ccf", "cust_class", "service_charge", "commodity_charge", "charge_ratio", "bill")
#End

#Declare Null Data Set
df_NA <- data.frame(
  usage_ccf = NA,
  #usage_month = NA,
  #usage_year = NA,
  cust_class = NA,
  #usage_date = NA,
  service_charge = NA,
  commodity_charge = NA,
  charge_ratio = NA,
  bill = NA
)
#End

#Run through all the OWRS files and test if they are Readable and add the information to the data frame
for(i in 1:(numOfFiles))
{
  #Open OWRS file and retrieve important data
  tryCatch(
    {
      #Declare Error Flags
      file_format_error <- TRUE
      #End

      #Set the index number for the file and directory vectors
      index <- i
      #End

      #Open OWRS file
      owrs_file <- getFileData(owrs_path, directory_names[index], file_names[index])
      file_format_error <- FALSE
      #End
    },
    error = function(cond)
    {
      #Display Error Message for specific files
      message(paste("Format error in file:", file_names[index], "\n", cond, "\n"))
      #End
    },
    finally =
    {
      #If there is an error format the row data accordingly
      if(file_format_error)
      {
        utility <- data.frame(utility_id = utilityID[index], utility_name = file_names[index], bill_frequency = "NA")
        df_temp <- data.frame(utility, df_NA)
        df_bill <- rbind(df_bill, df_temp)

        #Remove Temporary Data Frame
        rm(df_temp)
        #End
      } else
      {
        for(j in 1:length(customer_classes))
        {
          current_class <- customer_classes[j]
          
          tryCatch(
            {
              #df_class <- df_sample %>% filter(cust_class == customer_classes[j])
              df_adjustable_sample$usage_ccf <- -1

              some_error <- TRUE
              #Create a Data Frame with Utility Information and Calculated Bill Information
              if(owrs_file$rate_structure[[current_class]]$commodity_charge == "flat_rate*usage_ccf")
              {
                bt <- "Uniform"
              } else
              {
                bt <- owrs_file$rate_structure[[current_class]]$commodity_charge
              }
              utility <- data.frame(utility_id = utilityID[index], utility_name = owrs_file$metadata$utility_name, bill_frequency = owrs_file$metadata$bill_frequency,
                                    bill_type = bt)
              df_temp <- data.frame(utility, calculate_bill(df_adjustable_sample[1,], owrs_file))
              #End

              #Check if service charge and commodity charge are in the data frame
              df_temp <- hasServiceCharge(df_temp)
              df_temp <- hasCommodityCharge(df_temp)
              #End

              chargeRatio <- df_temp$service_charge/df_temp$bill
              df_temp$charge_ratio <- round(chargeRatio, digits = 3)

              df_temp_bill <- df_temp
              #df_bill <- rbind(df_bill, data.frame(df_temp[,c("utility_id", "utility_name", "bill_frequency", "bill_type", "usage_ccf", "cust_class", "service_charge", "commodity_charge", "charge_ratio", "bill")]))

              if(df_temp_bill$bill_frequency == "bimonthly")
                df_temp_bill$service_charge <- as.numeric(df_temp_bill$service_charge)/2



              #Add Full Utility Bill Information to the bill Data Frame
              for(k in seq(start, end, interval))
              {


                if(df_temp_bill$bill_frequency == "bimonthly")
                  df_adjustable_sample$usage_ccf <- 2*k else
                  df_adjustable_sample$usage_ccf <- k

                df_temp_bill$usage_ccf <- k

                temp <- calculate_bill(df_adjustable_sample[1,], owrs_file)

                if(df_temp_bill$bill_frequency == "bimonthly")
                {
                 df_temp_bill$commodity_charge <- as.numeric(temp["commodity_charge"])/2
                 df_temp_bill$bill <- as.numeric(temp["bill"])/2
                }else
                {
                  df_temp_bill$commodity_charge <- as.numeric(temp["commodity_charge"])
                  df_temp_bill$bill <- as.numeric(temp["bill"])
                }


                chargeRatio <- df_temp_bill$service_charge/df_temp_bill$bill
                df_temp_bill$charge_ratio <- round(chargeRatio, digits = 2)

                df_bill <- rbind(df_bill, data.frame(df_temp_bill[,c("utility_id", "utility_name", "bill_frequency", "bill_type",
                                                                     "usage_ccf", "cust_class", "service_charge", "commodity_charge",
                                                                     "charge_ratio", "bill")]))
                remove(temp)
              }

              value <- singleTargetValue - start

              if(value %% interval != 0 || singleTargetValue > end || singleTargetValue < start)
              {
                if(df_temp_bill$bill_frequency == "bimonthly")
                df_adjustable_sample$usage_ccf <- 2*singleTargetValue else
                  df_adjustable_sample$usage_ccf <- singleTargetValue

                df_temp_bill$usage_ccf <- singleTargetValue

                temp <- calculate_bill(df_adjustable_sample[1,], owrs_file)

                if(df_temp_bill$bill_frequency == "bimonthly")
                {
                  df_temp_bill$commodity_charge <- as.numeric(temp["commodity_charge"])/2
                  df_temp_bill$bill <- as.numeric(temp["bill"])/2
                }else
                {
                  df_temp_bill$commodity_charge <- as.numeric(temp["commodity_charge"])
                  df_temp_bill$bill <- as.numeric(temp["bill"])
                }


                chargeRatio <- df_temp_bill$service_charge/df_temp_bill$bill
                df_temp_bill$charge_ratio <- round(chargeRatio, digits = 2)

                df_bill <- rbind(df_bill, data.frame(df_temp_bill[,c("utility_id", "utility_name", "bill_frequency", "bill_type",
                                                                     "usage_ccf", "cust_class", "service_charge", "commodity_charge",
                                                                     "charge_ratio", "bill")]))
                remove(temp)
              };

              remove(df_temp_bill)

              some_error <- FALSE
            },
            error = function(cond)
            {
              #Display Error Message for specific files
              message(paste("Other error in file:", file_names[index], "\n", cond, "\n"))
              #End
            },
            finally =
            {
              #Check if another error occured
              if(some_error)
              {
                df_temp <- data.frame(utility, df_NA)
                df_bill <- rbind(df_bill, df_temp)
              }
              #End

              #Remove Temporary Data Frame
              rm(df_temp)
              #End
            }
          )
        }
      }
    }

  )
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

NoBiMonthly <- nrow(df_final_bill %>% filter(bill_frequency == "bimonthly"))
NoMonthly <- nrow(df_final_bill %>% filter(bill_frequency == "monthly"))
NoOtherSchedule <- nrow(df_final_bill) - (NoBiMonthly + NoMonthly)

if(NoOtherSchedule > 0)
{
  Schedule <- c("Monthly", "Bi-Monthly", "Other")
  Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly, NoOtherSchedule))
  names(Schedule_DF) <- c("Bill_Frequency", "Value")
} else {
  Schedule <- c("2. Monthly", "1. Bi-Monthly")
  Schedule_DF <- data.frame(Schedule, c(NoMonthly, NoBiMonthly))
  names(Schedule_DF) <- c("Bill_Frequency", "Value")
}


billFrequencyPie <-ggplot(Schedule_DF, aes(x="1", y=Value, fill= Bill_Frequency)) +
  geom_bar(width = 1, stat = "identity")+coord_polar("y", start=0) + scale_fill_brewer(palette="Blues") + theme_void() +
  geom_text(aes(y = Value/2 + c(0, cumsum(Value)[-length(Value)]), label = percent(Value/nrow(df_final_bill))), size=5) +
  ggtitle("Analysis of Bill Frequency")  + theme(plot.title = element_text(lineheight= .5, face="bold")) + labs(fill = "Bill Frequencies")


meanBill <- round(mean(df_final_bill$bill[df_final_bill$usage_ccf == singleTargetValue]), 2)
meanService <- round(mean(df_final_bill$service_charge[df_final_bill$usage_ccf == singleTargetValue]), 2)
meanCommodity <- round(mean(df_final_bill$commodity_charge[df_final_bill$usage_ccf == singleTargetValue]), 2)
meanOther <- round(meanBill - (meanService + meanCommodity), 2)

Mean <- c( "3. Service Charge", "2. Commodity Charge", "1. Other Charge")
Mean_DF <- data.frame(Mean, c(meanService, meanCommodity, meanOther))
names(Mean_DF) <- c("Charge_Structure", "Value")

meanBillPie <-ggplot(Mean_DF, aes(x= 1, y=Value, fill= Charge_Structure)) +
  geom_bar(width = .5, stat = "identity") + scale_fill_brewer(palette="Greens") + theme_void() +
  geom_text(aes(y = Value/2 + c(0, cumsum(Value)[-length(Value)]), label = printCurrency(Value))) +
  ggtitle("Mean Bill by Parts", subtitle = paste("The total mean bill for ", singleTargetValue, " usage ccf is ", printCurrency(meanBill), "0", sep = ""))  +
  labs(fill = "Charges") +
  theme(plot.title = element_text(lineheight=.8, face="bold"), plot.subtitle = element_text(lineheight = .8))

noTiered <- nrow(df_final_bill %>% filter(bill_type == "Tiered"))
noBudget <- nrow(df_final_bill %>% filter(bill_type == "Budget"))
noUniform <- nrow(df_final_bill %>% filter(bill_type == "Uniform"))
noOtherBillType <- nrow(df_final_bill) - (noTiered + noBudget + noUniform)

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


rateStructurePie <-ggplot(Structure_DF, aes(x="", y=Value, fill= Rate_Structure)) +
  geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + scale_fill_brewer(palette="Purples") + theme_void() +
  geom_text(aes(x = "", y = Value/2 + c(0, cumsum(Value)[-length(Value)]), label = percent(Value/nrow(df_final_bill))), size=5) +
  ggtitle("Analysis of Rate Structure")  + theme(plot.title = element_text(lineheight=.8, face="bold")) + labs(fill = "Rate Structures")

meanChargeRatio <- round(mean(as.numeric(df_final_bill$charge_ratio[df_final_bill$usage_ccf == singleTargetValue])), 3)

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

ratio_histogram <- ggplot(temp_df, aes(x=charge_ratio)) +
                   geom_histogram(binwidth=.05, colour="black", fill="white")+
                   labs(x = "Percent of Total Bill", y = "Number of utilities in that range")+
                   ggtitle(paste("Ratio of Service Charge to Total Bill at", singleTargetValue, "Usage CCF"))+
                   scale_y_continuous(expand = c(0,0))+
                   theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15),
                         axis.text.x = element_text(size = 10), axis.text.y = element_text(size = 10),
                         title = element_text(size = 25)) +
                   geom_vline(xintercept = mean(temp_df$charge_ratio), color = "red")

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
