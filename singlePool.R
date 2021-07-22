library(ncdf4)
library(ggplot2)

# This script takes an .nc file output from ORCHIDEE and plots the pool and all
# corresponding fluxes for a nitrogen species


# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "short_20100101_20101231_1M_stomate_history.nc"
ncfname <- paste(ncpath,ncname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)

# variable names
pname <- "SOIL_NOX"
p15name <- "SOIL_NOX_15"
f1name <- "NITRIFICATION_N15_3"
f2name <- "DENITRIFICATION1"
f3name <- "DENITRIFICATION2"
f4name <- "NOX_15_EMISSION"

# create arrays from variable names
parray <- log(ncvar_get(ncin,pname))
p15array <- log(ncvar_get(ncin,p15name))
f1array <- log(ncvar_get(ncin,f1name))
f2array <- log(ncvar_get(ncin,f2name))
f3array <- log(ncvar_get(ncin,f3name))
f4array <- log(ncvar_get(ncin,f4name))

# select pft for slices
pft <- 1

# slice data based on pft
pslice <- parray[pft,]
p15slice <- p15array[pft,]
f1slice <- f1array[pft,]
f2slice <- f2array[pft,]
f3slice <- f3array[pft,]
f4slice <- f4array[pft,]

# plot slices
plot(pslice, type = "b", col = "red")
lines(p15slice, type = "b", col = "blue")
lines(f1slice, type = "b", col = "green")
lines(f2slice, type = "b", col = "purple")
lines(f3slice, type = "b", col = "pink")
lines(f4slice, type = "b", col = "orange")