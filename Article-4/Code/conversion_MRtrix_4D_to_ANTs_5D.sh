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

  echo "Converting diffusion tensor from MRtrix 4D format to ANTs 5D format"
  
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

  if [ ! -d "$FOLDER_CONVERSION" ]; 
  then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir ${FOLDER_CONVERSION}
  fi

  rm -f ${FOLDER_CONVERSION}/*.nii.gz

  # conversion from mrtrix format to fsl format
  logCmd ImageMath 4 ${FOLDER_CONVERSION}/dtiComp.nii.gz TimeSeriesDisassemble ${INPUT}


  #D11, D22, D33, D12, D13, D23
  i=0 
  for index in xx yy zz xy xz yz; do
        #echo ${i}
        #echo ${index} 
        cp ${FOLDER_CONVERSION}/dtiComp100${i}.nii.gz ${FOLDER_CONVERSION}/dtiComp_${index}.nii.gz
	#SetDirectionByMatrix ${FOLDER_CONVERSION}/dtiComp_${index}.nii.gz ${FOLDER_CONVERSION}/dtiComp_modified_${index}.nii.gz -1 0 0 0 -1 0 0 0 1
  i=$((i+1))
  done

  logCmd ImageMath 3 ${OUTPUT} ComponentTo3DTensor ${FOLDER_CONVERSION}/dtiComp_

  # TODO it should automatically check that = 5 and = 1005

  PrintHeader ${OUTPUT} | cat  | grep "dim\[4] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[5] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[6] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat  | grep "dim\[7] =" | grep -v "pixdim"
  PrintHeader ${OUTPUT} | cat   | grep "intent_code ="
  echo " " 

