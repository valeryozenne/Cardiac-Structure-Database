# Cardiac-Structure-Database

Material for the article "Cardiac structure discontinuities revealed by ex-vivo microstructural
characterization. A focus on the basal inferoseptal left ventricle region" have been uploaded on the zenodo platform. The link is indicated at the bottom of this page. 


Additionnal materials including data and codes for dwi and tractography processing. 

If you use the data, please cite: 

```
```

Data associated with the article can be accessed at this link : 

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10303489.svg)](https://doi.org/10.5281/zenodo.10303489)

# Environnement

ANTs and MRtrix are mandatory dependencies. 

## OS version

Ubuntu 20.04.2 LTS
 
## MRtrix version
== mrconvert 3.0.2-108-g6844eb03 ==
64 bit release version, built Jun  9 2021, using Eigen 3.3.7
Author(s): J-Donald Tournier (jdtournier@gmail.com) and Robert E. Smith (robert.smith@florey.edu.au)
Copyright (c) 2008-2021 the MRtrix3 contributors.

## ANTs version
ANTs Version: 2.3.5.dev212-g44225
Compiled: Feb  4 2021 11:20:35

## Code 

A code for the computation of the diffusion tensor metric and streamlines is available. The code is subject to change at any moment. 
As an example, the code automatically produces the following figures. 

## Figures


### Human Sample 1 in LA Aligned space

### Human Sample 2 in LA Aligned space

### Human Sample 3 in LA Aligned space

### Human Sample 4 in LA Aligned space

### Human Sample 5 in LA Aligned space


### Sample 1 in template space
![](Figures/XX.png)
### Sample 2 in template space
![](Figures/XX.png)
### Sample 3 in template space
![](Figures/X.png)


## Data folder

The data are available on the Zenodo Platform.

* v0.1 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10303489.svg)](https://doi.org/10.5281/zenodo.10303489) Initial Push 


Data Hierarchy


```

├── Human
│   ├── 1
│   ├── 2
│   ├── 3
│   ├── 4
│   └── 5
└── Sheep
    ├── 1
    ├── 2
    ├── 3
    ├── 4
    └── 5


```


File Hierarchy 

```
.
├── 1
│   ├── cube-Segment_1-label.nii.gz
│   ├── grad.b
│   ├── mask_mean_b0.nii.gz
│   ├── mean_b0_RVIP.nii.gz
│   ├── tensor_RVIP.nii.gz
│   └── transform_itk_to_LA.txt


```


