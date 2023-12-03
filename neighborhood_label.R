library(tidyverse)
library(dplyr)
df_nypd = read_csv("https://www.dropbox.com/scl/fi/kf2zk4t1onxzm2vo3lpkq/NYPD_Complaint_Data_Historic.csv?rlkey=ly36vi9v66sno80eir6rohlwn&dl=1", na = "(null)") |> # some values are coded as "(null)" in the df; rewrite them as NA
  janitor::clean_names()

df_nypd = df_nypd |> 
  mutate(zip_code = zip_codes)

zip_codes = read_csv("data/zip_code.csv") |>
  janitor::clean_names()

merged_data = merge(df_nypd, zip_codes, by = "zip_code",all.x = TRUE)
