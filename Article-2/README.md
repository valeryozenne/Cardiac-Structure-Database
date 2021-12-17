# Cardiac-Structure-Database

Additionnal materials including data and codes for dwi and tractography processing. 

If you use the data, please cite: 

```
A groupwise registration and tractography framework for cardiac myofiber architecture description by diffusion MRI: an application to the ventricular junctions.
Julie Magat, Maxime Yon, Yann Bihan-Poudec, Valéry Ozenne
bioRxiv 2021.10.05.463112; doi: https://doi.org/10.1101/2021.10.05.463112

This article is a preprint and has not been certified by peer review.
```


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

A code for the computation of the diffusion tensor metric and streamlines is available.  The code is subject to change at any moment. 
As an example, the code automatically produces the following figures. 

## Figures

### Sample 1 in template space
![](Figures/figure_2D_tracto_1_FACT_Full_s50000_ep_a20_angle60_co_moved_to_T_0000.png)
### Sample 2 in template space
![](Figures/figure_2D_tracto_2_FACT_Full_s50000_ep_a20_angle60_co_moved_to_T_0000.png)
### Sample 3 in template space
![](Figures/figure_2D_tracto_3_FACT_Full_s50000_ep_a20_angle60_co_moved_to_T_0000.png)

## Data folder

The data are available on the Zenodo Platform.

* v0.1 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5140252.svg)](https://doi.org/10.5281/zenodo.5140252) Initial Push 
* v0.2 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5156088.svg)](https://doi.org/10.5281/zenodo.5156088) Add original DWI data in .mif format for MRtrix usage. 

```
.
├── Data
│   ├── 1
│   │   ├── Native
│   │   │   ├── Angles
│   │   │   └── Vectors
│   │   └── Template
│   │       ├── Angles
│   │       ├── Streamlines
│   │       └── Vectors
│   ├── 2
│   │   ├── Native
│   │   │   ├── Angles
│   │   │   └── Vectors
│   │   └── Template
│   │       ├── Angles
│   │       ├── Streamlines
│   │       └── Vectors
│   ├── 3
│   │   ├── Native
│   │   │   ├── Angles
│   │   │   └── Vectors
│   │   └── Template
│   │       ├── Angles
│   │       ├── Streamlines
│   │       └── Vectors
│   └── averaged
│       └── Template
│           ├── Angles
│           ├── Streamlines
│           └── Vectors
├── Figure_4
├── Figure_5
├── Figure_6
├── Figure_8
├── Slicer
└── Warps

```



