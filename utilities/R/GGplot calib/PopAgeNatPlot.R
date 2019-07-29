#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

#read in the target data
#find file name
fn<-list.files(pattern="tot_pop16_ag_fb",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
#subset into 2006-2016
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
#subset the data
target_df<-target_df0[1:8,3:4]

#update the column names for legend use
label<-c("0-4 years","5-24 years",
         "25-44 years","45-54 years",
         "55-64 years","65-74 years","75-84 years","85+ years")
target_df<-cbind(label,target_df)
target_df<-as.data.frame(target_df); colnames(target_df)<-c("Age","US-Born target","nonUS-Born target")
#read in the model output data
#find file name
fn<-list.files(pattern="pop_ag_nat",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))
outcomes_df<-as.data.frame(outcomes_df0)
outcomes_df<-cbind(label,outcomes_df)
colnames(outcomes_df)<-c("Age","US-Born model output","nonUS-Born model output")
#reshape the target data
rtarget<-melt(target_df,id="Age")
#reshape the outcomes data
routcomes<-melt(outcomes_df,id="Age")
#set up the plot options
ggplot() + theme_bw() +  ylab("") +xlab("Age Group")+ theme(legend.position="bottom") +
  scale_x_discrete(limits=label)+
  #add the model output
  geom_col(data=routcomes, aes(x=rep(label,2), y=value, fill=variable), position="dodge", alpha=0.3) +
  scale_fill_manual("", values=c("red","dodgerblue2"))+

  #add the target data
  geom_point(data=rtarget, aes(x=rep(label,2), y=value, color=variable), position=position_dodge(width = .9)) +
  #add legend
  scale_color_manual("", values=c("red","dodgerblue2"))+

  #add plot title
  ggtitle(paste0("Total Population 2016 in ", loc, " by Age and Nativity (mil)"))+
  #add data source
  labs(caption="target data source: Current Population Survey 2016, US Census Bureau")


