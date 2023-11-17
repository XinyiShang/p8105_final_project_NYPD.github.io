# Retrieve data from NYPD Complaint Data Historic
# Date: 11/17/2023
# Author: Xinyi Shang
# filter is recommended as the data set is huge (8.35M rows) and hard to import at one time
# Change query to apply different filters: 
# Line 1: select columns
# Line 2: filter time frame (can be modified to filter out different columns)
# Line 3: Order
# Line 4: Limit number of output

# Load necessary libraries
library(httr)
library(jsonlite)

# api_key = "YOUR-API-KEY" #create an api key by sign up for NYC open data (may not be necessary for small query)

json_url = "https://data.cityofnewyork.us/resource/qgea-i56i.json?" #api of the dataset 

#Set Up filters, modify the query as needed
#Change "LIMIT" to import larger data set 
query = "SELECT cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, cmplnt_to_dt, cmplnt_to_tm, addr_pct_cd, rpt_dt, ky_cd, ofns_desc, pd_cd, pd_desc, crm_atpt_cptd_cd, law_cat_cd, boro_nm, loc_of_occur_desc, prem_typ_desc, juris_desc, jurisdiction_code, parks_nm, hadevelopt, housing_psa, x_coord_cd, y_coord_cd, susp_age_group, susp_race, susp_sex, transit_district, latitude, longitude, lat_lon, patrol_boro, station_name, vic_age_group, vic_race, vic_sex, :@computed_region_efsh_h5xi, :@computed_region_f5dn_yrer, :@computed_region_yeji_bk3q, :@computed_region_92fq_4b7q, :@computed_region_sbqj_enih 
          WHERE cmplnt_fr_dt BETWEEN '2022-05-08T18:03:44'::floating_timestamp AND '2022-06-08T18:03:44'::floating_timestamp 
          ORDER BY rpt_dt DESC NULL FIRST 
          LIMIT 200000"
        

# Make the GET request
response = GET(paste0(json_url, "$query=", URLencode(query)))

# Check if the request was successful (status code 200) 
if (response$status_code == 200) {
  # Process the response
  content <- content(response, "text")
  data <- fromJSON(content)
} else {
  cat("Error: Unable to retrieve data. Status code:", response$status_code, "\n") #go check filter/url if get other status code
}
