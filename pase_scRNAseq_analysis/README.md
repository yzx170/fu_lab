# PASE model single cell RNA sequencing analysis

## Project Overview
We have developed a microfluidic-based stem cell model that recapitulates the early symmetry breaking event in human embryonic development that gives rise to the amniotic ectoderm (featured in [Nature](https://doi.org/10.1038/s41586-019-1535-2)). This project aims at examining the single cell RNA sequencing data of those microfluidic amniotic sac embryoid (μPASE) to uncover the mystery of early human embryonic development. 

### Platform: 
R
### Publication
https://doi.org/10.1016/j.stem.2022.08.009

### Data Availability
All data used in this repository is available upon request. 


## Scripts

### Integration Analysis
In this script, we performed integration analysis among downsampled PASE, [CS7 human gastrula](https://doi.org/10.1038/s41586-021-04158-y), human E9E11 gastruloid and pre-implantation data. 

### New Old Comparison
We compared the transcriptomic data of PASE between our latest sequencing results and our previous results to validate the consistency of our model. 

### Cell Chat
We used [CellChat](http://www.cellchat.org/) package to analyze the ligand-receptor interactions within our model. 

### SCENIC
We used [SCENIC](https://scenic.aertslab.org/) package to analyze the gene regulatory network within our model. 

### Trophoblast Validation
In this section, we did a comparative transcriptomic study among major trophoblast and amniotic ectoderm models available by the time we prepare the manuscript and came up with a stringent criteria to distinguish human trophoblast and amnion. 

This comparison includes: 
1. Human trophoblast (Blakeley et al., 2015; Petropoulos et al., 2016), 
2. Human amnion (Tyser et al., 2021), 
3. Zheng Transwell (Zheng et al., 2019b), 
4. Gao C5, Gao H1, Gao FH1 (Gao et al., 2019), 
5. Minn (Minn et al., 2020), 
6. Liu (Liu et al., 2021), 
7. Yu (Yu et al., 2021), 
8. Guo H9, Guo hNES1 (Guo et al., 2021), 
9. Io (Io et al., 2021), 
10. Yanagida (Yanagida et al., 2021), 
11. Dong H9, Dong WIBR3, Dong AN (Dong et al., 2020), 
12. Rostovskaya EarlyAME, and Rostovskaya LateAME (Rostovskaya et al., 2022).

Each dataset from the above manuscripts was individually processed to allow accurate comparison across the board. 

### Other scripts

#### 3D Trajectory
Used to generate 3D diffusion map to visualize the trajectories of major lineages. 
#### Feature Plots
Because the vector plots of single cell UMAP is notoriously difficult to change once they are generated, I developed a script to adjust the plotting parameters prior to export to improve the figure aesthetics. 
