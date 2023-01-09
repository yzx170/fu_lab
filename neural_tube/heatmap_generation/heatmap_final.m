% Generate Fluorescence Intensity Distribution Curve (2D) or Heatmap (3D)
% Processes: ad hoc intra-batch registration, normalization, tube mask, DV slicing, stretching, heatmap/distribution generation
% Inputs: Stitched fluorescent imageas at specific wavelength (both DAPI and TF), saving parameters
% Outputs: Fluorescence Intensity Heatmap/Distribution 
% Written by R. Yan, University of Michigan
% 9/17/2020


%% Initialization
clear; close all; clc;
mode = 3; % specify the current analysis mode (2D analysis is retired)
thresh = 0.15; % DAPI intensity threshold (double precision, from 0 to 1
percentile = 99; % Percentile for defined max intensity (see Normalization and Mask)
AP_intdp = 500; % AP interpolation data points (100% is most posterior)
DV_intdp = 50; % DV interpolation dp (100% is most ventral)
AP = 10000; % Preallocate matrix dimension (depends on sample images)
DV = 3000;
DV_tube = 25; % Percentage of tube area in DV direction (one side, for excluding tube cavity)
AP_tube = 1;

% Intra-batch optimization parameters
[INTRA_optimizer, INTRA_metric] = imregconfig('multimodal');
INTRA_optimizer.InitialRadius = 6.25e-4;
INTRA_optimizer.Epsilon = 1.5e-6;
INTRA_optimizer.GrowthFactor = 1.01;
INTRA_optimizer.MaximumIterations = 100;

% Inter-batch optimization parameters
% [INTER_optimizer, INTER_metric] = imregconfig('monomodal');
% INTER_optimizer.GradientMagnitudeTolerance = 1.00000e-04;
% INTER_optimizer.MinimumStepLength = 1.00000e-05;
% INTER_optimizer.MaximumStepLength = 1.00000e-02;
% INTER_optimizer.MaximumIterations = 100;
% INTER_optimizer.RelaxationFactor = 0.500000;


%% Import
% [BASE_file,BASE_path] = uigetfile('*.*','Please select the base TF images'); % Image with rectangular shaped tube preferred
% [BASE_DAPI_file,BASE_DAPI_path] = uigetfile('*.*','Please select the base DAPI images');
[ALIGNER_files, ALIGNER_path] = uigetfile(strcat('/Users/robinyan/Desktop/SHH',filesep, '*.*'),'Please select the TF imgaes','MultiSelect','on');
[ALIGNER_DAPI_files, ALIGNER_DAPI_path] = uigetfile(strcat(ALIGNER_path,filesep,'*.*'),'Please select the DAPI imgaes','MultiSelect','on');
if iscell(ALIGNER_files) == 0
    ALIGNER_files = {ALIGNER_files};
end
if iscell(ALIGNER_DAPI_files) == 0
    ALIGNER_DAPI_files = {ALIGNER_DAPI_files};
end
if length(ALIGNER_files) ~= length(ALIGNER_DAPI_files)
    error('Number of TF and DAPI images not consistent.');
end
NumImages = length(ALIGNER_files); 
wavelength = inputdlg({'Enter current channel wavelength(nm)'},'Channel Wavelength',[1 50],{'488'});
savepath = uigetdir(ALIGNER_path,'Please select the save location');


%% DAPI and TF Size Check
ALL = zeros(DV,AP,NumImages); % Preallocate
ALL_DAPI = ALL;
for j = 1:NumImages
    MOVING = imread(char(fullfile(ALIGNER_path,ALIGNER_files(j))));
    MOVING_DAPI = imread(char(fullfile(ALIGNER_DAPI_path,ALIGNER_DAPI_files(j))));
    % Convert base image to grayscale
    if size(MOVING,3) == 3
        MOVING = rgb2gray(MOVING);
    end
    if size(MOVING_DAPI,3) == 3
        MOVING_DAPI = rgb2gray(MOVING_DAPI);
    end
    % if size inconsistent, perform intra-batch registration
    if size(MOVING_DAPI,1) ~= size(MOVING,1) || size(MOVING_DAPI,2) ~= size(MOVING,2)
        disp('DAPI has different size than TF base.')
        MOVING = imregister(MOVING, MOVING_DAPI, 'affine', INTRA_optimizer, INTRA_metric);
    end  
    % if size larger than preallocation, need to change preallocation size
    if size(MOVING,1) > DV || size(MOVING,2) > AP
        error('Preallocation size smaller than current image size, use larger values.')
    end
    ALL(1:size(MOVING,1),1:size(MOVING,2),j) = MOVING;
    ALL_DAPI(1:size(MOVING,1),1:size(MOVING,2),j) = MOVING_DAPI;
end


%% Align Images to unify dimension
% for j = 1:NumImages
%     MOVING = imread(char(fullfile(ALIGNER_path,ALIGNER_files(j))));
%     MOVING_DAPI = imread(char(fullfile(ALIGNER_DAPI_path,ALIGNER_DAPI_files(j))));
%     % Convert moving images
%     if size(MOVING,3) == 3
%         MOVING = rgb2gray(MOVING);
%     end
%     if size(MOVING_DAPI,3) == 3
%         MOVING_DAPI = rgb2gray(MOVING_DAPI);
%     end
%     % Check MOVING files size
%     if size(MOVING_DAPI,1) ~= size(MOVING,1) || size(MOVING_DAPI,2) ~= size(MOVING,2)
%         disp('DAPI moving has different size than TF moving')
%         MOVING = imregister(MOVING, MOVING_DAPI, 'affine', INTRA_optimizer, INTRA_metric);
%     end  
%     
%     % Default spatial referencing objects
%     fixedRefObj = imref2d(size(FIXED_DAPI));
%     movingRefObj = imref2d(size(MOVING_DAPI));
% 
%     % Align centers
%     fixedCenterXWorld = mean(fixedRefObj.XWorldLimits);
%     fixedCenterYWorld = mean(fixedRefObj.YWorldLimits);
%     movingCenterXWorld = mean(movingRefObj.XWorldLimits);
%     movingCenterYWorld = mean(movingRefObj.YWorldLimits);
%     translationX = fixedCenterXWorld - movingCenterXWorld;
%     translationY = fixedCenterYWorld - movingCenterYWorld;
% 
%     % Coarse alignment
%     initTform = affine2d();
%     initTform.T(3,1:2) = [translationX, translationY];
% 
%     % Apply transformation
%     tform = imregtform(MOVING_DAPI,movingRefObj,FIXED_DAPI,fixedRefObj,'affine',INTER_optimizer,INTER_metric,'PyramidLevels',3,'InitialTransformation',initTform);
%     MOVINGREG.Transformation = tform;
%     MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true); % transformation apply to TF channel
%     MOVINGREG.RegisteredImage_DAPI = imwarp(MOVING_DAPI, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true); % transformation apply to DAPI channel
% 
%     % Store spatial referencing object
%     MOVINGREG.SpatialRefObj = fixedRefObj;
%     
%     % Output registered image
%     ALL = cat(3,ALL,MOVINGREG.RegisteredImage);
%     ALL_DAPI = cat(3,ALL_DAPI,MOVINGREG.RegisteredImage_DAPI);
% end

