function [] = analyze_spatial()
    fprintf('\nanalyzing spatial coding...\n');
%setting up
    %inputs
    root_path = '/gpfs/scratch/roberv04/pool/batch_mc_RF_GOL_rigid_bs_dff_F_fitness_pos';
    mat_file = 'batch_mc_RF_GOL_rigid_bs_dff_F_fitness_pos.mat';
    roi_type = ["ad","bd","m","s"];
    session_groups = [1 2 1 2 1 2 4 4 4 1 2];
    label_groups = ["","SAL","","PSEM","","PSEMCNO","SAL","PSEM","PSEMCNO","","PSEM"];
    %loading data
    fprintf('\nloading mat file...\n');
    s_work = load(fullfile(root_path,mat_file));
    fprintf('\nmat file loaded!\n');
    try
        s_work = s_work.s_pool;
    end
%pooling
    %preparing variables
    fprintf('\npooling data...\n');
    s_work(size(s_work,2)+1).root_folder = 'pool';
    s_work(size(s_work,2)).mouse_id = 'pool';
    tempstr = extractBefore(s_work(1).mouse_id,digitsPattern);
    tempstart = cellfun(@(x) (extractBefore(x,caseInsensitivePattern(tempstr))),s_work(1).session_id,'UniformOutput',false);
    tempstop = cellfun(@(x) (extractAfter(x,caseInsensitivePattern(tempstr))),s_work(1).session_id,'UniformOutput',false);
    s_work(size(s_work,2)).session_id = cellfun(@(x,y) strcat(x,y),tempstart,tempstop,'UniformOutput',false);
    s_work(size(s_work,2)).behavior_path = 'pool';
    for i=1:size(s_work,2)
        s_work(i).session_groups = session_groups;
    end
    s_work(size(s_work,2)).roi_id={};
    s_work(size(s_work,2)).roi_coor={};
    s_work(size(s_work,2)).roi_map={};
    s_work(size(s_work,2)).event_peak={};
    s_work(size(s_work,2)).event_onset_offset={};
    s_work(size(s_work,2)).traces_f=[];
    s_work(size(s_work,2)).traces_df=[];
    s_work(size(s_work,2)).event_binary_full=[];
    for i=1:size(roi_type,2)
        s_work(size(s_work,2)).(char(roi_type(i))).roi_id = {};
        s_work(size(s_work,2)).(char(roi_type(i))).event_peak = {};
        s_work(size(s_work,2)).(char(roi_type(i))).event_onset_offset = {};
        s_work(size(s_work,2)).(char(roi_type(i))).traces_f = [];
        s_work(size(s_work,2)).(char(roi_type(i))).traces_df = [];
        s_work(size(s_work,2)).(char(roi_type(i))).event_binary_full = [];
        s_work(size(s_work,2)).(char(roi_type(i))).spatial = struct;
        for j=1:size(s_work(size(s_work,2)).session_id,1)
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).event_binary = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all = struct;
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt = struct;
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split = struct;
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.timeRunning = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.nEvents = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.significant = logical([]);
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.peakIdx = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.fieldCenters = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.fieldWidth = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.nFields = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.rate_map = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.infoContent = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).all.normalizedInfo = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.timeRunning = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.nEvents = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.significant = logical([]);
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.peakIdx = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.fieldCenters = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.fieldWidth = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.nFields = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.rate_map = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.infoContent = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.normalizedInfo = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.timeRunning = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.nEvents = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.significant = logical([]);
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.peakIdx = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.fieldCenters = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.fieldWidth = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.nFields = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.rate_map = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.infoContent = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).opt.normalizedInfo = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.timeRunning = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.nEvents = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.significant = logical([]);
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.peakIdx = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.fieldCenters = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.fieldWidth = {};
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.nFields = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.rate_map = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.infoContent = [];
            s_work(size(s_work,2)).(char(roi_type(i))).spatial(j).split.normalizedInfo = [];
        end
    end
    %filling variables
    for i=1:size(s_work,2)-1
        s_work(size(s_work,2)).roi_id = cat(1,s_work(size(s_work,2)).roi_id,s_work(i).roi_id);
        s_work(size(s_work,2)).roi_coor = cat(1,s_work(size(s_work,2)).roi_coor,s_work(i).roi_coor);
        s_work(size(s_work,2)).roi_map{i,1} = s_work(i).roi_map;
        s_work(size(s_work,2)).event_peak = cat(2,s_work(size(s_work,2)).event_peak,s_work(i).event_peak);
        s_work(size(s_work,2)).event_onset_offset = cat(2,s_work(size(s_work,2)).event_onset_offset,s_work(i).event_onset_offset);
        s_work(size(s_work,2)).traces_f = cat(2,s_work(size(s_work,2)).traces_f,s_work(i).traces_f);
        s_work(size(s_work,2)).traces_df = cat(2,s_work(size(s_work,2)).traces_df,s_work(i).traces_df);
        s_work(size(s_work,2)).event_binary_full = cat(1,s_work(size(s_work,2)).event_binary_full,s_work(i).event_binary_full);
        for j=1:size(roi_type,2)
            s_work(size(s_work,2)).(char(roi_type(j))).roi_id = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).roi_id,s_work(i).(char(roi_type(j))).roi_id);
            s_work(size(s_work,2)).(char(roi_type(j))).event_peak = cat(2,s_work(size(s_work,2)).(char(roi_type(j))).event_peak,s_work(i).(char(roi_type(j))).event_peak);
            s_work(size(s_work,2)).(char(roi_type(j))).event_onset_offset = cat(2,s_work(size(s_work,2)).(char(roi_type(j))).event_onset_offset,s_work(i).(char(roi_type(j))).event_onset_offset);
            s_work(size(s_work,2)).(char(roi_type(j))).traces_f = cat(2,s_work(size(s_work,2)).(char(roi_type(j))).traces_f,s_work(i).(char(roi_type(j))).traces_f);
            s_work(size(s_work,2)).(char(roi_type(j))).traces_df = cat(2,s_work(size(s_work,2)).(char(roi_type(j))).traces_df,s_work(i).(char(roi_type(j))).traces_df);
            s_work(size(s_work,2)).(char(roi_type(j))).event_binary_full = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).event_binary_full,s_work(i).(char(roi_type(j))).event_binary_full);
            for k=1:size(s_work(size(s_work,2)).session_id,1)
                try
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).event_binary = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).event_binary,s_work(i).(char(roi_type(j))).spatial(k).event_binary);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.timeRunning = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.timeRunning,s_work(i).(char(roi_type(j))).spatial(k).all.timeRunning);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.nEvents = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.nEvents,s_work(i).(char(roi_type(j))).spatial(k).all.nEvents);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.significant = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.significant,s_work(i).(char(roi_type(j))).spatial(k).all.significant);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.peakIdx = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.peakIdx,s_work(i).(char(roi_type(j))).spatial(k).all.peakIdx);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.fieldCenters = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.fieldCenters,s_work(i).(char(roi_type(j))).spatial(k).all.fieldCenters);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.fieldWidth = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.fieldWidth,s_work(i).(char(roi_type(j))).spatial(k).all.fieldWidth);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.nFields = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.nFields,s_work(i).(char(roi_type(j))).spatial(k).all.nFields);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.rate_map = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.rate_map,s_work(i).(char(roi_type(j))).spatial(k).all.rate_map);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.infoContent = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.infoContent,s_work(i).(char(roi_type(j))).spatial(k).all.infoContent);
                    s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.normalizedInfo = cat(1,s_work(size(s_work,2)).(char(roi_type(j))).spatial(k).all.normalizedInfo,s_work(i).(char(roi_type(j))).spatial(k).all.normalizedInfo);
                end
            end
        end
    end
    fprintf('\ndata pooled!\n');
