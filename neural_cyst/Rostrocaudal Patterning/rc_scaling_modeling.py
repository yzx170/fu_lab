# %% Initialization
import numpy as np
import os
import pandas as pd
import matplotlib.pyplot as plt
from scipy import special
from scipy.optimize import curve_fit


# %% Function definitions
def phi_t_int(patterning_day, concentration_uM):
    # Time span and location span
    X = np.arange(0, 10.001, .001) # from 0mm to 10mm with 1um increment

    # Boundary condition: source concentration and diffusivity
    phi_0 = concentration_uM # uM
    D = (10**2)/np.pi # based on observation: achieve linear distribution after 1 day, for approximate solution

    # Patterning duration
    equilibrium_day = patterning_day - 1 # day

    # Prior to equilibrium, Phi as f(t, x)
    T1 = np.arange(.01, 1.01, .01) # from .01 day to 1 day with .01 day increment
    X, T1 = np.meshgrid(X, T1) # in meshgrid, Y-axis proceeds X-axis
    P1 = phi_0*(1-2*(10-X)/(2*np.sqrt(D*T1*np.pi))) # approximate solution

    # During equilibrium, Phi as f(x) only
    T2 = np.arange(1.01, 1.01+equilibrium_day, .01) # from 1.01 day to 4 day with .01 day increment
    P2, T2 = np.meshgrid(P1[-1, :], T2) 

    # After equilibrium, Phi decreases at constant rate
    T3 = np.arange(1.01+equilibrium_day, 2.01+equilibrium_day, .01) # from 4.01 day to 5 day with .01 day increment
    P3 = P2[-1, :]
    P3, T3 = np.meshgrid(P3, T3)
    P3 = P3 - (T3 - (1+equilibrium_day))*3 # decreasing at 3uM/day

    # Combine all time periods
    P = np.concatenate((P1, P2, P3), axis=0)
    P[P < 0] = 0 # remove all negative concentration
    T = np.concatenate((T1, T2, T3), axis=0)

    # Temporal integration of concentration
    P_T_int = np.trapz(y=P, x=T[:, 0], axis=0)
    return P_T_int

def x_to_phi_t_int(x_list, P_T_int):
    # Round up to micron precision
    x_list = np.round(x_list, decimals=3)
    int_list = np.zeros(len(x_list)) # pre-allocate
    err = 1e-5 # for locating position
    for i in np.arange(len(x_list)):
        x = x_list[i]
        int_list[i] = P_T_int[np.where(np.abs(np.arange(0, 10.001, .001) - x) < err)[0][0]]
    # int_list = P_T_int[int(x_list*1e3)]
    return int_list

def Hill(X, n, K):
  ymax = 1000 # observed "on" intensity for OTX2
  ymin = 550 # observed "off" intensity
  yrange = ymax-ymin
  y = yrange*K**n/(K**n + X**n) + ymin
  return y


# %% Read data
# Directory
google_drive_path = '/Users/robinyan/Library/CloudStorage/GoogleDrive-robinyzx@umich.edu/My Drive'
folder_path = 'Projects/Neural Cyst/2022/Exp 24/Confocal'
batch_path = 'Day 9'
current_path = os.path.join(google_drive_path, folder_path, batch_path)

# Read intensity quantificaiton file
chir_3um = pd.read_excel(os.path.join(current_path, 'quant', 'cyst_exp24_device2_3chir_hoxc9_otx2_hoxb1.nd2_quant.xlsx'), index_col=0)

chir_4um_1 = pd.read_excel(os.path.join(current_path, 'quant', 'cyst_exp24_device7_4chir_hoxc9_otx2_hoxb1.nd2_quant.xlsx'), index_col=0)
chir_4um_2 = pd.read_excel(os.path.join(current_path, 'quant', 'cyst_exp24_device8_4chir_hoxc9_otx2_hoxb1.nd2_quant.xlsx'), index_col=0)
chir_4um_3 = pd.read_excel(os.path.join(current_path, 'quant', 'cyst_exp24_device9_4chir_hoxc9_otx2_hoxb1.nd2_quant.xlsx'), index_col=0)

chir_6um = pd.read_excel(os.path.join(current_path, 'quant', 'cyst_exp24_device14_6chir_hoxc9_otx2_hoxb1.nd2_quant.xlsx'), index_col=0)

# Bundle all for batch conversion
combo = [chir_3um, chir_4um_1, chir_4um_2, chir_4um_3, chir_6um]

# Convert px to um for existing dateframes
scale = .65 # for Core Nikon spinning disk, 1px = .65um
for batch in combo: 
    batch.iloc[:, 4:6] = batch.iloc[:, 4:6]*scale
    batch.columns = ['Channel 0', 'Channel 1', 'Channel 2', 'Channel 3', 'X (rel, um)', 'Y (rel, um)']

