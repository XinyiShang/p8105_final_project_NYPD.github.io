suspect_victim_correlations
================
Nihaal Rahman

Looking at suspect/victim age by level of offense

``` r
age_combined <- gather(data, key = "variable", value = "age", susp_age_group, vic_age_group)

age_plot <- data |> 
  filter(susp_age_group %in% c('<18', '18-24', '25-44', '45-64', '65+') & vic_age_group %in% c('<18', '18-24', '25-44', '45-64', '65+')) |> 
  gather(key = "variable", value = "age", susp_age_group, vic_age_group) |> 
  ggplot(aes(x = law_cat_cd, fill = age)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of suspect and victim age by level of offense") +
  guides(fill = guide_legend(title = "Age")) +
  facet_wrap(~variable, scales = "free_x", ncol = 2) +
  theme(legend.position = "bottom")

print(age_plot)
```

![](victim_suspect_correlation_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Looking at suspect/victim sex by level of offense

``` r
sex_combined <- gather(data, key = "variable", value = "sex", susp_sex, vic_sex)

sex_plot <- data |> 
  filter(susp_sex %in% c('F', 'M') & vic_sex %in% c('F', 'M')) |> 
  gather(key = "variable", value = "sex", susp_sex, vic_sex) |> 
  ggplot(aes(x = law_cat_cd, fill = sex)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of suspect and victim sex by level of offense") +
  guides(fill = guide_legend(title = "Sex")) +
  facet_wrap(~variable, scales = "free_x", ncol = 2) +
  theme(legend.position = "bottom")

print(sex_plot)
```

![](victim_suspect_correlation_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Looking at suspect/victim race by level of offense

``` r
race_combined <- gather(data, key = "variable", value = "race", susp_race, vic_race)

race_plot <- ggplot(race_combined, aes(x = law_cat_cd, fill = race)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of supect and victim race by level of offense") +
  guides(fill = guide_legend(title = "Race")) +
  facet_wrap(~variable, scales = "free_x", ncol = 2) +
  theme(legend.position = "bottom") 

print(race_plot)
```

![](victim_suspect_correlation_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Seeing which combination of race+age+sex has the highest counts for
victim and suspects

``` r
victim_count <- data |> 
  filter(vic_sex %in% c('F', 'M')) |> 
  filter(vic_age_group %in% c('<18', '18-24', '25-44', '45-64', '65+')) |> 
  select(vic_age_group, vic_race, vic_sex) |> 
  group_by(vic_age_group, vic_race, vic_sex) |> 
  summarize(count = n()) |> 
  ungroup() |> 
  arrange(desc(count))
  
print(victim_count)
```

    ## # A tibble: 68 × 4
    ##    vic_age_group vic_race       vic_sex  count
    ##    <chr>         <chr>          <chr>    <int>
    ##  1 25-44         BLACK          F       149910
    ##  2 25-44         WHITE HISPANIC F        97297
    ##  3 25-44         BLACK          M        78439
    ##  4 45-64         BLACK          F        66138
    ##  5 25-44         WHITE          F        63926
    ##  6 25-44         WHITE HISPANIC M        62627
    ##  7 25-44         WHITE          M        58194
    ##  8 45-64         BLACK          M        52932
    ##  9 18-24         BLACK          F        43658
    ## 10 45-64         WHITE          M        42103
    ## # ℹ 58 more rows

``` r
suspect_count <- data |> 
  filter(susp_sex %in% c('F', 'M')) |> 
  filter(susp_age_group %in% c('<18', '18-24', '25-44', '45-64', '65+')) |> 
  select(susp_age_group, susp_race, susp_sex) |> 
  group_by(susp_age_group, susp_race, susp_sex) |> 
  summarize(count = n()) |> 
  ungroup() |> 
  arrange(desc(count))
  
print(suspect_count)
```

    ## # A tibble: 60 × 4
    ##    susp_age_group susp_race      susp_sex  count
    ##    <chr>          <chr>          <chr>     <int>
    ##  1 25-44          BLACK          M        161899
    ##  2 25-44          WHITE HISPANIC M         84750
    ##  3 25-44          BLACK          F         55501
    ##  4 45-64          BLACK          M         52222
    ##  5 18-24          BLACK          M         50762
    ##  6 25-44          WHITE          M         39766
    ##  7 25-44          WHITE HISPANIC F         27097
    ##  8 25-44          BLACK HISPANIC M         26551
    ##  9 18-24          WHITE HISPANIC M         25330
    ## 10 45-64          WHITE HISPANIC M         24104
    ## # ℹ 50 more rows
