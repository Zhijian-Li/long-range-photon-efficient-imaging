%% pixelwise maximum-likelihood recosntruciton
% a simple method reconstructing the data by calculating the mean value of
% the ToF information for each pixel

%% read the data
totDetect=Ts_gated;
numTotDetect = cellfun('length',totDetect);  % photon counts matrix
[lr,lc] = size(numTotDetect); 
time2depth = 1.5e-4; % the unit of the arrival time in the data is ps
                     % and the corresponding depth is 0.15 mm.

%% set different relative time gate start for different data 
switch foldername{ii}
    case '21km_K11_night'
        relative_start = 4430000;
    case '45km_building'
        relative_start = 3220000;
end

%% calculate the mean value
depth_ML = zeros(lr,lc);
for aa = 1:lr
    for bb = 1:lc
        depth_ML(aa,bb) = (mean(totDetect{aa,bb})-relative_start)*time2depth;
    end
end
depth_pixelwiseML{ii} = depth_ML;