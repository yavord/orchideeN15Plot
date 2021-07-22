library(ncdf4)
library(ggplot2)

# This script takes an .nc file output from ORCHIDEE and returns a plot of all
# fluxes and pools for a single process of the user's choice


# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "short_20100101_20101231_1M_stomate_history.nc"
ncfname <- paste(ncpath,ncname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)

# variable names
no3name <- "SOIL_NO3"
no3_15name <- "SOIL_NO3_15"
noxname <- "SOIL_NOX"
nox_15name <- "SOIL_NOX_15"
dname <- "DENITRIFICATION"
d15name <- "DENITRIFICATION1"
 
# create arrays for each variable
no3array
no3_15array
noxarray
nox_15array
darray
d15array

# select pft for slices
pft <- 1

# slice data based on pft
no3slice
no3_15slice
noxslice
nox_15slice
dslice
d15slice
