#!/bin/bash


# usefull link : https://opensource.com/article/19/10/programming-bash-loops




function CompareOrientation() {


   COSMATRIXREF=$(PrintHeader ${1} 4)
   COSMATRIXTENSOR=$(PrintHeader ${2} 4)

   if [ $COSMATRIXTENSOR = $COSMATRIXREF ]
   then
      echo "Salut les jumeaux !"
   else
     
      figlet PROBLEM
      echo ${COSMATRIXREF}
      echo ${COSMATRIXTENSOR}
   
   fi


}

function CheckStrides() {

if [[ ! -f $1 ]]
then
    echo "ERROR: $1 does not exist."
    exit

else
 
    STRIDES=$(mrinfo $1 | grep "Data strides" | awk '{print $4$5$6 }')
    echo $STRIDES
    if [ $1 != "-123" ]
    then
     echo $1
     echo mrinfo $1 | grep "Data strides"
    fi
  

fi

}

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


function CheckFolder() {

    if [[ ! -d $1 ]]
    then
    echo "ERROR: $1 does not exist."

    exit
 
    fi
}

function CreateFolderIfNotExist() {

    if [[ ! -d $1 ]]
    then
    echo "ERROR: $1 does not exist."

    mkdir $1
 
    fi
}


err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


#https://stackoverflow.com/questions/10582763/how-to-return-an-array-in-bash-without-using-globals

create_array() {
    local -n arr=$1             # use nameref for indirection
    arr=(one "two three" four)
}


use_array() {
    local my_array
    GetUserAndCreateArray my_array       # call function to populate the array
    #echo "inside use_array"
    #declare -p my_array         # test the array
    #echo ${my_array[0]}
    #echo ${my_array[1]}
    #echo ${my_array[2]}
    #echo ${my_array[3]}
    #return my_array
}


function GetUserAndCreateArray() {


if [ $USER = "valeryozenne" ]
then
VALERY=/home/$USER/mount/Valery/
IMAGERIE=/home/$USER/mount/Imagerie/
DICOM=/home/$USER/mount/Dicom/
ANTXNET=/home/Partage/Dev/ANTsXNet/
elif  [ $USER = "valery" ]
then
VALERY=/home/$USER/Reseau/Valery/
IMAGERIE=/home/$USER/Reseau/Imagerie/
DICOM=/home/$USER/Reseau/Dicom/
elif  [ $USER = "vozenne" ]
then
VALERY=/home/$USER/Reseau/Valery/
IMAGERIE=/home/$USER/Reseau/Imagerie/
DICOM=/home/$USER/Reseau/Dicom/
ANTXNET=/home/$USER/Dev/ANTsXNet/
else
figlet problem 
exit -1
fi 

local -n arr=$1  
arr=(${VALERY} ${IMAGERIE} ${DICOM} ${ANTXNET})

echo '---------------------------'
echo ${VALERY}
echo ${IMAGERIE}
echo ${DICOM}
echo ${ANTXNET}


}




main() {
  ARG1=$1
  ARG2=$2
  #
  echo "Running '$RUNNING'..."
  echo "script() - all args:  $@"
  echo "script() -     ARG1:  $ARG1"
  echo "script() -     ARG2:  $ARG2"
  #
  #foo
  #bar
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  echo '----------------------------------------------------'
  echo 'Depencies.sh on: passe par la  , le main est appele, tout va bien'
  echo '----------------------------------------------------'
  main "$@"
else
  echo '----------------------------------------------------'
  echo 'Depencies.sh: on passe ici , le main n est pas appele'   
  echo '----------------------------------------------------'
fi

