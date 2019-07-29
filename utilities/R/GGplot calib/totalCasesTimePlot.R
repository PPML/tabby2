#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

#read in the target data
#find file name
#total cases
fn<-list.files(pattern="cases_yr",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df_tot <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))
target_df_tot[,2] <-target_df_tot[,2]*1e3
#nativity stratification
fn<-list.files(pattern="fb_cases",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
#format the data into a single dataframe
target_df1<-cbind(target_df0[,2],1-target_df0[,2])*target_df0[,3]
target_df1<-target_df1/1e3
target_df<-cbind(target_df_tot,c(rep(NA,nrow(target_df_tot)-nrow(target_df1)),target_df1[,1]),c(rep(NA,nrow(target_df_tot)-nrow(target_df1)),target_df1[,2]))
#get the years
years<-target_df[,1]
target_df<-as.data.frame(target_df)
#update the column names for legend use
colnames(target_df)<-c("year", "total TB cases target", "non-US born TB cases target", "US born TB cases target")

#read in the model output data
#find file name
fn<-list.files(pattern="TBcases",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))


#format the outcomes data into one dataframe and update column names for legend
outcomes_df1<-cbind(outcomes_df0[[1]]*1e3,
                   c(rep(NA,length(outcomes_df0[[1]])-length(outcomes_df0[[2]])),outcomes_df0[[2]]*1e3),
                   c(rep(NA,length(outcomes_df0[[1]])-length(outcomes_df0[[3]])),outcomes_df0[[3]]*1e3))
outcomes_df<-outcomes_df1[years-1952,]
outcomes_df<-cbind(years,outcomes_df)
outcomes_df<-as.data.frame(outcomes_df)
colnames(outcomes_df)<-c("year", "total TB cases model output", "US born TB cases model output", "non-US born TB cases model output")
#reshape the target data
rtarget<-melt(target_df,id="year",color=variable)
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year",color=variable)
#set up the plot options
ggplot() + theme_bw() + ylab("TB Cases (000s) ") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(rep(c(1,2),times=3))))) +
  scale_x_continuous(breaks = c(years[1],seq(years[1],years[length(years)],10), years[length(years)])) +
  #add the target data
  geom_line(data=rtarget, aes(x=year, y=value,color=variable), linetype="dashed") +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("green","green","black","black","blue","blue"))+
  #add plot title
  ggtitle(paste0("Total TB Cases Identified (000s) in ",loc," ",years[1], "-", years[length(years)]))+
  #add data source
  labs(caption="target data source: Online Tuberculosis Information System (OTIS)")


