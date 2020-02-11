%% demo recognized on Feb 8,2020

% Implements the framework presented in
% "Single-photon computational 3D imaging at 45 km" arXiv: 1904.10341
% By Zheng-Ping Li et al

% The long-range-tailored reconstruction algorithm mainly consists of two parts:
% A global gating for censoring the raw data 
% A 3D deconvolution reconstruction scheme modified from SPIRAL-TAP by Z.H.Harmany et al.

% In our experiment, our SPAD operates at free-running mode, 
% and the raw data for a target has a large time period of 10us, which presents a large data size (>300M). 
% For illustration purpose, we show only the experimental data after the global-gating process (shown in the manuscript).

% Following is a simple demo for two results discussed in the manuscript:
% "21km_K11_night.mat", the data for the K11 captured at night over the range of 21km
% "45km_building.mat", the data for the building captured before dawn over the range of 45km
% Both these data have been censored by the global-gating process 

% This demo loops for two times to process two data mentioned above and plots the final results. 
% Each loop includes loading the uncensored data and reconstructing the data 
% with the "pixelwise_ML_reconstruction.m" and "deconvolution_reconstruction.m"

clc; clear; close all;

%% Loop: loading and processing the uncensored data

foldername{1} = '21km_K11_night';
foldername{2} = '45km_building';
addpath('./code');

for ii =1:2
    %load data
    load(['./data/' foldername{ii}]);
    fprintf('* Finished loading the data %s \n', foldername{ii});
    
    % reconstruction
    pixelwise_ML_reconstruction; % pixelwise ML recosntruction method
    fprintf('* Finished processing the data %s with the pixelwise ML method \n', foldername{ii});
    
    deconvolution_reconstruction; % our proposed reconstruction method
    fprintf('* Finished processing the data %s with our proposed method \n \n', foldername{ii});
end

    
    
%% Plot the final results
load('./data/Colormap_for_45km','mycmap');
figure;
h1 = subplot(2,2,1); imagesc(depth_pixelwiseML{1}, [0 27]);axis image;axis off;colorbar;colormap jet;
h2 = subplot(2,2,2); imagesc(depth_pixelwiseML{2}, [0 23]);axis image;axis off;colorbar;colormap(h2, mycmap);
h3 = subplot(2,2,3); imagesc(depth_proposed{1}, [0 27]);axis image;axis off;colorbar;colormap jet;
h4 = subplot(2,2,4); imagesc(depth_proposed{2}, [0 23]);axis image;axis off;colorbar;colormap(h4, mycmap);

title(h1, {'\fontsize{15}21km K11 at night'; '\fontsize{12}pixelwise ML'});
title(h3, '\fontsize{12}proposed method');
title(h2, {'\fontsize{15}45km building'; '\fontsize{12}pixelwise ML'});
title(h4, '\fontsize{12}proposed method');




