## deer vs. macropod biomass calculations
# Corey Bradshaw
# May 2026 / updated Oct 2026

## libraries
library(ggplot2)
library(ggpubr)
library(terra)

## DEER
## deer body masses (M) in kg
## Ce = Cervus elaphus (red deer); Dd = Dama dama (fallow deer); Ru = Rusa unicolor (Sambar deer);
## Ca = Cervus axis (chital deer); Rt = Rusa timorensis (rusa deer); Ap = Axis porcinus (hog deer)
## m = male; f = female
## Lo = lower limit; Up = upper limit
## sources: feralscan.org.au/deerscan/content/deer_fallow; feralscan.org.au/deerscan/content/deer_reddeer;
## feralscan.org.au/deerscan/content/deer_sambardeer; feralscan.org.au/deerscan/content/deer_chitaldeer;
## feralscan.org.au/deerscan/content/deer_rusadeer; feralscan.org.au/deerscan/content/deer_hogdeer
## https://doi.org/10.1071/WR23028

# Cervus elaphus
M_Ce_m_Lo <- 135; M_Ce_m_Up <- 220
M_Ce_m_Mn <- 180.0;
# M_Ce_m_SD <- 0 # https://doi.org/10.1071/WR23028
M_Ce_m_SD <- (M_Ce_m_Up - mean(c(M_Ce_m_Up, M_Ce_m_Lo)))/1.96 # SD = (upper limit - mean)/1.96 assuming range = 95% confidence interval
M_Ce_f_Lo <- 95; M_Ce_f_Up <- 95 # no range provided
M_Ce_f_Mn <- 153.3; M_Ce_f_SD <- 4.7 # https://doi.org/10.1071/WR23028

# Dama dama
M_Dd_m_Lo <- 60; M_Dd_m_Up <- 100
M_Dd_f_Lo <- 40; M_Dd_f_Up <- 50

# Rusa unicolor
#M_Ru_m_Lo <- 300; M_Ru_m_Up <- 300 # no range provided
M_Ru_m_Mn <- 199.6; M_Ru_m_SD <- 22.0 # https://doi.org/10.1071/WR23028 
#M_Ru_f_Lo <- 230; M_Ru_f_Up <- 230 # no range provided
M_Ru_f_Mn <- 147.7; M_Ru_f_SD <- 11.4 # https://doi.org/10.1071/WR23028

# Cervus axis
M_Ca_m_Lo <- 85; M_Ca_m_Up <- 85 # no range provided
M_Ca_f_Lo <- 60; M_Ca_f_Up <- 60 # no range provided

# Rusa timorensis
M_Rt_m_Lo <- 135; M_Rt_m_Up <- 135 # no range provided
M_Rt_f_Lo <- 90; M_Rt_f_Up <- 90 # no range provided

# Axis porcinus
M_Ap_m_Lo <- 55; M_Ap_m_Up <- 55 # no range provided
M_Ap_f_Lo <- 30; M_Ap_f_Up <- 30 # no range provided

## mean species mass
M_Ce <- mean(c(M_Ce_m_Mn, M_Ce_f_Mn)) # use mean of male and female means
M_Dd <- mean(c(M_Dd_m_Lo, M_Dd_m_Up, M_Dd_f_Lo, M_Dd_f_Up))
M_Ru <- mean(c(M_Ru_m_Mn, M_Ru_f_Mn)) # use mean of male and female means
M_Ca <- mean(c(M_Ca_m_Lo, M_Ca_m_Up, M_Ca_f_Lo, M_Ca_f_Up))
M_Rt <- mean(c(M_Rt_m_Lo, M_Rt_m_Up, M_Rt_f_Lo, M_Rt_f_Up))
M_Ap <- mean(c(M_Ap_m_Lo, M_Ap_m_Up, M_Ap_f_Lo, M_Ap_f_Up))

## proportion (p) of total population (N) per species (from Moriarty 2004 doi:10.1071/WR02100)
N_past <- 196000 # Moriarty (2004) gave a total N = 196000 for all 6 species combined
Np_Ce <- 32500/N_past
Np_Dd <- 55500/N_past
Np_Ru <- 70700/N_past
Np_Ca <- 13000/N_past
Np_Rt <- 15000/N_past
Np_Ap <- 9300/N_past

