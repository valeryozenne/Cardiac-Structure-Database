#!/bin/bash


function logCmd() {
  cmd="$@"
  echo "BEGIN >>>>>>>>>>>>>>>>>>>>"
  echo $cmd
  # Preserve quoted parameters by running "$@" instead of $cmd
  ( "$@" )

  cmdExit=$?

  if [[ $cmdExit -gt 0 ]];
    then
      echo "ERROR: command exited with nonzero status $cmdExit"
      echo "Command: $cmd"
      echo
      if [[ ! $DEBUG_MODE -gt 0 ]];
        then
          exit 1
        fi
    fi

  echo "END   <<<<<<<<<<<<<<<<<<<<"
  echo
  echo

  return $cmdExit
}


function CheckFile() {

    if [[ ! -f $1 ]]
    then
    echo "ERROR: $1 does not exist."

    exit
 
    fi
}


TIME=$(date +%H_%M_%S)


for MODE in Native Template
do

for NUM in averaged 1 2 3 
do

   if [[ ${MODE} = "Template"  ]]
   then

   FOLDER_INITIAL=/home/vozenne/Reseau/Imagerie/DICOM_DATA/2020-11-24_Septum/Data_For_Reviewer/Data/${NUM}/${MODE}/
   TENSOR_4D_NII=${FOLDER_INITIAL}/tensor_${NUM}_moved_4D_reoriented.nii.gz     
   
   #logCmd ./extract_metrics_from_tensor_simple_open.sh ${TIME} ${FOLDER_INITIAL} ${TENSOR_4D_NII} ${NUM} "_moved" "_reoriented" 
 
   CheckFile ${TENSOR_4D_NII}
   
   ## partie tracto
   
   FOLDER_TRACTO=${FOLDER_INITIAL}/Streamlines/
   mkdir ${FOLDER_TRACTO}
   SELECT=50000
   ANGLE=60
   CUTOFF=0.1
   MAXLENGH=20
   ROI_NAME=Full
   TRACTO_FACT=${FOLDER_TRACTO}/stream_${ROI_NAME}_s${SELECT}_a${MAXLENGH}_angle${ANGLE}_co${CUTOFF}.tck
  
   MEAN=${FOLDER_INITIAL}/mean_bzero_${NUM}_moved_reoriented.nii.gz
   FA=${FOLDER_INITIAL}/fa_${NUM}_moved_reoriented.nii.gz
   V1=${FOLDER_INITIAL}/Vectors/v1_${NUM}_moved_reoriented.nii.gz
   MASK=${FOLDER_INITIAL}/mask_atropos_${NUM}_all_to_T_via_ants.nii.gz
   CheckFile ${V1}
   CheckFile ${FA}
   CheckFile ${MEAN}
   
   OUT=${FOLDER_INITIAL}/mask_tracto_${NUM}_moved_reoriented.nii.gz
   #logCmd ThresholdImage 3 ${FA} ${OUT} 0.1 Inf 1 0  
   
   logCmd tckgen ${V1} -algorithm FACT -select ${SELECT} -step 0.5 -angle ${ANGLE} -cutoff ${CUTOFF} -maxlength ${MAXLENGH} -minlength 1 -seed_image ${OUT}  ${TRACTO_FACT}  --force
   
   
   X=10
   Y=-8
   Z=11
   FOV=40
   FIGURE_NAME=figure_2D_tracto_${NUM}_FACT_${ROI_NAME}_s${SELECT}_ep${STEP}_a${MAXLENGH}_angle${ANGLE}_co${CUT_OFF}_moved_to_T_
   logCmd mrview  ${MEAN}  -size 1800,600 -mode 2 -focus ${X},${Y},${Z} -target ${X},${Y},${Z}  -intensity 0,11 -tractography.load ${TRACTO_FACT}  -tractography.lighting 1 -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0  -orientationlabel 0 -colourbar 0  -imagevisible 0 -capture.folder Figures/ -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit
   
   FIGURE_NAME=figure_3D_tracto_${NUM}_FACT_${ROI_NAME}_s${SELECT}_ep${STEP}_a${MAXLENGH}_angle${ANGLE}_co${CUT_OFF}_moved_to_T_
   logCmd mrview  ${MEAN}  -size 1800,600 -mode 3 -focus ${X},${Y},${Z} -target ${X},${Y},${Z}  -intensity 0,11 -tractography.load ${TRACTO_FACT}  -tractography.lighting 1  -comments 0 -voxelinfo 0 -orientationlabel 0 -colourbar 0  -imagevisible 0 -capture.folder Figures/ -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit

   
   echo ${TENSOR_4D_NII}
   elif [[ ${MODE} = "Native" &&  ${NUM} != "averaged"  ]]
   then   
 
   FOLDER_INITIAL=/home/vozenne/Reseau/Imagerie/DICOM_DATA/2020-11-24_Septum/Data_For_Reviewer/Data/${NUM}/${MODE}/
   TENSOR_4D_NII=${FOLDER_INITIAL}/tensor_${NUM}_4D.nii.gz 
   
   #logCmd ./extract_metrics_from_tensor_simple_open.sh ${TIME} ${FOLDER_INITIAL} ${TENSOR_4D_NII} ${NUM} "" ""
 
   CheckFile ${TENSOR_4D_NII}
   echo ${TENSOR_4D_NII}
   
   
   fi
   

done

done

