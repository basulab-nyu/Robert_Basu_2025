function [] = ROI_merge_master()
	root_folder = '/gpfs/data/basulab/VR/cohort_7/m33b';
	ROI_file = 'ROI_s2p_set_m33b_curated.zip';
	video_file = 'vid_concat_m33b.tif';
    path_to_ROIs = fullfile(root_folder,ROI_file);
	path_to_movie = fullfile(root_folder,video_file);
	addpath(genpath('code'));
	[~,ROI_file] = fileparts(path_to_ROIs);
	tic;
    fprintf('\nloading files...\n\n');
	SM_AMOUNT = 0;
	DETREND_FRAMES = 45;
	sizeRange = [0 Inf];
	THR = 0;
	F_LOAD = @(fileName) import_RoiSet_sparse(fileName);
	thisFolder = fileparts(path_to_ROIs);
	ROI_SET = F_LOAD(path_to_ROIs);
	thisFile = path_to_movie;
	Y = bigread2(thisFile);
	Ysq = Y;
	Y = reshape(Y,[],size(Y,3));    
	ROI_SET.Cs = NaN(size(ROI_SET.cROI,2),size(Y,2));    
	for i_roi = 1:size(ROI_SET.Cs,1)
		this = ROI_SET.cROI(:,i_roi)>0;
		temp = mean(double(Y(this,:)),1);
		ROI_SET.Cs(i_roi,:) = temp;                
	end
	ROI_SET.Cs2 = prep_FR(ROI_SET.Cs, SM_AMOUNT, DETREND_FRAMES);
	padding = 3;
	detrend_option = true;
	zscore_option = true;
	fprintf('\ndone!\n\n');
	fprintf('\ncomputing correlations...\n\n');
	[corTrace] = corrTrace2_full(Ysq, ROI_SET.cROI, DETREND_FRAMES, padding, detrend_option, zscore_option);
	fprintf('\ndone!\n\n');
	fprintf('\nsaving output...\n\n');
	save(fullfile(root_folder,'ROI_merge'),'-v7.3');
	fprintf('\ndone!\n\n');
	fprintf('\nall done!!!\n\n');
	toc;
end