library(ncdf4)
library(ggplot2)
library(magrittr)
library(caret)
theme_set(theme_minimal())

# This script takes an .nc file output from ORCHIDEE and returns a plot of all
# fluxes and pools for nitrification and denitrification

# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "anspin.nc"
varname <- "process.csv"
ncfname <- paste(ncpath,ncname,sep = "")
varfname <- paste(ncpath,varname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)
# open csv of process names
var_names <- read.csv(varfname,header = T)

# process variable names, convert dash separator to list
dash_to_list <- function(x) {
  return(el(strsplit(toString(x), "-")))
}

plot_rows <- function(data, var_row) {
  to_char <- sapply(var_row,as.character)
  
  pool_array <- ncvar_get(data,to_char[1])
  pool_15_array <- ncvar_get(data,to_char[2])
  flux_array <- ncvar_get(data,to_char[3])
  flux15_array <- ncvar_get(data,to_char[4])
  pool2_array <- ncvar_get(data,to_char[5])
  pool2_15_array <- ncvar_get(data,to_char[6])

  # TODO: average out for all PFTs?
  pft <- 1

  plot_df <- data.frame(
    pool_array[pft,],
    pool_15_array[pft,],
    flux_array[pft,],
    flux15_array[pft,],
    pool2_array[pft,],
    pool2_15_array[pft,]
  )
  
  return(
    ggplot(plot_df, aes(x=1:365))+
    # ggplot(plot_df, aes(x=1:12))+
      labs(y="gN")+
      scale_x_continuous(name = "Day", breaks = seq(0,365,50))+
      # scale_x_continuous(name = "Month", breaks = seq(1,12,1))+
      scale_y_continuous(trans = 'log10')+
      geom_line(aes(y=plot_df[,1]), color = 'darkred')+
      geom_line(aes(y=plot_df[,2]), color = 'darkred', linetype='dashed')+
      geom_line(aes(y=plot_df[,3]), color = 'steelblue')+
      geom_line(aes(y=plot_df[,4]), color = 'steelblue', linetype='dashed')+
      geom_line(aes(y=plot_df[,5]), color = 'orange')+
      geom_line(aes(y=plot_df[,6]), color = 'orange', linetype='dashed')
  )
}

# plots <- lapply(var_names[1:2,], plot_row, data = ncin)

f_plot <- plot_rows(ncin, var_names[1,])
ggsave(
  filename = 'process.png',
  plot = f_plot,
  device = 'png',
  bg = 'white'
)
