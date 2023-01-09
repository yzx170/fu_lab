% Processing script for microfluidic channel gradient quantification
% Processes: 
% Inputs: Stitched brightfield images and cy-3 channel images
% Outputs:  
% Written by R. Yan, University of Michigan
% 11/12/2020
clear; close all; clc

%% Initialization
width_1d = 1000;
windowSize = 50; % for filter, percentage
contrast_amp = 200; % Amplification of pixel intensity


%% Import
Cy3_folder = fullfile('G:\My Drive\Projects\Neural Tube\Gradient Quantification\Trial 7\Cy3 Stitched\');
contents = dir(Cy3_folder);
names = {contents(3:end).name};
Nimages = length(names);
tspan = 1:Nimages;
Cy3_images = cell(1,Nimages);
for j = 1:Nimages
    Cy3_images{j} = imread(fullfile(Cy3_folder,names{j}));
    names{j} = names{j}(1:end-4);
end


%% Processing
% Filter design for stitching artifact
windowSize = windowSize/100*width_1d+1; % Translate % to data slots
b = (1/windowSize)*ones(1,windowSize);
a = 1;
delay = (windowSize-1); % Filter delay
width_adjusted = width_1d+delay; % Account for filter delay
sum_1d = zeros(length(tspan),width_1d); % Preallocation for filtered data (non-adjusted size)

for j = 1:length(tspan)
    % Conversion to double
    test_img = im2double(cell2mat(Cy3_images(tspan(j))));

    % Image alignment
    rotated = imrotate(test_img,-1); % rotation
    cropped = rotated(900:6900,4500:11000); % cropping
    
    % Remove outlier
%     cropped(isoutlier(cropped,'ThresholdFactor',5)) = mean(cropped,'all');
    
    % Increase contrast
    cropped = cropped*contrast_amp;
    
%     % Visualization
%     figure(1)
%     imshow(cropped)

    % Flatten
    flattened = mean(cropped);
    flattened_intep = interp1(1:length(flattened),flattened,linspace(1,length(flattened),width_adjusted),'pchip');
    flattened_filtered = filter(b,a,flattened_intep);
    sum_1d(j,:) = flattened_filtered((delay+1):end); % Adjustment due to filter delay
end

%% Visualization
figure(3)
datarange = 1:36;
ax = axes;
% ax.ColorOrder = [1 0 0; 0 0 1;0 1 0; 1 1 0; 1 0 1; 0 1 1; 0 0.5 0.5; 0.5 0 0; 0 0.5 0; 0 0 0.5; 0.5 0.5 0; 0.5 0.5 0.5];
ax.LineStyleOrder = {'-','--','+'};
hold on 
for j = datarange
    plot(linspace(1,100,width_1d),sum_1d(j,:),'linewidth',2)
end
legend(names(datarange))
xlabel('Channel Length (%)')
ylabel('Fluorescence Intensity (Arbitrary Unit)')


% %% Image Alignment Test
% test1 = imread('G:\My Drive\Projects\Neural Tube\Gradient Quantification\Trial 7\Brightfield Stitched\day2-stitched-01.TIF');
% test1 = imrotate(test1,-1); % rotation
% test1 = test1(900:6900,4500:11000); % cropping
% 
% imshow(test1)




