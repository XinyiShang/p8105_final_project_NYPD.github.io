Master Dataset
================
Yuki Joyama
2023-11-21

Use codes in this document to import the master dataset.

- NYPD Complaint Data Historic (NYC OpenData)  
- Data collected between 2017 Jan 01 12:00:00 AM - 2022 Dec 31 11:45:00
  PM  
  [data
  source](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i/explore/query/SELECT%0A%20%20%60cmplnt_num%60%2C%0A%20%20%60cmplnt_fr_dt%60%2C%0A%20%20%60cmplnt_fr_tm%60%2C%0A%20%20%60cmplnt_to_dt%60%2C%0A%20%20%60cmplnt_to_tm%60%2C%0A%20%20%60addr_pct_cd%60%2C%0A%20%20%60rpt_dt%60%2C%0A%20%20%60ky_cd%60%2C%0A%20%20%60ofns_desc%60%2C%0A%20%20%60pd_cd%60%2C%0A%20%20%60pd_desc%60%2C%0A%20%20%60crm_atpt_cptd_cd%60%2C%0A%20%20%60law_cat_cd%60%2C%0A%20%20%60boro_nm%60%2C%0A%20%20%60loc_of_occur_desc%60%2C%0A%20%20%60prem_typ_desc%60%2C%0A%20%20%60juris_desc%60%2C%0A%20%20%60jurisdiction_code%60%2C%0A%20%20%60parks_nm%60%2C%0A%20%20%60hadevelopt%60%2C%0A%20%20%60housing_psa%60%2C%0A%20%20%60x_coord_cd%60%2C%0A%20%20%60y_coord_cd%60%2C%0A%20%20%60susp_age_group%60%2C%0A%20%20%60susp_race%60%2C%0A%20%20%60susp_sex%60%2C%0A%20%20%60transit_district%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60lat_lon%60%2C%0A%20%20%60patrol_boro%60%2C%0A%20%20%60station_name%60%2C%0A%20%20%60vic_age_group%60%2C%0A%20%20%60vic_race%60%2C%0A%20%20%60vic_sex%60%2C%0A%20%20%60%3A%40computed_region_efsh_h5xi%60%2C%0A%20%20%60%3A%40computed_region_f5dn_yrer%60%2C%0A%20%20%60%3A%40computed_region_yeji_bk3q%60%2C%0A%20%20%60%3A%40computed_region_92fq_4b7q%60%2C%0A%20%20%60%3A%40computed_region_sbqj_enih%60%0AWHERE%0A%20%20%60cmplnt_fr_dt%60%0A%20%20%20%20BETWEEN%20%222017-01-01T00%3A00%3A00%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20AND%20%222022-12-31T23%3A45%3A00%22%20%3A%3A%20floating_timestamp%0AORDER%20BY%20%60rpt_dt%60%20DESC%20NULL%20FIRST/page/filter)

## Import NYPD csv file from dropbox

``` r
df_nypd = read_csv("https://www.dropbox.com/scl/fi/kf2zk4t1onxzm2vo3lpkq/NYPD_Complaint_Data_Historic.csv?rlkey=ly36vi9v66sno80eir6rohlwn&dl=1", na = "(null)") |> # some values are coded as "(null)" in the df; rewrite them as NA
  janitor::clean_names() 
```

    ## Warning: One or more parsing issues, call `problems()` on your data frame for details,
    ## e.g.:
    ##   dat <- vroom(...)
    ##   problems(dat)

    ## Rows: 2772016 Columns: 40
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (22): CMPLNT_FR_DT, CMPLNT_TO_DT, RPT_DT, OFNS_DESC, PD_DESC, CRM_ATPT_...
    ## dbl  (16): CMPLNT_NUM, ADDR_PCT_CD, KY_CD, PD_CD, JURISDICTION_CODE, HOUSING...
    ## time  (2): CMPLNT_FR_TM, CMPLNT_TO_TM
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

The file size is 0.97GB. The dataset should have 40 variables and
2772016 rows.  

Column names are changed to lower cases using `janitor::clean_names()`.
Please refer to this
[link](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i)
for more details about columns.

## Socioeconomic indicators