% % Visualization (show the results of registration)
% figure(1)
% title('Registration Result')
% montage(ALL);


%% Normalization and Mask
% Convert to double precision
ALL = im2double(ALL);
ALL_DAPI = im2double(ALL_DAPI);

% % Erode images to mitigate artifacts
% se = strel('square',5);
% ALL = imerode(ALL,se);
% ALL_DAPI = imerode(ALL_DAPI,se);

% Normalize DAPI to max intensity
ALL_DAPI = ALL_DAPI./max(max(ALL_DAPI));

% Generate boundary mask based on DAPI Intensity threshold
mask = (ALL_DAPI>thresh);

% Normalized to DAPI channel
ALL_DAPI_n = ALL_DAPI;
ALL_DAPI_n(~mask) = 1; % no normalization in non-tube area
ALL = ALL./ALL_DAPI_n;

% Apply mask
ALL_masked = ALL.*mask;

% Normalize TF to max intensity (altered)
% Max intensity defined per mean and std (to mitigate artifacts)
for j = 1:NumImages
    current = squeeze(ALL_masked(:,:,j));
    current = current(current>0); % only consider tube area
    current_max = prctile(current,percentile,'all'); % max defined at specified percentile
    ALL_masked(:,:,j) = ALL_masked(:,:,j)./current_max;
end
ALL_masked(ALL_masked > 1) = 1; % all outliers (above def. max) set to 1

% Visualization 
% figure(2)
% sgtitle('Registered Images (left) v. Masked Images (right)')
% subplot(1,2,1)
% montage(ALL)
% subplot(1,2,2)
% montage(ALL_masked)


