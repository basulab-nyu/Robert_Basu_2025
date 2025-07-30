function [] = maxproj_movie()
    input_file = '/gpfs/scratch/roberv04/RF/Blue_926/MC_Video_TSub_concat_batch_mc_RF_vid.tif';
    output_file = '/gpfs/scratch/roberv04/RF/Blue_926/MC_Video_TSub_concat_batch_mc_RF_vid_max.tif'
    addpath(genpath('ADP'));
	addpath(genpath('NoRMCorre'));
    addpath(genpath('JTools'));
	addpath(genpath('d-NMF-main'));
    fprintf('\nreading video...\n\n');
    tic;
    m_movie = bigread2(input_file);
	fprintf('\naveraging frames...\n\n');
	m_max = max(m_movie,[],3);
	fprintf('\nsaving projection...\n\n');
	saveastiff(int16(m_max),output_file);
    toc;
    fprintf('\ndone!!!\n\n');
end
