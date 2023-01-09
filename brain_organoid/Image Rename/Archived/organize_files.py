#%% Initialization
import shutil, os
# Input: image directory
masterdir = r'G:\My Drive\Projects\Brain Organoid\Trial 6\Confocal'

# Organize files into subfolders
all_batch = []
for filename in os.listdir(masterdir):
    if filename.endswith('.nd'): # create folders based on nd files
        batchname = filename[:-3]
        all_batch.append(batchname)
        os.makedirs(os.path.join(masterdir,batchname),exist_ok=True)
for current_batch in all_batch:
    for current_file in os.listdir(masterdir):
        if current_file.endswith(('.TIF','.nd')) and current_file.startswith(current_batch):
            shutil.move(os.path.join(masterdir,current_file),os.path.join(masterdir,current_batch,current_file))