## screen and calculate deer-grid overlap for additional macropods
##
## ALA_EMAIL=your-registered-email Rscript scripts/calculate_macropod_overlap.R
##
## candidate species: mainland macropods with mean adult mass of ≥
## 10 kg not already represented by commercial-survey estimates
## in biomasscalc.R
## mean masses are sex averages from Fisher et al. (2001),
## doi:10.1890/0012-9658(2001)082[3531:TEBOLH]2.0.CO;2.
##
## a species is included only when its post-2000 ALA records:
##   1. total at ≥ 1000, limiting results to well-documented taxa;
##   2. occupy at least 150 ABARES deer-occurrence cells (60,000 km2);
##   3. occur in the combined ABARES 2026 deer-occurrence raster
##
## thresholds make analysis a comparison of material, broad-scale
## biomass rather than one of sparse records or isolated colonies

library(galah)
library(terra)

ala_email <- trimws(Sys.getenv("ALA_EMAIL", unset = ""))
if (!nzchar(ala_email)) {
  stop("Set ALA_EMAIL to an email address registered with the Atlas of Living Australia.", call. = FALSE)
}

candidate_species <- data.frame(
  species = c(
    "Wallabia bicolor",
    "Macropus rufogriseus",
    "Macropus parryi",
    "Macropus dorsalis",
    "Macropus agilis",
    "Macropus antilopinus",
    "Osphranter bernardus"
  ),
  mean_mass_kg = c(15, 16.75, 16, 18, 16, 20, 19),
  stringsAsFactors = FALSE
)
commercial_species <- c(
  "Osphranter rufus",
  "Macropus giganteus",
  "Macropus fuliginosus",
  "Osphranter robustus"
)
commercial_harvest_states <- data.frame(
  species = c(
    rep("Osphranter rufus", 4),
    rep("Macropus giganteus", 4),
    rep("Macropus fuliginosus", 4),
    rep("Osphranter robustus", 3)
  ),
  state = c(
    "NSW", "QLD", "SA", "WA",
    "NSW", "QLD", "SA", "VIC",
    "NSW", "SA", "VIC", "WA",
    "NSW", "QLD", "SA"
  ),
  stringsAsFactors = FALSE
)

minimum_ala_records <- 1000
minimum_overlap_cells <- 150
deer <- rast("data/FeralDeerOccurrence2026_data_v1.0.0/AllDeerOccurrence2026.tif")
australia <- project(
  vect(rnaturalearth::ne_countries(country = "Australia", returnclass = "sf")),
  crs(deer)
)
states <- vect(rnaturalearth::ne_states(country = "Australia", returnclass = "sf"))
states <- states[states$postal %in% c("WA", "SA", "QL", "NS", "VI", "TS"), ]
states$state <- c(
  WA = "WA",
  SA = "SA",
  QL = "QLD",
  NS = "NSW",
  VI = "VIC",
  TS = "TAS"
)[states$postal]
states <- project(states, crs(deer))
deer_presence <- classify(deer, matrix(c(-Inf, Inf, 1), ncol = 3, byrow = TRUE))
deer_range <- as.polygons(deer_presence, dissolve = TRUE, na.rm = TRUE)
plot_deer_map <- function(title, show_deer_legend = TRUE) {
  if (show_deer_legend) {
    plot(
      deer,
      col = c("darkgreen", "lightgreen"),
      axes = FALSE,
      main = title,
      plg = list(
        x = "bottomleft",
        legend = c("verified deer records", "modelled deer occurrence"),
        title = ""
      )
    )
  } else {
    plot(
      deer,
      col = c("darkgreen", "lightgreen"),
      legend = FALSE,
      axes = FALSE,
      main = title
    )
  }
  plot(australia, add = TRUE, border = "grey20", lwd = 0.8)
}

plot_deer_map("ABARES known feral deer occurrence 2026")
cell_area_km2 <- prod(res(deer)) / 1e6

galah_config(email = ala_email, send_email = FALSE, verbose = FALSE)

download_ala_locations <- function(species) {
  records <- galah_call() |>
    galah_identify(species) |>
    galah_filter(
      year >= 2000,
      basis_of_record %in% c("HUMAN_OBSERVATION", "MACHINE_OBSERVATION", "PRESERVED_SPECIMEN")
    ) |>
    galah_select(decimalLatitude, decimalLongitude) |>
    atlas_occurrences()

  records <- records[
    is.finite(records$decimalLongitude) & is.finite(records$decimalLatitude),
  ]
  locations <- vect(
    records[, c("decimalLongitude", "decimalLatitude")],
    geom = c("decimalLongitude", "decimalLatitude"),
    crs = "EPSG:4326"
  )

  list(
    ala_records = nrow(records),
    locations = locations
  )
}

