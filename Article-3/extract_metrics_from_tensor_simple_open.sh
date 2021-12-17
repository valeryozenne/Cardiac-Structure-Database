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
  
  echo "nous utilisons la fonction extract_metrics_from_tensor" 
  echo "Nombres de paramètres : $#"
  echo "TIME" : $1
  echo "DIRECTORY name : $2"  
  echo "Check tensor: $3" 
  echo "NUM name: $4"
  echo "STRING name: $5"
 
  TIME=$1
  DIRECTORY=$2    
  TENSOR_CHECK=$3  
  NUM=$4
  STRING=$5 
  STRING2=$6 

  FOLDER_VECTORS=${DIRECTORY}/Vectors/
  FOLDER_ANGLES=${DIRECTORY}/Angles/
  echo "creating " ${FOLDER_VECTORS}
  mkdir $FOLDER_VECTORS
  mkdir $FOLDER_ANGLES     
  
  TENSOR_4D_NII=${DIRECTORY}/tensor_${NUM}${STRING}_4D${STRING2}.nii.gz

  CheckFile ${TENSOR_4D_NII}
  
  FA=${DIRECTORY}/fa_${NUM}${STRING}${STRING2}.nii.gz
  ADC=${DIRECTORY}/adc_${NUM}${STRING}${STRING2}.nii.gz
  
  V1=${FOLDER_VECTORS}v1_${NUM}${STRING}${STRING2}.nii.gz
  V2=${FOLDER_VECTORS}v2_${NUM}${STRING}${STRING2}.nii.gz 
  V3=${FOLDER_VECTORS}v3_${NUM}${STRING}${STRING2}.nii.gz

  # check FA in moved position   
  logCmd tensor2metric ${TENSOR_4D_NII} -fa ${FA} --force

  # check RGB in moved position   
  logCmd tensor2metric ${TENSOR_4D_NII} -adc ${ADC} --force
  

  # check orientation in moved position   
  logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V1} -num 1 --force
  logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V2} -num 2 --force  
  logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V3} -num 3 --force

  
 
 
  #NAME_VECTOR_V1=$(echo ${V1}  | sed "s/.nii.gz//g" | sed 's\'${FOLDER_VECTORS}'\\g')
  #NAME_VECTOR_V2=$(echo ${V2}  | sed "s/.nii.gz//g" | sed 's\'${FOLDER_VECTORS}'\\g')
  #NAME_VECTOR_V3=$(echo ${V3}  | sed "s/.nii.gz//g" | sed 's\'${FOLDER_VECTORS}'\\g')
  #OUTPUT_NAME=_$(echo ${V1}  | sed "s/.nii.gz//g"  | sed "s/v1_//g" | sed 's\'${FOLDER_VECTORS}'\\g' ) 

  # call AngleCalculation
  #logCmd /home/valery/Dev/BrukerTools/build/AngleCalculation/AngleCalculation ${FOLDER_VECTORS} ${OUTPUT_NAME} ${NAME_VECTOR_V1} ${NAME_VECTOR_V2}  ${NAME_VECTOR_V3} ${NUM} 'Full_Epi_resampled'

  #logCmd PrintHeader ${FA_NII} 4  | sed "s/x/ /g"
  # get correct orientation, this is not  done correctly in  AngleCalculation
  #PrintHeader ${FA_NII} 4  | sed "s/x/ /g" > ${FOLDER_VECTORS}/direction_matrix.txt
  #DIRECTION_MATRIX=$(PrintHeader ${FA_NII} 4  | sed "s/x/ /g" ) 
  #echo ${DIRECTION_MATRIX}
   

  #loop over the 6 angles
  #for ANGLES in helix transverse sheet_azi sheet_ele normal_azi normal_ele
  #do

  #ANGLES_REORIENTED=${DIRECTORY}/Angles/${ANGLES}_${NUM}${STRING}.nii.gz 
  # correct for orientation

  #logCmd SetDirectionByMatrix ${ANGLES_REORIENTED} ${ANGLES_REORIENTED} ${DIRECTION_MATRIX}  
  #done

  

  


  
