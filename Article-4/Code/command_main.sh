#!/bin/bash

. dependencies.sh

Help()
{
--------------------------------------------------------------------------------------
Valéry Ozenne, CNRS

Relevent references for this script include:
   * https://github.com/valeryozenne/Cardiac-Structure-Code/
   * https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0271279/
   * https://pubmed.ncbi.nlm.nih.gov/35302879/
   * https://github.com/ANTsX/ANTs/wiki/Warp-and-reorient-a-diffusion-tensor-image

--------------------------------------------------------------------------------------
script by Valery Ozenne and largely inspired from ANTs repository.
--------------------------------------------------------------------------------------
}


################################################################################
#
# Folders
#    1.  
#
################################################################################

TIME=$(date +%H_%M_%S)

FOLDER_DATABASE=/path/to/data_article_triangle/
SPECIES=Sheep
NUM=1

FORCE=0

# modify the .. by the local path of this directory: Data_For_Reviewer/Data/
# the data is available at this link : https://doi.org/10.5281/zenodo.10303489

FOLDER_SAMPLE=${FOLDER_DATABASE}/${SPECIES}/${NUM}/
CheckFolder ${FOLDER_SAMPLE}

FOLDER_INITIAL=${FOLDER_SAMPLE}/Initial/
FOLDER_ALIGNED=${FOLDER_SAMPLE}/Aligned/
FOLDER_FIGURES=../Figures/

CreateFolderIfNotExist ${FOLDER_INITIAL}
CreateFolderIfNotExist ${FOLDER_ALIGNED}
mkdir ${FOLDER_FIGURES}

FOLDER_VECTORS=${FOLDER_INITIAL}/Vectors/
CreateFolderIfNotExist ${FOLDER_VECTORS}

CheckFolder ${FOLDER_INITIAL}
CheckFolder ${FOLDER_ALIGNED}

TENSOR_4D_NII=${FOLDER_INITIAL}/tensor_${NUM}_4D.nii.gz
MEAN_NII=${FOLDER_INITIAL}/mean_bzero_${NUM}.nii.gz  
MASK_THRESHOLD_NII=${FOLDER_INITIAL}/mask_threshold_${NUM}_all.nii.gz  

if [[ ! -f ${TENSOR_4D_NII} ]] || [[ "${FORCE}" = 1 ]] ;  then 
cp ${FOLDER_SAMPLE}/tensor_RVIP.nii.gz ${TENSOR_4D_NII} 
fi
if [[ ! -f ${MEAN_NII} ]] || [[ "${FORCE}" = 1 ]] ;  then 
cp ${FOLDER_SAMPLE}/mean_b0_RVIP.nii.gz ${MEAN_NII} 
fi
if [[ ! -f ${MASK_THRESHOLD_NII} ]] || [[ "${FORCE}" = 1 ]] ;  then 
cp ${FOLDER_SAMPLE}/mask_threshold_${NUM}_all.nii.gz ${MASK_THRESHOLD_NII}
fi

CheckFile ${TENSOR_4D_NII}
CheckFile ${MEAN_NII}  
CheckFile ${MASK_THRESHOLD_NII} 

TENSOR_5D_NII=${FOLDER_INITIAL}/tensor_${NUM}_5D.nii.gz

FA=${FOLDER_INITIAL}/fa_${NUM}.nii.gz
ADC=${FOLDER_INITIAL}/adc_${NUM}.nii.gz
  
V1=${FOLDER_VECTORS}v1_${NUM}.nii.gz
V2=${FOLDER_VECTORS}v2_${NUM}.nii.gz 
V3=${FOLDER_VECTORS}v3_${NUM}.nii.gz

# check FA in moved position   
if [[ ! -f ${FA} ]] || [[ "${FORCE}" = 1 ]] ;  then
logCmd tensor2metric ${TENSOR_4D_NII} -fa ${FA} --force
fi

# check RGB in moved position , this can be open in 3Dslicer 
if [[ ! -f ${ADC} ]] || [[ "${FORCE}" = 1 ]] ;  then  
logCmd tensor2metric ${TENSOR_4D_NII} -adc ${ADC} --force
fi

# check orientation in moved position   
if [[ ! -f ${V1} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V1} -num 1 --force
logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V2} -num 2 --force  
logCmd tensor2metric ${TENSOR_4D_NII} -vector ${V3} -num 3 --force
fi


