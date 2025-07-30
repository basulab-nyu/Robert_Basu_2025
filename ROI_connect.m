function [] = ROI_connect()
    root_folder = '/gpfs/data/basulab/VR/cohort_7/m30';
    roi_name = 'ROI_s2p_set_m30_curated.zip';
	connect_name = 'ROI_link.mat';
	width = 512;
    height = 512;
	addpath(genpath('ADP'));
	addpath(genpath('code'));
	[sROI_input, ROI_input] = ReadImageJROI_C(fullfile(root_folder,roi_name), [height, width]);
	names_input = cellfun(@(x) x.strName, sROI_input(:), 'UniformOutput', false);
	ROI = ROI_input;
	sROI = sROI_input;
	load(fullfile(root_folder,connect_name));
	[x,y] = find(connected);
	ROI(:,:,union(x,y)) = [];
	sROI(union(x,y)) = [];
	names = cellfun(@(x) x.strName, sROI(:), 'UniformOutput', false);
	[~,yu,~] = unique(y);
	for i=1:size(yu,1)
		ROI(:,:,end+1) = any(ROI_input(:,:,[x(yu(i)),y(yu(i))]),3);
		sROI{end+1} = sROI_input([x(yu(i)),y(yu(i))]);
		names{end+1} = strcat(names_input{[x(yu(i)),y(yu(i))]});
	end
    save(fullfile(root_folder,'ROI_s2p_set_curated_merged'),'ROI','sROI','names');
end