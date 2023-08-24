

needs(rvest, tidyverse)


source("extract_harvard.R")

# AJPS

ajps_urls <- str_c("https://dataverse.harvard.edu/dataverse/ajps?q=&types=dataverses%3Adatasets&sort=dateSort&order=desc&page=", 1:65)

ajps <- map(ajps_urls, safely(extract_harvard), .progress = TRUE)

ajps_bind <- ajps |> 
  map('result') |> 
  compact() |> 
  bind_rows()|> 
  mutate(journal = "ajps") |> 
  write_csv("data/ajps_replication.csv")

# APSR

apsr_urls <- str_c("https://dataverse.harvard.edu/dataverse/the_review?q=&types=dataverses%3Adatasets&sort=dateSort&order=desc&page=", 1:54)

apsr <- map(apsr_urls, safely(extract_harvard), .progress = TRUE)

apsr_bind <- apsr |> 
  map('result') |> 
  compact() |> 
  bind_rows() |> 
  mutate(journal = "apsr") |> 
  write_csv("data/apsr_replication.csv")

# JOP

jop_urls <- str_c("https://dataverse.harvard.edu/dataverse/jop?q=&types=dataverses%3Adatasets&sort=dateSort&order=desc&page=", 1:76
)
jop <- map(jop_urls, safely(extract_harvard), .progress = TRUE)

jop_bind <- jop |> 
  map('result') |> 
  compact() |> 
  bind_rows() |> 
  mutate(journal = "jop") |> 
  write_csv("data/jop_replication.csv")

replication <- bind_rows(ajps_bind, apsr_bind, jop_bind) |> 
  write_csv("data/polsci_replication.csv")

# Replication plot

replication |> 
  filter(year < 2022) |> 
  group_by(year, journal) |> 
  count() |> 
  ggplot(aes(year, n, color = journal, group = journal)) + 
  geom_point() +
  geom_line() +
  theme_light() + 
  scale_color_viridis_d()