%analyzing spatial coding
    fprintf('\nprocessing data...\n');
    for i=1:size(s_work,2) %animals
        for j=1:size(roi_type,2) %roi type
            s_work(i).(char(roi_type(j))).roi_pc_binary = zeros(size(s_work(i).(char(roi_type(j))).roi_id,1),size(s_work(i).(char(roi_type(j))).spatial,2));
            for k=1:size(s_work(i).(char(roi_type(j))).spatial,2) %sessions
                try %sorting
                    field_center_index = find(~cellfun(@isempty,s_work(i).(char(roi_type(j))).spatial(k).all.fieldCenters));
                    s_work(i).(char(roi_type(j))).spatial(k).all.field_center_index = field_center_index;
                    s_work(i).(char(roi_type(j))).roi_pc_binary(field_center_index,k) = 1;
                    s_work(i).(char(roi_type(j))).spatial(k).all.field_center_active = cellfun(@(v)v(1),s_work(i).(char(roi_type(j))).spatial(k).all.fieldCenters(field_center_index));
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active = s_work(i).(char(roi_type(j))).spatial(k).all.rate_map(field_center_index,:);
                    [field_center_sorted,field_center_sorted_index] = sort(s_work(i).(char(roi_type(j))).spatial(k).all.field_center_active);
                    s_work(i).(char(roi_type(j))).spatial(k).all.field_center_sorted = field_center_sorted;
                    s_work(i).(char(roi_type(j))).spatial(k).all.field_center_sorted_index = field_center_sorted_index;
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted = s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active(field_center_sorted_index,:);
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_z = zscore(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map,0,2);
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_n = normalize(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map,2,'range');
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_z = zscore(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active,0,2);
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_n = normalize(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active,2,'range');
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_z = zscore(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted,0,2);
                    s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_n = normalize(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted,2,'range');
                end
            end
            for k=1:size(session_groups,2)
                if(session_groups(k)>1)
                    try %correlations for ROIs active across sessions within groups
                        s_work(i).(char(roi_type(j))).session_cross(k).roi_pc_binary = s_work(i).(char(roi_type(j))).roi_pc_binary(:,k:k+session_groups(k)-1);
                        tempsum = sum(s_work(i).(char(roi_type(j))).session_cross(k).roi_pc_binary,2);
                        s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active = find(tempsum == session_groups(k));
                        s_work(i).(char(roi_type(j))).session_cross(k).rate_map = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map,2),session_groups(k));
                        s_work(i).(char(roi_type(j))).session_cross(k).rate_map_z = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_z,2),session_groups(k));
                        s_work(i).(char(roi_type(j))).session_cross(k).rate_map_n = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_n,2),session_groups(k));
                        for x=1:session_groups(k)
                            s_work(i).(char(roi_type(j))).session_cross(k).rate_map(:,:,x) = s_work(i).(char(roi_type(j))).spatial(x+session_groups(k)-1).all.rate_map(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,:);
                            s_work(i).(char(roi_type(j))).session_cross(k).rate_map_z(:,:,x) = s_work(i).(char(roi_type(j))).spatial(x+session_groups(k)-1).all.rate_map_z(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,:);
                            s_work(i).(char(roi_type(j))).session_cross(k).rate_map_n(:,:,x) = s_work(i).(char(roi_type(j))).spatial(x+session_groups(k)-1).all.rate_map_n(s_work(i).(char(roi_type(j))).session_cross(k).roi_lg_active,:);
                        end
                        s_work(i).(char(roi_type(j))).session_cross(k).comp_id = strings;
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_n = {};
                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_n = {};
                        for p=1:session_groups(k)
                            for q=p+1:session_groups(k)
                                s_work(i).(char(roi_type(j))).session_cross(k).comp_id(size(s_work(i).(char(roi_type(j))).session_cross(k).comp_id,1)+1,1) = strcat(s_work(i).session_id{sum(session_groups(1:k-1))+p,1},"_vs_",s_work(i).session_id{sum(session_groups(1:k-1))+q,1});
                                tempSUBmap = s_work(i).(char(roi_type(j))).session_cross(k).rate_map(:,:,[p q]);
                                tempSUBmap_z = s_work(i).(char(roi_type(j))).session_cross(k).rate_map_z(:,:,[p q]);
                                tempSUBmap_n = s_work(i).(char(roi_type(j))).session_cross(k).rate_map_n(:,:,[p q]);
                                tempTCmap = permute(tempSUBmap,[2 3 1]);
                                tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
                                tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,3),1);
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map_z,3),1);
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map_n,3),1);
                                for x=1:size(tempTCmap,3)
                                    tempTC = corrcoef(tempTCmap(:,:,x));
                                    tempTC_z = corrcoef(tempTCmap_z(:,:,x));
                                    tempTC_n = corrcoef(tempTCmap_n(:,:,x));
                                    s_work(i).(char(roi_type(j))).session_cross(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr,1),1}(x,1) = tempTC(1,2);
                                    s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
                                end
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1));
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1));
                                s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,1));
                                for x=1:size(tempSUBmap,1)
                                    for y=1:size(tempSUBmap,1)
                                        tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
                                        tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
                                        tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
                                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
                                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
                                        s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_cross(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
                                    end
                                end
                                tempPVmap = permute(tempSUBmap,[1 3 2]);
                                tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
                                tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2),1);
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map_z,2),1);
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map_n,2),1);
                                for x=1:size(tempPVmap,3)
                                    tempPV = corrcoef(tempPVmap(:,:,x));
                                    tempPV_z = corrcoef(tempPVmap_z(:,:,x));
                                    tempPV_n = corrcoef(tempPVmap_n(:,:,x));
                                    s_work(i).(char(roi_type(j))).session_cross(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr,1),1}(x,1) = tempPV(1,2);
                                    s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
                                end
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2));
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2));
                                s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work(i).(char(roi_type(j))).session_cross(k).rate_map,2));
                                for x=1:size(tempSUBmap,2)
                                    for y=1:size(tempSUBmap,2)
                                        tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
                                        tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
                                        tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
                                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
                                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
                                        s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_cross(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
                                    end
                                end
                            end
                        end
                    end
                    try %correlations for ROIs active in pairwise sessions within groups
                        s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).roi_pc_binary = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n = {};
                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n = {};
                        for p=1:session_groups(k)
                            for q=p+1:session_groups(k)
                                s_work(i).(char(roi_type(j))).session_pairwise(k).roi_pc_binary{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_pc_binary,1)+1,1} = s_work(i).(char(roi_type(j))).roi_pc_binary(:,[sum(session_groups(1:k-1))+p sum(session_groups(1:k-1))+q]);
                                tempsum = sum(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_pc_binary{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_pc_binary,1),1},2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1)+1,1} = find(tempsum == 2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map,2),2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_z,2),2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_n,2),2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{size(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id,1)+1,1} = {strcat(s_work(i).session_id{sum(session_groups(1:k-1))+p,1},"_vs_",s_work(i).session_id{sum(session_groups(1:k-1))+q,1})};
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q).all.rate_map(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map_z(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q).all.rate_map_z(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map_n(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q).all.rate_map_n(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center,1)+1,1} = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.fieldCenters(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1});
                                s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center,1),1} = cellfun(@(v)v(1),s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center,1),1});
                                [~,field_center_sorted_index_pair] = sort(s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work(i).(char(roi_type(j))).session_pairwise(k).fields_center,1),1});
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(field_center_sorted_index_pair,:,1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(field_center_sorted_index_pair,:,2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,2);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,2);
                                tempSUBmap = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,[1 2]);
                                tempSUBmap_z = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,[1 2]);
                                tempSUBmap_n = s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,[1 2]);
                                tempTCmap = permute(tempSUBmap,[2 3 1]);
                                tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
                                tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr,1)+1,1} = NaN(size(tempSUBmap,3),1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,3),1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,3),1);
                                for x=1:size(tempTCmap,3)
                                    tempTC = corrcoef(tempTCmap(:,:,x));
                                    tempTC_z = corrcoef(tempTCmap_z(:,:,x));
                                    tempTC_n = corrcoef(tempTCmap_n(:,:,x));
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr,1),1}(x,1) = tempTC(1,2);
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
                                end
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map,1)+1,1} = NaN(size(tempSUBmap,1),size(tempSUBmap,1));
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,1),size(tempSUBmap_z,1));
                                s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,1),size(tempSUBmap_n,1));
                                for x=1:size(tempSUBmap,1)
                                    for y=1:size(tempSUBmap,1)
                                        tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
                                        tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
                                        tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
                                    end
                                end
                                tempPVmap = permute(tempSUBmap,[1 3 2]);
                                tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
                                tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr,1)+1,1} = NaN(size(tempSUBmap,2),1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,2),1);
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,2),1);
                                for x=1:size(tempPVmap,3)
                                    tempPV = corrcoef(tempPVmap(:,:,x));
                                    tempPV_z = corrcoef(tempPVmap_z(:,:,x));
                                    tempPV_n = corrcoef(tempPVmap_n(:,:,x));
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr,1),1}(x,1) = tempPV(1,2);
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
                                end
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map,1)+1,1} = NaN(size(tempSUBmap,2),size(tempSUBmap,2));
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,2),size(tempSUBmap_z,2));
                                s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,2),size(tempSUBmap_n,2));
                                for x=1:size(tempSUBmap,2)
                                    for y=1:size(tempSUBmap,2)
                                        tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
                                        tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
                                        tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
                                        s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
                                    end
                                end
                            end
                        end
                    end
                    try %correlations within group to first session as reference
                        s_work(i).(char(roi_type(j))).session_ref(k).comp_id = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).roi_pc_binary = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).fields_center = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_n = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n = {};
                        s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n = {};
                        for p=2:session_groups(k)
                            s_work(i).(char(roi_type(j))).session_ref(k).roi_pc_binary{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_pc_binary,1)+1,1} = s_work(i).(char(roi_type(j))).roi_pc_binary(:,sum(session_groups(1:k-1))+1);
                            s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1)+1,1} = find(s_work(i).(char(roi_type(j))).session_ref(k).roi_pc_binary{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_pc_binary,1),1});
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map,2),2);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_z,2),2);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1)+1,1} = NaN(size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work(i).(char(roi_type(j))).spatial(1).all.rate_map_n,2),2);
                            s_work(i).(char(roi_type(j))).session_ref(k).comp_id{size(s_work(i).(char(roi_type(j))).session_ref(k).comp_id,1)+1,1} = {strcat(s_work(i).session_id{sum(session_groups(1:k-1))+1,1},"_vs_",s_work(i).session_id{sum(session_groups(1:k-1))+p,1})};
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+1).all.rate_map(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+1).all.rate_map_z(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map_z(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,1) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+1).all.rate_map_n(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p).all.rate_map_n(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
                            s_work(i).(char(roi_type(j))).session_ref(k).fields_center{size(s_work(i).(char(roi_type(j))).session_ref(k).fields_center,1)+1,1} = s_work(i).(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+1).all.fieldCenters(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work(i).(char(roi_type(j))).session_ref(k).roi_lg_active,1),1});
                            s_work(i).(char(roi_type(j))).session_ref(k).fields_center{size(s_work(i).(char(roi_type(j))).session_ref(k).fields_center,1),1} = cellfun(@(v)v(1),s_work(i).(char(roi_type(j))).session_ref(k).fields_center{size(s_work(i).(char(roi_type(j))).session_ref(k).fields_center,1),1});
                            [~,field_center_sorted_index_pair] = sort(s_work(i).(char(roi_type(j))).session_ref(k).fields_center{size(s_work(i).(char(roi_type(j))).session_ref(k).fields_center,1),1});
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1),1}(field_center_sorted_index_pair,:,1);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1),1}(field_center_sorted_index_pair,:,2);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,1);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,2);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n,1)+1,1}(:,:,1) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,1);
                            s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n,1),1}(:,:,2) = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,2);
                            tempSUBmap = s_work(i).(char(roi_type(j))).session_ref(k).rate_map{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,[1 2]);
                            tempSUBmap_z = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,[1 2]);
                            tempSUBmap_n = s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,[1 2]);
                            tempTCmap = permute(tempSUBmap,[2 3 1]);
                            tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
                            tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr,1)+1,1} = NaN(size(tempSUBmap,3),1);
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,3),1);
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,3),1);
                            for x=1:size(tempTCmap,3)
                                tempTC = corrcoef(tempTCmap(:,:,x));
                                tempTC_z = corrcoef(tempTCmap_z(:,:,x));
                                tempTC_n = corrcoef(tempTCmap_n(:,:,x));
                                s_work(i).(char(roi_type(j))).session_ref(k).TC_corr{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr,1),1}(x,1) = tempTC(1,2);
                                s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_z{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
                                s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_n{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
                            end
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map,1)+1,1} = NaN(size(tempSUBmap,1),size(tempSUBmap,1));
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,1),size(tempSUBmap_z,1));
                            s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,1),size(tempSUBmap_n,1));
                            for x=1:size(tempSUBmap,1)
                                for y=1:size(tempSUBmap,1)
                                    tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
                                    tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
                                    tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
                                    s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
                                    s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
                                end
                            end
                            tempPVmap = permute(tempSUBmap,[1 3 2]);
                            tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
                            tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr,1)+1,1} = NaN(size(tempSUBmap,2),1);
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,2),1);
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,2),1);
                            for x=1:size(tempPVmap,3)
                                tempPV = corrcoef(tempPVmap(:,:,x));
                                tempPV_z = corrcoef(tempPVmap_z(:,:,x));
                                tempPV_n = corrcoef(tempPVmap_n(:,:,x));
                                s_work(i).(char(roi_type(j))).session_ref(k).PV_corr{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr,1),1}(x,1) = tempPV(1,2);
                                s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_z{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
                                s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_n{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
                            end
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map,1)+1,1} = NaN(size(tempSUBmap,2),size(tempSUBmap,2));
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,2),size(tempSUBmap_z,2));
                            s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,2),size(tempSUBmap_n,2));
                            for x=1:size(tempSUBmap,2)
                                for y=1:size(tempSUBmap,2)
                                    tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
                                    tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
                                    tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
                                    s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
                                    s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
                                    s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n{size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    fprintf('\ndata processed!\n');
    fprintf('\nplotting results...\n');
    for i=1:size(s_work,2) %animals
        for j=1:size(roi_type,2) %roi type
            for k=1:size(s_work(i).(char(roi_type(j))).spatial,2) %sessions
                try
                    fig = figure('Position',[300 100 650 500]);
                    imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted,1)],s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted);
                    hold on
                    ylabel('ROI #');
                    xlabel('position (cm)');
                    title(strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                    subtitle(strcat(s_work(i).session_id(k)),'Interpreter','none');
                    c = colorbar;
                    c.Label.String = 'rate (events/bin)';
                    hold off
                    fig_name = strcat('fig_rate_map_',s_work(i).mouse_id,'_',roi_type(j),'_',s_work(i).session_id(k),'.pdf');
                    fig.PaperOrientation = 'landscape';
                    print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                    close(fig);
                end
                try
                    fig = figure('Position',[300 100 650 500]);
                    imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_z,1)],s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_z);
                    hold on
                    ylabel('ROI #');
                    xlabel('position (cm)');
                    title(strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                    subtitle(strcat(s_work(i).session_id(k)),'Interpreter','none');
                    c = colorbar;
                    c.Label.String = 'rate (z scored)';
                    hold off
                    fig_name = strcat('fig_rate_map_z_',s_work(i).mouse_id,'_',roi_type(j),'_',s_work(i).session_id(k),'.pdf');
                    fig.PaperOrientation = 'landscape';
                    print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                    close(fig);
                end
                try
                    fig = figure('Position',[300 100 650 500]);
                    imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_n,1)],s_work(i).(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_n);
                    hold on
                    ylabel('ROI #');
                    xlabel('position (cm)');
                    title(strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                    subtitle(strcat(s_work(i).session_id(k)),'Interpreter','none');
                    c = colorbar;
                    c.Label.String = 'rate (normalized)';
                    hold off
                    fig_name = strcat('fig_rate_map_n_',s_work(i).mouse_id,'_',roi_type(j),'_',s_work(i).session_id(k),'.pdf');
                    fig.PaperOrientation = 'landscape';
                    print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                    close(fig);
                end
            end
            try
                fig = figure('Position',[300 100 650 500]);
                hold on
                for k=1:size(s_work(i).(char(roi_type(j))).spatial,2)
                    s_work(i).(char(roi_type(j))).spatial(k).all.fraction_active = nnz(s_work(i).(char(roi_type(j))).spatial(k).all.nEvents)/size(s_work(i).(char(roi_type(j))).spatial(k).all.nEvents,1);
                    bar([k],s_work(i).(char(roi_type(j))).spatial(k).all.fraction_active);
                end
                ylabel('fraction of active ROIs');
                xticks([1:1:size(s_work(i).session_id,1)])
                set(gca,'TickLabelInterpreter','none')
                xticklabels(cellfun(@string,s_work(i).session_id));
                title(strcat(s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                axis([-inf inf 0 1]);
                hold off
                fig_name = strcat('fig_active_fraction_',s_work(i).mouse_id,'_',roi_type(j),'.pdf');
                fig.PaperOrientation = 'landscape';
                print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                close(fig);
            end
            try
                fig = figure('Position',[300 100 650 500]);
                hold on
                for k=1:size(s_work(i).(char(roi_type(j))).spatial,2)
                    s_work(i).(char(roi_type(j))).spatial(k).all.fraction_tuned = nnz(s_work(i).(char(roi_type(j))).spatial(k).all.significant(find(s_work(i).(char(roi_type(j))).spatial(k).all.nEvents)))/nnz(s_work(i).(char(roi_type(j))).spatial(k).all.nEvents);
                    bar([k],s_work(i).(char(roi_type(j))).spatial(k).all.fraction_tuned);
                end
                ylabel('fraction of tuned ROIs');
                xticks([1:1:size(s_work(i).session_id,1)])
                set(gca,'TickLabelInterpreter','none')
                xticklabels(cellfun(@string,s_work(i).session_id));
                title(strcat(s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                axis([-inf inf 0 1]);
                hold off
                fig_name = strcat('fig_tuned_fraction_',s_work(i).mouse_id,'_',roi_type(j),'.pdf');
                fig.PaperOrientation = 'landscape';
                print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                close(fig);
            end
            try
                fig = figure('Position',[300 100 650 500]);
                hold on
                for k=1:size(s_work(i).(char(roi_type(j))).spatial,2)
                    s_work(i).(char(roi_type(j))).spatial(k).all.fields_number = s_work(i).(char(roi_type(j))).spatial(k).all.nFields(find(s_work(i).(char(roi_type(j))).spatial(k).all.significant));
                    errorbar([k],mean(s_work(i).(char(roi_type(j))).spatial(k).all.fields_number,1,'omitnan'),std(s_work(i).(char(roi_type(j))).spatial(k).all.fields_number,0,1,'omitnan')/sqrt(size(s_work(i).(char(roi_type(j))).spatial(k).all.fields_number,1)),'_','LineWidth',1.5);
                end
                ylabel('number of fields');
                xticks([1:1:size(s_work(i).session_id,1)])
                set(gca,'TickLabelInterpreter','none')
                xticklabels(cellfun(@string,s_work(i).session_id));
                title(strcat(s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                axis([-inf inf 0 inf]);
                hold off
                fig_name = strcat('fig_fields_number_',s_work(i).mouse_id,'_',roi_type(j),'.pdf');
                fig.PaperOrientation = 'landscape';
                print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                close(fig);
            end
            try
                fig = figure('Position',[300 100 650 500]);
                hold on
                for k=1:size(s_work(i).(char(roi_type(j))).spatial,2)
                    s_work(i).(char(roi_type(j))).spatial(k).all.fields_width = s_work(i).(char(roi_type(j))).spatial(k).all.fieldWidth(find(s_work(i).(char(roi_type(j))).spatial(k).all.significant));
                    s_work(i).(char(roi_type(j))).spatial(k).all.fields_width = cellfun(@mean,s_work(i).(char(roi_type(j))).spatial(k).all.fields_width);
                    errorbar([k],mean(s_work(i).(char(roi_type(j))).spatial(k).all.fields_width,1,'omitnan'),std(s_work(i).(char(roi_type(j))).spatial(k).all.fields_width,0,1,'omitnan')/sqrt(size(s_work(i).(char(roi_type(j))).spatial(k).all.fields_width,1)),'_','LineWidth',1.5);
                end
                ylabel('field width (cm)');
                xticks([1:1:size(s_work(i).session_id,1)])
                set(gca,'TickLabelInterpreter','none')
                xticklabels(cellfun(@string,s_work(i).session_id));
                title(strcat(s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                axis([-inf inf 0 inf]);
                hold off
                fig_name = strcat('fig_field_width_',s_work(i).mouse_id,'_',roi_type(j),'.pdf');
                fig.PaperOrientation = 'landscape';
                print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                close(fig);
            end
            try
                fig = figure('Position',[300 100 650 500]);
                hold on
                for k=1:size(s_work(i).(char(roi_type(j))).spatial,2)
                    s_work(i).(char(roi_type(j))).spatial(k).all.spatial_information = s_work(i).(char(roi_type(j))).spatial(k).all.normalizedInfo(find(s_work(i).(char(roi_type(j))).spatial(k).all.significant));
                    errorbar([k],mean(s_work(i).(char(roi_type(j))).spatial(k).all.spatial_information,1,'omitnan'),std(s_work(i).(char(roi_type(j))).spatial(k).all.spatial_information,0,1,'omitnan')/sqrt(size(s_work(i).(char(roi_type(j))).spatial(k).all.spatial_information,1)),'_','LineWidth',1.5);
                end
                ylabel('normalized spatial information');
                xticks([1:1:size(s_work(i).session_id,1)])
                set(gca,'TickLabelInterpreter','none')
                xticklabels(cellfun(@string,s_work(i).session_id));
                title(strcat(s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                axis([-inf inf 0 inf]);
                hold off
                fig_name = strcat('fig_spatial_info_',s_work(i).mouse_id,'_',roi_type(j),'.pdf');
                fig.PaperOrientation = 'landscape';
                print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                close(fig);
            end
            for k=1:size(session_groups,2)
                if(session_groups(k)>1)
                    for x=1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted,1)
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'rate (events/bin)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'rate (z scored)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{x,1},1)],s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'rate (normalized)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_z{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_from_Zscored_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_z{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_from_Zscored_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr_map_n{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_from_normalized_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr_map_n{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_from_normalized_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                    end
                    try
                        fig = figure('Position',[300 100 650 500]);
                        hold on
                        for x=1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr,1)
                            plot(linspace(0,200,size(s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr{x,1},1)),s_work(i).(char(roi_type(j))).session_pairwise(k).PV_corr{x,1},'LineWidth',1.5);
                        end
                        title(label_groups(k));
                        if(contains(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'GOL') == 1)
                            subtitle('GOL');
                        else
                            subtitle('RF');
                        end
                        ylabel('PV correlation');
                        xlabel('position (cm)');
                        axis([-inf inf -1 1]);
                        legend(cellfun(@string,s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id),'Interpreter','none','Location','southeast');
                        yline(0,'--');
                        hold off
                        fig_name = strcat('fig_PV_corr_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                        fig.PaperOrientation = 'landscape';
                        print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                        close(fig);
                    end
                    try
                        fig = figure('Position',[300 100 650 500]);
                        hold on
                        for x=1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr,1)
                            errorbar([x],mean(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr{x,1},1,'omitnan'),std(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr{x,1},0,1,'omitnan')/sqrt(size(s_work(i).(char(roi_type(j))).session_pairwise(k).TC_corr{x,1},1)),'_','LineWidth',1.5);
                        end
                        title(label_groups(k));
                        if(contains(string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'GOL') == 1)
                            subtitle('GOL');
                        else
                            subtitle('RF');
                        end
                        ylabel('TC correlation');
                        xticks([1:1:size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1)])
                        set(gca,'TickLabelInterpreter','none')
                        xticklabels(cellfun(@string,s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id));
                        axis([0 size(s_work(i).(char(roi_type(j))).session_pairwise(k).rate_map,1)+1 -1 1]);
                        yline(0,'--');
                        hold off
                        fig_name = strcat('fig_TC_corr_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_pairwise(k).comp_id{x,1}),'.pdf');
                        fig.PaperOrientation = 'landscape';
                        print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                        close(fig);
                    end
                    for x=1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted,1)
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_ref_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none')
                            c = colorbar;
                            c.Label.String = 'rate (events/bin)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_ref_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_z{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_ref_z_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none')  
                            c = colorbar;
                            c.Label.String = 'rate (z scored)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_ref_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[100 100 1050 500]);
                            til = tiledlayout(1,2);
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{x,1}(:,:,1));
                            nexttile;
                            imagesc([0:5:200],[1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{x,1},1)],s_work(i).(char(roi_type(j))).session_ref(k).rate_map_sorted_n{x,1}(:,:,2));
                            til.TileSpacing = 'compact';
                            til.Padding = 'compact';
                            ylabel(til,'ROI #');
                            xlabel(til,'position (cm)');
                            title(til,strcat('rate_map_ref_n_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(til,strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none')  
                            c = colorbar;
                            c.Label.String = 'rate (normalized)';
                            c.Layout.Tile = 'east';
                            fig_name = strcat('fig_rate_map_ref_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        %%%
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map{x,1},1),size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map{x,1},1),s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_ref_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_ref_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z{x,1},1),size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z{x,1},1),s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_z{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_from_Zscored_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_ref_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_z{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_from_Zscored_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_ref_z_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc(size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n{x,1},1),size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n{x,1},1),s_work(i).(char(roi_type(j))).session_ref(k).TC_corr_map_n{x,1});
                            hold on
                            ylabel('ROI #');
                            xlabel('ROI #');
                            title(strcat('TC_correlation_from_normalized_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_TC_corr_map_ref_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                        try
                            fig = figure('Position',[300 100 650 500]);
                            imagesc([0:5:200],[0:5:200],s_work(i).(char(roi_type(j))).session_ref(k).PV_corr_map_n{x,1});
                            hold on
                            ylabel('position (cm)');
                            xlabel('position (cm)');
                            title(strcat('PV_correlation_from_normalized_maps_',s_work(i).mouse_id,'_',roi_type(j)),'Interpreter','none');
                            subtitle(strcat(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1})),'Interpreter','none');
                            c = colorbar;
                            c.Label.String = 'pearson coefficient';
                            hold off
                            fig_name = strcat('fig_PV_corr_map_ref_n_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                            fig.PaperOrientation = 'landscape';
                            print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                            close(fig);
                        end
                    end
                    try
                        fig = figure('Position',[300 100 650 500]);
                        hold on
                        for x=1:size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr,1)
                            plot(linspace(0,200,size(s_work(i).(char(roi_type(j))).session_ref(k).PV_corr{x,1},1)),s_work(i).(char(roi_type(j))).session_ref(k).PV_corr{x,1},'LineWidth',1.5);
                        end
                        title(label_groups(k));
                        if(contains(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'GOL') == 1)
                            subtitle('GOL_ref','Interpreter','none');
                        else
                            subtitle('RF_ref','Interpreter','none');
                        end
                        ylabel('PV correlation');
                        xlabel('position (cm)');
                        axis([-inf inf -1 1]);
                        legend(cellfun(@string,s_work(i).(char(roi_type(j))).session_ref(k).comp_id),'Interpreter','none','Location','southeast');
                        yline(0,'--');
                        hold off
                        fig_name = strcat('fig_PV_corr_ref_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                        fig.PaperOrientation = 'landscape';
                        print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                        close(fig);
                    end
                    try
                        fig = figure('Position',[300 100 650 500]);
                        hold on
                        for x=1:size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr,1)
                            errorbar([x],mean(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr{x,1},1,'omitnan'),std(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr{x,1},0,1,'omitnan')/sqrt(size(s_work(i).(char(roi_type(j))).session_ref(k).TC_corr{x,1},1)),'_','LineWidth',1.5);
                        end
                        title(label_groups(k));
                        if(contains(string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'GOL') == 1)
                            subtitle('GOL_ref','Interpreter','none');
                        else
                            subtitle('RF_ref','Interpreter','none');
                        end
                        ylabel('TC correlation');
                        xticks([1:1:size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1)])
                        set(gca,'TickLabelInterpreter','none')
                        xticklabels(cellfun(@string,s_work(i).(char(roi_type(j))).session_ref(k).comp_id));
                        axis([0 size(s_work(i).(char(roi_type(j))).session_ref(k).rate_map,1)+1 -1 1]);
                        yline(0,'--');
                        hold off
                        fig_name = strcat('fig_TC_corr_ref_',s_work(i).mouse_id,'_',roi_type(j),'_',string(s_work(i).(char(roi_type(j))).session_ref(k).comp_id{x,1}),'.pdf');
                        fig.PaperOrientation = 'landscape';
                        print(fullfile(root_path,fig_name),'-dpdf','-r300','-bestfit');
                        close(fig);
                    end
                end
            end
        end
    end
    s_spatial = s_work;
    fprintf('\nresults plotted!\n');
    fprintf('\nsaving output...\n');
    %assignin('base','s_work',s_work);
    save(fullfile(root_path,strrep(mat_file,'.mat','_spatial.mat')),'s_spatial','-v7.3');
    fprintf('\noutput saved!\n');
    fprintf('\nspatial coding analyzed!!!\n');
end