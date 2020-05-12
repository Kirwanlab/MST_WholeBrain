# Pull mean values from regions of interest (functionally or anatomically defined), plot them, run stats
# Assumes that you've run 3dROIstats to produce a file formatted like this:
#   name			      Mean_1  	Mean_2  	...   Mean_N 
#   datafilename[0] Value1    Value2    ...   ValueN
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
library(dplyr)

#variables to update every time:
parDir <- '/Volumes/Yorick/MST_WholeBrain'
derDirName <- 'derivatives'
workDirName <- 'grpAnalysis'
maskName <- 'MVM1_MEcond_p.0001_k100_nn2_mask' #created interactively with AFNI GUI. Command was: 3dClusterize -nosum -1Dformat -inset MST_MVM1+tlrc.HEAD -idat 1 -ithr 1 -NN 2 -clust_nvox 100 -bisided -7.5613 7.5613 -pref_map MVM1_MEcond_p.0001_k100_nn2_mask
deconvName <- 'mst_stats_REML_blur2'
subBricks <- c(1,4,7,10)
subBrickLabels <- c('CR', 'Hit', 'LureFA', 'LureCR')
nSubBricks <- 15
roiNames <- c('LVisual', 'RDorsVisual', 'LIFS', 'RIFS', 'RVentVisual', 'RDMPFC', 'LVMPFC', 'LDMPFC', 'LAntInsula', 'RAntInsula', 'RIFG', 'LPrecentral', 'RCaudate', 'LCaudate', 'RPrecentral', 'LPrecuneus', 'LMidTemp', 'RCingulate', 'RVMPFC', 'RPCC', 'RInfPrecentral', 'LIinfParietal', 'RPostcentral', 'RInfPostcentral')
## all ROIs (put in fewer to drop ROIs you don't need)
validRois <- c('LVisual', 'RDorsVisual', 'LIFS', 'RIFS', 'RVentVisual', 'RDMPFC', 'LVMPFC', 'LDMPFC', 'LAntInsula', 'RAntInsula', 'RIFG', 'LPrecentral', 'RCaudate', 'LCaudate', 'RPrecentral', 'LPrecuneus', 'LMidTemp', 'RCingulate', 'RVMPFC', 'RPCC', 'RInfPrecentral', 'LIinfParietal', 'RPostcentral', 'RInfPostcentral')

#variables that shouldn't change much
derDir <- sprintf('%s/%s',parDir, derDirName)
workDir <- sprintf('%s/Analyses/%s', derDir, workDirName) #this one might change every time
mask <- sprintf('%s/%s+tlrc', workDir,maskName)
roiStatsFile <- sprintf('%s.txt', maskName)
nRois <- length(roiNames)
nValidRois <- length(validRois)

### Main Work Goes Here:

#cd into the working directory
setwd(workDir)

# create the roi stats file 
if (!file.exists(roiStatsFile)) {
  system(sprintf('3dROIstats -1DRformat -mask %s %s/sub-*/%s+tlrc.HEAD > %s', mask, derDir, deconvName, roiStatsFile))
}

#read in all the unformatted data
allTheData <- read.table(roiStatsFile, header = TRUE, comment.char = '')
#name the columns with ROI labels
names(allTheData) <- c('name', roiNames)

#number the sub-bricks
allTheData$subBrik <- c(0:nSubBricks)

#drop the sub-bricks we don't care about
theData <- allTheData[allTheData$subBrik %in% subBricks, ]

#subset just the ROIs we want
theData <- select(theData, c('name', validRois))

#extract the subject ID from the filename paths. Assumes things are named in a BIDS-like manner.
theData$subj <- str_extract(as.character(theData$name), "sub-[0-9]{4}")

#label the sub-bricks
theData$conds <- subBrickLabels

#convert from wide to long format
theDataLong <- gather(theData, roi, beta, validRois[1]:validRois[nValidRois], factor_key = TRUE)

#plot 
# ggplot(data = theDataLong, aes(x = conds, y = beta, fill = conds)) + 
#   geom_bar(stat = "summary", fun.y = "mean", position = "dodge") + 
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
ezANOVA(data=theDataLong, wid=.(subj), dv=.(beta), within=.(roi,conds), type=3)
# $ANOVA results
# Effect DFn  DFd         F            p p<.05        ges
# 1       roi  23 1081 146.71836 0.000000e+00     * 0.61802361
# 2     conds   3  141  36.99083 1.069402e-17     * 0.09279467
# 3 roi:conds  69 3243  94.52874 0.000000e+00     * 0.41432390

# for (i in validRois) {
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
write.csv(output, "PairwiseTtestsMVM.csv")
