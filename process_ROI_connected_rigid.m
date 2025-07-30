function [] = process_ROI_connected_rigid()
    root_folder = '/gpfs/data/basulab/VR/cohort_5/m12';
    input_name = 'vid';
	vid_name = 'MC_Video_nonrigid.tif';
    roi_name = 'ROI_s2p_set_curated_merged.mat';
	width = 512;
    height = 512;
	length = 20000;
	filter_window = 1000;
	output_name = 'dff';
	str_slash = '/';
    if ~contains(root_folder,str_slash)
        str_slash = '\';
    end
	addpath(genpath('code'));
    folder_list = list_folders_VR(root_folder);
	for i = 1:size(folder_list,1)
        if isfolder(folder_list(i)) == 1
            fprintf('\nworking on:\n\n');
            input_folder = fullfile(folder_list(i),input_name);
            disp(input_folder);
            if isfolder(input_folder) == 1
                fprintf('\ninput folder found...\n\n');
                output_folder = fullfile(folder_list(i),output_name);
                disp(output_folder);
                if ~exist(output_folder,'dir')
                    mkdir(output_folder);
                    fprintf('\noutput folder created...\n\n');
                else
                    fprintf('\noutput folder found...\n\n');
                end
                input_video = fullfile(input_folder,vid_name);
                disp(input_video);
                if isfile(input_video) == 1
                    fprintf('\nvideo file found...\n\n');
                else
                    fprintf('\n***video file missing***\n\n');
                    continue
                end
				input_ROI = fullfile(root_folder,roi_name);
                disp(input_ROI);
                if isfile(input_ROI) == 1
                    fprintf('\nROI file found...\n\n');
                    extract_dff_rigid(input_video,input_ROI,output_folder,width,height,length,filter_window);
                    temp_find = strfind(folder_list(i),str_slash);
                    session_id = extractAfter(folder_list(i),temp_find(end));
                    struct_xml = dir(fullfile(folder_list(i),session_id,'.xml'));
                    if isempty(struct_xml) == 0
                        input_xml = fullfile(folder_list(i),struct_xml(1).name);
                        disp(input_xml);
                        dest_xml = fullfile(output_folder,struct_xml(1).name);
                        if isfile(input_xml) == 1
                            fprintf('\nXML file found...\n\n');
                            copyfile(input_xml,dest_xml);
                            disp(dest_xml);
                            fprintf('\nXML file copied...\n\n');
                        else
                            fprintf('\n***XML file missing***\n\n');
                            continue
                        end
                        struct_csv = dir(fullfile(folder_list(i),'*.csv'));
                        if isempty(struct_csv) == 0
                            input_csv = fullfile(folder_list(i),struct_csv(1).name);
                            disp(input_csv);
                            dest_csv = fullfile(output_folder,struct_csv(1).name);
                            if isfile(input_csv) == 1
                                fprintf('\nCSV file found...\n\n');
                                copyfile(input_csv,dest_csv);
                                disp(dest_csv);
                                fprintf('\nCSV file copied...\n\n');
                            else
                                fprintf('\n***CSV file error***\n\n');
                                continue
                            end
                        else
                            fprintf('\n***CSV file missing***\n\n');
                            continue
                        end
                    else
                        fprintf('\n***XML file missing***\n\n');
                        continue
                    end
                else
                    fprintf('\n***ROI file missing***\n\n');
                    continue
                end
            else
                fprintf('\n***input folder missing***\n\n');
                continue
            end
        else
            fprintf('\n***input session missing***\n\n');
            continue
        end
    end
	fprintf('\nall done!!!\n\n');