#!/bin/bash

function Display_JSON(){

echo =============================================================================================
echo =============================================================================================
jq '.sequence['${ID}']' $1
echo =============================================================================================
echo =============================================================================================
}

function Get_PROJECT_FOLDER(){
echo $(jq '.sequence['${ID}'] .PROJECT_FOLDER' $1 | tr -d '"')
}

function Get_MAIN_EXAM_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .MAIN_EXAM_FOLDER_NAME' $1 | tr -d '"')
}

function Get_SUB_EXAM_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .SUB_EXAM_FOLDER_NAME' $1 | tr -d '"')
}

function Get_MRTRIX_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .MRTRIX_FOLDER_NAME' $1 | tr -d '"')
}

function Get_SEQ_AP_B0_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .SEQ_AP_B0_FOLDER_NAME' $1 | tr -d '"')
}

function Get_SEQ_PA_B0_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .SEQ_AP_B0_FOLDER_NAME' $1 | tr -d '"')
}

function Get_SEQ_AP_BVALUE_FOLDER_NAME(){
echo $(jq '.sequence['${ID}'] .SEQ_AP_BVALUE_FOLDER_NAME' $1 | tr -d '"')
}

function Get_MPRAGE_FOLDER(){
echo $(jq '.sequence['${ID}'] .MPRAGE_FOLDER' $1 | tr -d '"')
}

function Get_FORCE(){
echo $(jq '.sequence['${ID}'] .FORCE' $1 | tr -d '"')
}

function Get_DIR(){
echo $(jq '.sequence['${ID}'] .DIR' $1 | tr -d '"')
}

function Get_THRESHOLD(){
echo $(jq '.sequence['${ID}'] .THRESHOLD' $1 | tr -d '"')
}


function Get_TRANSFORM_ALIGNED(){
echo $(jq '.sequence['${ID}'] .TRANSFORM_ALIGNED' $1 | tr -d '"')
}


function Get_RESLICED_REFERENCE(){
echo $(jq '.sequence['${ID}'] .RESLICED_REFERENCE' $1 | tr -d '"')
}