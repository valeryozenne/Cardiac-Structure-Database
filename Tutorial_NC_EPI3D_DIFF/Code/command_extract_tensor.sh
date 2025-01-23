#!/bin/bash

. dependencies.sh
. utility.sh 

TIME=$(date +%H_%M_%S)

FORCE='N'

PROJECT_FOLDER=/workspace_QMRI/PROJECTS_DATA/2025_RECH_EPI3Ddiff_horse/

#MAIN_EXAM_FOLDER_PATH=${PRISMA_FOLDER}/EEPHEARTNUMBER5_25_01_08-16_36_22-STD-1_3_12_2_1107_5_2_43_66056/
#MAIN_EXAM_FOLDER_PATH=${PRISMA_FOLDER}/2024-10-11-EXVIVO-UNMASC-20633_2024-10-11-EXVIVO-UNMASC-20633/
#SUB_EXAM_FILENAME_LIST==RMSB_PC_20250108_163722_912000
#SUB_EXAM_FILENAME_LIST=RMSB_PC_20241011_135124_275000
#mrconvert ${EXAM_FOLDER_PATH}/NC_EPI3D_DIFF_S5_B0_HF_4SEG_0003/ ${DWI_B0_HF} -grad ${VEC_B0_LIST} --force
#mrconvert ${EXAM_FOLDER_PATH}/NC_EPI3D_DIFF_S5_B0_FH_4SEG_0004/ ${DWI_B0_FH} -grad ${VEC_B0_LIST} --force
#mrconvert ${EXAM_FOLDER_PATH}/NC_EPI3D_DIFF_S5_B1000_HF_4SEG_0005/ ${DWI_BVALUE_HF} -grad ${VEC_BVALUE_LIST}  --force





JSON=$1

Display_JSON ${JSON}

PROJECT_FOLDER=$(Get_PROJECT_FOLDER ${JSON})
MAIN_EXAM_FOLDER_NAME=$(Get_MAIN_EXAM_FOLDER_NAME ${JSON})
SUB_EXAM_FOLDER_NAME=$(Get_SUB_EXAM_FOLDER_NAME ${JSON})
MRTRIX_FOLDER_NAME=$(Get_MRTRIX_FOLDER_NAME ${JSON})
SEQ_AP_B0_FOLDER_NAME=$(Get_SEQ_AP_B0_FOLDER_NAME ${JSON})
SEQ_PA_B0_FOLDER_NAME=$(Get_SEQ_PA_B0_FOLDER_NAME ${JSON})
SEQ_AP_BVALUE_FOLDER_NAME=$(Get_SEQ_AP_BVALUE_FOLDER_NAME ${JSON})
DIR=$(Get_DIR ${JSON})
FORCE=$(Get_FORCE ${JSON})
TRANSFORM_ALIGNED=$(Get_TRANSFORM_ALIGNED ${JSON})
RESLICED_REFERENCE=$(Get_RESLICED_REFERENCE ${JSON})
THRESHOLD=$(Get_THRESHOLD ${JSON})
MPRAGE_FOLDER=$(Get_MPRAGE_FOLDER ${JSON})

LIST_VEC_FOLDER=${PROJECT_FOLDER}/ListeVecteurs/
PRISMA_FOLDER=${PROJECT_FOLDER}/PrismaData/

MAIN_EXAM_FOLDER_PATH=${PRISMA_FOLDER}/${MAIN_EXAM_FOLDER_NAME}/
CheckFolder ${MAIN_EXAM_FOLDER_PATH}

SUB_EXAM_FOLDER_PATH=${MAIN_EXAM_FOLDER_PATH}/${SUB_EXAM_FOLDER_NAME}/
CheckFolder ${SUB_EXAM_FOLDER_PATH}

MRTRIX_FOLDER=${MAIN_EXAM_FOLDER_PATH}/${MRTRIX_FOLDER_NAME}/
CreateFolderIfNotExist ${MRTRIX_FOLDER}

echo ------------ ${DIR} --------------

