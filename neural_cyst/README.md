
# Rostrocaudal Patterning of Neural Cyst Array

## Project Overview
This project aims at performing rostrocaudal patterning on neural cyst-like tissue array. 

Major results to date are summarized in this [slide deck](https://github.com/yzx170/fu_lab/blob/main/neural_cyst/Neural%20Cyst.pdf). 

### Platform:
Python 




## Scripts

### Neural Cyst Formation

1. Phase cell counting: this script counts the number of cells within each cluster on a phase image. 
2. Phase Area Measurement: this script measures the area of each colony within a phase image. 
3. Marker Intensity Quantification: this script measures the average fluorescence expression of each channel via a DAPI nuclear mask. 


### Rostrocaudal Patterning

1. RC Scaling Modeling: requires output from "Marker Intensity Quantification". This script simulates the dynamics of morphogen diffusion using Fick's Second Law to uncover the relations between morphogen induction and cell fate decisions. Currently only looking at CHIR99021 concentration and induction time with OTX2 expression. 
