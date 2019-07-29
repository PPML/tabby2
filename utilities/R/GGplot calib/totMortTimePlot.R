#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

  #read in the target data
  #find file name
  fn<-list.files(pattern="tot_mort",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
  target_df <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data

  #read in the model output data
  #find file name
  fn<-list.files(pattern="mort_yr_nat",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
  outcomes_df0 <-as.data.frame(readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS")))

#update the column names for legend use
target_df[,2]<-target_df[,2]/1e6
target_df<-as.data.frame(target_df)
colnames(target_df)<-c("year", "total deaths target")

#get years
years<-target_df[,1]
#subset the outcomes data to match the years
outcomes_df1<-outcomes_df0[years-1949,]
#format the outcomes data into one dataframe and update column names for legend
outcomes_df<-as.data.frame(cbind(years,outcomes_df1))
colnames(outcomes_df)<-c("year", "total deaths model output")
#reshape the target data
rtarget<-melt(target_df,id="year")
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year" )
#set up the plot options
ggplot() + theme_bw() +  scale_y_log10() + ylab("Deaths in Millions") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(1,2)))) +
  scale_x_continuous(breaks = c(seq(years[1],years[length(years)],10), years[length(years)])) +
  #add the target data
  geom_line(data=rtarget, aes(x=year, y=value, color=variable), linetype="dashed") +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value, color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("black","grey"))+
  #add plot title
  ggtitle(paste0("Total Death Counts in ", loc," (mil, log-scale)"))+
  #add data source
  labs(caption="target data source: Human Mortality Database")


