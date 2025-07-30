function [] = pool_behavior()
	root_folder = '/gpfs/data/basulab/VR/cohort_7';
    struct_behavior_pool_reduced = struct;
    mice = dir(root_folder);
    for i=1:size(mice,1)
        if contains(mice(i).name,'m') && isdir(fullfile(mice(i).folder,mice(i).name))
            struct_behavior_pool_reduced(1).(mice(i).name) = struct;
            sessions = dir(fullfile(mice(i).folder,mice(i).name));
            for j=1:size(sessions,1)
                if contains(sessions(j).name,digitsPattern(6))
                    struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)) = struct;
                    series = dir(fullfile(sessions(j).folder,sessions(j).name));
                    for k=1:size(series,1)
                        if (contains(series(k).name,'_t-') && isdir(fullfile(series(k).folder,series(k).name))) || (contains(series(k).name,'_v-') && isdir(fullfile(series(k).folder,series(k).name)))
                            matfile = dir(fullfile(series(k).folder,series(k).name,'behavior',strcat('*',series(k).name,'*.mat')));
                            if ~isempty(matfile)
                                struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = load(fullfile(series(k).folder,series(k).name,'behavior',matfile(1).name));
                                struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')).struct_behavior_lap;
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_position_lap');
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_norm_pos_lap');
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_time_lap');
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_lick_lap');
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_speed_lap');
								struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')) = rmfield(struct_behavior_pool_reduced(1).(mice(i).name).(strcat('s',sessions(j).name)).(strrep(series(k).name,'-','_')),'m_lick_scat');
                            end
                        end
                    end
                end
            end
        end
    end
	save(fullfile(root_folder,'struct_behavior_pool_reduced.mat'),'struct_behavior_pool_reduced','-v7.3');
end