# Convert relative position to absolute
abs_list = [527, 283, 420, 775-275, 740] # absolute distance (in um, measured from phase) from post left end to closest cyst centroid, for each device being analyzed
for i in np.arange(len(combo)): 
    batch = combo[i]
    rel = batch.iloc[:, 4].min()
    abs = abs_list[i]
    batch.iloc[:, 4] = batch.iloc[:, 4] - rel + abs
    batch.columns = ['Channel 0', 'Channel 1', 'Channel 2', 'Channel 3', 'X (abs, um)', 'Y (rel, um)']


# %% Model fitting
# Input: convert location to Phi_t_integral under current condition
x_list = (chir_3um.iloc[:, 4] + 3000)/1e3 # convert to distance to rostral reservoir in mm
int_list = x_to_phi_t_int(x_list, phi_t_int(3, 3)) # convert location to concentration integral, current condition: 3 days at 3uM
# Output: marker expression
expression_list = chir_3um.iloc[:, 2]
# Fitting 
popt, pcov = curve_fit(Hill, int_list, expression_list, [10, 5])
# Fitted parameters
popt


# %% Visualize model and training data 
fig, ax = plt.subplots(1,1, figsize = (20,10))

# Training data
ax.scatter(x_list, expression_list)

# Model 
X = np.arange(0, 10.001, .001)
pred = Hill(phi_t_int(3, 3), popt[0], popt[1])
ax.plot(X, pred)

plt.ylabel('OTX2 Expression')
plt.xlabel('Horizontal Location (end to end, mm)')
plt.xlim([0, 10])
plt.legend(['CHIR 3','Fitting'])
# %% Test model at varying source concentration
fig, ax = plt.subplots(1,1, figsize = (20,10))

# Available data
for batch in combo: 
    ax.scatter((batch.iloc[:, 4] + 3000)/1e3, batch.iloc[:, 2])

# Model at varying source concentration
X = np.arange(0, 10.001, .001)
pred_3um = Hill(phi_t_int(3, 3) ,popt[0], popt[1])
ax.plot(X, pred_3um)
pred_4um = Hill(phi_t_int(3, 4) ,popt[0], popt[1])
ax.plot(X, pred_4um)
pred_6um = Hill(phi_t_int(3, 6) ,popt[0], popt[1])
ax.plot(X, pred_6um, 'purple')

plt.ylabel('OTX2 Expression')
plt.xlabel('Horizontal Location (end to end, mm)')
plt.xlim([0, 10])
plt.legend(['CHIR 3', 'CHIR 4 (1)', 'CHIR 4 (2)', 'CHIR 4 (3)', 'CHIR 6', 'CHIR 3 Fitting', 'CHIR 4 Prediction', 'CHIR 6 Prediction'])
# %% Test model at varying patterning days
fig, ax = plt.subplots(1,1, figsize = (20,10))

# Training data
ax.scatter(x_list, expression_list)

# Model at varying patterning days
X = np.arange(0, 10.001, .001)
pred_3day = Hill(phi_t_int(3, 3) ,popt[0], popt[1])
ax.plot(X, pred_3day)
pred_4day = Hill(phi_t_int(4, 3) ,popt[0], popt[1])
ax.plot(X, pred_4day)
pred_5day = Hill(phi_t_int(5, 3) ,popt[0], popt[1])
ax.plot(X, pred_5day)

plt.ylabel('OTX2 Expression')
plt.xlabel('Horizontal Location (end to end, mm)')
plt.xlim([0, 10])
plt.legend(['CHIR 3', '3uM 3 Day Fitting', '4 Day Prediction', '5 Day Prediction'])


# %% Intergral Profile plotting at different BC
plt.figure(figsize= (10, 6))
legend_list=[]
for chir in [3, 4, 6]:
    plt.plot(np.arange(0, 10.001, .001), phi_t_int(3, chir))
    legend_list.append('CHIR at %.1d uM' %chir)
plt.ylim([0, 25])
plt.xlim([0, 10])
plt.xlabel('Horizontal Location (mm)')
plt.ylabel('Concentration Integral (uM$\cdot$t)')
plt.legend(legend_list)
plt.title('Concentration Integral at Different Rostral Position')


# %% Intergral Profile plotting for different patterning length
plt.figure(figsize= (10, 6))
legend_list=[]
for days in [3, 4, 5]:
    plt.plot(np.arange(0, 10.001, .001), phi_t_int(days, 3))
    legend_list.append('Pattern for %.1d day' %days)
plt.ylim([0, 25])
plt.xlim([0, 10])
plt.xlabel('Horizontal Location (mm)')
plt.ylabel('Concentration Integral (uM$\cdot$t)')
plt.legend(legend_list)
plt.title('Concentration Integral at Different Rostral Position')

# %%
