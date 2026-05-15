## deer vs. macropod biomass calculations
# Corey Bradshaw
# May 2026

## libraries
library(ggplot2)
library(ggpubr)

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
N_tot_now_Lo <- 1000000 # https://invasives.org.au/blog/background-briefing-australias-deer-plague/
N_tot_now_Up <- 2000000 # https://invasives.org.au/blog/background-briefing-australias-deer-plague/
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

## state-specific N estimates for each macropod species
## https://www.dcceew.gov.au/sites/default/files/documents/kangaroo-statistics-states-2022.pdf
N_Oru_NSW <- 2915853; N_Oru_QLD <- 6371750; N_Oru_SA <- 2019168; N_Oru_WA <- 609155
N_Mg_NSW <- 5883251; N_Mg_QLD <- 9592950; N_Mg_SA <- 121539; N_Mg_VIC <- 1181925
N_Mf_NSW <- 470180; N_Mf_SA <- 954571; N_Mf_VIC <- 1181925; N_Mf_WA <- 1086235
N_Oro_NSW <- 365616; N_Oro_QLD <- 1763000; N_Oro_SA <- 121539
N_Ne_SA <- 384671

## N total across states per species
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
macropod.dat <- data.frame(species = c("Osphranter rufus", "Macropus giganteus", "Macropus fuliginosus", "Osphranter robustus", "Notamacropus eugenii"),
                             biomass = c(B_Oru, B_Mg, B_Mf, B_Oro, B_Ne))
sum(macropod.dat[,c("biomass")])

## % deer of macropod biomass
pc_deer_of_macropod <- 100 * colSums(deer.dat[,c("biomass_Lo", "biomass_Up", "biomass_Md")]) / sum(macropod.dat[,c("biomass")])
pc_deer_of_macropod

plt2 <- ggplot(macropod.dat, aes(x = reorder(species, -biomass), y = biomass)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  xlab("") +
  ylab("biomass (tonnes)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "italic"))

## plot horizontal bar graph comparing total deer and total macropod biomass in descending order
total.dat <- data.frame(group = c("deer", "macropods"),
                        biomass_Lo = c(sum(deer.dat$biomass_Lo), sum(macropod.dat$biomass)),
                        biomass_Up = c(sum(deer.dat$biomass_Up), sum(macropod.dat$biomass)),
                        biomass_Md = c(sum(deer.dat$biomass_Md), sum(macropod.dat$biomass)))

plt3 <- ggplot(total.dat, aes(x = group, y = biomass_Md)) +
  geom_bar(stat = "identity", fill = c("lightblue", "lightgreen")) +
  geom_errorbar(data = subset(total.dat, group == "deer"), aes(ymin = biomass_Lo, ymax = biomass_Up), width = 0.2) +
  coord_flip() +
  xlab("") +
  ylab("biomass (tonnes)")

## plot together
ggarrange(plt1, plt2, plt3, ncol = 1, nrow = 3, heights = c(1, 1, 0.5))
