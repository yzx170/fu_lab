# %% Initialization
import numpy as np
import os
import pandas as pd
import matplotlib.pyplot as plt
from skimage import feature, morphology, color, measure, segmentation, filters
from cellpose import utils, io, models
from datetime import date


# %% Count cells in each individual colony in all images under current folder
# Specify current folder
google_drive_path = '/Users/robinyan/Library/CloudStorage/GoogleDrive-robinyzx@umich.edu/My Drive'
folder_name = 'Projects/Neural Cyst/Manuscript Summary/Figure 1  Neural Cyst Generation/Panel C Cell Seeding/Day 0 Cell Counting/10X Exp 20-21-22/'
current_dir = os.path.join(google_drive_path, folder_name)

# Cellpose parameters
model = models.Cellpose(gpu=True, model_type='cyto')
channels = [0,0]

# Store cell counts
counts = []

radius = 300 # x and y distance from centroid (pixels)
for filename in os.listdir(current_dir): # Go through each image in folder
    if filename.endswith(('.jpg', '.JPG')):
        img = io.imread(os.path.join(current_dir, filename))
        original = color.rgb2gray(img) # convert to grayscale
        edges = feature.canny(original) # extract edges as rough contours
        dilated = morphology.dilation(edges, morphology.square(30)) # dilate contours to outline features
        segmented = measure.label(dilated) # label features
        cleaned = morphology.remove_small_objects(segmented, min_size=5e4) # remove small features (scattered cells)
        props = measure.regionprops_table(cleaned, properties=['centroid']) # calculate colony centroid
        for i in np.arange(len(props['centroid-0'])): # go through each colony in image
            coord = [int(props['centroid-0'][i]), int(props['centroid-1'][i])]
            roi = original[np.maximum(coord[0]-radius, 0):coord[0]+radius, np.maximum(coord[1]-radius, 0):coord[1]+radius] # crop based on centroids
            masks, flows, styles, diams = model.eval(roi, diameter=None, channels=channels) # run cellpose
            counts.append(masks.max()) # add count to counts list


# %% Output results
df = pd.DataFrame(counts) # create a data frame to store data
df.columns = ['Number of Cells'] # Rename columns
pd.DataFrame.to_excel(df, os.path.join(current_dir, str(date.today()) + 'counts.xlsx')) # write df into an excel sheet