echo MAIN_EXAM_FOLDER_NAME ${MAIN_EXAM_FOLDER_NAME}
echo SUB_EXAM_FOLDER_NAME ${SUB_EXAM_FOLDER_NAME}
echo MRTRIX_FOLDER_NAME ${MRTRIX_FOLDER_NAME}

echo MAIN_EXAM_FOLDER_PATH ${MAIN_EXAM_FOLDER_PATH}
echo SUB_EXAM_FOLDER_PATH ${SUB_EXAM_FOLDER_PATH}
echo MRTRIX_FOLDER ${MRTRIX_FOLDER}
echo ''
echo ${MPRAGE_FOLDER}
echo ${SEQ_AP_B0_FOLDER_NAME}
echo ${SEQ_PA_B0_FOLDER_NAME}
echo ${SEQ_AP_BVALUE_FOLDER_NAME}

echo ====================================================

# fix !!
NUMERO_DE_FICHIERS_DE_VEC=3
BVALUE=1000

FIGURE_FOLDER=${MAIN_EXAM_FOLDER_PATH}/Figures/
CreateFolderIfNotExist ${FIGURE_FOLDER}
CheckFolder ${PRISMA_FOLDER}
CheckFolder ${MAIN_EXAM_FOLDER_PATH}



COUNT=1

for xx in -1 1
do
for yy in -1 1
do
for zz in -1 1
do

#echo ${COUNT}

if [[ ${COUNT} -eq 3 ]]; then

FOLDER_INITIAL=${MRTRIX_FOLDER}/Initial/
CreateFolderIfNotExist ${FOLDER_INITIAL}
FOLDER_ALIGNED=${MRTRIX_FOLDER}/Aligned/
CreateFolderIfNotExist ${FOLDER_ALIGNED}

VEC_B0_LIST=${MRTRIX_FOLDER}/direction_b0.txt
VEC_BVALUE_LIST=${MRTRIX_FOLDER}/direction.txt

echo "0  0  0  0" > ${VEC_B0_LIST}

./extract_lines.sh ${LIST_VEC_FOLDER}/DTI_vector_${NUMERO_DE_FICHIERS_DE_VEC}.txt "=${DIR}" ${DIR} | grep -v "direction" > ${MRTRIX_FOLDER}/tempo_liste_des_directions.txt

./add_bvalue_in_mrtrix_format.sh ${MRTRIX_FOLDER}/tempo_liste_des_directions.txt ${BVALUE} > ${VEC_BVALUE_LIST}

echo "$xx $yy $zz" "${COUNT}"

if [[ $xx -eq 1 ]]; then
flix_x=0
else
flix_x=1
fi

if [[ $yy -eq 1 ]]; then
flix_y=0
else
flix_y=1
fi

if [[ $zz -eq 1 ]]; then
flix_z=0
else
flix_z=1
fi

VEC_BVALUE_LIST_FLIPPED=${MRTRIX_FOLDER}/direction_flip_${flix_x}_${flix_y}_${flix_z}.txt
awk -v facteurx="${xx}" -v facteury="${yy}" -v facteurz="${zz}" '{
    printf "%f ", $1 * facteurx
    printf "%f ", $2 * facteury
    printf "%f ", $3 * facteurz
    print $4
}' ${VEC_BVALUE_LIST} > ${VEC_BVALUE_LIST_FLIPPED}

#cat ${VEC_BVALUE_LIST_FLIPPED}



MPRAGE=${MRTRIX_FOLDER}/mprage.mif
MPRAGE_NII=${MRTRIX_FOLDER}/mprage.nii.gz
DWI_B0_HF=${MRTRIX_FOLDER}/dwi_b0_HF.mif
DWI_B0_FH=${MRTRIX_FOLDER}/dwi_b0_FH.mif
DWI_B0_HF_2ND=${MRTRIX_FOLDER}/dwi_b0_HF_2nd.mif
DWI_B0_FH_2ND=${MRTRIX_FOLDER}/dwi_b0_FH_2nd.mif
DWI_BVALUE_HF=${MRTRIX_FOLDER}/dwi_b${BVALUE}_HF_raw.mif
DWI_HF=${MRTRIX_FOLDER}/dwi_HF_raw.mif

