# %% Initialization
import numpy as np
import os
import pandas as pd
import matplotlib.pyplot as plt
from skimage import feature, morphology, color, measure, segmentation, filters, io
import h5py

# %% Average cyst marker intensity for all four channels in every image, output in xlsx
# Require path to .nd2 files, output folder with exported .tif files and masks as .h5 files (generated with ilastik)
# Directory
google_drive_path = '/Users/robinyan/Library/CloudStorage/GoogleDrive-robinyzx@umich.edu/My Drive'
folder_path = 'Projects/Neural Cyst/2022/Exp 24/Confocal'
batch_path = 'Day 9'
current_path = os.path.join(google_drive_path, folder_path, batch_path)

# Create folder to store all output xlsx files
os.makedirs(os.path.join(current_path, 'quant'), exist_ok=True)

# Get file names
imagenames = []
for filename in os.listdir(current_path):
    if filename.endswith('.nd2'):
        imagenames.append(filename)

# Loop through all images
for imagename in imagenames:
    # Start a data frame
    data = pd.DataFrame()

    # Load nuclear mask
    mask = h5py.File(os.path.join(current_path, 'output', imagename) + '-C1_Simple Segmentation.h5', 'r')['exported_data']
    mask = mask[:, :, 0] == 1
    # Remove noise
    cleaned = morphology.remove_small_objects(mask, min_size=5e3)
    # Label masks
    label_mask = measure.label(cleaned)

    # Load DAPI to get image size
    dapi = io.imread(os.path.join(current_path, 'output', imagename) + '-C1.tif')

    # Load remaining channels
    nChannel = 4
    im = np.zeros((dapi.shape[0], dapi.shape[1], nChannel))
    for channel in np.arange(nChannel):
        im[:, :, channel] = io.imread(os.path.join(current_path, 'output', imagename) + '-C%.1d.tif' %(channel+1))

    # Calculate average intensity for each cyst, loop through each channel
    for channel in np.arange(nChannel):
        data['Channel %.1d' %channel] = measure.regionprops_table(label_mask, im[:, :, channel], properties=['mean_intensity'])['mean_intensity']
    data['X (rel, px)'] = measure.regionprops_table(label_mask, properties=['centroid'])['centroid-1']
    data['Y (rel, px)'] = measure.regionprops_table(label_mask, properties=['centroid'])['centroid-0']

    # Output measurement in xlsx
    pd.DataFrame.to_excel(data, os.path.join(current_path, 'quant', imagename) + '_quant.xlsx') # write df into an excel sheet
# %%
