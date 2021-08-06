library(ncdf4)
library(ggplot2)
library(magrittr)
library(caret)
theme_set(theme_minimal())

# This script takes an .nc file output from ORCHIDEE and returns a plot of all
# fluxes and pools for nitrification and denitrification

# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "final1.nc"
varname <- "varProcess.csv"
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
  pool15_array <- ncvar_get(data,to_char[2])
  flux_array <- ncvar_get(data,to_char[3])
  flux15_array <- ncvar_get(data,to_char[4])

  plot_df <- data.frame(
    pool_array[4,],
    pool15_array[4,],
    flux_array[4,],
    flux15_array[4,]
  )

  return(
    ggplot(plot_df, aes(x=1:12))+
      labs(y="gN")+
      scale_x_continuous(name = "Month", breaks = seq(1,12,1))+
      geom_line(aes(y=plot_df[,1]), color = 'darkred')+
      geom_line(aes(y=plot_df[,2]), color = 'darkred', linetype='dashed')+
      geom_line(aes(y=plot_df[,3]), color = 'steelblue')+
      geom_line(aes(y=plot_df[,3]), color = 'steelblue', linetype='dashed')
  )
}

# center and scale data
# pp <- preProcess(denitrifDf, method = c("range"))
# # pp <- preProcess(denitrifDf, method = c("scale","center"))
# norm <- predict(pp, denitrifDf)
# log <- log(denitrifDf)  

# plots <- lapply(var_names[1:4,], plot_row, data = ncin)

test <- plot_rows(ncin, var_names[3,])
# ggsave(
#   filename = '1.png',
#   plot = test,
#   device = 'png'
# )