``` r
df_socio = readxl::read_excel(here::here("data", "neighorhood_Indicators.xlsx"), sheet = "Data")
```

This dataset (121 variables and 3553 rows) provides information on the
NYC socioecomonic background. ([data
source](https://furmancenter.org/coredata/userguide/about))  
The excel file is stored in “data” directory. Variable explanations can
be found in the “Data Dictionary” sheet.

## Neighborhoods (Sub-borough) Information

The neighborhoods information is not included in our master dataset so
we will add them using `addr_pct_cd` (NYPD precinct codes) and
approximate mapping from Golub et al. (2006)  
NYPD the 121st Precinct serves the northwestern shore of Staten Island
(Willowbrook, Westerleigh, Port Richmond, Mariner’s Harbor, Elm Park,
Port Ivory, Chelsea, and Bloomfield) so we classified this as
`North Shore`.

``` r
df_nypd_loc = df_nypd |> 
  mutate(
    region_name = case_when( # region_name: neighborhood, sub-borough
      # manhattan
      addr_pct_cd %in% c(1, 6) ~ "Greenwich Village/Financial District", 
      addr_pct_cd %in% c(5, 7, 9)  ~ "Lower East Side/Chinatown",
      addr_pct_cd %in% c(10, 18, 14)  ~ "Chelsea/Clinton/Midtown",
      addr_pct_cd %in% c(13, 17) ~ "Stuyvesant Town/Turtle Bay",
      addr_pct_cd %in% c(20, 24) ~ "Upper West Side",
      addr_pct_cd == 19 ~ "Upper East Side",
      addr_pct_cd == 22 ~ "Central Park",
      addr_pct_cd %in% c(26, 30) ~ "Morningside Heights/Hamilton Heights",
      addr_pct_cd %in% c(28, 32) ~ "Central Harlem",
      addr_pct_cd %in% c(23, 25) ~ "East Harlem",
      addr_pct_cd %in% c(33, 34) ~ "Washington Heights/Inwood",
      # the bronx
      addr_pct_cd %in% c(40, 41) ~ "Mott Haven/Hunts Point",
      addr_pct_cd %in% c(42, 48) ~ "Morrisania/Belmont",
      addr_pct_cd == 44 ~ "Highbridge/South Concourse",
      addr_pct_cd == 46 ~ "University Heights/Fordham",
      addr_pct_cd == 52 ~ "Kingsbridge Heights/Mosholu", 
      addr_pct_cd == 50 ~ "Riverdale/Kingsbridge" ,
      addr_pct_cd == 43 ~ "Soundview/Parkchester",
      addr_pct_cd == 45 ~ "Throgs Neck/Co-op City",
      addr_pct_cd == 49 ~ "Pelham Parkway",
      addr_pct_cd == 47 ~ "Williamsbridge/Baychester",
      # brooklyn
      addr_pct_cd %in% c(90, 94) ~ "Williamsburg/Greenpoint",
      addr_pct_cd %in% c(84, 88) ~ "Brooklyn Heights/Fort Greene",
      addr_pct_cd %in% c(79, 81) ~ "Bedford Stuyvesant",
      addr_pct_cd == 83 ~ "Bushwick",
      addr_pct_cd == 75 ~ "East New York/Starrett City",
      addr_pct_cd %in% c(76, 78) ~ "Park Slope/Carroll Gardens",
      addr_pct_cd == 72 ~ "Sunset Park",
      addr_pct_cd == 77 ~ "North Crown Heights/Prospect Heights",
      addr_pct_cd == 71 ~ "South Crown Heights",
      addr_pct_cd == 68 ~ "Bay Ridge",
      addr_pct_cd == 62 ~ "Bensonhurst" ,
      addr_pct_cd == 66 ~ "Borough Park",
      addr_pct_cd == 60 ~ "Coney Island",
      addr_pct_cd == 70 ~ "Flatbush",
      addr_pct_cd == 61 ~ "Sheepshead Bay/Gravesend",
      addr_pct_cd == 73 ~ "Brownsville/Ocean Hill",
      addr_pct_cd == 67 ~ "East Flatbush",
      addr_pct_cd %in% c(63, 69) ~ "Flatlands/Canarsie",
      # queens
      addr_pct_cd == 114 ~ "Astoria",
      addr_pct_cd == 108 ~ "Sunnyside/Woodside",
      addr_pct_cd == 115 ~ "Jackson Heights",
      addr_pct_cd == 110 ~ "Elmhurst/Corona",
      addr_pct_cd == 104 ~ "Middle Village/Ridgewood",
      addr_pct_cd == 112 ~ "Rego Park/Forest Hills",
      addr_pct_cd == 109 ~ "Flushing/Whitestone",
      addr_pct_cd == 107 ~ "Hillcrest/Fresh Meadows",
      addr_pct_cd == 102 ~ "Ozone Park/Woodhaven",
      addr_pct_cd == 106 ~ "South Ozone Park/Howard Beach", 
      addr_pct_cd == 111 ~ "Bayside/Little Neck",
      addr_pct_cd %in% c(103, 113) ~ "Jamaica",
      addr_pct_cd == 105 ~ "Queens Village",
      addr_pct_cd %in% c(100, 101) ~ "Rockaways",
      # staten island
      addr_pct_cd %in% c(120, 121) ~ "North Shore",
      addr_pct_cd == 122 ~ "Mid-Island",
      addr_pct_cd == 123 ~ "South Shore"
    )
  ) |> 
 drop_na(region_name) # excluded the data without the information of location 

# list of sub_borough
unique(pull(df_nypd_loc, region_name))
```

    ##  [1] "Jamaica"                             
    ##  [2] "Flatbush"                            
    ##  [3] "Upper East Side"                     
    ##  [4] "East Harlem"                         
    ##  [5] "Bedford Stuyvesant"                  
    ##  [6] "Chelsea/Clinton/Midtown"             
    ##  [7] "Greenwich Village/Financial District"
    ##  [8] "Rockaways"                           
    ##  [9] "Flushing/Whitestone"                 
    ## [10] "East Flatbush"                       
    ## [11] "Queens Village"                      
    ## [12] "University Heights/Fordham"          
    ## [13] "Stuyvesant Town/Turtle Bay"          
    ## [14] "Ozone Park/Woodhaven"                
    ## [15] "Brownsville/Ocean Hill"              
    ## [16] "Sunset Park"                         
    ## [17] "Morningside Heights/Hamilton Heights"
    ## [18] "Morrisania/Belmont"                  
    ## [19] "Lower East Side/Chinatown"           
    ## [20] "Upper West Side"                     
    ## [21] "Williamsbridge/Baychester"           
    ## [22] "East New York/Starrett City"         
    ## [23] "Bensonhurst"                         
    ## [24] "Flatlands/Canarsie"                  
    ## [25] "Borough Park"                        
    ## [26] "Elmhurst/Corona"                     
    ## [27] "Williamsburg/Greenpoint"             
    ## [28] "Bay Ridge"                           
    ## [29] "Bushwick"                            
    ## [30] "Throgs Neck/Co-op City"              
    ## [31] "Coney Island"                        
    ## [32] "Highbridge/South Concourse"          
    ## [33] "Rego Park/Forest Hills"              
    ## [34] "Sheepshead Bay/Gravesend"            
    ## [35] "Mott Haven/Hunts Point"              
    ## [36] "Astoria"                             
    ## [37] "Soundview/Parkchester"               
    ## [38] "Sunnyside/Woodside"                  
    ## [39] "North Crown Heights/Prospect Heights"
    ## [40] "Kingsbridge Heights/Mosholu"         
    ## [41] "North Shore"                         
    ## [42] "Hillcrest/Fresh Meadows"             
    ## [43] "Washington Heights/Inwood"           
    ## [44] "Central Harlem"                      
    ## [45] "Bayside/Little Neck"                 
    ## [46] "Jackson Heights"                     
    ## [47] "Brooklyn Heights/Fort Greene"        
    ## [48] "South Ozone Park/Howard Beach"       
    ## [49] "Riverdale/Kingsbridge"               
    ## [50] "Middle Village/Ridgewood"            
    ## [51] "Pelham Parkway"                      
    ## [52] "South Crown Heights"                 
    ## [53] "Mid-Island"                          
    ## [54] "Park Slope/Carroll Gardens"          
    ## [55] "South Shore"                         
    ## [56] "Central Park"