# convert nifti 4D  to nifti 5D
CheckFile ${TENSOR_4D_NII}
if [[ ! -f ${TENSOR_5D_NII} ]] || [[ "${FORCE}" = 1 ]] ;  then 
# check input format 
PrintHeader ${TENSOR_4D_NII} | cat  | grep "dim\[4] =" | grep -v "pixdim"
PrintHeader ${TENSOR_4D_NII} | cat  | grep "dim\[5] =" | grep -v "pixdim"
logCmd ./conversion_MRtrix_4D_to_ANTs_5D.sh	 ${TIME} ${TENSOR_4D_NII} ${TENSOR_5D_NII}
# check output format 
PrintHeader ${TENSOR_5D_NII} | cat  | grep "dim\[4] =" | grep -v "pixdim"
PrintHeader ${TENSOR_5D_NII} | cat  | grep "dim\[5] =" | grep -v "pixdim"  

fi


MEAN_NII_MOVED_TO_LA=${FOLDER_ALIGNED}/mean_bzero_${NUM}_to_LA_via_ants.nii.gz
MASK_THRESHOLD_MOVED_TO_LA=${FOLDER_ALIGNED}/mask_threshold_${NUM}_all_to_LA_via_ants.nii.gz
TENSOR_5D_NII_DEFORMED=${FOLDER_ALIGNED}/tensor_${NUM}_moved_5D_deformed.nii.gz
TENSOR_5D_NII_REORIENTED=${FOLDER_ALIGNED}/tensor_${NUM}_moved_5D_reoriented.nii.gz   


CheckFile ${MEAN_NII} 
CheckFile ${MASK_THRESHOLD_NII}
CheckFile ${TENSOR_5D_NII} 

#TRANSFORM_INITIAL_TO_LA=${FOLDER_TRANSFORM_DTI}/transform-itk_to_LA.txt
REFERENCE=../Ref/nlin_0.3_template0.nii.gz
# if too small, use mrgrid for padding, this will extent the fov of the new space .

#
CheckFile ${REFERENCE} 

#TRANSFORM_ITK_COMPOSITE=${DIRECTORY}/T_${NUM}_DT_to_ST_to_LA_Aligned_composite${NT}0CompositeWarp.nii.gz
TRANSFORM_ITK_COMPOSITE=${FOLDER_SAMPLE}/transform_itk_to_LA.mat	
CheckFile ${TRANSFORM_ITK_COMPOSITE}

CheckFile ${TRANSFORM_ITK_COMPOSITE} 


