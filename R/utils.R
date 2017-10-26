

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
  first_dash_idx <- regexpr("-", x )[1]
  
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
getFileData <- function(path, dir, filename){
  return(read_owrs_file(paste(c(path, "/", dir, "/", filename), collapse = '')))
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