%% Heatmap/Distribution and Output
if mode == 2 % 2D analysis
%     % Per width average intensity (based on mask)
%     AP_dist = sum(ALL_masked,1)./sum(mask,1);
%     AP_dist(isnan(AP_dist)) = 0; % resolve errors from 0/0
%     AP_dist = squeeze(AP_dist)';
%     AP_dist_int = zeros(size(ALL,3),AP_intdp); % prepare for interpolation
%     
%     % determine AP boundary
%     tube_loc = (AP_dist > 0);
%     for j = 1:size(ALL,3)
%         current = tube_loc(j,:);
%         location = find(current);
%         startpoint = location(1);
%         endpoint = location(end); % assume determined tube length continuous
%         AP_dist_int(j,:) = interp1(1:(endpoint-startpoint+1),AP_dist(j,startpoint:endpoint),linspace(1,(endpoint-startpoint+1),AP_intdp),'pchip');
%     end
%     
%     % Visualization
%     figure(3)
%     hold on
%     plot(linspace(1,100,AP_intdp),AP_dist_int(:,:))
%     xlabel('Percentage Length of NT (%)')
%     ylabel('Per Length Intensity (Arbitrary Unit)')
%     legend
%     
%     % Output and Save
%     savefilename = strcat(savepath,filesep,string(wavelength),'_distribution.svg');
%     saveas(gcf,savefilename)
    
