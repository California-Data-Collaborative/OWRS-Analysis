


owrs_to_supplier_report_manual_map <- list(
  "Big Bear Lake  City Of" = "City of Big Bear Lake, Dept of Water & Power",
  "Calaveras Public Utilities District" = "",
  "Crescent City" = "Crescent City City of",
  "Discovery Bay  Town Of" = "Discovery Bay Community Services District",
  "Golden State Water Company - Hawthorne" = "Hawthorne City of",
  "Golden State Water Company - Lakewood" = "",
  "Marina Coast Water District - Central Marina" = "Marina Coast Water District",
  "Marina Coast Water District - Ord Community" = "Marina Coast Water District",
  "Rio Dell  City Of" = "",
  "San Bernardino County Service Area 64 Spring Valley Lake" = "San Bernardino County Service Area 64",
  "Sierra Estates Mutual Water Company" = ""
)



assign_fuzzy_match_names <- function(df, source_column_name, 
                                     new_name_column = "fuzzy_match", 
                                     names_to_match_with, manual_map, cutoff=0.85){
  
  
  df[new_name_column] <- as.character(sapply( df[[source_column_name]], 
                                              GetCloseMatches,
                                                sequence_strings =  names_to_match_with, 
                                                n=1L, cutoff = cutoff))
  if(!is.null(manual_map)){
    manually_mapped_names <- as.character(manual_map[df[[source_column_name]]])
    df[new_name_column] <- ifelse(manually_mapped_names == "NULL", 
                                  df[[new_name_column]],
                                  manually_mapped_names)
  }
  
  return(df)
}



fuzzy_district_left_join <- function(df1, df2, left_on=NULL, right_on=NULL, new_column_name, cutoff=0.9){
  common_pattern <- "(water)|(district)|(city)|(of)|(community)|(services?)|(county)|(department)|(csa)|(company)|(,)"
  df1$simplified <- str_squish(str_remove_all(tolower(df1$utility_name), common_pattern))
  df2$simplified <- str_squish(str_remove_all(tolower(df2$utility_name), common_pattern))
  df1$simplified_from_owrs <- as.character(sapply( df1$simplified,
                                                             GetCloseMatches,
                                                             sequence_strings =  df2$simplified,
                                                             n=1L, cutoff = 0.9))
  df1 <- df1 %>% left_join(df2 %>% select(simplified, utility_name_owrs=utility_name), 
                                               by=c("simplified_from_owrs"="simplified"))
  
  df1
}


preprocess_raftelis_name <- function(s){
  
  if(grepl("City of", s)){
    a <- substr(s, 0, 8)
    b <- substr(s, 9, 999)
    s <- paste(b, a, sep=" ")
  }
  
  s <- gsub("CSD", "Community Services District", s)

  return(s)
}

















