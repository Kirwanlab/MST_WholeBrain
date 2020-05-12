#!/bin/bash

#SBATCH --time=40:00:00   # walltime
#SBATCH --ntasks=10   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10gb   # memory per CPU core
#SBATCH -J "TaskS4"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



### --- Set up --- ###										###??? update variables/arrays
#
# This is where the script will orient itself.
# Notes are supplied, and is the only section
# that really needs to be changed for each
# experiment.


# General variables
derDir=~/compute/Exercise/derivatives						# par dir of data
outDir=${derDir}/Analyses/grpAnalysis						# where output will be written (should match step3)
refFile=${derDir}/sub-1425/run-1_mst_scale+tlrc			# reference file, for finding dimensions etc
mask=${outDir}/Intersection_GM_mask+tlrc				# assumes that you made this with Task_step4 scripts.

subj=$1

pref=mst

print=${subj}_ACF_raw_${pref}.txt

# blur, determine parameter estimate
blurInt=2

cd ${derDir}/${subj}

3dmerge -prefix ${pref}_stats_REML_blur${blurInt} -1blur_fwhm $blurInt -doall ${pref}_stats_REML+tlrc
3dmerge -prefix ${pref}_errts_REML_blur${blurInt} -1blur_fwhm $blurInt -doall ${pref}_errts_REML+tlrc

3dFWHMx -mask $mask -input ${pref}_errts_REML_blur${blurInt}+tlrc -acf >> $print