## per-species total population size today, assuming 1-2 million deer in total across Australia
#N_tot_now_Lo <- 1000000 # https://invasives.org.au/blog/background-briefing-australias-deer-plague/
#N_tot_now_Up <- 2000000 # https://invasives.org.au/blog/background-briefing-australias-deer-plague/
N_tot_now_Lo <- 500000 # assume 50% of lower bound
N_tot_now_Up <- 4000000 # assume 2× upper bound

N_Ce_Lo <- Np_Ce * N_tot_now_Lo
N_Ce_Up <- Np_Ce * N_tot_now_Up
N_Dd_Lo <- Np_Dd * N_tot_now_Lo
N_Dd_Up <- Np_Dd * N_tot_now_Up
N_Ru_Lo <- Np_Ru * N_tot_now_Lo
N_Ru_Up <- Np_Ru * N_tot_now_Up
N_Ca_Lo <- Np_Ca * N_tot_now_Lo
N_Ca_Up <- Np_Ca * N_tot_now_Up
N_Rt_Lo <- Np_Rt * N_tot_now_Lo
N_Rt_Up <- Np_Rt * N_tot_now_Up
N_Ap_Lo <- Np_Ap * N_tot_now_Lo
N_Ap_Up <- Np_Ap * N_tot_now_Up

## deer biomass (B = (N * M)/1000) in tonnes
B_Ce_Lo <- N_Ce_Lo * M_Ce / 1000
B_Ce_Up <- N_Ce_Up * M_Ce / 1000
B_Dd_Lo <- N_Dd_Lo * M_Dd / 1000
B_Dd_Up <- N_Dd_Up * M_Dd / 1000
B_Ru_Lo <- N_Ru_Lo * M_Ru / 1000
B_Ru_Up <- N_Ru_Up * M_Ru / 1000
B_Ca_Lo <- N_Ca_Lo * M_Ca / 1000
B_Ca_Up <- N_Ca_Up * M_Ca / 1000
B_Rt_Lo <- N_Rt_Lo * M_Rt / 1000
B_Rt_Up <- N_Rt_Up * M_Rt / 1000
B_Ap_Lo <- N_Ap_Lo * M_Ap / 1000
B_Ap_Up <- N_Ap_Up * M_Ap / 1000


## MACROPODS
## macropod body masses (M) in kg
## Oru = Osphranter rufus; Mg = Macropus giganteus; Mf = Macropus fuliginosus
## Oro = Osphranter robustus; Ne = Notamacropus eugenii
## source: Fisher et al. 2001, doi:10.1890/0012-9658(2001)082[3531:TEBOLH]2.0.CO;2
M_Oru <- 26.5
M_Mg <- 17.8
M_Mf <- 16
M_Oro <- 15.6
M_Ne <- 5.28

## State-specific N estimates for commercially harvested macropods
## https://www.dcceew.gov.au/sites/default/files/documents/kangaroo-statistics-states-2022.pdf
N_Oru_NSW_raw <- 2915853; N_Oru_QLD_raw <- 6371750; N_Oru_SA_raw <- 2019168; N_Oru_WA_raw <- 609155
N_Mg_NSW_raw <- 5883251; N_Mg_QLD_raw <- 9592950; N_Mg_SA_raw <- 121539; N_Mg_VIC_raw <- 1181925
N_Mf_NSW_raw <- 470180; N_Mf_SA_raw <- 954571; N_Mf_VIC_raw <- 1181925; N_Mf_WA_raw <- 1086235
N_Oro_NSW_raw <- 365616; N_Oro_QLD_raw <- 1763000; N_Oro_SA_raw <- 121539
N_Ne_SA <- 384671

## Proportion of each state-specific range proxy overlapping the deer grid
## Range proxies are concave hulls around unique occupied post-2000 ALA cells.
## See scripts/calculate_macropod_overlap.R and
## data/commercial_macropod_deer_overlap_2026.csv.
setwd("~/Documents/GitHub/deermacropodBiomass")
commercial_overlap.dat <- read.csv("data/commercial_macropod_deer_overlap_2026.csv")
deer_overlap_fraction <- function(species, state) {
  fraction <- commercial_overlap.dat$deer_overlap_fraction[
    commercial_overlap.dat$species == species &
      commercial_overlap.dat$state == state
  ]
  if (length(fraction) != 1) {
    stop(
      sprintf("Expected one deer-overlap fraction for %s in %s.", species, state),
      call. = FALSE
    )
  }
  fraction
}

