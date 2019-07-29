#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

#read in the target data
#find file name
fn<-list.files(pattern="age_cases_tot",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
#subset into 2006-2016
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))
#get the last ten years
target_df0<-target_df0[(nrow(target_df0)-10):nrow(target_df0),] #last 10 years
#calculate the numbers of cases from percentages and sample size
target_df1<-cbind(target_df0[,1],target_df0[,2:11]*target_df0[,12])
#sum across years
target_df<-(colSums(target_df1[,2:11])/sum(target_df1[,2:11]))*100
#get the years
years<-target_df0[,1]
#update the column names for legend use
label<-c("0-4 years","5-14 years","15-24 years ",
         "25-34 years","35-44 years","45-54 years",
         "55-64 years","65-74 years","75-84 years","85+ years")
names(target_df)<-label
target_df<-as.data.frame(target_df); colnames(target_df)<-"percentage"
#read in the model output data
#find file name
fn<-list.files(pattern="age_cases_tot",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))
#get the last ten years
outcomes_df0<-outcomes_df0[(nrow(outcomes_df0)-10):nrow(outcomes_df0),] #last 10 years
#add the last two age groups
outcomes_df1<-outcomes_df0[,-12]; outcomes_df1[,11]<-outcomes_df1[,11]+outcomes_df0[,12]
#sum across years
outcomes_df<-(colSums(outcomes_df1[,2:11])/sum(outcomes_df1[,2:11]))*100
outcomes_df<-as.data.frame(outcomes_df)
rownames(outcomes_df)<-label;colnames(outcomes_df)<-"percentage"
#set up the plot options
ggplot() + theme_bw() + ylab("") +xlab("Age Group")+ theme(legend.position="bottom") +
  scale_x_discrete(limits=label)+
  #add the model output
  geom_col(data=outcomes_df, aes(x=label, y=percentage, fill="dodgerblue1"), alpha=.5) +
  #add the target data
  geom_point(data=target_df, aes(x=label, y=percentage,color="black") ) +
  #add legend
  scale_color_manual("", values="black", label="TB cases target")+
  scale_fill_manual("", values="dodgerblue2", label="TB cases model output")+
  #add plot title
  ggtitle(paste0("Age distribution of TB cases in ", loc, " ",  years[1], "-", years[length(years)]))+
  #add data source
  labs(caption="target data source: Online Tuberculosis Information System (OTIS)")


