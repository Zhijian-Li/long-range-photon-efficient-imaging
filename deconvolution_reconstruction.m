%% A deconvolution Reconstruction Scheme
% A 3D deconvolution scheme modified from SPIRAL-TAP by Z.H.Harmany et al.

%% Preprocess the uncensored data and Set some algorithm parameters

fprintf('* * preprocessing the data and generating the forward model \n');

% translate the type of the data from cell to 3D matrix
totDetect=Ts_gated;                                              % read the data
numTotDetect = cellfun('length',totDetect);                      % photon counts
[lr,lc] = size(numTotDetect);                                    % size of the picture
bin=1*10^(-9);                                                   % temporal resolution of the 3D matrix is 1ns, 
                                                                 % unit: s


[MM, mm] = findmaxmin_for_cell(totDetect, lr, lc);               % find the maximum and the minimum in the uncensored data
y = preprocess_cell2matrix(MM, mm, lr, lc, bin, totDetect);      % turn the cell totDetect to a 3D matrix y 
                                                                 % with 1ns bin resolution

% ganerate the imaging forward model 
% according to the calibration of the imaging setup 
width=10^(-9);                                                   % the whole system jitter is 1ns
sigma=0.025/1400;                                                % the size of the light spot 
samplesize=0.015/1400;                                           % the size of the FoV
                                                                 % over 1400m range, 
                                                                 % the radii of the two above are 0.025m and 0.015m 
                                                                 
blur=blurcal_3D(samplesize,bin,3,3,21,sigma,width);              % generate the 3D spatiotemporal kernel       
A = @(x) convn(x,blur,'same'); AT = @(x) convn(x,blur,'same');   % construct the imaging forward model                              

% set the regularizer value, the filter parameter, and the relative time gate start
switch foldername{ii}
    case '21km_K11_night'
        tautv = 0.25;
        ref_cut_factor = 0.025;
        relative_start = 4430000;
    case '45km_building'
        tautv = 0.25;
        ref_cut_factor = 0.097;
        relative_start = 3220000;
end
        
% set some other parameters like iteration limits:
miniter = 1;
maxiter = 3;
stopcriterion = 3;
tolerance = 1e-8;
verbose = 10;        

% initialization:
yinit = (sum(sum(y)).*numel(AT(y)))./(sum(sum(AT(y))) .*sum(sum((AT(ones(size(y))))))).*AT(y);
    

%% Reconstruction with a convex solver modified from SPIRALTAP

fprintf('* * reconstructing with a modified convex solver \n');

[recoveredSPIRALtv, iterationsSPIRALtv, objectiveSPIRALtv,...
reconerrorSPIRALtv, cputimeSPIRALtv] ...
         = SPIRALTAP3D_v1(y,A,tautv,...
            'noisetype','gaussian',...
            'penalty','TV',...
            'AT',AT,...    
            'maxiter',maxiter,...
            'Initialization',yinit,...
            'miniter',miniter,...
            'stopcriterion',stopcriterion,...
            'tolerance',tolerance,...
            'monotone',1,...
            'saveobjective',1,...
            'savereconerror',1,...
            'savecputime',1,...
            'savesolutionpath',0,...
            'truth',y,...
            'verbose',verbose);
        

%% Obtain a fine depth map from the recovered 3D matrix given by the convex solver above
% From the 3D recovered result, a reflectivity map and a depth map can be acquired
% and a finer depth map can be obtained after filtering the depth map with the reflectivity map

fprintf('* *  obtaining the final depth map from the recovered 3D matrix \n');
                     
depth_final = zeros(lr,lc);
for a=1:lr
    for b=1:lc
           [ ref_recover(a,b), dep_recover(a,b)] = max(recoveredSPIRALtv(a,b,:));
           if ref_recover(a,b) >  ref_cut_factor 
              depth_final(a,b) = (dep_recover(a,b)*bin*10^(12))*1.5*10^(-4)+(mm-relative_start)*1.5e-4;
           end  
    end
end
depth_proposed{ii} = depth_final;
