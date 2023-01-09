#%% Initialization
import shutil, os

# Input: image directory
masterdir = r'E:\test'

# Delete Thumbnails
for filename in os.listdir(masterdir):
    if 'thumb' in filename: 
        os.remove(os.path.join(masterdir,filename))

# Preserve original files in "Raw" folder (for shading correction)
os.makedirs(os.path.join(masterdir, "Raw"), exist_ok=True)
for current_file in os.listdir(masterdir):
    if current_file.endswith(('.tif','.TIF','.nd')):
        shutil.copy(os.path.join(masterdir,current_file),os.path.join(masterdir, "Raw"))

# Organize files into subfolders
all_batch = []
for filename in os.listdir(masterdir):
    if filename.endswith('.nd'): # create folders based on nd files
        batchname = filename[:-3]
        all_batch.append(batchname)
        os.makedirs(os.path.join(masterdir,batchname),exist_ok=True)
for current_batch in all_batch:
    for current_file in os.listdir(masterdir):
        if current_file.endswith(('.tif','.TIF','.nd')) and current_file.startswith(current_batch):
            shutil.move(os.path.join(masterdir,current_file),os.path.join(masterdir,current_batch,current_file))

# Make "Stitched" folder
os.makedirs(os.path.join(masterdir, "Stitched"), exist_ok=True)

# Rename files in subfolders to MIST compatible format
for current_batch in all_batch:
    currentdir = os.path.join(masterdir,current_batch)
    for filename in os.listdir(currentdir):
        if filename[-3:].lower() == 'tif':
            cutoff = -10
            info = filename[:cutoff]
            rest = filename[cutoff:] # last 10 characters contain position _s
            prefix, num = rest[:-4].split('_s')
            num = num.zfill(3) # rename position number to 3 digits
            new_filename = info + prefix + "_s" + num + ".tif"
            os.rename(os.path.join(currentdir, filename), os.path.join(currentdir, new_filename))
# %%
