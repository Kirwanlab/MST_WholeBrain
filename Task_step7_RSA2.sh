#!/bin/bash

# Step 2 of the RSA: run a t-test vs 0 on the normalized correlations. Correction for 
# multiple comparisons done with AFNI's ETAC algorithm. This is actually a pretty CPU-
# intensive process.

parDir=/Volumes/Yorick/MST_WholeBrain        #parent directory
derDir=${parDir}/derivatives
refFile=${derDir}/sub-1425/run-1_mst_scale+tlrc			# reference file, for finding dimensions etc
mask=${derDir}/Analyses/grpAnalysis/Intersection_GM_mask+tlrc

outDir=${derDir}/Analyses/rsa

outputPrefix=rsub_correl_vs_0


if [ ! -d $outDir ]; then
	mkdir -p $outDir
fi

cd $outDir

3dttest++ \
-prefix ${outputPrefix} \
-mask ${mask} \
-ETAC \
-ETAC_blur 2 4 \
-ETAC_opt name=NN2_blur2_4:NN2:2sid:pthr=.01,.005,.001 \
-setA \
sub-1425_z+tlrc'[0]' \
sub-1428_z+tlrc'[0]' \
sub-1435_z+tlrc'[0]' \
sub-1443_z+tlrc'[0]' \
sub-1461_z+tlrc'[0]' \
sub-1475_z+tlrc'[0]' \
sub-1476_z+tlrc'[0]' \
sub-1479_z+tlrc'[0]' \
sub-1514_z+tlrc'[0]' \
sub-1515_z+tlrc'[0]' \
sub-1516_z+tlrc'[0]' \
sub-1537_z+tlrc'[0]' \
sub-1538_z+tlrc'[0]' \
sub-1539_z+tlrc'[0]' \
sub-1540_z+tlrc'[0]' \
sub-1542_z+tlrc'[0]' \
sub-1543_z+tlrc'[0]' \
sub-1544_z+tlrc'[0]' \
sub-1545_z+tlrc'[0]' \
sub-1548_z+tlrc'[0]' \
sub-1549_z+tlrc'[0]' \
sub-1565_z+tlrc'[0]' \
sub-1568_z+tlrc'[0]' \
sub-1569_z+tlrc'[0]' \
sub-1570_z+tlrc'[0]' \
sub-1572_z+tlrc'[0]' \
sub-1573_z+tlrc'[0]' \
sub-1587_z+tlrc'[0]' \
sub-1588_z+tlrc'[0]' \
sub-1589_z+tlrc'[0]' \
sub-1591_z+tlrc'[0]' \
sub-1592_z+tlrc'[0]' \
sub-1593_z+tlrc'[0]' \
sub-1594_z+tlrc'[0]' \
sub-1597_z+tlrc'[0]' \
sub-1963_z+tlrc'[0]' \
sub-2259_z+tlrc'[0]' \
sub-2313_z+tlrc'[0]' \
sub-2347_z+tlrc'[0]' \
sub-2384_z+tlrc'[0]' \
sub-2395_z+tlrc'[0]' \
sub-2411_z+tlrc'[0]' \
sub-2413_z+tlrc'[0]' \
sub-2436_z+tlrc'[0]' \
sub-2459_z+tlrc'[0]' \
sub-2552_z+tlrc'[0]' \
sub-2555_z+tlrc'[0]' \
sub-2560_z+tlrc'[0]'