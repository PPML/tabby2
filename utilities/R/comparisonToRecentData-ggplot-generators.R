
	################################################
	## Generate Comparison to Recent Data ggplots ##
	################################################

	# All of the following functions will return ggplots, 
	# and will be prefixed with 'calib_plt_'



# ----------------------------------------------------------------------------


#' Plot LTBI Prevalence in Non-US-Born Individuals by Age

calib_plt_nusb_ltbi <- function(loc) { 
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
}


# ----------------------------------------------------------------------------


#' Plot Percent of TB Cases in Non-US-Born Individuals

calib_plt_pct_cases_nusb <- function(loc) { 
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
	rtarget<-reshape2::melt(target_df,id="year")
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year")
	#set up the plot options
	ggplot() + theme_bw() + ylab("") + theme(legend.position="bottom") +
		scale_x_continuous(breaks = years) + 
		# scale_y_continuous(breaks = 58:70, minor_breaks = 1) + 
		expand_limits(y = 0) + 
		guides(colour=guide_legend(override.aes=list(linetype=c(1,2)))) +
		#add the target data
		geom_line(data=rtarget, aes(x=year, y=value*100,color=variable), linetype="dashed") +
		geom_point(data=rtarget, aes(x=year, y=value*100,color=variable)) +
		#add the model output
		geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
		#add legend
		scale_color_manual(name = "", values=c("blue","black")) +
		#add plot title
		ggtitle(paste0("Percent of TB Cases Non-US Born in ",loc," ", years[1],"-", years[11]))+
		#add data source
		labs(caption="target data source: Online Tuberculosis Information System (OTIS)")

}


# ----------------------------------------------------------------------------



#' Plot Percent of non-US born TB cases from recent immigrants (<2 yrs)

calib_plt_pct_cases_nusb_recent <- function(loc) { 

	#read in the target data
	#find file name
	#FB stratification
	fn<-list.files(pattern="fb_recent_cases",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
	target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
	target_df0<-target_df0[,-3] #keep year and percentage
	target_df0<-target_df0[(nrow(target_df0)-10):nrow(target_df0),] #last 10 years
	##set the parameter for years
	years<-target_df0[,1]
	target_df<-as.data.frame(target_df0)

	#update the column names for legend use
	colnames(target_df)<-c("year", "% non-US born cases from recent immigrants (<2yrs) target")

	#read in the model output data
	#find file name
	fn<-list.files(pattern="percentRecentFBcases",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
	outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))

	#format the outcomes data into one dataframe and update column names for legend
	outcomes_df<-cbind(years,outcomes_df0[12:22])
	outcomes_df<-as.data.frame(outcomes_df)
	colnames(outcomes_df)<-c("year", "% non-US born cases from recent immigrants (<2yrs) model output")
	#reshape the target data
	rtarget<-reshape2::melt(target_df,id="year",color=variable)
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year",color=variable)
	#set up the plot options
	ggplot() + 
	  theme_bw() + 
		ylab("") + 
		theme(legend.position="bottom") + 
		guides(colour=guide_legend(nrow = 2, override.aes=list(linetype=c(1,2))) ) +
		scale_x_continuous(breaks = years) +
		expand_limits(y=0) + 
		#add the target data
		geom_line(data=rtarget, aes(x=year, y=value*100,color=variable), linetype="dashed") +
		geom_point(data=rtarget, aes(x=year, y=value*100,color=variable)) +
		#add the model output
		geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
		#add legend
		scale_color_manual(name = "", values=c("blue","black"))+
		#add plot title
		ggtitle(paste0("Percent of non-US born TB cases from recent immigrants (<2yrs) in ",loc," ", years[1],"-", years[11]))+
		#add data source
		labs(caption="target data source: Online Tuberculosis Information System (OTIS)")
}


# ----------------------------------------------------------------------------



#' Plot Total Population by Age and Nativity 

calib_plt_pop_by_age_nat <- function(loc) { 

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
	rtarget<-reshape2::melt(target_df,id="Age")
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id="Age")
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
}



# ----------------------------------------------------------------------------


calib_plt_tb_cases_age_dist <- function(loc) { 

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
}