N_Oru_NSW <- N_Oru_NSW_raw * deer_overlap_fraction("Osphranter rufus", "NSW")
N_Oru_QLD <- N_Oru_QLD_raw * deer_overlap_fraction("Osphranter rufus", "QLD")
N_Oru_SA <- N_Oru_SA_raw * deer_overlap_fraction("Osphranter rufus", "SA")
N_Oru_WA <- N_Oru_WA_raw * deer_overlap_fraction("Osphranter rufus", "WA")
N_Mg_NSW <- N_Mg_NSW_raw * deer_overlap_fraction("Macropus giganteus", "NSW")
N_Mg_QLD <- N_Mg_QLD_raw * deer_overlap_fraction("Macropus giganteus", "QLD")
N_Mg_SA <- N_Mg_SA_raw * deer_overlap_fraction("Macropus giganteus", "SA")
N_Mg_VIC <- N_Mg_VIC_raw * deer_overlap_fraction("Macropus giganteus", "VIC")
N_Mf_NSW <- N_Mf_NSW_raw * deer_overlap_fraction("Macropus fuliginosus", "NSW")
N_Mf_SA <- N_Mf_SA_raw * deer_overlap_fraction("Macropus fuliginosus", "SA")
N_Mf_VIC <- N_Mf_VIC_raw * deer_overlap_fraction("Macropus fuliginosus", "VIC")
N_Mf_WA <- N_Mf_WA_raw * deer_overlap_fraction("Macropus fuliginosus", "WA")
N_Oro_NSW <- N_Oro_NSW_raw * deer_overlap_fraction("Osphranter robustus", "NSW")
N_Oro_QLD <- N_Oro_QLD_raw * deer_overlap_fraction("Osphranter robustus", "QLD")
N_Oro_SA <- N_Oro_SA_raw * deer_overlap_fraction("Osphranter robustus", "SA")

## N total across states per species after deer-range adjustment
N_Oru <- N_Oru_NSW + N_Oru_QLD + N_Oru_SA + N_Oru_WA
N_Mg <- N_Mg_NSW + N_Mg_QLD + N_Mg_SA + N_Mg_VIC
N_Mf <- N_Mf_NSW + N_Mf_SA + N_Mf_VIC + N_Mf_WA
N_Oro <- N_Oro_NSW + N_Oro_QLD + N_Oro_SA
N_Ne <- N_Ne_SA

## macropod biomass (B = (N * M)/1000) in tonnes
B_Oru <- N_Oru * M_Oru / 1000
B_Mg <- N_Mg * M_Mg / 1000
B_Mf <- N_Mf * M_Mf / 1000
B_Oro <- N_Oro * M_Oro / 1000
B_Ne <- N_Ne * M_Ne / 1000

## Additional macropods with occurrence records in the ABARES 2026 deer grid
## Wb = Wallabia bicolor; Nr = Notamacropus rufogriseus; Np = Notamacropus parryi
## Occurrence overlap is calculated from post-2000 ALA records and the 20-km
## ABARES deer-occurrence raster by scripts/calculate_macropod_overlap.R.
## Mean body masses are sex averages from Fisher et al. (2001),
## doi:10.1890/0012-9658(2001)082[3531:TEBOLH]2.0.CO;2.
## Density is predicted by Damuth's (1981) mammal allometry:
## log10(density per km2) = 4.23 - 0.75 * log10(mass in g),
## doi:10.1038/290699a0. Bounds use the configurable density multiplier, so
## these are screening estimates, not survey estimates.
overlap.dat <- read.csv("data/macropod_deer_overlap_2026.csv")
density_uncertainty_factor <- 3
overlap.dat$density_Md <- 10^4.23 * (overlap.dat$mean_mass_kg * 1000)^-0.75
overlap.dat$population_Md <- overlap.dat$overlap_area_km2 * overlap.dat$density_Md
overlap.dat$population_Lo <- overlap.dat$population_Md / density_uncertainty_factor
overlap.dat$population_Up <- overlap.dat$population_Md * density_uncertainty_factor
overlap.dat$biomass_Lo <- overlap.dat$population_Lo * overlap.dat$mean_mass_kg / 1000
overlap.dat$biomass_Up <- overlap.dat$population_Up * overlap.dat$mean_mass_kg / 1000
overlap.dat$biomass_Md <- overlap.dat$population_Md * overlap.dat$mean_mass_kg / 1000

