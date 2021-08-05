library(ncdf4)
library(stringr)
library(magrittr)
library(tidyr)
library(grid)
library(gridExtra)

# This script takes an .nc file and .csv containing the names of all N cycle 
# variables in ORCHIDEE that support stable isotope values and returns a 
# table containing their mean relative differences



# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "final1.nc"
varname <- "var.csv"
ncfname <- paste(ncpath,ncname,sep = "")
varfname <- paste(ncpath,varname,sep = "")

# ouput
outpath <- "/home/yavor/Documents/mint/wd/ncdf/output/"
outfname <- paste(outpath,ncname,".jpg",sep = "")

# open ncdf
ncin <- nc_open(ncfname)
# open ncycle var names
var_names <- read.csv(varfname,header = T) 
# create df that holds final mean relative difference
diff_df <- data.frame(N_process = 1:nrow(var_names), MRD = 1:nrow(var_names))


for (row in 1:nrow(var_names)) {
  # Variable names
  nTot_name <- toString(var_names[row,1])
  n15_name <- toString(var_names[row,2])

  # Create arrays from variable names
  nTot_array <- ncvar_get(ncin,nTot_name)
  n15_array <- ncvar_get(ncin,n15_name) * 2
  
  # Get mean relative difference
  MRD <- all.equal(n15_array, nTot_array, tolerance = 10^-8) %>%
    str_split(": ") %>% 
    unlist()

  # Fill out MRD df
  diff_df[row, 1] <- nTot_name
  diff_df[row, 2] <- MRD[2]
}

# Set NA vals to 0
diff_df[is.na(diff_df)] <- 0

# plot table
jpeg(outfname)
grid.table(diff_df)
dev.off()