# ----------------------------------------------------------------------------


calib_plt_tb_cases_age_over_time <- function(loc) { 

	#read in the target data find file name
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
	rtarget<-reshape2::melt(target_df,id="year")
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year")
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
}


# ----------------------------------------------------------------------------


calib_plt_tb_deaths_by_year <- function(loc) { 

	#read in the target data
	#find file name
	#total tb deaths
	fn<-list.files(pattern="tb_deaths",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
	target_df0<-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))
	#get the last ten years
	target_df0<-target_df0[(nrow(target_df0)-10):nrow(target_df0),] #last 10 years
	##set the parameter for years
	years<-target_df0[,1]
	#create a dataframe of sum of tb deaths
	target_df<-cbind(target_df0[,1],rowSums(target_df0[,2:11]))
	target_df<-as.data.frame(target_df)
	#scale down to thousands
	# target_df[,2:4] <-target_df[,2:4]
	#update the column names for legend use
	colnames(target_df)<-c("year", "total TB deaths target")

	#read in the model output data
	#find file name
	fn<-list.files(pattern="TBdeaths_",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
	outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))

	#format the outcomes data into one dataframe and update column names for legend
	outcomes_df<-cbind(years,outcomes_df0*1e6)
	outcomes_df<-as.data.frame(outcomes_df)
	colnames(outcomes_df)<-c("year","total TB deaths model output")
	#reshape the target data
	rtarget<-reshape2::melt(target_df,id="year",color=variable)
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year",color=variable)
	#set up the plot options
	ggplot() + theme_bw() + ylab("Deaths with TB") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(1,2)))) +
		scale_x_continuous(breaks = years) +
		#add the target data
		geom_line(data=rtarget, aes(x=year, y=value,color=variable), linetype="dashed") +
		#add the model output
		geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
		#add legend
		scale_color_manual(name = "", values=c("blue","black"))+
		#add plot title
		ggtitle(paste0("Total Deaths with TB in ",loc," ", years[1],"-", years[11]))+
		#add data source
		labs(caption="target data source: CDC WONDER")
}



# ----------------------------------------------------------------------------


calib_plt_tb_deaths_by_age_over_time <- function(loc) { 

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
}


# ----------------------------------------------------------------------------


calib_plt_tb_cases_identified_over_ten_years <- function(loc) { 

	#read in the target data
	#find file name
	#total cases
	fn<-list.files(pattern="cases_yr",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
	target_df_tot <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))
	target_df_tot[,2] <-target_df_tot[,2]*1e3 #scale up to per 1000s
	#get the last ten years
	target_df_tot<-target_df_tot[(nrow(target_df_tot)-10):nrow(target_df_tot),]
	#get years
	years<-target_df_tot[,1]
	#nativity stratification
	fn<-list.files(pattern="fb_cases",system.file(paste0(loc,"/calibration_targets/"),package = "MITUS"))
	target_df0 <-readRDS(system.file(paste0(loc,"/calibration_targets/",fn),package="MITUS"))  #read in the model output data
	#format the data into a single dataframe
	target_df1<-cbind(target_df0[,2],1-target_df0[,2])*target_df0[,3]
	target_df1<-target_df1/1e3
	target_df1<-target_df1[(nrow(target_df1)-10):nrow(target_df1),]
	target_df<-cbind(target_df_tot,target_df1[,1],target_df1[,2])
	target_df<-as.data.frame(target_df)
	#scale down to thousands
	# target_df[,2:4] <-target_df[,2:4]
	#update the column names for legend use
	colnames(target_df)<-c("year", "total TB cases target", "non-US born TB cases target", "US born TB cases target")

	#read in the model output data
	#find file name
	fn<-list.files(pattern="TBcases",system.file(paste0(loc,"/calibration_outputs/"),package = "MITUS"))
	outcomes_df0 <-readRDS(system.file(paste0(loc,"/calibration_outputs/",fn), package="MITUS"))

	#format the outcomes data into one dataframe and update column names for legend
	outcomes_df<-cbind(years,outcomes_df0[[1]][(length(outcomes_df0[[1]])-10):length(outcomes_df0[[1]])]*1e3,
										 outcomes_df0[[2]][(length(outcomes_df0[[2]])-10):length(outcomes_df0[[2]])]*1e3,
										 outcomes_df0[[3]][(length(outcomes_df0[[3]])-10):length(outcomes_df0[[3]])]*1e3)
	outcomes_df<-as.data.frame(outcomes_df)
	colnames(outcomes_df)<-c("year", "total TB cases model output", "US born TB cases model output", "non-US born TB cases model output")
	#reshape the target data
	rtarget<-reshape2::melt(target_df,id="year",color=variable)
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year",color=variable)
	#set up the plot options
	ggplot() + theme_bw() + ylab("TB Cases (000s) ") + theme(legend.position="bottom") + guides(colour=guide_legend(override.aes=list(linetype=c(rep(c(1,2),times=3))))) +
		scale_x_continuous(breaks = years) +
    expand_limits(y=0) + 
		#add the target data
		geom_line(data=rtarget, aes(x=year, y=value,color=variable), linetype="dashed", alpha=.5) +
		#add the model output
		geom_line(data=routcomes, aes(x=year, y=value,color=variable)) +
		#add legend
		scale_color_manual(name = "", values=c("green","green","black","black","blue","blue"))+
		#add plot title
		ggtitle(paste0("Total TB Cases Identified (000s) in ",loc," ", years[1],"-",years[length(years)]))+
		#add data source
		labs(caption="target data source: Online Tuberculosis Information System (OTIS)")
}


