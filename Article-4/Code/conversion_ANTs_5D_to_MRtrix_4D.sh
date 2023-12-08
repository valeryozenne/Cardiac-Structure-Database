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


 
  echo "Converting diffusion tensor from ANTs 5D format to MRtrix 4D format conversion_ANTs_5D_to_MRtrix_4D"
  
  echo "Nombres de paramètres : $#"
  echo "Time : $1"
  echo "Input name : $2"
  echo "Output name: $3"

  # please read 
  #https://github.com/ANTsX/ANTs/wiki/Importing-diffusion-tensor-data-from-other-software
  # and 
  # https://github.com/ANTsX/ANTs/wiki/Warp-and-reorient-a-diffusion-tensor-image
  TIME=$1
  INPUT=$2
  OUTPUT=$3

  FOLDER_CONVERSION=/tmp/ants_${TIME}/

  if [ ! -d "$FOLDER_CONVERSION" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir ${FOLDER_CONVERSION}
  fi

  rm -f ${FOLDER_CONVERSION}/*.nii.gz

  i=0 
  for index in xx xy xz yy yz zz   ; do
        echo ${i}
        echo ${index}
        logCmd ImageMath 3 ${FOLDER_CONVERSION}/Component_${index}.nii.gz ExtractVectorComponent ${INPUT} ${i} 
       
  i=$((i+1))
  done

  logCmd ImageMath 4 ${OUTPUT} TimeSeriesAssemble 1 0 ${FOLDER_CONVERSION}/Component_xx.nii.gz ${FOLDER_CONVERSION}/Component_yy.nii.gz ${FOLDER_CONVERSION}/Component_zz.nii.gz ${FOLDER_CONVERSION}/Component_xy.nii.gz ${FOLDER_CONVERSION}/Component_xz.nii.gz ${FOLDER_CONVERSION}/Component_yz.nii.gz

  # TODO it should automatically check that = 5 and = 1005

  PrintHeader ${OUTPUT} | cat  | grep "dim\[4] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[5] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[6] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[7] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "intent_code ="
  
  echo " " 