if [[ ! -f ${MPRAGE} ]]; then
logCmd mrconvert ${SUB_EXAM_FOLDER_PATH}/${MPRAGE_FOLDER} ${MPRAGE}
fi

if [[ ! -f ${MPRAGE_NII} ]]; then
logCmd mrconvert ${MPRAGE} ${MPRAGE_NII}
fi

if [[ ! -f ${DWI_B0_HF} ]]; then
mrconvert ${SUB_EXAM_FOLDER_PATH}/${SEQ_AP_B0_FOLDER_NAME} ${DWI_B0_HF} -grad ${VEC_B0_LIST} --force
fi

if [[ ! -f ${DWI_B0_FH} ]]; then
mrconvert ${SUB_EXAM_FOLDER_PATH}/${SEQ_PA_B0_FOLDER_NAME} ${DWI_B0_FH} -grad ${VEC_B0_LIST} --force
fi

#echo "---------------------"
#mrinfo  ${DWI_B0_HF} 
#mrinfo  ${DWI_B0_FH} 
#mrinfo  ${DWI_B0_HF_2ND} 
#mrinfo  ${DWI_B0_FH_2ND} 
#echo "---------------------"


if [[ ! -f ${DWI_BVALUE_HF} ]]; then
mrconvert ${SUB_EXAM_FOLDER_PATH}/${SEQ_AP_BVALUE_FOLDER_NAME} ${DWI_BVALUE_HF} -grad ${VEC_BVALUE_LIST_FLIPPED}  --force
fi

mrinfo  ${DWI_B0_HF}  -size  -spacing 
mrinfo  ${DWI_B0_FH}   -size  -spacing 
mrinfo ${DWI_BVALUE_HF}   -size  -spacing 

#mrview ${MPRAGE} -overlay.load ${DWI_B0_HF} -overlay.load ${DWI_B0_HF_2ND}
#mrview ${MPRAGE} -overlay.load ${DWI_B0_FH} -overlay.load ${DWI_B0_FH_2ND}


if [[ ! -f ${DWI_HF} ]]; then
mrcat ${DWI_B0_HF} ${DWI_BVALUE_HF} ${DWI_HF}
fi

DWI_DENOISE_NAME=dwi_den.mif
DWI_DENOISE=${MRTRIX_FOLDER}/${DWI_DENOISE_NAME}
DWI_DENOISE_MODIFIED=${MRTRIX_FOLDER}/dwi_den_right_strides.mif
if [[ ! -f $DWI_DENOISE ]]; then
logCmd dwidenoise ${DWI_HF} ${DWI_DENOISE}  
fi

