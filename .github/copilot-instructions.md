# Copilot Instructions

## Commands

```sh
Rscript scripts/biomasscalc.R
```

The repository does not currently define separate build, test, lint, or single-test commands.

## High-level architecture

- `scripts/biomasscalc.R` is the entire analysis pipeline. It loads `ggplot2` and `ggpubr`, hard-codes the deer and macropod source assumptions, computes biomass estimates, builds `deer.dat`, `macropod.dat`, and `total.dat`, and combines three plots with `ggarrange()`.
- The deer section models uncertainty with lower and upper bounds for total population and carries those bounds through to biomass error bars.
- The macropod section uses single-value body masses plus state-specific population counts that are summed into species totals before biomass is calculated.
- `README.md` is the main narrative document. It defines the project scope, species included, and required R libraries, so keep it aligned with any change to species coverage or dependencies.
- `www/` contains image assets used by the README and does not participate in the R analysis workflow.

## Key conventions

- Core inputs are embedded directly in `scripts/biomasscalc.R`; there are no external data files or helper modules to update instead.
- Variable prefixes are meaningful and used consistently: `M_` for body mass, `N_` for population size, `Np_` for deer population proportions, `B_` for biomass.
- Species identifiers are abbreviated in variable names (`Ce`, `Dd`, `Ru`, `Ca`, `Rt`, `Ap`, `Oru`, `Mg`, `Mf`, `Oro`, `Ne`) and are documented in comments immediately above each block.
- Deer calculations keep separate low/high values (`*_Lo`, `*_Up`) and only derive midpoint values when preparing the plotting data frame.
- Plotting is done from hand-built data frames rather than a long-format transformation pipeline, so changes to the analysis usually require updating both the scalar calculations and the corresponding plotting table rows.
