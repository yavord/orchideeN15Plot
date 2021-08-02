library(ncdf4)
library(ggplot2)
library(magrittr)
library(caret)
theme_set(theme_minimal())

# This script takes an .nc file output from ORCHIDEE and returns a plot of all
# fluxes and pools for nitrification and denitrification
# ,poolSub,poolSub_15,flux,flux_15

# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "final1.nc"
varname <- "varProcess.csv"
ncfname <- paste(ncpath,ncname,sep = "")
varfname <- paste(ncpath,varname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)
# open csv of process names
var_name <- read.csv(varfname)

