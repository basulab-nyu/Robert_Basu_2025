function [] = concatenate_sessions()
    root_folder = '/gpfs/data/basulab/VR/cohort_7/m33a';
    input_name = 'vid';
	addpath(genpath('code'));
	[~,m_id] = fileparts(root_folder);
    folder_list = list_folders_VR(root_folder);
	tic;
    fprintf('\nlisting files...\n\n');
    list_files = string();
    for i = 1:size(folder_list,1)
        str_file = fullfile(folder_list(i),input_name,'MC_Video_TSub_nonrigid.tif');
        if isfile(str_file) == 1
			disp(str_file);
            list_files(i) = str_file;
        end
    end
	list_files = transpose(list_files);
	list_files(cellfun('isempty',list_files)) = [];
    fprintf('\nfiles listed!!!\n\n');
    fprintf('\nreading frames...\n\n');
    temp = bigread2(list_files(1),1);
    [height, width, blockSize] = size(temp);
    vid_concat = zeros(height,width,size(list_files,1)*blockSize,'int16');
    start = 1;
    stop = start + size(temp,3) - 1;
    vid_concat(:,:,start:stop) = temp;
    for i = 2:size(list_files,1)
        temp = bigread2(list_files(i),1);
        start = (i-1)*blockSize+1;
        stop = start + size(temp,3) - 1;
        vid_concat(:,:,start:stop) = temp;
    end    
    vid_concat = vid_concat(:,:,1:stop);
    fprintf('\nframes processed!!!\n\n');
    fprintf('\nsaving file...\n\n');
    save_path = fullfile(root_folder,strcat('vid_concat_',m_id,'.tif'));
	fTIF_concat = Fast_BigTiff_Write(save_path,1,0);
	for i = 1:size(vid_concat,3)
		fTIF_concat.WriteIMG(uint16(vid_concat(:,:,i)'));
	end
	fTIF_concat.close;
	%saveastiff(int16(vid_concat),save_path);
    fprintf('\nconcatenation done!!!\n\n');
	fprintf('\naveraging frames...\n\n');
	m_max = max(vid_concat,[],3);
	save_path = fullfile(root_folder,strcat('vid_max_proj_',m_id,'.tif'));
	saveastiff(int16(m_max),save_path);
	m_mean = mean(vid_concat,3);
	save_path = fullfile(root_folder,strcat('vid_mean_proj_',m_id,'.tif'));
	saveastiff(int16(m_mean),save_path);
	fprintf('\nprojections computed!!!\n\n');
	toc;
end