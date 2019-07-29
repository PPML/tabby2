#dependencies
library(ggplot2)
library(MITUS)
library(reshape2)

#set the location
loc<-loc

#read in the target data
#find file name
fn<-list.files(pattern="age_cases_tot",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
target_df0<-target_df0[(nrow(target_df0)-10):nrow(target_df0),] #last 10 years
target_df1<-target_df0[,2:11]*target_df0[,12]
#sum into age bands
target_df<-cbind(target_df0[,1], rowSums(target_df1[,1:3]),rowSums(target_df1[,4:5]),rowSums(target_df1[,6:8]),rowSums(target_df1[,9:10]))
#update the column names for legend use
target_df<-as.data.frame(target_df)
#get the years
years<-target_df[,1]
colnames(target_df)<-c("year", "Cases in 0-24 yrs target", "Cases in 25-44 yrs target", "Cases in 45-64 yrs target", "Cases in 65+ yrs target" )

#read in the model output data
#find file name
fn<-list.files(pattern="age_cases_4grp",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS")) #ends in 2016

#format the outcomes data into one dataframe and update column names for legend
outcomes_df<-cbind(years,outcomes_df0[(nrow(outcomes_df0)-10):nrow(outcomes_df0),])
outcomes_df<-as.data.frame(outcomes_df)
colnames(outcomes_df)<-c("year", "Cases in 0-24 yrs model output", "Cases in 25-44 yrs model output",
                         "Cases in 45-64 yrs model output", "Cases in 65+ yrs model output" )
ddf<-c("model","reported data")
#reshape the target data
rtarget<-melt(target_df,id="year")
#reshape the outcomes data
routcomes<-melt(outcomes_df,id ="year")
#set up the plot options
ggplot() + theme_bw() + ylab("") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(rep(c(1,2),times=4))))) +

  scale_x_continuous(breaks = years) +
  #add the target data
  geom_line(data=rtarget, aes(x=year, y=value*1e3,color=variable), linetype="dashed", alpha=.5) +
  #add the model output
  geom_line(data=routcomes, aes(x=year, y=value*1e3,color=variable)) +
  #add legend
  scale_color_manual(name = "", values=c("blue","blue","red","red","purple4","purple4","darkgreen","darkgreen"))+
  #create the dashes in the legend
  # scale_linetype_manual(values = c(rep("dotted",4),1,1,1,1))+
  #add plot title
  ggtitle(paste0("TB Cases in ", loc, " by Age ", years[1], "-", years[length(years)]))+
  #add data source
  labs(caption="target data source: Online Tuberculosis Information System (OTIS)")


