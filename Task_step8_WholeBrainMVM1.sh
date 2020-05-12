#!/bin/bash

# Group analysis on the MST deconvolution analysis
#
# Assumes things are in BIDS format, datasets have been blurred, you've run clustsim
#
# This script was written to run on a local machine (i.e., not on a cluster) with 12 cores available.
# 


parDir=/Volumes/Yorick/MST_WholeBrain        #parent directory
derDir=${parDir}/derivatives
refFile=${derDir}/sub-1425/run-1_mst_scale+tlrc			# reference file, for finding dimensions etc
prefix=mst
mask=Intersection_GM_mask+tlrc
nJobs=12 #number of cores to devote to this. More is better.

outDir=${derDir}/Analyses/grpAnalysis

outputPrefix=MST_MVM1


if [ ! -d $outDir ]; then
	mkdir -p $outDir
fi

cd $outDir



3dMVM  -prefix $outputPrefix -jobs $nJobs -mask $mask \
-wsVars "cond" \
-num_glt 2 \
-gltLabel 1 CR-HIT      -gltCode 1 'cond : 1*cr -1*hit' \
-gltLabel 2 LCR-LFA      -gltCode 2 'cond : 1*lcr -1*lfa' \
-dataTable  \
Subj	cond	InputFile \
sub-1425    cr    ${derDir}/sub-1425/mst_stats_REML_blur2+tlrc'[1]' \
sub-1428    cr    ${derDir}/sub-1428/mst_stats_REML_blur2+tlrc'[1]' \
sub-1435    cr    ${derDir}/sub-1435/mst_stats_REML_blur2+tlrc'[1]' \
sub-1443    cr    ${derDir}/sub-1443/mst_stats_REML_blur2+tlrc'[1]' \
sub-1461    cr    ${derDir}/sub-1461/mst_stats_REML_blur2+tlrc'[1]' \
sub-1475    cr    ${derDir}/sub-1475/mst_stats_REML_blur2+tlrc'[1]' \
sub-1476    cr    ${derDir}/sub-1476/mst_stats_REML_blur2+tlrc'[1]' \
sub-1479    cr    ${derDir}/sub-1479/mst_stats_REML_blur2+tlrc'[1]' \
sub-1514    cr    ${derDir}/sub-1514/mst_stats_REML_blur2+tlrc'[1]' \
sub-1515    cr    ${derDir}/sub-1515/mst_stats_REML_blur2+tlrc'[1]' \
sub-1516    cr    ${derDir}/sub-1516/mst_stats_REML_blur2+tlrc'[1]' \
sub-1537    cr    ${derDir}/sub-1537/mst_stats_REML_blur2+tlrc'[1]' \
sub-1538    cr    ${derDir}/sub-1538/mst_stats_REML_blur2+tlrc'[1]' \
sub-1539    cr    ${derDir}/sub-1539/mst_stats_REML_blur2+tlrc'[1]' \
sub-1540    cr    ${derDir}/sub-1540/mst_stats_REML_blur2+tlrc'[1]' \
sub-1542    cr    ${derDir}/sub-1542/mst_stats_REML_blur2+tlrc'[1]' \
sub-1543    cr    ${derDir}/sub-1543/mst_stats_REML_blur2+tlrc'[1]' \
sub-1544    cr    ${derDir}/sub-1544/mst_stats_REML_blur2+tlrc'[1]' \
sub-1545    cr    ${derDir}/sub-1545/mst_stats_REML_blur2+tlrc'[1]' \
sub-1548    cr    ${derDir}/sub-1548/mst_stats_REML_blur2+tlrc'[1]' \
sub-1549    cr    ${derDir}/sub-1549/mst_stats_REML_blur2+tlrc'[1]' \
sub-1565    cr    ${derDir}/sub-1565/mst_stats_REML_blur2+tlrc'[1]' \
sub-1568    cr    ${derDir}/sub-1568/mst_stats_REML_blur2+tlrc'[1]' \
sub-1569    cr    ${derDir}/sub-1569/mst_stats_REML_blur2+tlrc'[1]' \
sub-1570    cr    ${derDir}/sub-1570/mst_stats_REML_blur2+tlrc'[1]' \
sub-1572    cr    ${derDir}/sub-1572/mst_stats_REML_blur2+tlrc'[1]' \
sub-1573    cr    ${derDir}/sub-1573/mst_stats_REML_blur2+tlrc'[1]' \
sub-1587    cr    ${derDir}/sub-1587/mst_stats_REML_blur2+tlrc'[1]' \
sub-1588    cr    ${derDir}/sub-1588/mst_stats_REML_blur2+tlrc'[1]' \
sub-1589    cr    ${derDir}/sub-1589/mst_stats_REML_blur2+tlrc'[1]' \
sub-1591    cr    ${derDir}/sub-1591/mst_stats_REML_blur2+tlrc'[1]' \
sub-1592    cr    ${derDir}/sub-1592/mst_stats_REML_blur2+tlrc'[1]' \
sub-1593    cr    ${derDir}/sub-1593/mst_stats_REML_blur2+tlrc'[1]' \
sub-1594    cr    ${derDir}/sub-1594/mst_stats_REML_blur2+tlrc'[1]' \
sub-1597    cr    ${derDir}/sub-1597/mst_stats_REML_blur2+tlrc'[1]' \
sub-1963    cr    ${derDir}/sub-1963/mst_stats_REML_blur2+tlrc'[1]' \
sub-2259    cr    ${derDir}/sub-2259/mst_stats_REML_blur2+tlrc'[1]' \
sub-2313    cr    ${derDir}/sub-2313/mst_stats_REML_blur2+tlrc'[1]' \
sub-2347    cr    ${derDir}/sub-2347/mst_stats_REML_blur2+tlrc'[1]' \
sub-2384    cr    ${derDir}/sub-2384/mst_stats_REML_blur2+tlrc'[1]' \
sub-2395    cr    ${derDir}/sub-2395/mst_stats_REML_blur2+tlrc'[1]' \
sub-2411    cr    ${derDir}/sub-2411/mst_stats_REML_blur2+tlrc'[1]' \
sub-2413    cr    ${derDir}/sub-2413/mst_stats_REML_blur2+tlrc'[1]' \
sub-2436    cr    ${derDir}/sub-2436/mst_stats_REML_blur2+tlrc'[1]' \
sub-2459    cr    ${derDir}/sub-2459/mst_stats_REML_blur2+tlrc'[1]' \
sub-2552    cr    ${derDir}/sub-2552/mst_stats_REML_blur2+tlrc'[1]' \
sub-2555    cr    ${derDir}/sub-2555/mst_stats_REML_blur2+tlrc'[1]' \
sub-2560    cr    ${derDir}/sub-2560/mst_stats_REML_blur2+tlrc'[1]' \
sub-1425    hit    ${derDir}/sub-1425/mst_stats_REML_blur2+tlrc'[4]' \
sub-1428    hit    ${derDir}/sub-1428/mst_stats_REML_blur2+tlrc'[4]' \
sub-1435    hit    ${derDir}/sub-1435/mst_stats_REML_blur2+tlrc'[4]' \
sub-1443    hit    ${derDir}/sub-1443/mst_stats_REML_blur2+tlrc'[4]' \
sub-1461    hit    ${derDir}/sub-1461/mst_stats_REML_blur2+tlrc'[4]' \
sub-1475    hit    ${derDir}/sub-1475/mst_stats_REML_blur2+tlrc'[4]' \
sub-1476    hit    ${derDir}/sub-1476/mst_stats_REML_blur2+tlrc'[4]' \
sub-1479    hit    ${derDir}/sub-1479/mst_stats_REML_blur2+tlrc'[4]' \
sub-1514    hit    ${derDir}/sub-1514/mst_stats_REML_blur2+tlrc'[4]' \
sub-1515    hit    ${derDir}/sub-1515/mst_stats_REML_blur2+tlrc'[4]' \
sub-1516    hit    ${derDir}/sub-1516/mst_stats_REML_blur2+tlrc'[4]' \
sub-1537    hit    ${derDir}/sub-1537/mst_stats_REML_blur2+tlrc'[4]' \
sub-1538    hit    ${derDir}/sub-1538/mst_stats_REML_blur2+tlrc'[4]' \
sub-1539    hit    ${derDir}/sub-1539/mst_stats_REML_blur2+tlrc'[4]' \
sub-1540    hit    ${derDir}/sub-1540/mst_stats_REML_blur2+tlrc'[4]' \
sub-1542    hit    ${derDir}/sub-1542/mst_stats_REML_blur2+tlrc'[4]' \
sub-1543    hit    ${derDir}/sub-1543/mst_stats_REML_blur2+tlrc'[4]' \
sub-1544    hit    ${derDir}/sub-1544/mst_stats_REML_blur2+tlrc'[4]' \
sub-1545    hit    ${derDir}/sub-1545/mst_stats_REML_blur2+tlrc'[4]' \
sub-1548    hit    ${derDir}/sub-1548/mst_stats_REML_blur2+tlrc'[4]' \
sub-1549    hit    ${derDir}/sub-1549/mst_stats_REML_blur2+tlrc'[4]' \
sub-1565    hit    ${derDir}/sub-1565/mst_stats_REML_blur2+tlrc'[4]' \
sub-1568    hit    ${derDir}/sub-1568/mst_stats_REML_blur2+tlrc'[4]' \
sub-1569    hit    ${derDir}/sub-1569/mst_stats_REML_blur2+tlrc'[4]' \
sub-1570    hit    ${derDir}/sub-1570/mst_stats_REML_blur2+tlrc'[4]' \
sub-1572    hit    ${derDir}/sub-1572/mst_stats_REML_blur2+tlrc'[4]' \
sub-1573    hit    ${derDir}/sub-1573/mst_stats_REML_blur2+tlrc'[4]' \
sub-1587    hit    ${derDir}/sub-1587/mst_stats_REML_blur2+tlrc'[4]' \
sub-1588    hit    ${derDir}/sub-1588/mst_stats_REML_blur2+tlrc'[4]' \
sub-1589    hit    ${derDir}/sub-1589/mst_stats_REML_blur2+tlrc'[4]' \
sub-1591    hit    ${derDir}/sub-1591/mst_stats_REML_blur2+tlrc'[4]' \
sub-1592    hit    ${derDir}/sub-1592/mst_stats_REML_blur2+tlrc'[4]' \
sub-1593    hit    ${derDir}/sub-1593/mst_stats_REML_blur2+tlrc'[4]' \
sub-1594    hit    ${derDir}/sub-1594/mst_stats_REML_blur2+tlrc'[4]' \
sub-1597    hit    ${derDir}/sub-1597/mst_stats_REML_blur2+tlrc'[4]' \
sub-1963    hit    ${derDir}/sub-1963/mst_stats_REML_blur2+tlrc'[4]' \
sub-2259    hit    ${derDir}/sub-2259/mst_stats_REML_blur2+tlrc'[4]' \
sub-2313    hit    ${derDir}/sub-2313/mst_stats_REML_blur2+tlrc'[4]' \
sub-2347    hit    ${derDir}/sub-2347/mst_stats_REML_blur2+tlrc'[4]' \
sub-2384    hit    ${derDir}/sub-2384/mst_stats_REML_blur2+tlrc'[4]' \
sub-2395    hit    ${derDir}/sub-2395/mst_stats_REML_blur2+tlrc'[4]' \
sub-2411    hit    ${derDir}/sub-2411/mst_stats_REML_blur2+tlrc'[4]' \
sub-2413    hit    ${derDir}/sub-2413/mst_stats_REML_blur2+tlrc'[4]' \
sub-2436    hit    ${derDir}/sub-2436/mst_stats_REML_blur2+tlrc'[4]' \
sub-2459    hit    ${derDir}/sub-2459/mst_stats_REML_blur2+tlrc'[4]' \
sub-2552    hit    ${derDir}/sub-2552/mst_stats_REML_blur2+tlrc'[4]' \
sub-2555    hit    ${derDir}/sub-2555/mst_stats_REML_blur2+tlrc'[4]' \
sub-2560    hit    ${derDir}/sub-2560/mst_stats_REML_blur2+tlrc'[4]' \
sub-1425    lfa    ${derDir}/sub-1425/mst_stats_REML_blur2+tlrc'[7]' \
sub-1428    lfa    ${derDir}/sub-1428/mst_stats_REML_blur2+tlrc'[7]' \
sub-1435    lfa    ${derDir}/sub-1435/mst_stats_REML_blur2+tlrc'[7]' \
sub-1443    lfa    ${derDir}/sub-1443/mst_stats_REML_blur2+tlrc'[7]' \
sub-1461    lfa    ${derDir}/sub-1461/mst_stats_REML_blur2+tlrc'[7]' \
sub-1475    lfa    ${derDir}/sub-1475/mst_stats_REML_blur2+tlrc'[7]' \
sub-1476    lfa    ${derDir}/sub-1476/mst_stats_REML_blur2+tlrc'[7]' \
sub-1479    lfa    ${derDir}/sub-1479/mst_stats_REML_blur2+tlrc'[7]' \
sub-1514    lfa    ${derDir}/sub-1514/mst_stats_REML_blur2+tlrc'[7]' \
sub-1515    lfa    ${derDir}/sub-1515/mst_stats_REML_blur2+tlrc'[7]' \
sub-1516    lfa    ${derDir}/sub-1516/mst_stats_REML_blur2+tlrc'[7]' \
sub-1537    lfa    ${derDir}/sub-1537/mst_stats_REML_blur2+tlrc'[7]' \
sub-1538    lfa    ${derDir}/sub-1538/mst_stats_REML_blur2+tlrc'[7]' \
sub-1539    lfa    ${derDir}/sub-1539/mst_stats_REML_blur2+tlrc'[7]' \
sub-1540    lfa    ${derDir}/sub-1540/mst_stats_REML_blur2+tlrc'[7]' \
sub-1542    lfa    ${derDir}/sub-1542/mst_stats_REML_blur2+tlrc'[7]' \
sub-1543    lfa    ${derDir}/sub-1543/mst_stats_REML_blur2+tlrc'[7]' \
sub-1544    lfa    ${derDir}/sub-1544/mst_stats_REML_blur2+tlrc'[7]' \
sub-1545    lfa    ${derDir}/sub-1545/mst_stats_REML_blur2+tlrc'[7]' \
sub-1548    lfa    ${derDir}/sub-1548/mst_stats_REML_blur2+tlrc'[7]' \
sub-1549    lfa    ${derDir}/sub-1549/mst_stats_REML_blur2+tlrc'[7]' \
sub-1565    lfa    ${derDir}/sub-1565/mst_stats_REML_blur2+tlrc'[7]' \
sub-1568    lfa    ${derDir}/sub-1568/mst_stats_REML_blur2+tlrc'[7]' \
sub-1569    lfa    ${derDir}/sub-1569/mst_stats_REML_blur2+tlrc'[7]' \
sub-1570    lfa    ${derDir}/sub-1570/mst_stats_REML_blur2+tlrc'[7]' \
sub-1572    lfa    ${derDir}/sub-1572/mst_stats_REML_blur2+tlrc'[7]' \
sub-1573    lfa    ${derDir}/sub-1573/mst_stats_REML_blur2+tlrc'[7]' \
sub-1587    lfa    ${derDir}/sub-1587/mst_stats_REML_blur2+tlrc'[7]' \
sub-1588    lfa    ${derDir}/sub-1588/mst_stats_REML_blur2+tlrc'[7]' \
sub-1589    lfa    ${derDir}/sub-1589/mst_stats_REML_blur2+tlrc'[7]' \
sub-1591    lfa    ${derDir}/sub-1591/mst_stats_REML_blur2+tlrc'[7]' \
sub-1592    lfa    ${derDir}/sub-1592/mst_stats_REML_blur2+tlrc'[7]' \
sub-1593    lfa    ${derDir}/sub-1593/mst_stats_REML_blur2+tlrc'[7]' \
sub-1594    lfa    ${derDir}/sub-1594/mst_stats_REML_blur2+tlrc'[7]' \
sub-1597    lfa    ${derDir}/sub-1597/mst_stats_REML_blur2+tlrc'[7]' \
sub-1963    lfa    ${derDir}/sub-1963/mst_stats_REML_blur2+tlrc'[7]' \
sub-2259    lfa    ${derDir}/sub-2259/mst_stats_REML_blur2+tlrc'[7]' \
sub-2313    lfa    ${derDir}/sub-2313/mst_stats_REML_blur2+tlrc'[7]' \
sub-2347    lfa    ${derDir}/sub-2347/mst_stats_REML_blur2+tlrc'[7]' \
sub-2384    lfa    ${derDir}/sub-2384/mst_stats_REML_blur2+tlrc'[7]' \
sub-2395    lfa    ${derDir}/sub-2395/mst_stats_REML_blur2+tlrc'[7]' \
sub-2411    lfa    ${derDir}/sub-2411/mst_stats_REML_blur2+tlrc'[7]' \
sub-2413    lfa    ${derDir}/sub-2413/mst_stats_REML_blur2+tlrc'[7]' \
sub-2436    lfa    ${derDir}/sub-2436/mst_stats_REML_blur2+tlrc'[7]' \
sub-2459    lfa    ${derDir}/sub-2459/mst_stats_REML_blur2+tlrc'[7]' \
sub-2552    lfa    ${derDir}/sub-2552/mst_stats_REML_blur2+tlrc'[7]' \
sub-2555    lfa    ${derDir}/sub-2555/mst_stats_REML_blur2+tlrc'[7]' \
sub-2560    lfa    ${derDir}/sub-2560/mst_stats_REML_blur2+tlrc'[7]' \
sub-1425    lcr    ${derDir}/sub-1425/mst_stats_REML_blur2+tlrc'[10]' \
sub-1428    lcr    ${derDir}/sub-1428/mst_stats_REML_blur2+tlrc'[10]' \
sub-1435    lcr    ${derDir}/sub-1435/mst_stats_REML_blur2+tlrc'[10]' \
sub-1443    lcr    ${derDir}/sub-1443/mst_stats_REML_blur2+tlrc'[10]' \
sub-1461    lcr    ${derDir}/sub-1461/mst_stats_REML_blur2+tlrc'[10]' \
sub-1475    lcr    ${derDir}/sub-1475/mst_stats_REML_blur2+tlrc'[10]' \
sub-1476    lcr    ${derDir}/sub-1476/mst_stats_REML_blur2+tlrc'[10]' \
sub-1479    lcr    ${derDir}/sub-1479/mst_stats_REML_blur2+tlrc'[10]' \
sub-1514    lcr    ${derDir}/sub-1514/mst_stats_REML_blur2+tlrc'[10]' \
sub-1515    lcr    ${derDir}/sub-1515/mst_stats_REML_blur2+tlrc'[10]' \
sub-1516    lcr    ${derDir}/sub-1516/mst_stats_REML_blur2+tlrc'[10]' \
sub-1537    lcr    ${derDir}/sub-1537/mst_stats_REML_blur2+tlrc'[10]' \
sub-1538    lcr    ${derDir}/sub-1538/mst_stats_REML_blur2+tlrc'[10]' \
sub-1539    lcr    ${derDir}/sub-1539/mst_stats_REML_blur2+tlrc'[10]' \
sub-1540    lcr    ${derDir}/sub-1540/mst_stats_REML_blur2+tlrc'[10]' \
sub-1542    lcr    ${derDir}/sub-1542/mst_stats_REML_blur2+tlrc'[10]' \
sub-1543    lcr    ${derDir}/sub-1543/mst_stats_REML_blur2+tlrc'[10]' \
sub-1544    lcr    ${derDir}/sub-1544/mst_stats_REML_blur2+tlrc'[10]' \
sub-1545    lcr    ${derDir}/sub-1545/mst_stats_REML_blur2+tlrc'[10]' \
sub-1548    lcr    ${derDir}/sub-1548/mst_stats_REML_blur2+tlrc'[10]' \
sub-1549    lcr    ${derDir}/sub-1549/mst_stats_REML_blur2+tlrc'[10]' \
sub-1565    lcr    ${derDir}/sub-1565/mst_stats_REML_blur2+tlrc'[10]' \
sub-1568    lcr    ${derDir}/sub-1568/mst_stats_REML_blur2+tlrc'[10]' \
sub-1569    lcr    ${derDir}/sub-1569/mst_stats_REML_blur2+tlrc'[10]' \
sub-1570    lcr    ${derDir}/sub-1570/mst_stats_REML_blur2+tlrc'[10]' \
sub-1572    lcr    ${derDir}/sub-1572/mst_stats_REML_blur2+tlrc'[10]' \
sub-1573    lcr    ${derDir}/sub-1573/mst_stats_REML_blur2+tlrc'[10]' \
sub-1587    lcr    ${derDir}/sub-1587/mst_stats_REML_blur2+tlrc'[10]' \
sub-1588    lcr    ${derDir}/sub-1588/mst_stats_REML_blur2+tlrc'[10]' \
sub-1589    lcr    ${derDir}/sub-1589/mst_stats_REML_blur2+tlrc'[10]' \
sub-1591    lcr    ${derDir}/sub-1591/mst_stats_REML_blur2+tlrc'[10]' \
sub-1592    lcr    ${derDir}/sub-1592/mst_stats_REML_blur2+tlrc'[10]' \
sub-1593    lcr    ${derDir}/sub-1593/mst_stats_REML_blur2+tlrc'[10]' \
sub-1594    lcr    ${derDir}/sub-1594/mst_stats_REML_blur2+tlrc'[10]' \
sub-1597    lcr    ${derDir}/sub-1597/mst_stats_REML_blur2+tlrc'[10]' \
sub-1963    lcr    ${derDir}/sub-1963/mst_stats_REML_blur2+tlrc'[10]' \
sub-2259    lcr    ${derDir}/sub-2259/mst_stats_REML_blur2+tlrc'[10]' \
sub-2313    lcr    ${derDir}/sub-2313/mst_stats_REML_blur2+tlrc'[10]' \
sub-2347    lcr    ${derDir}/sub-2347/mst_stats_REML_blur2+tlrc'[10]' \
sub-2384    lcr    ${derDir}/sub-2384/mst_stats_REML_blur2+tlrc'[10]' \
sub-2395    lcr    ${derDir}/sub-2395/mst_stats_REML_blur2+tlrc'[10]' \
sub-2411    lcr    ${derDir}/sub-2411/mst_stats_REML_blur2+tlrc'[10]' \
sub-2413    lcr    ${derDir}/sub-2413/mst_stats_REML_blur2+tlrc'[10]' \
sub-2436    lcr    ${derDir}/sub-2436/mst_stats_REML_blur2+tlrc'[10]' \
sub-2459    lcr    ${derDir}/sub-2459/mst_stats_REML_blur2+tlrc'[10]' \
sub-2552    lcr    ${derDir}/sub-2552/mst_stats_REML_blur2+tlrc'[10]' \
sub-2555    lcr    ${derDir}/sub-2555/mst_stats_REML_blur2+tlrc'[10]' \
sub-2560    lcr    ${derDir}/sub-2560/mst_stats_REML_blur2+tlrc'[10]'



cd $parDir


