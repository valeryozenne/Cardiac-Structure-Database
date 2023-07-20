# Cardiac-Structure-Database

Here is a brief tutorial for tensor reorientation. Largely inspired from https://github.com/ANTsX/ANTs/wiki/Warp-and-reorient-a-diffusion-tensor-image.

# Acknowledgments

The author is grateful for the help provided via the Github or Discourse platform by Philip Cook and Nick Tustison regarding the use of ANTs and Max Pietsh, Robert Smith and Donald Tournier regarding the use of MRtrix3 software. 

# References
Here are relevent references for this script in cardiac DTI: 

```
Rodriguez Padilla J, Petras A, Magat J, Bayer J, Bihan-Poudec Y, El-Hamrani D, Ramlugun G, Neic A, Augustin C, Vaillant F, Constantin M, Benoist D, Pourtau L, Dubes V, Rogier J, Labrousse L, Bernus O, Quesson B, Haissaguerre M, Gsell M, Plank G, Ozenne V, Vigmond E. Impact of Intraventricular Septal Fiber Orientation on Cardiac Electromechanical Function. Am J Physiol Heart Circ Physiol. 2022 Mar 18. doi: 10.1152/ajpheart.00050.2022. Epub ahead of print. PMID: 35302879.
```

```
Magat J, Yon M, Bihan-Poudec Y, Ozenne V (2022) A groupwise registration and tractography framework for cardiac myofiber architecture description by diffusion MRI: An application to the ventricular junctions. PLOS ONE 17(7): e0271279. https://doi.org/10.1371/journal.pone.0271279
```

# Environnement

ANTs and MRtrix are mandatory dependencies. Itksnap and 3DSlicer may be usefull as well. 

## OS version

Distributor ID:	Ubuntu
Description:	Ubuntu 22.04.2 LTS
Release:	22.04
Codename:	jammy
 
## MRtrix version
== mrinfo 3.0.4-39-ga5e5ae85 ==
64 bit release version, built May 25 2023, using Eigen 3.4.0
Author(s): J-Donald Tournier (d.tournier@brain.org.au) and Robert E. Smith (robert.smith@florey.edu.au)
Copyright (c) 2008-2023 the MRtrix3 contributors.

## ANTs version
ANTs Version: 2.4.4.post12-g8cc4f8a
Compiled: May 25 2023 10:33:31

## Code 

A code for the computation and reorientation of the diffusion tensor metric. The code is subject to change at any moment. As an example, the code automatically produces the following figures. 

## Figures

Sample in initial orientation
![Alt text](Figures/figure_2D_mean_bzero_initial_1_0000.png)

Sample after reorientation
![Alt text](Figures/figure_2D_mean_bzero_after_rotation_1_0000.png) 

cFA and v1 in initial orientation

![Alt text](Figures/figure_2D_initial_cFA_1_0000.png)
![Alt text](Figures/figure_2D_initial_fixel_1_0000.png)

cFA and v1 after reorientation
![Alt text](Figures/figure_2D_after_rotation_cFA_1_0000.png) 
![Alt text](Figures/figure_2D_after_rotation_fixel_1_0000.png) 









