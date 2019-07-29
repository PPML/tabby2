#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc1<-loc
if (loc1 != "US") {loc2<-"ST"} else {loc2<-loc1}
#read in the target data
#find file name
fn<-list.files(pattern="prev_NUSB_11_IGRA",system.file(paste0(loc2,"/calibration_targets/"),package = "MITUS"))
#subset into 2006-2016
target_df0 <-readRDS(system.file(paste0(loc2,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
#sum across years
target_df<-(target_df0[,2]/sum(target_df0[,2]))*100
#update the column names for legend use

label<-c("5-14 years","15-24 years ",
         "25-34 years","35-44 years","45-54 years",
         "55-64 years","65-74 years","75+ years")
names(target_df)<-label
target_df<-as.data.frame(target_df); colnames(target_df)<-"percentage"
#read in the model output data
#find file name
fn<-list.files(pattern="NUSB_LTBI_pct",system.file(paste0(loc1,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc1,"/calibration_outputs/",fn), package="MITUS"))
outcomes_df<-as.data.frame(outcomes_df0)
rownames(outcomes_df)<-label;colnames(outcomes_df)<-"percentage"
#set up the plot options
ggplot() + theme_bw() + ylab("") +xlab("Age Group")+ theme(legend.position="bottom") +
  scale_x_discrete(limits=label)+
  #add the model output
  geom_col(data=outcomes_df, aes(x=label, y=percentage, fill="dodgerblue1"), alpha=.5) +
  #add the target data
  geom_point(data=target_df, aes(x=label, y=percentage,color="black"  )) +
  #add legend
  scale_color_manual("", values="black", label="LTBI % target")+
  scale_fill_manual("", values="dodgerblue2", label="LTBI % model output")+
  #add plot title
  ggtitle(paste0("IGRA+ LTBI in non-US Born Population 2011 in ",loc," by Age (%)"))+
  #add data source
labs(caption="target data estimated using National Health and Nutrition Examination Survey (NHANES) data")


