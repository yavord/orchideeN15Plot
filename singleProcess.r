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
  # convert var to char
  to_char <- sapply(var_row,as.character)
  # init empty df
  plot_df <- data.frame()
  
  # for avg of PFTs add all 365 days to plot_df
  for(i in 1:length(to_char)) {
    var_mean <- apply(ncvar_get(data, to_char[i]), 2, mean)
    plot_df <- rbind(plot_df, var_mean)
  }
  
  # transpose for ggplot
  plot_df <- t(plot_df) %>% as.data.frame()
  rownames(plot_df) <- c(1:nrow(plot_df))

  # plot
  return(
    ggplot(plot_df, aes(x=1:365))+
      scale_x_continuous(name = "Day", breaks = seq(0,365,50))+
      scale_y_continuous(name = "gN", trans = 'log10')+
      geom_line(aes(y=plot_df[,1]), color = 'darkred')+
      geom_line(aes(y=plot_df[,2]), color = 'darkred', linetype='dashed')+
      geom_line(aes(y=plot_df[,3]), color = 'steelblue')+
      geom_line(aes(y=plot_df[,4]), color = 'steelblue', linetype='dashed')+
      geom_line(aes(y=plot_df[,5]), color = 'orange')+
      geom_line(aes(y=plot_df[,6]), color = 'orange', linetype='dashed')
  )
}

f_plot <- plot_rows(ncin, var_names[1,])
ggsave(
  filename = 'process.png',
  plot = f_plot,
  device = 'png',
  bg = 'white'
)