elseif mode == 3 % 3D analysis (2D analysis also included)
    Final = zeros(DV_intdp,AP_intdp,size(ALL_masked,3));
    for j = 1:size(ALL_masked,3)
        % AP truncation
        AP_mask = sum(mask(:,:,j),1);
        loc = find(AP_mask);
        AP_start = loc(1); 
        AP_end = loc(end);
        AP_trunc = ALL_masked(:,AP_start:AP_end,j);
        
        % DV truncation and interpolation
        DV_int = zeros(DV_intdp,size(AP_trunc,2));
        for jj = 1:size(AP_trunc,2)
            current = AP_trunc(:,jj);
            loc = find(current);
            if isempty(loc) % in case of DAPI positive and TF negative
                interpolated = zeros(DV_intdp,1);
            else
                DV_start = loc(1);
                DV_end = loc(end);
                if DV_start == DV_end % in case of single positive DAPI pixel
                    interpolated = ones(DV_intdp,1)*current(DV_start);
                else
                    interpolated = interp1(1:(DV_end-DV_start+1),current(DV_start:DV_end),linspace(1,(DV_end-DV_start+1),DV_intdp),'pchip');
                end
            end
            DV_int(:,jj) = interpolated';
        end
        
        % AP interpolation
        AP_int = interp1((1:(AP_end-AP_start+1))',DV_int',linspace(1,(AP_end-AP_start+1),AP_intdp),'pchip')';
        
        % Exclude central tube cavity
        AP_int(round(DV_intdp*(DV_tube)/100):round(DV_intdp*(100-DV_tube)/100),round(AP_intdp*(AP_tube)/100):round(AP_intdp*(100-AP_tube)/100)) = 0;
        
        % Write to new matrix array
        Final(:,:,j) = AP_int;
    end
    Final = flip(Final,1); % correct DV orientation
    Final = flip(Final,2); % correct AP orientation
    if size(ALL_masked,3) > 1 % more than one input image
        Final_flat = zeros(size(squeeze(mean(Final,1))')); % for 1D analysis
    elseif size(ALL_masked,3) == 1 % only one input image
        Final_flat = zeros(size((mean(Final,1)))); % for 1D analysis
    end
    for j = 1:size(Final_flat,1)
        for jj = 1:size(Final_flat,2)
            Final_flat(j,jj) = mean(nonzeros(Final(:,jj,j)));
        end
    end
    Final_flat(isnan(Final_flat)) = 0;
    Final_flat_heatmap = zeros(size(Final)); % for 1D heatmap
    for j = 1:size(ALL_masked,3)
        Final_flat_heatmap(:,:,j) = repmat(Final_flat(j,:), size(Final,1),1);
    end
    savefilename = strcat(savepath,filesep,string(wavelength),'_distribution.mat');
    save(savefilename,'Final_flat') % Save distribution plot for positive position quantification
    
    % 2D Visualization
    new_x = num2cell(floor(linspace(1,100,AP_intdp)));
    new_x((mod(1:AP_intdp,AP_intdp/(100/20))~=0)) = {''}; % only display 20% increment in x
    new_y = num2cell(ceil(linspace(1,100,DV_intdp)));
    new_y((mod(1:DV_intdp,DV_intdp/(100/20))~=0)) = {''}; % only display 20% increment in x
    figure(3)
    set(gcf, 'Position',  [50, 50, 2050, 950])
    for j = 1:NumImages
        subplot(NumImages,1,j)
        h = heatmap(Final(:,:,j));
        h.Title = strcat('Neural Tube',32,num2str(j));
        h.XLabel = '% Length in AP Direction';
        h.YLabel = '% Length in DV Direction'; 
        h.XDisplayLabels = new_x;
        h.YDisplayLabels = new_y;
        h.ColorLimits = [0 1];
        h.FontSize = 6;
        colormap(hot)
        grid off
    end
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_heatmap.svg');
    saveas(gcf,savefilename)
    % Average
    figure(4)
    set(gcf, 'Position',  [50, 50, 2050, 250])
    Final_avg = mean(Final,3);
    Final_avg = Final_avg./max(max(Final_avg)); % Normalize to local max for easy interpretation
    h = heatmap(Final_avg);
    h.Title = 'Average';
    h.XLabel = '% Length in AP Direction';
    h.YLabel = '% Length in DV Direction';
    h.XDisplayLabels = new_x;
    h.YDisplayLabels = new_y;
    h.ColorLimits = [0 1];
    h.FontSize = 6;
    colormap(hot)
    grid off
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_heatmap_avg.svg');
    saveas(gcf,savefilename)
    
    % 1D Visualization
    figure(5)
    set(gcf, 'Position',  [50, 50, 2050, 250])
    hold on
    plot(linspace(1,100,AP_intdp),Final_flat(:,:))
    xlabel('Percentage Length of NT (%)')
    ylabel('Local Intensity (Arbitrary Unit)')
    legend(strseq('NT ',1:size(Final,3)))
    hold off
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_distribution.svg');
    saveas(gcf,savefilename)
    % Average
    figure(6)
    set(gcf, 'Position',  [50, 50, 2050, 250])
    hold on
    plot(linspace(1,100,AP_intdp),mean(Final_flat(:,:,1))/max(mean(Final_flat(:,:,1)))) % Similar normalization reason as 2D
    xlabel('Percentage Length of NT (%)')
    ylabel('Average Intensity (Arbitrary Unit)')
    hold off
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_distribution_avg.svg');
    saveas(gcf,savefilename)
    
    % 2D Heatmap for 1D data
    new_x = num2cell(floor(linspace(1,100,AP_intdp)));
    new_x((mod(1:AP_intdp,AP_intdp/(100/20))~=0)) = {''}; % only display 20% increment in x
    new_y = num2cell(ceil(linspace(1,100,DV_intdp)));
    new_y((mod(1:DV_intdp,DV_intdp/(100/20))~=0)) = {''}; % only display 20% increment in x
    figure(7)
    set(gcf, 'Position',  [50, 50, 2050, 950])
    for j = 1:NumImages
        subplot(NumImages,1,j)
        h = heatmap(Final_flat_heatmap(:,:,j));
        h.Title = strcat('Neural Tube',32,num2str(j));
        h.XLabel = '% Length in AP Direction';
        h.YLabel = '% Length in DV Direction'; 
        h.XDisplayLabels = new_x;
        h.YDisplayLabels = new_y;
        h.ColorLimits = [0 1];
        h.FontSize = 6;
        colormap(hot)
        grid off
    end
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_1d_heatmap.svg');
    saveas(gcf,savefilename)
    % Average
    figure(8)
    set(gcf, 'Position',  [50, 50, 2050, 250])
    Final_flat_heatmap_avg = mean(Final_flat_heatmap,3);
    Final_flat_heatmap_avg = Final_flat_heatmap_avg./max(max(Final_flat_heatmap_avg)); % Normalize to local max for easy interpretation
    h = heatmap(Final_flat_heatmap_avg);
    h.Title = 'Average';
    h.XLabel = '% Length in AP Direction';
    h.YLabel = '% Length in DV Direction';
    h.XDisplayLabels = new_x;
    h.YDisplayLabels = new_y;
    h.ColorLimits = [0 1];
    h.FontSize = 6;
    colormap(hot)
    grid off
    % Output and Save
    savefilename = strcat(savepath,filesep,string(wavelength),'_1d_heatmap_avg.svg');
    saveas(gcf,savefilename)
end


