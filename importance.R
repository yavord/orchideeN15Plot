library(ncdf4)
library(ggplot2)
library(magrittr)
library(caret)
library(dplyr)
theme_set(theme_minimal())

# path and filename
ncpath <- "/home/yavor/Documents/mint/wd/ncdf/input/"
ncname <- "anspin2.nc"
varname <- "importance.csv"
ncfname <- paste(ncpath,ncname,sep = "")
varfname <- paste(ncpath,varname,sep = "")

# open ncdf
ncin <- nc_open(ncfname)
# open csv of process names
var_names <- read.csv(varfname,header = T)

plot_rows <- function(data, var) {
  # convert var to char
  to_char <- sapply(var,as.character)
  # init empty df
  plot_df <- data.frame()
  
  # for avg of PFTs add all 365 days to plot_df
  for(i in 1:length(to_char)) {
    var_mean <- apply(ncvar_get(data, to_char[i]), 2, mean)
    plot_df <- rbind(plot_df, var_mean)
  }
  
  # transpose for ggplot
  plot_df <- t(plot_df) %>% as.data.frame()
  #find mean,max,and min of each variable
  sd <- summarise_all(plot_df, sd) %>% t
  min <- summarise_all(plot_df, min) %>% t
  max <- summarise_all(plot_df, max) %>% t
  means <- summarise_all(plot_df, mean) %>%
    t %>%
    bind_cols(sd) %>%
    bind_cols(to_char)
  
  # rename columns for plotting
  colnames(means) <- c("Concentration (gN)/dt", "sd", "Flux")

  return(
    ggplot(data = means, aes(x=`Concentration (gN)/dt`, y=Flux))+
      geom_bar(stat = 'identity', color = 'black', fill = 'steelblue',
               position=position_dodge())+
      geom_errorbar(aes(xmin=`Concentration (gN)/dt`-sd, xmax=`Concentration (gN)/dt`+sd), width=.2,
                    position=position_dodge(.9))
  )
}

f_plot <- plot_rows(ncin, var_names)

ggsave(
  filename = 'importance.png',
  plot = f_plot,
  device = 'png',
  bg = 'white'
)