## plot vertical bar graph for deer biomass by species in descending order
deer.dat <- data.frame(species = c("Rusa unicolor", "Cervus elaphus", "Dama dama", "Rusa timorensis", "Cervus axis", "Axis porcinus"),
                        biomass_Lo = c(B_Ru_Lo, B_Ce_Lo, B_Dd_Lo, B_Rt_Lo, B_Ca_Lo, B_Ap_Lo),
                        biomass_Up = c(B_Ru_Up, B_Ce_Up, B_Dd_Up, B_Rt_Up, B_Ca_Up, B_Ap_Up),
                        biomass_Md = c((B_Ru_Lo + B_Ru_Up)/2, (B_Ce_Lo + B_Ce_Up)/2, (B_Dd_Lo + B_Dd_Up)/2, (B_Rt_Lo + B_Rt_Up)/2, (B_Ca_Lo + B_Ca_Up)/2, (B_Ap_Lo + B_Ap_Up)/2))
colSums(deer.dat[,c("biomass_Lo", "biomass_Up", "biomass_Md")])

plt1 <- ggplot(deer.dat, aes(x = reorder(species, -biomass_Md), y = biomass_Md)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  xlab("") +
  ylab("biomass (tonnes)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"))


## plot vertical bar graph for macropod species in descending order
macropod.dat <- rbind(
  data.frame(
    species = c("Osphranter rufus", "Macropus giganteus", "Macropus fuliginosus",
                "Osphranter robustus", "Notamacropus eugenii"),
    biomass_Lo = c(B_Oru, B_Mg, B_Mf, B_Oro, B_Ne),
    biomass_Up = c(B_Oru, B_Mg, B_Mf, B_Oro, B_Ne),
    biomass_Md = c(B_Oru, B_Mg, B_Mf, B_Oro, B_Ne)
  ),
  overlap.dat[, c("species", "biomass_Lo", "biomass_Up", "biomass_Md")]
)
colSums(macropod.dat[, c("biomass_Lo", "biomass_Up", "biomass_Md")])

## % deer of macropod biomass
pc_deer_of_macropod <- 100 * c(
  sum(deer.dat$biomass_Lo) / sum(macropod.dat$biomass_Up),
  sum(deer.dat$biomass_Up) / sum(macropod.dat$biomass_Lo),
  sum(deer.dat$biomass_Md) / sum(macropod.dat$biomass_Md)
)
names(pc_deer_of_macropod) <- c("lower deer / upper macropod", "upper deer / lower macropod", "midpoint")
pc_deer_of_macropod

plt2 <- ggplot(macropod.dat, aes(x = reorder(species, -biomass_Md), y = biomass_Md)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  xlab("") +
  ylab("biomass (tonnes)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"))

## plot horizontal bar graph comparing total deer and total macropod biomass in descending order
total.dat <- data.frame(group = c("deer", "macropods"),
                        biomass_Lo = c(sum(deer.dat$biomass_Lo), sum(macropod.dat$biomass_Lo)),
                        biomass_Up = c(sum(deer.dat$biomass_Up), sum(macropod.dat$biomass_Up)),
                        biomass_Md = c(sum(deer.dat$biomass_Md), sum(macropod.dat$biomass_Md)))

plt3 <- ggplot(total.dat, aes(x = group, y = biomass_Md)) +
  geom_bar(stat = "identity", fill = c("lightblue", "lightgreen")) +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  coord_flip() +
  xlab("") +
  ylab("biomass (tonnes)")

## plot together
ggarrange(plt1, plt2, plt3, ncol = 1, nrow = 3, heights = c(1, 1, 0.5))


## DEER ALLOMETRIC DENSITY SCENARIO
## Estimate total deer abundance from the ABARES 2026 occurrence maps and
## Damuth's (1981) mammal density allometry used for the added macropods.
## The allometric species estimates determine the total; Moriarty's (2004)
## species proportions then allocate that total among the six deer species.
## As with the added macropods, bounds use density_uncertainty_factor.
deer_occurrence_area_km2 <- function(raster_path) {
  occurrence <- rast(raster_path)
  sum(!is.na(values(occurrence))) * prod(res(occurrence)) / 1e6
}

