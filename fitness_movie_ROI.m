function [] = fitness_movie_ROI()
    root_folder = '/gpfs/data/basulab/VR/cohort_5/m12';
    input_name = 'dff';
    input_img = 'vid_max_proj_m12.tif';
    output_name = 'fitness_fullsample';
	input_session = ...
	["240307",...
	"240308",...
	"240309",...
	"240310",...
	"240311",...
	"240312",...
	"240313",...
	"240314",...
	"240325",...
	"240326",...
	"240327",...
	"240328",...
	"240329",...
	"240330",...
	"240331",...
	"240401",...
	"240402"];
	addpath(genpath('code'));
    str_slash = '/';
    if ~contains(root_folder,str_slash)
        str_slash = '\';
    end
    output_folder = fullfile(root_folder,output_name);
    if(~exist(output_folder,'dir'))
        mkdir(output_folder);
    end
    folder_list = list_folders_VR(root_folder);
    fprintf('\nloading mat files into struct...\n');
    tic;
    s_root = struct;
	s_root(1).img = bigread2(fullfile(root_folder,input_img),1);
    for i=1:size(folder_list,1)
        if isfolder(folder_list(i)) == 1
            fprintf('\nworking on:\n');
            input_folder = fullfile(folder_list(i),input_name);
            disp(input_folder);
            if isfolder(input_folder) == 1 && (contains(input_folder,input_session))
                fprintf('\ninput folder found...\n');
                if isfile(fullfile(input_folder,dir(fullfile(input_folder,'dff.mat')).name)) == 1
                    fprintf('\nloading mat files...\n');
                    full_name = fullfile(input_folder,dir(fullfile(input_folder,'dff.mat')).name);
                    v_str_cut = strfind(full_name,str_slash);
                    for j=1:length(v_str_cut)-1
                        temp_name = extractBetween(full_name,v_str_cut(j)+1,v_str_cut(j+1)-1);
                        if contains(temp_name,'_t-')
                            str_name = char(temp_name);
                        end
                    end
                    s_root(i).name = str_name;
                    load(fullfile(input_folder,dir(fullfile(input_folder,'dff.mat')).name),'F');
					if size(F,1) < size(F,2)
						F = F';
					end
					s_root(i).roi_id = load(fullfile(input_folder,dir(fullfile(input_folder,'roi.mat')).name),'names');
                    s_root(i).roi_coor = load(fullfile(input_folder,dir(fullfile(input_folder,'roi.mat')).name),'Coor');
					fprintf('\nmat file loaded as:\n');
                    disp(str_name);
					fprintf('\nloading movie file...\n');
					temp_mov = bigread2(fullfile(folder_list(i),'vid','MC_Video_nonrigid.tif'));
					if ~isa(temp_mov,'single')
						temp_mov = single(temp_mov);
					end  
					fprintf('\nmovie file loaded!\n');
					temp_F = F';
					fprintf('\ndetecting events...\n');
					temp_roi_sessions = NaN(size(temp_mov,1),size(temp_mov,2),size(s_root(i).roi_coor.Coor,1));
					for j=1:size(s_root(i).roi_coor.Coor,1)
						temp_mask = poly2mask(s_root(i).roi_coor.Coor{j,1}(1,:),s_root(i).roi_coor.Coor{j,1}(2,:),size(temp_mov,1),size(temp_mov,2));
						temp_roi = double(s_root(1).img);
						temp_roi(temp_mask == 0) = 0;
						temp_roi_sessions(:,:,j) = temp_roi;
					end
					[dff,s_root(i).start_stop,s_root(i).peak,s_root(i).amp,s_root(i).width,s_root(i).auc] = fitness_detect_fullsample(temp_F,temp_roi_sessions,temp_mov);
					s_root(i).amp = cellfun(@(c) transpose(c),s_root(i).amp,'UniformOutput',false);
					clear temp_mov;
					clear temp_roi_sessions;
					clear temp_F;
					stamps_t = s_root(i).peak;
					stamps_f = s_root(i).amp;
					save(full_name,'F','dff','stamps_t','stamps_f','-v7.3');
					clear F;
					clear dff;
					clear stamps_t;
					clear stamps_f;
                    fprintf('\nsession done!\n\n');
                else
                    fprintf('\n***mat file missing***\n');
                    continue
                end
            else
                fprintf('\n~~~input folder != input session~~~\n');
                continue
            end
        else
            fprintf('\n***input folder missing***\n');
            continue
        end
    end
    fprintf('\nmat files loaded into struct!\n\n');
	fprintf('\nsaving mat file...\n');
    save(fullfile(output_folder,'fitness'),'s_root','-v7.3');
	fprintf('\nall done!!!\n');
end