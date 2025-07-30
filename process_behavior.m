function [] = process_behavior()
    root_folder = '/gpfs/data/basulab/VR/cohort_5/m12';
    output_name = 'behavior';
	addpath(genpath('code'));
    folder_list = list_folders_VR(root_folder);
    folder_table = string.empty;
     for i = 1:size(folder_list,1)
         if isfolder(folder_list(i)) == 1
			fprintf('\nworking on:\n\n');
            disp(folder_list(i));
            folder_table = cat(1,folder_table,folder_list(i));
            input_folder = convertStringsToChars(folder_list(i));
            output_folder = strcat(folder_list(i),'/',output_name);
            if(~exist(output_folder,'dir'))
                mkdir(folder_list(i),output_name);
            end
			try
				extract_behavior_VR(input_folder,output_folder);
				plot_behavior_VR(input_folder,output_folder);
				fprintf('\ndone!\n\n');
			catch
				fprintf('\nERROR\n\n');
			end
			fprintf('\nall done!!!\n\n');
         end
     end
     folder_table = array2table(folder_table);
     writetable(folder_table,fullfile(root_folder,'folder_list.txt'));
end