# ----------------------------------------------------------------------------


calib_plt_tb_cases_nat_over_time <- function(loc) { 

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
	rtarget<-reshape2::melt(target_df,id="year",color=variable)
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year",color=variable)
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
}


# ----------------------------------------------------------------------------


calib_plt_pop_by_nat_over_time <- function(loc) { 

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
	rtarget<-reshape2::melt(target_df,id="year")
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year" )
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
}


# ----------------------------------------------------------------------------


calib_plt_deaths_over_time <- function(loc) { 

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
	rtarget<-reshape2::melt(target_df,id="year")
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year" )
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
}


# ----------------------------------------------------------------------------

calib_plt_trt_outcomes <- function(loc) { 

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
	rtarget<-reshape2::melt(target_df,id="year",color=variable)
	#reshape the outcomes data
	routcomes<-reshape2::melt(outcomes_df,id ="year",color=variable)
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
}


# ----------------------------------------------------------------------------


calib_plt_us_ltbi_by_age <- function(loc) { 

	#set the location
	loc1<-loc
	if (loc1 != "US") {loc2<-"ST"} else {loc2<-loc1}
	#read in the target data
	#find file name
	fn<-list.files(pattern="prev_USB_11_IGRA",system.file(paste0(loc2,"/calibration_targets/"),package = "MITUS"))
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
	fn<-list.files(pattern="_USB_LTBI_pct",system.file(paste0(loc1,"/calibration_outputs/"),package = "MITUS"))
	outcomes_df0 <-readRDS(system.file(paste0(loc1,"/calibration_outputs/",fn), package="MITUS"))
	outcomes_df<-as.data.frame(outcomes_df0)
	rownames(outcomes_df)<-label;colnames(outcomes_df)<-"percentage"
	#set up the plot options
	ggplot() + theme_bw() + ylab("") +xlab("Age Group")+ theme(legend.position="bottom") +
		scale_x_discrete(limits=label)+
		#add the model output
		geom_col(data=outcomes_df, aes(x=label, y=percentage, fill="dodgerblue2"),alpha=0.5) +
		#add the target data
		geom_point(data=target_df, aes(x=label, y=percentage, color="black" ) ) +
		#add legend
		scale_color_manual("", values="black", label="LTBI % target")+
		scale_fill_manual("", values="dodgerblue2", label="LTBI % model output")+
		#add plot title
		ggtitle(paste0("IGRA+ LTBI in US Born Population 2011 in ",loc," by Age (%)"))+
		#add data source
		labs(caption="target data estimated using National Health and Nutrition Examination Survey (NHANES) data")

}
