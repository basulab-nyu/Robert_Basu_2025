function [] = run_dNMF()
	input_folder = '/gpfs/scratch/roberv04/cohort_6/m16';
	input_video = 'vid_concat_m16.ome.tif';
	output_name = 'ROI_dNMF_set_m16';
	str_slash = '/';
    if ~contains(input_folder,str_slash)
        str_slash = '\';
    end
	input_file = fullfile(input_folder,input_video);
	addpath(genpath('code'));
	options.thr = 2;                    % Threshold for active pixels
	options.patchSize = [512 512];        % Size of image patches
	options.stride = 0;                % Offset of image patches
	options.overlapThr = 0.25;          % Spatial overlap merge threshold 
	options.temporalCorrThr = 0.8;      % Temporal correlation merge threshold 
	options.minSkew = 1;                % Minimum skew of temporal trace of valid ROIs
	options.sizeRange = [50 1000];      % Allowable size range of valid ROIs
	fprintf('\nrunning dNMF...\n\n');
    tic;	
	[ROIs, Cs, coherence, skew, sz, tElapsed] = mcb_DNMF(input_file, options);		
	save(fullfile(input_folder,'DNMF_Out.mat'), 'ROIs', 'Cs', 'coherence', 'skew', 'sz', 'options', 'tElapsed', '-v7.3');
	toc;
    fprintf('\ndNMF done!!!\n');	
	ROI_folder = strcat(input_folder,str_slash,output_name,str_slash);
	if(~exist(ROI_folder,'dir'))
		mkdir(ROI_folder);
	end
	fprintf('\nwriting ROI files...\n\n');
    tic;
	[~,max_idx] = max(Cs,[],2);
	for i_roi = 1:size(ROIs,3)        
		[a,b] = find(imdilate(ROIs(:,:,i_roi)>0,ones(3)));
		c = boundary(a,b,0.95);
		writeImageJROI_3([a(c) b(c)], 4, max_idx(i_roi), sprintf('r%04d',i_roi), ROI_folder);
	end
	toc;
    fprintf('\nROI files done!!!\n');
    fprintf('\nzipping ROI folder...\n\n');
    tic;
	zip(fullfile(input_folder,output_name),'*',ROI_folder);
	rmdir(ROI_folder, 's');
	toc;
    fprintf('\nROI folder zipped!!!\n\n');
end