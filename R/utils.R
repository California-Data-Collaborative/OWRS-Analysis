
standardize_OWRS_names <- function(owrs_file, current_class){
  mask <- names(owrs_file$rate_structure[[current_class]]) == "tier_starts_commodity"
  names(owrs_file$rate_structure[[current_class]])[mask] <- "tier_starts"
  
  mask <- names(owrs_file$rate_structure[[current_class]]) == "tier_prices_commodity"
  names(owrs_file$rate_structure[[current_class]])[mask] <- "tier_prices"
  
  mask <- names(owrs_file$rate_structure[[current_class]]) == "flat_rate_commodity"
  names(owrs_file$rate_structure[[current_class]])[mask] <- "flat_rate"
  
  return(owrs_file)
}

singleUtilitySim <- function(df_sample, df_OWRS, owrs_file, current_class){
  
  owrs_file <- standardize_OWRS_names(owrs_file, current_class)
  
  if(owrs_file$rate_structure[[current_class]]$commodity_charge == "flat_rate*usage_ccf"){
    bt <- "Uniform"
  }else {
    bt <- owrs_file$rate_structure[[current_class]]$commodity_charge
  }
  
  if(is.null(owrs_file$metadata$unit_type)){
    ut <- "ccf"
  }else {
    ut <- owrs_file$metadata$unit_type
  }
  
  df_temp <- df_sample %>%
    mutate(utility_id = df_OWRS[i,]$utility_id,
           utility_name = df_OWRS[i,]$utility_name,
           bill_frequency = owrs_file$metadata$bill_frequency,
           unit_type = ut,
           bill_type = bt)
  
  isBimonthly <- length(grep("[Bb][Ii]", df_temp$bill_frequency[1]))
  
  # double usage for bimonthly customers
  if(isBimonthly==TRUE)
    df_temp$usage_ccf <- 2*df_temp$usage_ccf
  
  #cal bill and validate service charge and commodity charge
  df_temp <- calculate_bill(df_temp, owrs_file)
  df_temp <- hasServiceCharge(df_temp)
  df_temp <- hasCommodityCharge(df_temp)
  
  #for error!!!!!!
  # df_temp <- data.frame(utility, df_NA)
  # df_bill <- rbind(df_bill, df_temp)
  
  
  # divide bill by two for comparison to monthly customers 
  if(isBimonthly){
    df_temp$service_charge <- df_temp$service_charge/2.0
    df_temp$commodity_charge <- df_temp["commodity_charge"]/2.0
    df_temp$bill <- df_temp["bill"]/2.0
  }
  
  # calculate percent of bill that comes from fixed charges
  percentFixed <- df_temp$service_charge/df_temp$bill
  df_temp$percentFixed <- round(percentFixed, digits = 2)
  
  return(df_temp)
}


#A function to check if a service charge is present and if not adds a 0 value to the Data Frame
hasServiceCharge <- function(x) {
  if(!"service_charge" %in% colnames(x))
  {
    x$service_charge <- 0
  }
  
  return(x)
}


#A function to check if a commodity charge is present and if not adds a 0 value to the Data Frame
hasCommodityCharge <- function(x) {
  if(!"service_charge" %in% colnames(x))
  {
    x$commodity_charge <- 0
  }
  
  return(x)
}

extract_date <- function(x){
  date_pattern <- "[a-zA-Z\\s_-]*(\\d{1,4}\\-\\d{1,2}\\-\\d{1,4}).*"
  
  datestr <- gsub(x, pattern=date_pattern, replacement="\\1")
  first_dash_idx <- regexpr("-", datestr )[1]
  
  if(first_dash_idx<=3){
    date_parts <- strsplit(datestr, "-")[[1]]
    datestr <- paste(date_parts[3],date_parts[1],date_parts[2], sep="-")
  }
  
  #return(as.Date(datestr, format="%Y-%m-%d"))
  return(datestr)
}

extract_utility_name <- function(x){
  tmp <- unlist(strsplit(x, " "))
  tmp <- tmp[1:(length(tmp)-2)]
  tmp <- paste(tmp, collapse=" ")
  return(tmp)
}


#A function to retrieve Utility Rate Information from OWRS files
getFileData <- function(path, subpath){
  return(read_owrs_file(paste(c(path, "/", subpath), collapse = '')))
}


printCurrency <- function(Number){
  paste('$', Number, sep = "")
}


getFileNames <- function(path){
  #iterate through each directory and get the filenames
  file_names <- unlist(list.files(path=path, pattern = "\\.owrs$", recursive=TRUE))
  file_names <- file_names[!grepl("/[O|o]lder", file_names)] #remove subdirs "Older"
  file_names <- file_names[!grepl("/Need", file_names)] #remove subdirs "Need..."
  file_names <- file_names[!grepl("/Other", file_names)] #remove subdirs "Other"
  file_names <- file_names[!grepl("/Not", file_names)] #remove subdirs "Not.."
}


