#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc1<-loc
if (loc1 != "US") {loc2<-"ST"} else {loc2<-loc1}

#read in the target data
#find file name
#total tb deaths
fn<-list.files(pattern="tx_outcomes",system.file(paste0(loc2,"/calibration_targets/"),package = "MITUS"))
target_df<-readRDS(system.file(paste0(loc2,"/calibration_targets/",fn),package="MITUS"))[,1:3]
target_df<-as.data.frame(target_df)
#scale down to thousands
# target_df[,2:4] <-target_df[,2:4]
#update the column names for legend use
colnames(target_df)<-c("year","% discontinued tx target", "% died on tx target")

#read in the model output data
#find file name
fn<-list.files(pattern="txOutcomes",system.file(paste0(loc1,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc1,"/calibration_outputs/",fn), package="MITUS"))

#format the outcomes data into one dataframe and update column names for legend
outcomes_df<-cbind(1993:2014,outcomes_df0[[1]],outcomes_df0[[2]])
outcomes_df<-as.data.frame(outcomes_df)
colnames(outcomes_df)<-c("year","% discontinued tx model output", "% died on tx model output")
#reshape the target data
rtarget<-melt(target_df,id="year",color=variable)
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year",color=variable)
#set up the plot options
ggplot() + theme_bw() + ylab("") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=rep(c(1,2),2)))) +
  scale_x_continuous(breaks = c(1993,1995,2000,2005,2010,2014)) +
  #add the target data
  geom_line(data=rtarget, aes(x=year, y=value*100,color=variable), linetype="dashed") +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value*100,color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("blue","blue", "red", "red"))+
  #add plot title
  ggtitle(paste0("Active TB Treatment Outcomes in ",loc," (%) 1993-2014"))+
  #add data source
  labs(caption="target data source: National TB Report")


