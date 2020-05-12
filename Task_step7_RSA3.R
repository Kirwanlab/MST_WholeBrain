# Analysis of the regions of interest (ROI) identified in the RSA. Written for R.
# 
# Pull mean values from regions of interest (functionally or anatomically defined), plot them, run stats
# Assumes the data are from 3dROIstats in a file formatted like this:
#   name			      Mean_1  	Mean_2  	...   Mean_N 
#   datafilename[0] Value1    Value2    ...   ValueN
#   ...
# 
# Will create that file if it doesn't exist.
#
# Brock Kirwan
# kirwan@byu.edu
#
# March 6, 2020

#load libraries:
library(stringr)
library(ggplot2)
library(ez)
library(tidyr)

#variables to update every time:
parDir <- '/Volumes/Yorick/MST_WholeBrain'
derDirName <- 'derivatives'
workDirName <- 'rsa'
maskName <- 'ETAC_mask' #Created using the interactive AFNI GUI. Command was: 3dClusterize -nosum -1Dformat -inset rsub_correl_vs_0.NN2_blur2_4.ETACmask.global.2sid.5perc.nii.gz -idat 0 -ithr 0 -NN 2 -clust_nvox 5 -bisided -0.0001 0.0001 -pref_map ETAC_mask
deconvName <- 'mst_stats_REML_blur2'
subBricks <- c(1,4,7,10)
subBrickLabels <- c('CR', 'Hit', 'LureFA', 'LureCR')
nSubBricks <- 15
validRoiNumbers <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
roiNames <- c('lDMPFC', 'bPRECUN', 'lAngular', 'rHippocampus', 'rMidTemporal', 'lMidTemporal', 'lHippocampus', 'rAngular', 'lMidTemporal2')



#variables that shouldn't change much
derDir <- sprintf('%s/%s',parDir, derDirName)
workDir <- sprintf('%s/Analyses/%s', derDir, workDirName) #this one might change every time
mask <- sprintf('%s/%s+tlrc', workDir,maskName)
roiStatsFile <- sprintf('%s.txt', maskName)
nRois <- length(roiNames)

### Main Work Goes Here:

#cd into the working directory
setwd(workDir) #might crash if this doesn't already exist.

# create the roi stats file with a command like this:
#    3dROIstats -1DRformat -mask mask_all_yassa_fractionized+tlrc /Volumes/Yorick/Exercise/derivatives/sub-*/mst_stats_REML+tlrc.HEAD > mask_all_yassa_fractionized.txt
if (!file.exists(roiStatsFile)) {
  system(sprintf('3dROIstats -1DRformat -mask %s %s/sub-*/%s+tlrc.HEAD > %s', mask, derDir, deconvName, roiStatsFile))
}

#read in all the unformatted data
allTheData <- read.table(roiStatsFile, header = TRUE, comment.char = '')

#only keep the valid ROI columns (keep in mind 1st column is filenames)
allTheData <- allTheData[c(1, validRoiNumbers + 1)]

#name the columns with ROI labels
names(allTheData) <- c('name', roiNames)

#number the sub-bricks
allTheData$subBrik <- c(0:nSubBricks)

#drop the sub-bricks we don't care about
theData <- allTheData[allTheData$subBrik %in% subBricks, ]


#extract the subject ID from the filename paths. Assumes things are named in a BIDS-like manner.
theData$subj <- str_extract(as.character(theData$name), "sub-[0-9]{4}")

#label the sub-bricks
theData$conds <- subBrickLabels

#convert from wide to long format
theDataLong <- gather(theData, roi, beta, roiNames[1]:roiNames[nRois], factor_key = TRUE)

#plot 
# ggplot(data = theDataLong, aes(x = conds, y = beta, fill = conds)) + 
#   geom_bar(stat = "summary", fun.y = "mean", position = "dodge") + 
#   geom_errorbar(aes(ymin=))
#   facet_wrap(~roi)

#pull means and calc stderr
summaryStats <- aggregate(theDataLong[,"beta"], list(theDataLong$conds, theDataLong$roi), mean)
names(summaryStats) <- c('conds', 'roi', 'meanBeta')

sdRoiCond <- aggregate(theDataLong[,"beta"], list(theDataLong$conds, theDataLong$roi), sd)
summaryStats$sem <- sdRoiCond$x/sqrt(length(unique(theDataLong$subj)))

ggplot(data = summaryStats, aes(x = conds, y = meanBeta, fill = conds)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymax = meanBeta + sem, ymin = meanBeta - sem), size = .3, width = .1, position = position_dodge(.9)) +
  facet_wrap(~roi, ncol=4)


#Stats
#anova:
ezANOVA(data=theDataLong, wid=.(subj), dv=.(beta), within=.(roi,conds), type=3)
# $ANOVA
# Effect DFn  DFd         F            p p<.05        ges
# 2       roi   8  376  4.550664 2.647638e-05     * 0.02516765
# 3     conds   3  141 30.985644 1.900305e-15     * 0.15802035
# 4 roi:conds  24 1128  4.544084 3.989491e-12     * 0.01610919

# for (i in roiNames) {
#   x <- theData[names(theData) == i ]
#   p <- pairwise.t.test(x[, 1], theData$conds, p.adjust.method = "none", pool.sd = FALSE, paired = TRUE)
#   print(i)
#   print(p)
# }

## T-test code from Ari:
beh_names <- unique(theDataLong$conds)
numBeh <- length(beh_names)
output <- NULL
for(r in unique(theDataLong$roi)){
  hold_dt <- theDataLong[which(theDataLong$roi==r),]
  count <- 0
  for(b in beh_names[-numBeh]){
    count <- count + 1
    for(h in beh_names[-(1:count)]){
      hold.t <- t.test(hold_dt$beta[hold_dt$conds==b], hold_dt$beta[hold_dt$conds==h], paired=T)
      hold_out <- as.matrix(cbind(r, "", "",
                                  paste(b, "vs", h),
                                  round(hold.t$statistic,2),
                                  round(hold.t$parameter,2),
                                  round(hold.t$p.value,4),
                                  ifelse(hold.t$p.value<0.05,"*", "")))
      output <- rbind(output,hold_out)
    }
  }
}
#write out the data to a .csv file
write.csv(theDataLong, "MTL_Anatomical_ROI_betas.csv")
write.csv(output, "pairedTtests.csv")


