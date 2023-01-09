#%% Initialization
import os
# Input: image directory
maindir = r'G:\My Drive\Projects\Brain Organoid\Trial 6\Confocal' #specify the root directory for all folders
batch = 'batch_1_otx2(488)_pax6(561)_1' #specify current folder name
currentdir = os.path.join(maindir,batch)

# if filename contains '_s'
for filename in os.listdir(currentdir):
    if filename[-3:].lower() == 'tif':
        cutoff = -10
        info = filename[:cutoff]
        rest = filename[cutoff:]
        prefix, num = rest[:-4].split('_s')
        num = num.zfill(3) # Rename position number to 3 digits
        new_filename = info + prefix + "_s" + num + ".tif"
        os.rename(os.path.join(currentdir, filename), os.path.join(currentdir, new_filename))