make_range_proxy <- function(locations) {
  cells <- unique(cellFromXY(deer, crds(project(locations, crs(deer)))))
  occupied_cells <- vect(
    xyFromCell(deer, cells[!is.na(cells)]),
    type = "points",
    crs = crs(deer)
  )
  vect(
    sf::st_concave_hull(sf::st_union(sf::st_as_sf(occupied_cells)), ratio = 0.2)
  )
}

area_km2 <- function(x) {
  if (nrow(x) == 0) {
    return(0)
  }
  sum(expanse(x, unit = "km"))
}

calculate_commercial_overlap <- function(species, state, range_proxy) {
  state_polygon <- states[states$state == state, ]
  range_in_state <- intersect(range_proxy, state_polygon)
  range_area_km2 <- area_km2(range_in_state)
  deer_overlap <- intersect(range_in_state, deer_range)
  deer_overlap_km2 <- area_km2(deer_overlap)

  data.frame(
    species = species,
    state = state,
    range_area_km2 = range_area_km2,
    deer_overlap_km2 = deer_overlap_km2,
    deer_overlap_fraction = if (range_area_km2 == 0) 0 else deer_overlap_km2 / range_area_km2
  )
}

screen_candidate <- function(species, mean_mass_kg) {
  ala <- download_ala_locations(species)
  locations <- ala$locations
  cells <- cellFromXY(deer, crds(project(locations, crs(deer))))
  deer_cells <- unique(cells[!is.na(cells) & !is.na(values(deer)[cells])])
  ala_records <- ala$ala_records
  overlap_cells <- length(deer_cells)

  list(
    summary = data.frame(
      species = species,
      ala_scientific_name = species,
      ala_records = ala_records,
      overlap_cells = overlap_cells,
      overlap_area_km2 = overlap_cells * cell_area_km2,
      mean_mass_kg = mean_mass_kg,
      sufficient_ala_records = ala_records >= minimum_ala_records,
      sufficient_deer_overlap = overlap_cells >= minimum_overlap_cells,
      included = ala_records >= minimum_ala_records &&
        overlap_cells >= minimum_overlap_cells,
      stringsAsFactors = FALSE
    ),
    locations = locations
  )
}

screened_candidates <- Map(
  screen_candidate,
  candidate_species$species,
  candidate_species$mean_mass_kg
)
screening <- do.call(
  rbind,
  lapply(screened_candidates, `[[`, "summary")
)
screening$exclusion_reason <- ifelse(
  screening$included,
  "included",
  ifelse(
    !screening$sufficient_ala_records & !screening$sufficient_deer_overlap,
    "insufficient ALA records and deer-grid overlap",
    ifelse(
      !screening$sufficient_ala_records,
      "insufficient ALA records",
      "insufficient deer-grid overlap"
    )
  )
)

included_indices <- which(screening$included)
included_colours <- c("black", "black", "black")
commercial_data <- setNames(
  lapply(commercial_species, download_ala_locations),
  commercial_species
)
commercial_ranges <- lapply(commercial_data, function(x) make_range_proxy(x$locations))
commercial_overlap <- do.call(
  rbind,
  Map(
    function(species, state) {
      calculate_commercial_overlap(
        species,
        state,
        commercial_ranges[[species]]
      )
    },
    commercial_harvest_states$species,
    commercial_harvest_states$state
  )
)

plot_deer_map(
  #"ALA occurrence records for harvested and included macropods",
  show_deer_legend = FALSE
)
for (i in seq_along(commercial_data)) {
  locations <- project(commercial_data[[i]]$locations, crs(deer))
  plot(
    locations,
    add = TRUE,
    col = "grey40",
    pch = 1,
    cex = 0.15
  )
}
for (i in seq_along(included_indices)) {
  locations <- project(
    screened_candidates[[included_indices[i]]]$locations,
    crs(deer)
  )
  plot(
    locations,
    add = TRUE,
    col = included_colours[i],
    pch = 16,
    cex = 0.15
  )
}
legend(
  x = -1100000,
  y = -3750000,
  legend = c(
    "verified deer points",
    "modelled deer occurrence",
    "commercially harvested macropods",
    "added macropods"
  ),
  col = c("darkgreen", "lightgreen", "grey40", "black"),
  pch = c(15, 15, 1, 1),
  cex = 0.75,
  y.intersp = 0.75,
  bg = NA,
  bty = "n",
  xjust = 0,
  yjust = 1
)

write.csv(
  screening,
  "data/macropod_overlap_screening_2026.csv",
  row.names = FALSE
)
write.csv(
  screening[screening$included, c(
    "species",
    "ala_scientific_name",
    "ala_records",
    "overlap_cells",
    "overlap_area_km2",
    "mean_mass_kg"
  )],
  "data/macropod_deer_overlap_2026.csv",
  row.names = FALSE
)
write.csv(
  commercial_overlap,
  "data/commercial_macropod_deer_overlap_2026.csv",
  row.names = FALSE
)
