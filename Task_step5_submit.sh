#!/bin/bash





workDir=~/compute/MST_WholeBrain
scriptDir=${workDir}/code
slurmDir=${workDir}/derivatives/Slurm_out
time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/TaskS5_${time}

mkdir -p $outDir


sbatch \
-o ${outDir}/output_TaskS5.txt \
-e ${outDir}/error_TaskS5.txt \
${scriptDir}/Task_step5_blurBetas.sh
