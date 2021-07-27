library(ncdf4)
library(ggplot2)
library(magrittr)
library(caret)
theme_set(theme_minimal())

# This script takes an .nc file output from ORCHIDEE and returns a plot of all
# fluxes and pools for a single process of the user's choice


# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "normal.nc"
# varname 
ncfname <- paste(ncpath,ncname,sep = "")
# varfname

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
no3array <- ncvar_get(ncin,no3name)
no3_15array <- ncvar_get(ncin,no3_15name)
noxarray <- ncvar_get(ncin,noxname)
nox_15array <- ncvar_get(ncin,nox_15name)
darray <- ncvar_get(ncin,dname)
d15array <- ncvar_get(ncin,d15name)

# select pft for slices
pft <- 1

# slice data based on pft
no3slice <- no3array[pft,]
no3_15slice <- no3_15array[pft,]
noxslice <- noxarray[pft,]
nox_15slice <- nox_15array[pft,]
dslice <- darray[pft,]
d15slice <- d15array[pft,]

# add slices to final df for plotting
denitrifDf <- data.frame(
  no3slice,
  no3_15slice,
  noxslice,
  nox_15slice,
  dslice,
  d15slice
)

# center and scale data
pp <- preProcess(denitrifDf, method = c("range"))
# pp <- preProcess(denitrifDf, method = c("scale","center"))
norm <- predict(pp, denitrifDf)
log <- log(denitrifDf)  

ggplot(norm, aes(x= 1:12))+
  labs(y = "gN (normalized)")+
  scale_x_continuous(name = "Month", breaks = seq(1,12,1))+
  geom_line(aes(y = `no3_15slice`), color = 'darkred')+
  geom_line(aes(y = `nox_15slice`), color = 'steelblue')+
  geom_line(aes(y = `d15slice`), color = 'darkseagreen')