if [[ ! -f ${MASK_THRESHOLD_MOVED_TO_LA} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3  -i ${MASK_THRESHOLD_NII} -o ${MASK_THRESHOLD_MOVED_TO_LA} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${REFERENCE}  -f 0.00001 -v 1
fi

if [[ ! -f ${MEAN_NII_MOVED_TO_LA} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3  -i ${MEAN_NII} -o ${MEAN_NII_MOVED_TO_LA} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${REFERENCE}  -f 0.00001 -v 1
fi

if [[ ! -f ${TENSOR_5D_NII_DEFORMED} ]] || [[ "${FORCE}" = 1 ]] ;  then  
logCmd antsApplyTransforms -d 3 -e 2 -i ${TENSOR_5D_NII} -o ${TENSOR_5D_NII_DEFORMED} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${REFERENCE}  -f 0.00001 -v 1 
fi

## If you have computed a single affine transform only, you can reorient the tensor at this stage:
if [[ ! -f ${TENSOR_5D_NII_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd ReorientTensorImage 3 ${TENSOR_5D_NII_DEFORMED} ${TENSOR_5D_NII_REORIENTED} ${TRANSFORM_ITK_COMPOSITE} 
fi 


TENSOR_4D_NII_REORIENTED=${FOLDER_ALIGNED}/tensor_${NUM}_4D_moved_reoriented.nii.gz
# convert nifti 5D  to nifti 4D
CheckFile ${TENSOR_5D_NII_REORIENTED}
if [[ ! -f ${TENSOR_4D_NII_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then 
# check input format 
PrintHeader ${TENSOR_5D_NII_REORIENTED} | cat  | grep "dim\[4] =" | grep -v "pixdim"
PrintHeader ${TENSOR_5D_NII_REORIENTED} | cat  | grep "dim\[5] =" | grep -v "pixdim"
# convert the new tensor to 4D format  
logCmd ./conversion_ANTs_5D_to_MRtrix_4D.sh ${TIME} ${TENSOR_5D_NII_REORIENTED} ${TENSOR_4D_NII_REORIENTED} 

# check output format 
PrintHeader ${TENSOR_4D_NII_REORIENTED} | cat  | grep "dim\[4] =" | grep -v "pixdim"
PrintHeader ${TENSOR_4D_NII_REORIENTED} | cat  | grep "dim\[5] =" | grep -v "pixdim"  

fi

FA_REORIENTED=${FOLDER_ALIGNED}/fa_${NUM}_moved_reoriented.nii.gz
ADC_REORIENTED=${FOLDER_ALIGNED}/adc_${NUM}_moved_reoriented.nii.gz
  
mkdir ${FOLDER_ALIGNED}/Vectors/  
V1_REORIENTED=${FOLDER_ALIGNED}/Vectors/v1_${NUM}_moved_reoriented.nii.gz
V2_REORIENTED=${FOLDER_ALIGNED}/Vectors/v2_${NUM}_moved_reoriented.nii.gz
V3_REORIENTED=${FOLDER_ALIGNED}/Vectors/v3_${NUM}_moved_reoriented.nii.gz

# check FA in moved position 
if [[ ! -f ${FA_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then   
logCmd tensor2metric ${TENSOR_4D_NII} -fa ${FA_REORIENTED} --force
fi

# check RGB in moved position , this can be open in 3Dslicer   
if [[ ! -f ${ADC_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then   
logCmd tensor2metric ${TENSOR_4D_NII} -adc ${ADC_REORIENTED} --force
fi

# check orientation in moved position   
if [[ ! -f ${V1_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V1_REORIENTED} -num 1 --force
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V2_REORIENTED} -num 2 --force  
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V3_REORIENTED} -num 3 --force
fi



X1=8.8
Y1=-7
Z1=8

X2=10
Y2=-7
Z2=8




FOV=110
FIGURE_NAME=figure_2D_mean_bzero_initial_${NUM}_
logCmd mrview  ${MEAN_NII} -size 1800,600 -mode 2 \
               -intensity 0,2 \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
                -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit

FOV=110
FIGURE_NAME=figure_2D_mean_bzero_after_rotation_${NUM}_
logCmd mrview  ${MEAN_NII_MOVED_TO_LA}  -size 1800,600 -mode 2 \
               -intensity 0,2 \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
               -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit



FOV=50
FIGURE_NAME=figure_2D_initial_cFA_${NUM}_
logCmd mrview  ${MEAN_NII}  -size 1800,600 -mode 2 \
               -focus ${X1},${Y1},${Z1} -target ${X1},${Y1},${Z1} \
               -intensity 0,2  \
               -overlay.load ${V1} -overlay.intensity 0,0.4 -overlay.opacity 0.75 \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
                -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit

FOV=30
FIGURE_NAME=figure_2D_initial_fixel_${NUM}_
logCmd mrview  ${MEAN_NII}  -size 1800,600 -mode 2 \
               -focus ${X1},${Y1},${Z1} -target ${X1},${Y1},${Z1} \
               -intensity 0,2  \
               -fixel.load ${V1}  \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
                -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit


FOV=50
FIGURE_NAME=figure_2D_after_rotation_cFA_${NUM}_
logCmd mrview  ${MEAN_NII_MOVED_TO_LA}  -size 1800,600 -mode 2 \
               -focus ${X2},${Y2},${Z2} -target ${X2},${Y2},${Z2} \
               -intensity 0,2  \
               -overlay.load ${V1_REORIENTED} -overlay.intensity 0,0.4 -overlay.opacity 0.75 \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
                -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit

FOV=30
FIGURE_NAME=figure_2D_after_rotation_fixel_${NUM}_
logCmd mrview  ${MEAN_NII_MOVED_TO_LA}  -size 1800,600 -mode 2 \
               -focus ${X2},${Y2},${Z2} -target ${X2},${Y2},${Z2} \
               -intensity 0,2  \
               -fixel.load ${V1_REORIENTED}  \
               -config MRViewOrthoAsRow 1 -fov ${FOV}  -comments 0 -voxelinfo 0 \
               -orientationlabel 0 -colourbar 0  \
                -capture.folder ${FOLDER_FIGURES} -capture.prefix ${FIGURE_NAME} -capture.grab  -noannotations  --force  -exit







# other usefull things for the segmentation

#logCmd N4BiasFieldCorrection  -d 3  -i ${MEAN_NII}  -o ${DTI_INPUT_N4_FIRST}  -s 4 -b [80,3] -c [200x200x200x200,1e-6] -x ${MASK_OTSU_RESAMPLED_FIRST}  -v


   
   

