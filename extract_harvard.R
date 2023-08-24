
extract_harvard <- function(url) {
  cat(url)
  
  page <- rvest::read_html(url)
  
  tibble::tibble(
    dataverse = stringr::str_extract(url, '(?<=dataverse/).+?(?=\\?)') |>
      stringr::str_to_upper(),
    article = rvest::html_elements(page, ".card-title-icon-block") |>
      rvest::html_text2() |>
      stringr::str_remove("Replication Data for: "),
    date =  rvest::html_elements(page, ".text-center+ .text-muted") |>
      rvest::html_text() |>
      lubridate::mdy()
  ) |>
    dplyr::mutate(year = stringr::str_extract(date, "\\d{4}"))
}