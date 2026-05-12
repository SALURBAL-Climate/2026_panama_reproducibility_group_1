library(tidyverse)
library(arrow)

# READ FILES
files <- list.files(
  path = "2026_panama_reproducibility",
  pattern = "\\.parquet$",
  full.names = TRUE
)

if (length(files) == 0) {
  stop("No .parquet files found in '2026_panama_reproducibility'.", call. = FALSE)
}

df <- map_dfr(files, read_parquet)

df <- df |>
  summarize(
    deaths = sum(deaths),
    cardio = sum(cardio),
    respdisease = sum(respdisease),
    respinf = sum(respinf),
    temp = mean(temp),
    pm25 = mean(pm25),
    .by = c(sim_id, date)
  ) |>
  mutate(strata = paste0(year(date), ":", month(date), ":", wday(date))) |>
  mutate(strata = as_factor(strata))
