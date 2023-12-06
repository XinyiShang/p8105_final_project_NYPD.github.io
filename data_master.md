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

    ## Warning: One or more parsing issues, call `problems()` on your data frame for details, e.g.:
    ##   dat <- vroom(...)
    ##   problems(dat)

The file size is 0.97GB. The dataset should have 40 variables and
2772016 rows.  

Column names are changed to lower cases using `janitor::clean_names()`.
Please refer to this
[link](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i)
for more details about columns.

## Socioeconomic indicators

``` r
df_socio = readxl::read_excel("./data/neighorhood_Indicators.xlsx", sheet = "Data")
```

This dataset (121 variables and 3553 rows) provides information on the
NYC socioecomonic background. ([data
source](https://furmancenter.org/coredata/userguide/about))  
The excel file is stored in “data” directory. Variable explanations can
be found in the “Data Dictionary” sheet.
