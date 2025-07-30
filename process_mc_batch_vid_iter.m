function [] = process_mc_batch_vid_iter()
    root_folder = '/gpfs/data/basulab/VR/cohort_7/m33a';
    input_name = 'mc';
    output_name = 'vid';
	addpath(genpath('code'));
    folder_list = list_folders_VR(root_folder);
	for i = 1:size(folder_list,1)
        if isfolder(folder_list(i)) == 1
			input_folder = fullfile(folder_list(i),input_name);
			output_folder = fullfile(folder_list(i),output_name);
			if isfolder(input_folder) == 1
				fprintf('\nworking on:\n\n');
				disp(input_folder);
				disp(output_folder);
				if ~isempty(dir(fullfile(input_folder,'*.tif')))
					if(~exist(output_folder,'dir'))
						mkdir(folder_list(i),output_name);
					end
					process_s2p_VR_cluster(input_folder,output_folder);
				else
					fprintf('\n***insufficient data***\n');
					continue
				end
			else
				fprintf('\n***input folder missing***\n\n');
				continue
			end
        end
	end
end