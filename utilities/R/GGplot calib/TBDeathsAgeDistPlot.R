#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc
#read in the target data
#find file name
fn<-list.files(pattern="tb_deaths",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
#sum across years
target_df<-colSums(na.omit(target_df0[,2:11]))
#get the years
years<-target_df0[,1]
#update the column names for legend use
label<-c("0-4 years","5-14 years","15-24 years ",
         "25-34 years","35-44 years","45-54 years",
         "55-64 years","65-74 years","75-84 years","85+ years")
names(target_df)<-label
target_df<-as.data.frame(target_df); colnames(target_df)<-"total.deaths"
#read in the model output data
#find file name
fn<-list.files(pattern="TBdeathsAge",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))
outcomes_df<-as.data.frame(outcomes_df)
rownames(outcomes_df)<-label;colnames(outcomes_df)<-"total.deaths"
#set up the plot options
ggplot() + theme_bw() + ylab("") +xlab("Age Group")+ theme(legend.position="bottom") +
  scale_x_discrete(limits=label)+
  #add the model output
  geom_col(data=outcomes_df, aes(x=label, y=total.deaths, fill="dodgerblue1"), alpha=.5) +
  #add the target data
  geom_point(data=target_df, aes(x=label, y=total.deaths,color="black" )) +
  #add legend
  scale_color_manual("", values="black", label="deaths with TB target")+
  scale_fill_manual("", values="dodgerblue2", label="deaths with TB model output")+
  #add plot title
  ggtitle(paste0("Age distribution of Deaths with TB in ", loc, " ",  years[1],"-",years[length(years)])) +
  #add data source
  labs(caption="target data source: CDC WONDER")


