# Dorsoventral Patterning of Brain Organoid

## Project Overview
This work-in-progress project aims at performing dorsoventral patterning on stem cell-based human forebrain organoid to model the neurogenesis in cerebral cortex with surrounding ventral tissues. 

### Platform: 
Python and ImageJ Macro




## Scripts

### Image Rename  
The image acquisition software we use, MetaMorph for Olympus, does not perform large-field imaging required to analyze the whole organoid. This script organizes the raw TIF outputs from the software into separate folders and change file name to make them compatible with stitching. 

### MIST Stitching
This script reads the metadata from the individual images to automatically calculate the grid size, performs shading correction via [BaSiC](https://github.com/marrlab/BaSiC), then stitches the images via [MIST](https://github.com/usnistgov/MIST) and combines all channels into one file. 

