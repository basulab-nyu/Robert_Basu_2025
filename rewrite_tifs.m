function [] = rewrite_tifs()
	target_folder = '/gpfs/data/basulab/VR/cohort_5/m8/240329/VR_240329_m8_nov_t-000';
	addpath(genpath('code'));
	fprintf('\nprocessing...\n\n');
	tiffs = dir(fullfile(target_folder,'*.tif'));
	stack = bigread2(fullfile(target_folder,tiffs(1).name),1);
	stack = bfopen(fullfile(target_folder,tiffs(1).name))
    if(~isempty(files))
        r = imread(fullfile(target_folder,tiffs(1).name));        
    else
        r = NaN(512,512);
    end
    N = length(files);
    Ygreen = zeros(size(r,1),size(r,2),N,'uint16');
	stacks = makeStacksG(target_folder);
	[~,session_id,~] = fileparts(target_folder)
	save_path = fullfile(target_folder,strcat('stacks_',session_id,'.tif'));
	fTIF_concat = Fast_BigTiff_Write(save_path,1,0);
	for i = 1:size(vid_concat,3)
		fTIF_concat.WriteIMG(uint16(stacks(:,:,i)'));
	end
	fprintf('\ndone!!!\n\n');
	toc;
end