if [[ ! -f ${DWI_DENOISE_MODIFIED} ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd mrconvert  -strides 1,2,3,4 ${DWI_DENOISE}  ${DWI_DENOISE_MODIFIED}  --force
fi

DTI_NAME=tensor.mif
MEAN_B0_NAME=mean_bzero.mif

MEAN_B0=${FOLDER_INITIAL}/${MEAN_B0_NAME}
MEAN_B0_NII=$(echo ${MEAN_B0}| sed 's/.mif/.nii.gz/g')
DTI=${FOLDER_INITIAL}/${DTI_NAME}

if [[ ! -f $DTI ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd dwi2tensor -info -b0 ${MEAN_B0} ${DWI_DENOISE_MODIFIED} ${DTI}  --force
fi

if [[ ! -f ${MEAN_B0_NII} ]] || [[ ${FORCE} == 'Y' ]]; then
mrconvert ${MEAN_B0} ${MEAN_B0_NII} --force
fi

#### optional
if [[ ! -f ${FOLDER_INITIAL}/mask_maximum.nii.gz ]] || [[ ${FORCE} == 'Y' ]]; then
echo 'optionnal'
ThresholdImage 3 ${MEAN_B0_NII} ${FOLDER_INITIAL}/mask_maximum.nii.gz 2000 Inf 0 1
fi

if [[ ! -f ${FOLDER_INITIAL}/mean_bzero_corrected.nii.gz ]] || [[ ${FORCE} == 'Y' ]]; then
mrcalc ${MEAN_B0_NII} ${FOLDER_INITIAL}/mask_maximum.nii.gz -mult ${FOLDER_INITIAL}/mean_bzero_corrected.nii.gz --force
fi

MASK_THRESHOLD_NII=${FOLDER_INITIAL}/mask_threshold.nii.gz
if [[ ! -f ${MASK_THRESHOLD_NII} ]] || [[ ${FORCE} == 'Y' ]]; then
ThresholdImage 3 ${MEAN_B0_NII} ${MASK_THRESHOLD_NII} ${THRESHOLD} Inf 1 0
fi

FA_NAME=fa.mif
ADC_NAME=adc.mif
AD_NAME=ad.mif
RD_NAME=rd.mif
E1_NAME=e1.mif
E2_NAME=e2.mif
E3_NAME=e3.mif
V1_NAME=v1.mif
V2_NAME=v2.mif
V3_NAME=v3.mif

ADC=${FOLDER_INITIAL}/${ADC_NAME}
FA=${FOLDER_INITIAL}/${FA_NAME}
AD=${FOLDER_INITIAL}/${AD_NAME}
RD=${FOLDER_INITIAL}/${RD_NAME}

CreateFolderIfNotExist ${FOLDER_INITIAL}/Vectors/  

V1=${FOLDER_INITIAL}/Vectors/${V1_NAME}
V2=${FOLDER_INITIAL}/Vectors/${V2_NAME}
V3=${FOLDER_INITIAL}/Vectors/${V3_NAME} 

if [[ ! -f ${ADC} ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd tensor2metric -adc ${ADC} ${DTI} --force
fi

if [[ ! -f ${FA} ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd tensor2metric -fa ${FA} ${DTI} --force
fi

if [[ ! -f ${AD} ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd tensor2metric -ad ${AD} ${DTI} --force
fi

if [[ ! -f ${RD} ]] || [[ ${FORCE} == 'Y' ]]; then
logCmd tensor2metric -rd ${RD} ${DTI} --force
fi

if [[ ! -f ${V1} ]] || [[ ${FORCE} == 'Y' ]]; then
tensor2metric ${DTI} -vector ${V1} -num 1 --force 
fi

if [[ ! -f ${V2} ]] || [[ ${FORCE} == 'Y' ]]; then
tensor2metric ${DTI} -vector ${V2} -num 2 --force
fi

if [[ ! -f ${V3} ]] || [[ ${FORCE} == 'Y' ]];  then
tensor2metric ${DTI} -vector ${V3} -num 3 --force
fi

V1_MASKED=$(echo ${V1} | sed 's/.mif/_masked.nii.gz/g')

if [[ ! -f ${V1_MASKED} ]] || [[ ${FORCE} == 'Y' ]]; then
mrcalc ${V1} ${MASK_THRESHOLD_NII} -mult ${V1_MASKED} --force
fi

#FIGURE_FILENAME=figure_reco_${COUNT}_mean_b0_and_fixel_
#mrview ${MEAN_B0} -mode 2 -fov 50 -size 1200,1200 -fixel.load ${V1_MASKED} \
# -capture.folder ${FIGURE_FOLDER}  -capture.prefix ${FIGURE_FILENAME} \
# -capture.grab -force -exit

#mrview ${MEAN_B0}  -mode 2 -fov 30 -fixel.load ${V1_MASKED}

TENSOR_4D_NII=${FOLDER_INITIAL}/tensor_4D.nii.gz
TENSOR_5D_NII=${FOLDER_INITIAL}/tensor_5D.nii.gz

if [[ ! -f ${TENSOR_4D_NII} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd mrconvert ${DTI}  ${TENSOR_4D_NII}
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


echo itksnap -g ${MEAN_B0_NII} -o ${MEAN_B0_NII}

NUM=1

MEAN_B0_NII_MOVED_TO_LA=${FOLDER_ALIGNED}/mean_bzero_${NUM}_to_LA_via_ants.nii.gz
MASK_THRESHOLD_MOVED_TO_LA=${FOLDER_ALIGNED}/mask_threshold_${NUM}_all_to_LA_via_ants.nii.gz
TENSOR_5D_NII_DEFORMED=${FOLDER_ALIGNED}/tensor_${NUM}_moved_5D_deformed.nii.gz
TENSOR_5D_NII_REORIENTED=${FOLDER_ALIGNED}/tensor_${NUM}_moved_5D_reoriented.nii.gz   

CheckFile ${MEAN_B0_NII} 
CheckFile ${MASK_THRESHOLD_NII}
CheckFile ${TENSOR_5D_NII} 

TRANSFORM_INITIAL_TO_LA=../Transforms/${TRANSFORM_ALIGNED}
CheckFile ${TRANSFORM_INITIAL_TO_LA}

RESLICED_REFERENCE=../Transforms/${RESLICED_REFERENCE}
CheckFile ${RESLICED_REFERENCE}
# if too small, use mrgrid for padding, this will extent the fov of the new space .

#TRANSFORM_ITK_COMPOSITE=${DIRECTORY}/T_${NUM}_DT_to_ST_to_LA_Aligned_composite${NT}0CompositeWarp.nii.gz
TRANSFORM_ITK_COMPOSITE=${FOLDER_ALIGNED}/transform_composite_Linear.mat	

# creating a .mat transform 
# could be also a vector field for non linear registration     

if [[ ! -f ${TRANSFORM_ITK_COMPOSITE} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3 -o Linear[${TRANSFORM_ITK_COMPOSITE}] \
                        -t ${TRANSFORM_INITIAL_TO_LA} \
                        -r ${RESLICED_REFERENCE}  -v                       
fi


MPRAGE_SPACING_X=$(mrinfo ${MPRAGE} -spacing | cut -d " " -f 1)
MPRAGE_SPACING_Y=$(mrinfo ${MPRAGE} -spacing | cut -d " " -f 2)
MPRAGE_SPACING_Z=$(mrinfo ${MPRAGE} -spacing | cut -d " " -f 3)

RESLICED_MPRAGE_REFERENCE=${FOLDER_ALIGNED}/resliced_ref_to_mprage_resolution.nii.gz
if [[ ! -f ${RESLICED_MPRAGE_REFERENCE} ]] || [[ "${FORCE}" = 1 ]] ;  then
logCmd mrgrid ${RESLICED_REFERENCE} regrid  -voxel ${MPRAGE_SPACING_X},${MPRAGE_SPACING_Y},${MPRAGE_SPACING_Z} ${RESLICED_MPRAGE_REFERENCE} --force
fi
MPRAGE_MOVED_TO_LA=${FOLDER_ALIGNED}/mprage_to_LA_via_ants.nii.gz
CheckFile ${TRANSFORM_ITK_COMPOSITE}

if [[ ! -f ${MPRAGE_MOVED_TO_LA} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3  -i ${MPRAGE_NII} -o ${MPRAGE_MOVED_TO_LA} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${RESLICED_MPRAGE_REFERENCE}  -f 0.00001 -v 1
fi

if [[ ! -f ${MEAN_B0_NII_MOVED_TO_LA} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3  -i ${MEAN_B0_NII} -o ${MEAN_B0_NII_MOVED_TO_LA} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${RESLICED_REFERENCE}  -f 0.00001 -v 1
fi

if [[ ! -f ${MASK_THRESHOLD_MOVED_TO_LA} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd antsApplyTransforms -d 3  -i ${MASK_THRESHOLD_NII} -o ${MASK_THRESHOLD_MOVED_TO_LA} -n NearestNeighbor -t ${TRANSFORM_ITK_COMPOSITE}  -r ${RESLICED_REFERENCE}  -f 0.00001 -v 1
fi



if [[ ! -f ${TENSOR_5D_NII_DEFORMED} ]] || [[ "${FORCE}" = 1 ]] ;  then  
logCmd antsApplyTransforms -d 3 -e 2 -i ${TENSOR_5D_NII} -o ${TENSOR_5D_NII_DEFORMED} -t ${TRANSFORM_ITK_COMPOSITE}  -r ${RESLICED_REFERENCE}  -f 0.00001 -v 1 
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
  
CreateFolderIfNotExist ${FOLDER_ALIGNED}/Vectors/  
V1_REORIENTED=${FOLDER_ALIGNED}/Vectors/v1_${NUM}_moved_reoriented.nii.gz
V2_REORIENTED=${FOLDER_ALIGNED}/Vectors/v2_${NUM}_moved_reoriented.nii.gz
V3_REORIENTED=${FOLDER_ALIGNED}/Vectors/v3_${NUM}_moved_reoriented.nii.gz

# check FA in moved position 
if [[ ! -f ${FA_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then   
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -fa ${FA_REORIENTED} --force
fi

# check RGB in moved position , this can be open in 3Dslicer   
if [[ ! -f ${ADC_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then   
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -adc ${ADC_REORIENTED} --force
fi

# check orientation in moved position   
if [[ ! -f ${V1_REORIENTED} ]] || [[ "${FORCE}" = 1 ]] ;  then 
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V1_REORIENTED} -num 1 --force
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V2_REORIENTED} -num 2 --force  
logCmd tensor2metric ${TENSOR_4D_NII_REORIENTED} -vector ${V3_REORIENTED} -num 3 --force
fi

V1_REORIENTED_MASKED=$(echo ${V1_REORIENTED} | sed 's/.nii.gz/_masked.nii.gz/g' )
if [[ ! -f ${V1_REORIENTED_MASKED} ]] || [[ "${FORCE}" = 1 ]] ;  then
mrcalc ${V1_REORIENTED} ${MASK_THRESHOLD_MOVED_TO_LA} -mult ${V1_REORIENTED_MASKED} --force
fi


CreateFolderIfNotExist ${MRTRIX_FOLDER}/Figures/

if [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_large_fov_anatomical_0000.png ]] && [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_small_fov_anatomical_0000.png ]]  ;  then
mrview ${MPRAGE_MOVED_TO_LA} -size 1800,600  -mode 2 -fov 300 -config MRViewOrthoAsRow 1  \
 -capture.folder ${MRTRIX_FOLDER}/Figures/  -capture.prefix figure_large_fov_anatomical_ -capture.grab -fov 100 -capture.prefix figure_small_fov_anatomical_ -capture.grab -force -exit
fi

if [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_large_fov_overlay_0000.png ]] && [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_small_fov_overlay_0000.png ]]  ;  then
mrview ${MPRAGE_MOVED_TO_LA} -size 1800,600  -mode 2 -fov 300 -config MRViewOrthoAsRow 1 \
  -overlay.load ${V1_REORIENTED_MASKED} -overlay.intensity 0,0.4  \
  -capture.folder ${MRTRIX_FOLDER}/Figures/  -capture.prefix figure_large_fov_overlay_ -capture.grab -fov 100 -capture.prefix figure_small_fov_overlay_ -capture.grab -force -exit
fi

if [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_large_fov_fixel_0000.png ]] && [[ ! -f ${MRTRIX_FOLDER}/Figures/figure_small_fov_fixel_0000.png ]]  ;  then
mrview ${MPRAGE_MOVED_TO_LA}  -size 1800,600 -mode 2 -fov 300 -config MRViewOrthoAsRow 1 \
   -fixel.load ${V1_REORIENTED_MASKED} \
  -capture.folder ${MRTRIX_FOLDER}/Figures/  -capture.prefix figure_large_fov_fixel_ -capture.grab -fov 100 -capture.prefix figure_small_fov_fixel_ -capture.grab -force -exit
fi

fi

let COUNT++

done # loop x
done # loop y
done # loop z
