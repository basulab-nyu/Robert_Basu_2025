function [] = split_mc_tif_ms_to_ss()
    root_folder = '/gpfs/data/basulab/VR/cohort_7/m33a';
    input_name = 'batch_mc';
    output_name = 'mc';
    batch_size = 1000;
    session_size = 20000;
    chunk_size = session_size/batch_size;
	addpath(genpath('code'));
    source_folder = fullfile(root_folder,input_name,'reg_tif');
    folder_list = list_folders_VR(root_folder);
	files_nb = nan(length(folder_list),1);
    files_cml = nan(length(folder_list),1);
    array_input_files = string();
    array_output_files = string();
	struct_files = dir(fullfile(source_folder,'*.tif'));
	m_idx_files = [];
	for i=1:size(struct_files,1)
		temp = extract(struct_files(i).name,digitsPattern);
		m_idx_files(i) = str2num(temp{1});
	end
	[~,m_idx_sort] = sort(m_idx_files);
	struct_files = struct_files(m_idx_sort);
    for i=1:size(folder_list,1)
        if isfolder(folder_list(i)) == 1
            fprintf('\nworking on:\n\n');
            disp(folder_list(i));
            input_folder = convertStringsToChars(folder_list(i));
            output_folder = fullfile(folder_list(i),output_name);
            if(~exist(output_folder,'dir'))
                mkdir(folder_list(i),output_name);
            end
            files_nb(i) = chunk_size;
            files_cml(i) = sum(files_nb,'omitnan') - chunk_size;
            for j=1:chunk_size
                array_input_files(i,j) = fullfile(struct_files(j+files_cml(i)).folder,struct_files(j+files_cml(i)).name);
                array_output_files(i,j) = fullfile(output_folder,struct_files(j+files_cml(i)).name);
                input_file = string(fullfile(struct_files(j+files_cml(i)).folder,struct_files(j+files_cml(i)).name));
                output_file = string(fullfile(output_folder,struct_files(j+files_cml(i)).name));
                if isfile(input_file) == 1
                    fprintf('\ncopying from...\n\n');
                    disp(input_file);
                    fprintf('\ninto...\n\n');
                    disp(output_file);
                    copyfile(input_file,output_file);
                    fprintf('\ndone!!!\n\n');
                end
            end
        end
    end
	save(fullfile(root_folder,'tiffs_session_split'),'array_input_files','array_output_files');
end