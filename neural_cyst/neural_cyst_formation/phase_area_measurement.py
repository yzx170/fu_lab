# %% Initialization
import numpy as np
import os
import pandas as pd
import matplotlib.pyplot as plt
from scipy import ndimage as ndi
from skimage import feature, morphology, color, measure, segmentation, filters, io
from datetime import date


# %% Measure area for each individual colony in all images under current folder
# Specify current folder
google_drive_path = '/Users/robinyan/Library/CloudStorage/GoogleDrive-robinyzx@umich.edu/My Drive'
folder_name = 'Projects/Neural Cyst/Manuscript Summary/Figure 1  Neural Cyst Generation/Panel C Cell Seeding/Day 1-3 Area Change/Day 3/4X Exp 20-21-22'
current_dir = os.path.join(google_drive_path, folder_name)

# Store area measurement
area = []

# Current conversion factor (pixels to microns)
conversition_factor = 10/8 # Laser room, 4X TC objective, 8 pixels = 10 microns


for filename in os.listdir(current_dir): # Go through each image in folder
    if filename.endswith(('.jpg', '.JPG')):
        img = io.imread(os.path.join(current_dir, filename))
        original = color.rgb2gray(img) # convert to grayscale
        edges = feature.canny(original, sigma = .1) # extract edges as rough contours, increased sigma for higher sensitivity
        dilated = morphology.dilation(edges, morphology.square(5)) # dilate contours to outline features
        filled = ndi.binary_fill_holes(dilated) # fill in cavities
        segmented = measure.label(filled) # label features
        cleaned = morphology.remove_small_objects(segmented, min_size=5e3) # remove small features (scattered cells)
        eroded = morphology.erosion(cleaned, morphology.square(5)) # offset effects from dilation
        props = measure.regionprops_table(eroded, properties=['area']) # calculate colony area
        area.extend(props['area']*conversition_factor**2)


# %% Output results
df = pd.DataFrame(area) # create a data frame to store data
df.columns = ['Area of Colony (um2)'] # Rename columns
pd.DataFrame.to_excel(df, os.path.join(current_dir, str(date.today()) + '_area.xlsx')) # write df into an excel sheet


# %% Preview of data
plt.hist(df.iloc[:, 0], 20)
plt.xlabel('area of objects (um$^2$)')
plt.ylabel('frequency of occurance')

df.iloc[:, 0].mean()
# %%
