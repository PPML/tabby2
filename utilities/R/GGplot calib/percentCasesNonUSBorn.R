#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

#read in the target data
#find file name
#FB stratification
fn<-list.files(pattern="fb_cases",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
target_df0<-target_df0[,-3] #keep year and percentage
target_df0<-target_df0[(nrow(target_df0)-10):nrow(target_df0),] #last 10 years
##set the parameter for years
years<-target_df0[,1]
#set as dataframe
target_df<-as.data.frame(target_df0)
#update the column names for legend use
colnames(target_df)<-c("year", "% cases non-US born target")

#read in the model output data
#find file name
fn<-list.files(pattern="TBcases",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))

#format the outcomes data into one dataframe and update column names for legend
outcomes_df<-cbind(years,(outcomes_df0[[3]][14:24]/outcomes_df0[[1]][54:64])*100)
outcomes_df<-as.data.frame(outcomes_df)
colnames(outcomes_df)<-c("year", "% cases non-US born model output")
#reshape the target data
rtarget<-melt(target_df,id="year")
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year")
#set up the plot options
ggplot() + theme_bw() + ylab("") + theme(legend.position="bottom") +
  scale_x_continuous(breaks = years) + scale_y_continuous(breaks = 58:70, minor_breaks = 1) + guides(colour=guide_legend(override.aes=list(linetype=c(1,2)))) +
  #add the target data
  geom_line(data=rtarget, aes(x=year, y=value*100,color=variable), linetype="dashed") +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("blue","black")) +
  #add plot title
  ggtitle(paste0("Percent of TB Cases Non-US Born in ",loc," ", years[1],"-", years[11]))+
  #add data source
  labs(caption="target data source: Online Tuberculosis Information System (OTIS)")


