#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc


#read in the target data
#find file name
fn<-list.files(pattern="tot_pop_yr_fb",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
target_df<-as.data.frame(target_df)
#read in the model output data
#find file name
fn<-list.files(pattern="pop_yr_nat",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-as.data.frame(readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS")))

#update the column names for legend use
colnames(target_df)<-c("year", "total pop. target", "US born pop. target", "non-US born pop. target")
#format the outcomes data into one dataframe and update column names for legend
outcomes_df<-as.data.frame(cbind(1950:2017,(outcomes_df0[,1]+outcomes_df0[,2]),outcomes_df0[,1],outcomes_df0[,2]))
colnames(outcomes_df)<-c("year", "total pop. model output", "US born pop. model output", "non-US born pop. model output")
#reshape the target data
rtarget<-melt(target_df,id="year")
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year" )
#set up the plot options
ggplot() + theme_bw() +  scale_y_log10() + ylab("Population in Millions") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(rep(c(1,2),times=3))))) +
  scale_x_continuous(breaks = c(1950,1960,1970,1980,1990,2000,2010,2017)) +
   #add the target data
  geom_line(data=rtarget, aes(x=year, y=value, color=variable), linetype="dashed", alpha=.5) +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value, color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("red","red","black","grey20","dodgerblue2","dodgerblue2"))+
  #add plot title
  ggtitle(paste0(loc, " Population: Total, US Born, & Non-US Born (mil, log-scale)"))+
  #add data source
  labs(caption="target data source: decennial census, US Census Bureau")


