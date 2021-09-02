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
  to_char <- sapply(var[,6],as.character)
  pool <- sapply(var[,5],as.character)
  names <- sapply(var[,3],as.character)
  # init empty df
  plot_df <- data.frame()

  # for avg of PFTs add all 365 days to plot_df
  for(i in 1:length(to_char)) {
    j <- apply(ncvar_get(data, to_char[i]), 2, mean)
    s <- apply(ncvar_get(data, pool[i]), 2, mean)
    s0 <- j + s
    final <- s / s0
    plot_df <- rbind(plot_df, final)
  }

  x <- rep('Flux (gN/dt)',8)
  
  # transpose for ggplot
  plot_df <- t(plot_df) %>% as.data.frame()
  #find mean,max,and min of each variable
  sd <- summarise_all(plot_df, sd) %>% t
  means <- summarise_all(plot_df, mean) %>%
    t %>%
    bind_cols(sd) %>%
    bind_cols(names)

  # rename columns for plotting
  colnames(means) <- c("f", "sd1", "Flux")
  # means <- var
  means <- bind_cols(means, var[,1:2])
  
  return(
    ggplot(data = means, aes(x=f, y=Epsilon, group = Flux, color= Flux))+
      geom_point(size = 3)+
      geom_errorbar(aes(xmin=f-sd1, xmax=f+sd1), width=.001,
                    position=position_dodge(0.5), size = 1)+
      geom_errorbar(aes(ymin=Epsilon-sd2,ymax=Epsilon+sd2), width=.0001,
                    position = position_dodge(0.5), size = 1)+
      theme(text = element_text(size = 16))+
      ylab("Epsilon (‰)")
  )
}

f_plot <- plot_rows(ncin, var_names)

ggsave(
  filename = 'importance.png',
  plot = f_plot,
  device = 'png',
  bg = 'white'
)