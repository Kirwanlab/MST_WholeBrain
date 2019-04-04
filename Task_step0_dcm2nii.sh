#!/bin/bash




### --- Notes
#
# 1) this script will construct T1, T2, EPI data and organize output
#		according to BIDS formatting
#
# 2) written so you can just update $subjList and rerun the whole script



###??? change these variables/arrays
rawDir=/Volumes/Yorick/MriRawData							# location of dicom data
workDir=/Volumes/Yorick/Exercise        					# desired working directory
templateDir=${workDir}/code/Templates

subjList=(1425 1428 1435 1443 1461 1475 1476 1479 1514 1515 1516 1537 1538 1539 1540 1542 1543 1544 1545 1548 1549 1565 1568 1569 1570 1572 1573 1587 1588 1589 1591 1592 1593 1594 1597 1963 2259 2313 2347 2384 2395 2411 2413 2436 2459 2552 2555 2560)	# list of subjects
session=Exercise											# scanning session - for raw data organization (ses-STT)
task=task-mst												# name of task, for epi data naming

epiDirs=(run{1,2,3,4,5,6})		            				# epi dicom directory name/prefix
t1Dir=t1													# t1 ditto
t2Dir=HHR													# t2 ditto
#need to add something for DWI directory
blipDir=()											# blip ditto - names one per scanning phase



### set up BIDS parent dirs
for i in derivatives sourcedata stimuli rawdata; do
	if [ ! -d ${workDir}/$i ]; then
		mkdir -p ${workDir}/$i
	fi
done



for i in ${subjList[@]}; do

	### set up BIDS raw data dirs
	anatDir=${workDir}/rawdata/sub-${i}/anat
	funcDir=${workDir}/rawdata/sub-${i}/func
	derivDir=${workDir}/derivatives/sub-${i}

	if [ ! -d $anatDir ]; then
		mkdir -p $anatDir
	fi
	if [ ! -d $funcDir ]; then
		mkdir -p $funcDir 
	fi
	if [ ! -d $derivDir ]; then
		mkdir -p  $derivDir 
	fi


	### construct data
	dataDir=${rawDir}/sub-${i}/ses-${session}/dicom

	# t1 data: import and deface
	if [ ! -f ${anatDir}/sub-${i}_T1w.nii.gz ]; then
		#import T1 from dicom. Put in dicom folder for now. Will be de-faced in the next step.
		mkdir ${rawDir}/sub-${i}/ses-${session}/anat
		dcm2niix -b y -ba y -z y -o ${rawDir}/sub-${i}/ses-${session}/anat -f sub-${i}_T1w ${dataDir}/${t1Dir}*/
		#de-face the T1. There are several ways to do this. The FreeSurfer program 'mri_deface' seems to work pretty well, but it fails on a few of our scans, presumably due to low gray/white contrast. This is the code for making that happen:
		## [N.B.: This step may not work in a script because of Mac OS X SIP. You can disable this "security" feature by doing this: https://afni.nimh.nih.gov/afni/community/board/read.php?1,149775,149775]
		# mri_deface ${rawDir}/${studySub}/${session}/${studySub}_run-${run}_T1w.nii.gz /usr/local/bin/freesurfer/talairach_mixed_with_skull.gca /usr/local/bin/freesurfer/face.gca ${studyDir}/${studySub}/anat/${studySub}_run-${run}_T1w.nii.gz
		##delete the log file (which writes out the same info every time it's successful)
		# rm ${studySub}_run-${run}_T1w.nii.log
	
		## There is also a python tool for this called pydeface (written by Russ Poldrack), but I couldn't get it to work with all the python dependencies it has.
		## Instead, I borrowed the mask and the mean structural files from that toolkit and I use them with AFNI tools to:
		## 1-calculate a spatial transformation from the mean structural to the subject's struct
		## 2-apply that transformation to the face mask
		## 3-multiply the mask by the subject structural to zero out all the face voxels (and nothing else)
		3dAllineate -base ${rawDir}/sub-${i}/ses-${session}/anat/sub-${i}_T1w.nii.gz -input ${templateDir}/mean_reg2mean.nii.gz -prefix ${derivDir}/mean_reg2mean_aligned.nii -1Dmatrix_save ${derivDir}/allineate_matrix 
		3dAllineate -base ${rawDir}/sub-${i}/ses-${session}/anat/sub-${i}_T1w.nii.gz -input ${templateDir}/facemask.nii.gz       -prefix ${derivDir}/facemask_aligned.nii      -1Dmatrix_apply ${derivDir}/allineate_matrix.aff12.1D 
		3dcalc -a ${derivDir}/facemask_aligned.nii -b ${rawDir}/sub-${i}/ses-${session}/anat/sub-${i}_T1w.nii.gz  -prefix ${anatDir}/sub-${i}_T1w.nii.gz -expr "step(a)*b"
		#keep the BIDS validator happy and copy over the json file
		cp ${rawDir}/sub-${i}/ses-${session}/anat/sub-${i}_T1w.json ${anatDir}/.
		
	fi


	# t2
	if [ ! -f ${anatDir}/sub-${i}_T2w.nii.gz ]; then
		dcm2niix -b y -ba y -z y -o $anatDir -f sub-${i}_T2w ${dataDir}/${t2Dir}*/
	fi


	# epi
	for j in ${!epiDirs[@]}; do
		pos=$(($j+1))
		if [ ! -f ${funcDir}/sub-${i}_${task}_run-${pos}_bold.nii.gz ]; then
			dcm2niix -b y -ba y -z y -o $funcDir -f sub-${i}_${task}_run-${pos}_bold ${dataDir}/${epiDirs[$j]}*/
		fi

        #also keeps BIDS validator happy. Requires program jq: https://stedolan.github.io/jq/
		funcjson=${funcDir}/sub-${i}_${task}_run-${pos}_bold.json
		taskexist=$(cat ${funcjson} | jq '.TaskName')
		if [ "$taskexist" == "null" ]; then
			jq '. |= . + {"TaskName":"MST"}' ${funcjson} > ${derivDir}/tasknameadd.json         #?? replace "MST" with your task name
			rm ${funcjson}
			mv ${derivDir}/tasknameadd.json ${funcjson}
		fi

	done


	# blip
	if [ ! -z $blipDir ]; then
		for k in ${!blipDir[@]}; do
			pos=$(($k+1))
			if [ ! -f ${funcDir}/sub-${i}_phase-${pos}_blip.nii.gz ]; then
				dcm2niix -b y -ba y -z y -o $funcDir -f sub-${i}_phase-${pos}_blip ${dataDir}/${blipDir}*/
			fi
		done
	fi
done
