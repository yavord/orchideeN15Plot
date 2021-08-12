library(ncdf4)
library(ggplot2)
library(dplyr)
library(magrittr)
theme_set(theme_minimal())


# This script takes an .nc file output from ORCHIDEE and plots the pool and all
# corresponding fluxes for a nitrogen species


# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "anspin.nc"
ncfname <- paste(ncpath,ncname,sep = "")

varname <- "pools/otherPools.csv"
varfname <- paste(ncpath,varname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)
# open variable names
var_names <- read.csv(varfname)

plot_all <- function(data, all_var) {
  # convert vars from int to char
  to_char <- mutate_all(.tbl = all_var, as.character)
  
  # create empty data frame for plot data
  plot_df <- data.frame()
  
  # For avg of PFTs add all 365 days to plot_df
  for(i in 1:nrow(to_char)) {
    for (j in 1:ncol(to_char)) {
      var_mean <- apply(ncvar_get(data,to_char[i,j]), 2, mean) # mean of all PFTs
      plot_df <- rbind(plot_df, var_mean)
    }
  }
  
  # transpose and change row names for ggplot
  plot_df <- t(plot_df) %>% as.data.frame()
  rownames(plot_df) <- c(1:nrow(plot_df))
  
  # return ggplot of final plot
  return(
    ggplot(plot_df, aes(x=1:365))+
      scale_x_continuous(name = "Day", breaks = seq(0,365,50))+
      scale_y_continuous(name = "gN", trans = 'log10')+
      geom_line(aes(y=plot_df[,1]), color = 'darkred')+
      geom_line(aes(y=plot_df[,2]), color = 'darkred', linetype='dashed')+
      geom_line(aes(y=plot_df[,3]), color = 'cadetblue')+
      geom_line(aes(y=plot_df[,4]), color = 'cadetblue', linetype='dashed')+
      geom_line(aes(y=plot_df[,5]), color = 'lightpink4')+
      geom_line(aes(y=plot_df[,6]), color = 'lightpink4', linetype='dashed')+
      geom_line(aes(y=plot_df[,7]), color = 'green4')+
      geom_line(aes(y=plot_df[,8]), color = 'green4', linetype='dashed')+
      geom_line(aes(y=plot_df[,9]), color = 'tomato')+
      geom_line(aes(y=plot_df[,10]), color = 'tomato', linetype='dashed')+
      geom_line(aes(y=plot_df[,11]), color = 'orange')+
      geom_line(aes(y=plot_df[,12]), color = 'orange', linetype='dashed')
  )
}

f_plot <- plot_all(ncin,var_names)
ggsave(
  filename = "pool.png",
  plot = f_plot,
  device = 'png',
  bg = 'white'
)
