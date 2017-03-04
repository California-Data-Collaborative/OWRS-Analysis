library(dplyr)
library(raster)
library(rgdal)
library(RateParser)
library(yaml)

#import sample data and give the data parameters used in the owrs files that are not in the original data
df_smc <- santamonica
names(df_smc) <- c( "cust_id", "usage_ccf", "usage_month", "usage_year",  "cust_class", "usage_date", "cust_class_from-utility")

df_sample <- tbl_df(df_smc) %>%
  mutate(hhsize = 4, meter_size = '3/4"', usage_zone = 1, landscape_area = 2000,
         et_amount = 2, wrap_customer = "No", irr_area = 2000, carw_customer = "No",
         season = "Winter", tax_exemption = "granted", lot_size_group = 3,
         temperature_zone = "Medium", pressure_zone = 1, water_font = "city_delivered",
         area = "inside_city", water_type = "potable", rate_class = "C1",
         dwelling_units = 10, elevation_zone = 2, greater_than = "False",
         usage_indoor_budget_ccf = .3) %>% 
  group_by(cust_class)
#End


#Declare the customer classes to be tested for each utility 
customer_classes <- c("RESIDENTIAL_SINGLE" 
                      #"RESIDENTIAL_MULTI",
                      #"COMMERCIAL"
)
#End

#Retrieve the directories and files in the directores from the Open-Water-Specification-File directory 
setwd("../Open-Water-Rate-Specification/full_utility_rates/California");
directory_names <- list.files()

numOfFiles <- length(directory_names)

rm(file_names, utilityID)
file_names <- vector()
utilityID <- vector()
error <- vector()

for(i in 1:numOfFiles)
{
  
  setwd(paste(c(directory_names[i],"/"), collapse = ''))
  
  #Need to add error checking in case someone writes a non owrs file name
  tempFileName <- unlist(list.files(pattern = "\\.owrs$"))
  #End
  
  if(length(tempFileName) == 0)
  {
    error <- c(error, i)
  }
  else
  {
    #Retrieve Utility ID from directory name
    file_names <- c(file_names, tempFileName)
    tempUtilityID <- as.numeric(gsub("\\D", "", directory_names[i]))
    utilityID <- c(utilityID, tempUtilityID)
    rm(tempUtilityID)
    #End
  }
  
  rm(tempFileName)
  setwd("../")
}

setwd("../../../WaterRateTester/")
#End

for(i in 1: length(error))
{
  directory_names <- directory_names[-error]
}
numOfFiles <- numOfFiles - length(error)


#Remove Previous Data and reinitialize the df_bill data frame
rm(df_bill)
df_bill <- data.frame(integer(), character(), character(), double(), character(), double(), double(), double())
names(df_bill) <- c( "utility_id" ,"utility_name", "bill_frequency", "usage_ccf", "cust_class", "service_charge", "commodity_charge", "bill")
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
      owrs_file <- getFileData(index)
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
      }
      else
      {
        for(j in 1:length(customer_classes))
        {
          tryCatch(
            {
              df_class <- df_sample %>% filter(cust_class == customer_classes[j])
              
              some_error <- TRUE
              #Create a Data Frame with Utility Information and Calculated Bill Information
              utility <- data.frame(utility_id = utilityID[index], utility_name = owrs_file$metadata$utility_name, bill_frequency = owrs_file$metadata$bill_frequency)
              df_temp <- data.frame(utility, calculate_bill(df_class[1,], owrs_file))
              #End
              
              #Check if service charge and commodity charge are in the data frame
              df_temp <- hasServiceCharge(df_temp)
              df_temp <- hasCommodityCharge(df_temp)
              #End
              
              #Add Full Utility Bill Information to the bill Data Frame
              df_bill <- rbind(df_bill, data.frame(df_temp[,c("utility_id", "utility_name", "bill_frequency", "usage_ccf", "cust_class", "service_charge", "commodity_charge", "bill")]))
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
df_final_bill$commodity_charge <- round(df_final_bill$commodity_charge, 2)
df_final_bill$utility_name <- as.character(df_final_bill$utility_name)
df_final_bill$bill_frequency <- as.character(df_final_bill$bill_frequency)

df_final_bill <- df_final_bill %>% arrange(utility_name)
#End

shape <- readOGR(dsn = "../Shapefiles", layer = "service_areas_cadc_with_utility_id_points") 
shape <- merge(shape, df_final_bill, by = "utility_id")

setwd("../TempShapeFiles/")
#Output The Final Bill information to a  shapefile
writeOGR(shape, ".", "service_areas_cadc_points_with_billing_info", driver="ESRI Shapefile", overwrite_layer = TRUE)
#End
zipDemFiles <- list.files(recursive = TRUE)
setwd("../")
zip(zipfile = "../Dropbox/CSV/shapefileZip", files = paste("TempShapeFiles", zipDemFiles, sep = "/"))

setwd("WaterRateTester/")

#A function to check if a service charge is present and if not adds a 0 value to the Data Frame
hasServiceCharge <- function(x) {
  if(!"service_charge" %in% colnames(x))
  {
    x$service_charge <- 0
  }
  
  return(x)
}
#End

#A function to check if a commodity charge is present and if not adds a 0 value to the Data Frame
hasCommodityCharge <- function(x) {
  if(!"service_charge" %in% colnames(x))
  {
    x$commodity_charge <- 0
  }
  
  return(x)
}
#End

#A function to retrieve Utility Rate Information from OWRS files
getFileData <- function(fileNumber){
  return(read_owrs_file(paste(c("../Open-Water-Rate-Specification/full_utility_rates/California/",
                                directory_names[fileNumber], "/", file_names[fileNumber]), collapse = '')))
}
#End