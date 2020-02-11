# Single-photon computational 3D imaging at 45 km
 
This demo includes data and MATLAB codes for the paper "Single-photon computational 3D imaging at 45 km"
by Zheng-Ping Li, Xin Huang, Yuan Cao, Bin Wang, Yu-Huai Li, Weijie Jin, Chao Yu, Jun Zhang, Qiang Zhang, Cheng-Zhi Peng, Feihu Xu, and Jian-Wei Pan
preprinted in arXiv: 1904.10341.

How to cite (BibTeX):
@article{li2019single,
  title={Single-photon computational 3D imaging at 45 km},
  author={Li, Zheng-Ping and Huang, Xin and Cao, Yuan and Wang, Bin and Li, Yu-Huai and Jin, Weijie and Yu, Chao and Zhang, Jun and Zhang, Qiang and Peng, Cheng-Zhi and others},
  journal={arXiv preprint arXiv:1904.10341},
  year={2019}
}
Corresponding author: feihuxu@ustc.edu.cn.

To try the codes, just download the zip and run the "demo_02_08_2020.m" in MATLAB. 
Warning: the code was tested using MATLAB 2017b and it might be incompatible with older versions.  

The raw data is obtained by our single-photon lidar system for a building named K11 over 21km far away and a target over 45km far away. 
The implementation codes are used to compute the depth maps of the remote targets from the raw data.

Note: This long-range-tailored reconstruction algorithm mainly consists of two parts:
       - A global gating for censoring the raw data 
       - A 3D deconvolution reconstruction scheme modified from SPIRAL-TAP by Z.H.Harmany et al. (http://drz.ac/code/spiraltap/)

In our experiment, our SPAD operates at free-running mode where the raw data for a target has a large time period of 10us, which presents a large data size (>300M). 
Here, for illustration purpose, we show only the experimental data after the global-gating process (shown in the manuscript).


Instructions for the experimental data:
    - Ts_gated: (type: cell), size(Ts_gated) = 128x128 for 45km building and 256x256 for 21km K11,
       It is a 2D cell contains the the uncensored ToF information of the arrival photons (unit: ps).
    - meanSigDetect: signal photons per pixel, calculating from the raw data.
    - SBR: signal-to-noise ratio within the signal window (about 200ns), calculating from the raw data.

Others:
Colormap_for_45km.mat stores a colormap matrix named "mycmap", with which the depth map can have a fine visualization.