deer_allometric_input.dat <- data.frame(
  species = c(
    "Cervus elaphus",
    "Dama dama",
    "Rusa unicolor",
    "Cervus axis",
    "Rusa timorensis",
    "Axis porcinus"
  ),
  mass_kg = c(M_Ce, M_Dd, M_Ru, M_Ca, M_Rt, M_Ap),
  population_proportion = c(Np_Ce, Np_Dd, Np_Ru, Np_Ca, Np_Rt, Np_Ap),
  occurrence_raster = c(
    "RedDeerOccurrence2026.tif",
    "FallowDeerOccurrence2026.tif",
    "SambarDeerOccurrence2026.tif",
    "ChitalDeerOccurrence2026.tif",
    "RusaDeerOccurrence2026.tif",
    "HogDeerOccurrence2026.tif"
  )
)
deer_allometric_input.dat$occurrence_area_km2 <- vapply(
  file.path(
    "data",
    "FeralDeerOccurrence2026_data_v1.0.0",
    deer_allometric_input.dat$occurrence_raster
  ),
  deer_occurrence_area_km2,
  numeric(1)
)
deer_allometric_input.dat$density_Md <- 10^4.23 *
  (deer_allometric_input.dat$mass_kg * 1000)^-0.75
deer_allometric_input.dat$population_from_density_Md <-
  deer_allometric_input.dat$occurrence_area_km2 *
  deer_allometric_input.dat$density_Md
deer_allometric_input.dat

N_tot_allometric_Md <- sum(deer_allometric_input.dat$population_from_density_Md)
N_tot_allometric_Lo <- N_tot_allometric_Md / density_uncertainty_factor
N_tot_allometric_Up <- N_tot_allometric_Md * density_uncertainty_factor
N_tot_allometric <- c(
  lower = N_tot_allometric_Lo,
  midpoint = N_tot_allometric_Md,
  upper = N_tot_allometric_Up
)
N_tot_allometric

deer_allometric.dat <- data.frame(
  species = deer_allometric_input.dat$species,
  biomass_Lo = N_tot_allometric_Lo *
    deer_allometric_input.dat$population_proportion *
    deer_allometric_input.dat$mass_kg / 1000,
  biomass_Up = N_tot_allometric_Up *
    deer_allometric_input.dat$population_proportion *
    deer_allometric_input.dat$mass_kg / 1000,
  biomass_Md = N_tot_allometric_Md *
    deer_allometric_input.dat$population_proportion *
    deer_allometric_input.dat$mass_kg / 1000
)
colSums(deer_allometric.dat[, c("biomass_Lo", "biomass_Up", "biomass_Md")])

pc_allometric_deer_of_macropod <- 100 * c(
  sum(deer_allometric.dat$biomass_Lo) / sum(macropod.dat$biomass_Up),
  sum(deer_allometric.dat$biomass_Up) / sum(macropod.dat$biomass_Lo),
  sum(deer_allometric.dat$biomass_Md) / sum(macropod.dat$biomass_Md)
)
names(pc_allometric_deer_of_macropod) <- c(
  "lower deer / upper macropod",
  "upper deer / lower macropod",
  "midpoint"
)
pc_allometric_deer_of_macropod

plt1_allometric <- ggplot(
  deer_allometric.dat,
  aes(x = reorder(species, -biomass_Md), y = biomass_Md)
) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  xlab("") +
  ylab("biomass (tonnes)") +
  ggtitle("deer biomass from allometric population estimate") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"))

plt2_allometric <- ggplot(
  macropod.dat,
  aes(x = reorder(species, -biomass_Md), y = biomass_Md)
) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  xlab("") +
  ylab("biomass (tonnes)") +
  ggtitle("macropod biomass") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"))

total_allometric.dat <- data.frame(
  group = c("deer", "macropods"),
  biomass_Lo = c(
    sum(deer_allometric.dat$biomass_Lo),
    sum(macropod.dat$biomass_Lo)
  ),
  biomass_Up = c(
    sum(deer_allometric.dat$biomass_Up),
    sum(macropod.dat$biomass_Up)
  ),
  biomass_Md = c(
    sum(deer_allometric.dat$biomass_Md),
    sum(macropod.dat$biomass_Md)
  )
)

plt3_allometric <- ggplot(
  total_allometric.dat,
  aes(x = group, y = biomass_Md)
) +
  geom_bar(stat = "identity", fill = c("lightblue", "lightgreen")) +
  geom_errorbar(aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  coord_flip() +
  xlab("") +
  ylab("biomass (tonnes)") +
  ggtitle("total biomass from allometric deer population estimate")

ggarrange(
  plt1_allometric,
  plt2_allometric,
  plt3_allometric,
  ncol = 1,
  nrow = 3,
  heights = c(1, 1, 0.5)
)
