function [] = analyze_behavior(behav_file)
    RZ_A = [85,105];
    RZ_Aa = [145,165];
    RZ_B = [25,45];
    %ignore_session_id = ["_fam1_","_fam2_","_nov_"];
    %ignore_session_instances = 4;
    s_work = load(behav_file);
	try
		s_work = s_work.struct_behavior_pool_reduced;
    end
    try
		s_work = s_work.s_work;
	end
    mice_list = string;
    mice = fieldnames(s_work);
    for i=1:size(mice,1)
        mice_list(end+1) = mice{i};
    end
    mice_list = unique(mice_list);
    mice_list = mice_list(2:end);
    mice_list = mice_list';
    sessions_list = string;
    mice = fieldnames(s_work);
    for i=1:size(mice,1)
        sessions = fieldnames(s_work.(mice{i}));
        for j=1:size(sessions,1)
            sessions_list(end+1) = sessions{j};
        end
    end
    sessions_list = unique(sessions_list);
    sessions_list = sessions_list(2:end);
    sessions_list = sessions_list';
    series_list = string;
    mice = fieldnames(s_work);
    for i=1:size(mice,1)
        sessions = fieldnames(s_work.(mice{i}));
        for j=1:size(sessions,1)
            series = fieldnames(s_work.(mice{i}).(sessions{j}));
            for k=1:size(series,1)
                series_list(end+1) = series{k};
            end
        end
    end
	series_list = series_list';
%check typos before proceeding
	series_list = series_list';
    series_list = strrep(series_list,'_t_000','_t');
    series_list = strrep(series_list,'_t_001','_t');
    series_list = strrep(series_list,'_t_002','_t');
    series_list = strrep(series_list,'_v_000','_t');
    series_list = strrep(series_list,'_v_001','_t');
    series_list = strrep(series_list,'_v_002','_t');
    for i=1:size(mice,1)
        series_list = strrep(series_list,strcat('_',mice{i},'_'),'_');
    end
    series_list = unique(series_list);
    series_list = series_list(2:end);
    series_list = series_list';
    series_list_date = extract(series_list,digitsPattern(6));
    series_list_type = split(series_list,digitsPattern(6));
    series_list_type = series_list_type(:,2);
    series_list_type_v = replace(series_list_type,'_t','_v');
    %series_list(find(contains(series_list,ignore_session_id),ignore_session_instances*size(ignore_session_id,2))) = 'ignored';
    fraction_correct_licks_A1 = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_licks_Aa = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_licks_A2 = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_licks_B = NaN(size(series_list_date,1),size(mice,1));
	spatial_distrib_licks = NaN(50,size(series_list_date,1),size(mice,1));
	spatial_distrib_speed = NaN(50,size(series_list_date,1),size(mice,1));
	spatial_distrib_time = NaN(50,size(series_list_date,1),size(mice,1));
    for s=1:size(series_list_date,1)
        for i=1:size(mice,1)
            sessions = fieldnames(s_work.(mice{i}));
            for j=1:size(sessions,1)
                series = fieldnames(s_work.(mice{i}).(sessions{j}));
                for k=1:size(series,1)
                    if (contains(series{k},series_list_date(s)) && contains(series{k},series_list_type(s))) || (contains(series{k},series_list_date(s)) && contains(series{k},series_list_type_v(s)))
                        licks_RZ_A = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_A(1)/4):ceil(RZ_A(2)/4),:),"omitnan")';
                        licks_nonRZ_A = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_A(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_A(2)/4):end,:),"omitnan")';
                        licks_RZ_Aa = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_Aa(1)/4):ceil(RZ_Aa(2)/4),:),"omitnan")';
                        licks_nonRZ_Aa = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_Aa(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_Aa(2)/4):end,:),"omitnan")';
                        licks_RZ_B = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_B(1)/4):ceil(RZ_B(2)/4),:),"omitnan")';
                        licks_nonRZ_B = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_B(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_B(2)/4):end,:),"omitnan")';
                        licks_total = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4,1,"omitnan")';
                        fraction_correct_licks_A1(s,i) = mean(licks_RZ_A./licks_total,"omitnan");
                        fraction_correct_licks_Aa(s,i) = mean(licks_RZ_Aa./licks_total,"omitnan");
                        fraction_correct_licks_A2(s,i) = mean(licks_RZ_A./licks_total,"omitnan");
                        fraction_correct_licks_B(s,i) = mean(licks_RZ_B./licks_total,"omitnan");
						spatial_distrib_licks(:,s,i) = s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4_avg;
						spatial_distrib_speed(:,s,i) = s_work.(mice{i}).(sessions{j}).(series{k}).m_speed_bin_4_avg;
						spatial_distrib_time(:,s,i) = s_work.(mice{i}).(sessions{j}).(series{k}).m_time_bin_4_avg;
                    end
                end
            end
        end
    end
    % fraction_correct_licks_RF = fraction_correct_licks_A1(find(~contains(series_list,'_fam1_') & ~contains(series_list,'_int_') & ~contains(series_list,'_fam2_') & ~contains(series_list,'_nov_') & ~contains(series_list,'_A_')) & ~contains(series_list,'_Aa_') & ~contains(series_list,'_A2_') & ~contains(series_list,'_B_'),:);
    fraction_correct_licks_RF = fraction_correct_licks_A1(find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:);
    fraction_correct_licks_RF = cat(1,fraction_correct_licks_RF,fraction_correct_licks_Aa(find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:));
    fraction_correct_licks_RF = cat(1,fraction_correct_licks_RF,fraction_correct_licks_A2(find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:));
    fraction_correct_licks_RF = cat(1,fraction_correct_licks_RF,fraction_correct_licks_B(find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:));
    fraction_correct_licks_chance = mean(fraction_correct_licks_RF,1,"omitnan");
    fraction_correct_licks_GOL1_A1 = fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:);
    fraction_correct_licks_GOL1_Aa = fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:);
    fraction_correct_licks_GOL1_A2 = fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:);
    fraction_correct_licks_GOL1_B = fraction_correct_licks_B(find(contains(series_list,'_nov_')),:);
    fraction_correct_licks_GOL2_C1 = fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:);	
    fraction_correct_licks_GOL2_Cc = fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:);
    fraction_correct_licks_GOL2_C2 = fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:);
    fraction_correct_licks_GOL2_D = fraction_correct_licks_B(find(contains(series_list,'_B_')),:);
    fraction_correct_licks_GOL3_E1 = fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:);
    fraction_correct_licks_GOL3_Ee = fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:);
    fraction_correct_licks_GOL3_E2 = fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:);
    fraction_correct_licks_GOL3_F = fraction_correct_licks_B(find(contains(series_list,'_D_')),:);
	series_list_RF = series_list(find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])));
	spatial_distrib_licks_RF = spatial_distrib_licks(:,find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:);
	spatial_distrib_speed_RF = spatial_distrib_licks(:,find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:);
	spatial_distrib_time_RF = spatial_distrib_licks(:,find(~contains(series_list,["_fam1_","_int_","_fam2_","_nov_","_A1_","_A_","_Aa_","_A2_","_B_","_C1_","_C_","_Cc_","_C2_","_D_","ignored"])),:);
	series_list_GOL1_A1 = series_list(find(contains(series_list,'_fam1_')));
    series_list_GOL1_Aa = series_list(find(contains(series_list,'_int_')));
    series_list_GOL1_A2 = series_list(find(contains(series_list,'_fam2_')));
    series_list_GOL1_B = series_list(find(contains(series_list,'_nov_')));
    series_list_GOL2_C1 = series_list(find(contains(series_list,["_A1_","_A_"])));
    series_list_GOL2_Cc = series_list(find(contains(series_list,'_Aa_')));
    series_list_GOL2_C2 = series_list(find(contains(series_list,'_A2_')));
    series_list_GOL2_D = series_list(find(contains(series_list,'_B_')));
    series_list_GOL3_E1 = series_list(find(contains(series_list,["_C1_","_C_"])));
    series_list_GOL3_Ee = series_list(find(contains(series_list,'_Cc_')));
    series_list_GOL3_E2 = series_list(find(contains(series_list,'_C2_')));
    series_list_GOL3_F = series_list(find(contains(series_list,'_D_')));
	spatial_distrib_licks_GOL1_A1 = spatial_distrib_licks(:,find(contains(series_list,'_fam1_')),:);
    spatial_distrib_licks_GOL1_Aa = spatial_distrib_licks(:,find(contains(series_list,'_int_')),:);
    spatial_distrib_licks_GOL1_A2 = spatial_distrib_licks(:,find(contains(series_list,'_fam2_')),:);
    spatial_distrib_licks_GOL1_B = spatial_distrib_licks(:,find(contains(series_list,'_nov_')),:);
    spatial_distrib_licks_GOL2_C1 = spatial_distrib_licks(:,find(contains(series_list,["_A1_","_A_"])),:);
    spatial_distrib_licks_GOL2_Cc = spatial_distrib_licks(:,find(contains(series_list,'_Aa_')),:);
    spatial_distrib_licks_GOL2_C2 = spatial_distrib_licks(:,find(contains(series_list,'_A2_')),:);
    spatial_distrib_licks_GOL2_D = spatial_distrib_licks(:,find(contains(series_list,'_B_')),:);
    spatial_distrib_licks_GOL3_E1 = spatial_distrib_licks(:,find(contains(series_list,["_C1_","_C_"])),:);
    spatial_distrib_licks_GOL3_Ee = spatial_distrib_licks(:,find(contains(series_list,'_Cc_')),:);
    spatial_distrib_licks_GOL3_E2 = spatial_distrib_licks(:,find(contains(series_list,'_C2_')),:);
    spatial_distrib_licks_GOL3_F = spatial_distrib_licks(:,find(contains(series_list,'_D_')),:);
	spatial_distrib_speed_GOL1_A1 = spatial_distrib_speed(:,find(contains(series_list,'_fam1_')),:);
    spatial_distrib_speed_GOL1_Aa = spatial_distrib_speed(:,find(contains(series_list,'_int_')),:);
    spatial_distrib_speed_GOL1_A2 = spatial_distrib_speed(:,find(contains(series_list,'_fam2_')),:);
    spatial_distrib_speed_GOL1_B = spatial_distrib_speed(:,find(contains(series_list,'_nov_')),:);
    spatial_distrib_speed_GOL2_C1 = spatial_distrib_speed(:,find(contains(series_list,["_A1_","_A_"])),:);
    spatial_distrib_speed_GOL2_Cc = spatial_distrib_speed(:,find(contains(series_list,'_Aa_')),:);
    spatial_distrib_speed_GOL2_C2 = spatial_distrib_speed(:,find(contains(series_list,'_A2_')),:);
    spatial_distrib_speed_GOL2_D = spatial_distrib_speed(:,find(contains(series_list,'_B_')),:);
    spatial_distrib_speed_GOL3_E1 = spatial_distrib_speed(:,find(contains(series_list,["_C1_","_C_"])),:);
    spatial_distrib_speed_GOL3_Ee = spatial_distrib_speed(:,find(contains(series_list,'_Cc_')),:);
    spatial_distrib_speed_GOL3_E2 = spatial_distrib_speed(:,find(contains(series_list,'_C2_')),:);
    spatial_distrib_speed_GOL3_F = spatial_distrib_speed(:,find(contains(series_list,'_D_')),:);
	spatial_distrib_time_GOL1_A1 = spatial_distrib_time(:,find(contains(series_list,'_fam1_')),:);
    spatial_distrib_time_GOL1_Aa = spatial_distrib_time(:,find(contains(series_list,'_int_')),:);
    spatial_distrib_time_GOL1_A2 = spatial_distrib_time(:,find(contains(series_list,'_fam2_')),:);
    spatial_distrib_time_GOL1_B = spatial_distrib_time(:,find(contains(series_list,'_nov_')),:);
    spatial_distrib_time_GOL2_C1 = spatial_distrib_time(:,find(contains(series_list,["_A1_","_A_"])),:);
    spatial_distrib_time_GOL2_Cc = spatial_distrib_time(:,find(contains(series_list,'_Aa_')),:);
    spatial_distrib_time_GOL2_C2 = spatial_distrib_time(:,find(contains(series_list,'_A2_')),:);
    spatial_distrib_time_GOL2_D = spatial_distrib_time(:,find(contains(series_list,'_B_')),:);
    spatial_distrib_time_GOL3_E1 = spatial_distrib_time(:,find(contains(series_list,["_C1_","_C_"])),:);
    spatial_distrib_time_GOL3_Ee = spatial_distrib_time(:,find(contains(series_list,'_Cc_')),:);
    spatial_distrib_time_GOL3_E2 = spatial_distrib_time(:,find(contains(series_list,'_C2_')),:);
    spatial_distrib_time_GOL3_F = spatial_distrib_time(:,find(contains(series_list,'_D_')),:);
	s_distrib = struct;
	s_distrib.spatial_distrib_licks_RF = spatial_distrib_licks_RF;
	s_distrib.spatial_distrib_speed_RF = spatial_distrib_speed_RF;
	s_distrib.spatial_distrib_time_RF = spatial_distrib_time_RF;
	s_distrib.spatial_distrib_licks_GOL1_A1 = spatial_distrib_licks_GOL1_A1;
    s_distrib.spatial_distrib_licks_GOL1_Aa = spatial_distrib_licks_GOL1_Aa;
    s_distrib.spatial_distrib_licks_GOL1_A2 = spatial_distrib_licks_GOL1_A2;
    s_distrib.spatial_distrib_licks_GOL1_B = spatial_distrib_licks_GOL1_B;
    s_distrib.spatial_distrib_licks_GOL2_C1 = spatial_distrib_licks_GOL2_C1;
    s_distrib.spatial_distrib_licks_GOL2_Cc = spatial_distrib_licks_GOL2_Cc;
    s_distrib.spatial_distrib_licks_GOL2_C2 = spatial_distrib_licks_GOL2_C2;
    s_distrib.spatial_distrib_licks_GOL2_D = spatial_distrib_licks_GOL2_D;
    s_distrib.spatial_distrib_licks_GOL3_E1 = spatial_distrib_licks_GOL3_E1;
    s_distrib.spatial_distrib_licks_GOL3_Ee = spatial_distrib_licks_GOL3_Ee;
    s_distrib.spatial_distrib_licks_GOL3_E2 = spatial_distrib_licks_GOL3_E2;
    s_distrib.spatial_distrib_licks_GOL3_F = spatial_distrib_licks_GOL3_F;
	s_distrib.spatial_distrib_speed_GOL1_A1 = spatial_distrib_speed_GOL1_A1;
    s_distrib.spatial_distrib_speed_GOL1_Aa = spatial_distrib_speed_GOL1_Aa;
    s_distrib.spatial_distrib_speed_GOL1_A2 = spatial_distrib_speed_GOL1_A2;
    s_distrib.spatial_distrib_speed_GOL1_B = spatial_distrib_speed_GOL1_B;
    s_distrib.spatial_distrib_speed_GOL2_C1 = spatial_distrib_speed_GOL2_C1;
    s_distrib.spatial_distrib_speed_GOL2_Cc = spatial_distrib_speed_GOL2_Cc;
    s_distrib.spatial_distrib_speed_GOL2_C2 = spatial_distrib_speed_GOL2_C2;
    s_distrib.spatial_distrib_speed_GOL2_D = spatial_distrib_speed_GOL2_D;
    s_distrib.spatial_distrib_speed_GOL3_E1 = spatial_distrib_speed_GOL3_E1;
    s_distrib.spatial_distrib_speed_GOL3_Ee = spatial_distrib_speed_GOL3_Ee;
    s_distrib.spatial_distrib_speed_GOL3_E2 = spatial_distrib_speed_GOL3_E2;
    s_distrib.spatial_distrib_speed_GOL3_F = spatial_distrib_speed_GOL3_F;
	s_distrib.spatial_distrib_time_GOL1_A1 = spatial_distrib_time_GOL1_A1;
    s_distrib.spatial_distrib_time_GOL1_Aa = spatial_distrib_time_GOL1_Aa;
    s_distrib.spatial_distrib_time_GOL1_A2 = spatial_distrib_time_GOL1_A2;
    s_distrib.spatial_distrib_time_GOL1_B = spatial_distrib_time_GOL1_B;
    s_distrib.spatial_distrib_time_GOL2_C1 = spatial_distrib_time_GOL2_C1;
    s_distrib.spatial_distrib_time_GOL2_Cc = spatial_distrib_time_GOL2_Cc;
    s_distrib.spatial_distrib_time_GOL2_C2 = spatial_distrib_time_GOL2_C2;
    s_distrib.spatial_distrib_time_GOL2_D = spatial_distrib_time_GOL2_D;
    s_distrib.spatial_distrib_time_GOL3_E1 = spatial_distrib_time_GOL3_E1;
    s_distrib.spatial_distrib_time_GOL3_Ee = spatial_distrib_time_GOL3_Ee;
    s_distrib.spatial_distrib_time_GOL3_E2 = spatial_distrib_time_GOL3_E2;
    s_distrib.spatial_distrib_time_GOL3_F = spatial_distrib_time_GOL3_F;
	s_distrib.series_list_RF = series_list_RF;
	s_distrib.series_list_GOL1_A1 = series_list_GOL1_A1;
    s_distrib.series_list_GOL1_Aa = series_list_GOL1_Aa;
    s_distrib.series_list_GOL1_A2 = series_list_GOL1_A2;
    s_distrib.series_list_GOL1_B = series_list_GOL1_B;
    s_distrib.series_list_GOL2_C1 = series_list_GOL2_C1;
    s_distrib.series_list_GOL2_Cc = series_list_GOL2_Cc;
    s_distrib.series_list_GOL2_C2 = series_list_GOL2_C2;
    s_distrib.series_list_GOL2_D = series_list_GOL2_D;
    s_distrib.series_list_GOL3_E1 = series_list_GOL3_E1;
    s_distrib.series_list_GOL3_Ee = series_list_GOL3_Ee;
    s_distrib.series_list_GOL3_E2 = series_list_GOL3_E2;
    s_distrib.series_list_GOL3_F = series_list_GOL3_F;
	save(strrep(behav_file,'.mat','_distrib.mat'),'s_distrib','-v7.3');
    discrimination_index_GOL1_A1_vs_Aa = (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_fam1_')),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_fam1_')),:));
    discrimination_index_GOL1_A1_vs_A2 = (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_fam1_')),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_fam1_')),:));
    discrimination_index_GOL1_A1_vs_B = (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) - fraction_correct_licks_B(find(contains(series_list,'_fam1_')),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,'_fam1_')),:) + fraction_correct_licks_B(find(contains(series_list,'_fam1_')),:));
    discrimination_index_GOL1_Aa_vs_A1 = (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_int_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_int_')),:));
    discrimination_index_GOL1_Aa_vs_A2 = (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_int_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_int_')),:));
    discrimination_index_GOL1_Aa_vs_B = (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) - fraction_correct_licks_B(find(contains(series_list,'_int_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_int_')),:) + fraction_correct_licks_B(find(contains(series_list,'_int_')),:));
    discrimination_index_GOL1_A2_vs_A1 = (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_fam2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_A2_vs_Aa = (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_fam2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_A2_vs_B = (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) - fraction_correct_licks_B(find(contains(series_list,'_fam2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:) + fraction_correct_licks_B(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_B_vs_A1 = (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_nov_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_B_vs_Aa = (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_nov_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_B_vs_A2 = (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_nov_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_nov_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_fam2_')),:));
    discrimination_index_GOL1_C1_vs_Cc = (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) - fraction_correct_licks_Aa(find(contains(series_list,["_A1_","_A_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) + fraction_correct_licks_Aa(find(contains(series_list,["_A1_","_A_"])),:));
    discrimination_index_GOL1_C1_vs_C2 = (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) - fraction_correct_licks_A2(find(contains(series_list,["_A1_","_A_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) + fraction_correct_licks_A2(find(contains(series_list,["_A1_","_A_"])),:));
    discrimination_index_GOL1_C1_vs_D = (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) - fraction_correct_licks_B(find(contains(series_list,["_A1_","_A_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_A1_","_A_"])),:) + fraction_correct_licks_B(find(contains(series_list,["_A1_","_A_"])),:));
    discrimination_index_GOL1_Cc_vs_C1 = (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_Aa_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_Aa_')),:));
    discrimination_index_GOL1_Cc_vs_C2 = (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_Aa_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_Aa_')),:));
    discrimination_index_GOL1_Cc_vs_D = (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) - fraction_correct_licks_B(find(contains(series_list,'_Aa_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Aa_')),:) + fraction_correct_licks_B(find(contains(series_list,'_Aa_')),:));
    discrimination_index_GOL1_C2_vs_C1 = (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_A2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_C2_vs_Cc = (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_A2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_C2_vs_D = (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) - fraction_correct_licks_B(find(contains(series_list,'_A2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:) + fraction_correct_licks_B(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_D_vs_C1 = (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_B_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_D_vs_Cc = (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_B_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_D_vs_C2 = (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_B_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_B_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_A2_')),:));
    discrimination_index_GOL1_E1_vs_Ee = (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) - fraction_correct_licks_Aa(find(contains(series_list,["_C1_","_C_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) + fraction_correct_licks_Aa(find(contains(series_list,["_C1_","_C_"])),:));
    discrimination_index_GOL1_E1_vs_E2 = (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) - fraction_correct_licks_A2(find(contains(series_list,["_C1_","_C_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) + fraction_correct_licks_A2(find(contains(series_list,["_C1_","_C_"])),:));
    discrimination_index_GOL1_E1_vs_F = (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) - fraction_correct_licks_B(find(contains(series_list,["_C1_","_C_"])),:)) ./ (fraction_correct_licks_A1(find(contains(series_list,["_C1_","_C_"])),:) + fraction_correct_licks_B(find(contains(series_list,["_C1_","_C_"])),:));
    discrimination_index_GOL1_Ee_vs_E1 = (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_Cc_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_Cc_')),:));
    discrimination_index_GOL1_Ee_vs_E2 = (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_Cc_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_Cc_')),:));
    discrimination_index_GOL1_Ee_vs_F = (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) - fraction_correct_licks_B(find(contains(series_list,'_Cc_')),:)) ./ (fraction_correct_licks_Aa(find(contains(series_list,'_Cc_')),:) + fraction_correct_licks_B(find(contains(series_list,'_Cc_')),:));
    discrimination_index_GOL1_E2_vs_E1 = (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_C2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_C2_')),:));
    discrimination_index_GOL1_E2_vs_Ee = (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_C2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_C2_')),:));
    discrimination_index_GOL1_E2_vs_F = (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) - fraction_correct_licks_B(find(contains(series_list,'_C2_')),:)) ./ (fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:) + fraction_correct_licks_B(find(contains(series_list,'_C2_')),:));
    discrimination_index_GOL1_F_vs_E1 = (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) - fraction_correct_licks_A1(find(contains(series_list,'_D_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) + fraction_correct_licks_A1(find(contains(series_list,'_C2_')),:));
    discrimination_index_GOL1_F_vs_Ee = (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) - fraction_correct_licks_Aa(find(contains(series_list,'_D_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) + fraction_correct_licks_Aa(find(contains(series_list,'_C2_')),:));
    discrimination_index_GOL1_F_vs_E2 = (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) - fraction_correct_licks_A2(find(contains(series_list,'_D_')),:)) ./ (fraction_correct_licks_B(find(contains(series_list,'_D_')),:) + fraction_correct_licks_A2(find(contains(series_list,'_C2_')),:));
    fraction_correct_trials_A1 = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_trials_Aa = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_trials_A2 = NaN(size(series_list_date,1),size(mice,1));
    fraction_correct_trials_B = NaN(size(series_list_date,1),size(mice,1));
    for s=1:size(series_list_date,1)
        for i=1:size(mice,1)
            sessions = fieldnames(s_work.(mice{i}));
            for j=1:size(sessions,1)
                series = fieldnames(s_work.(mice{i}).(sessions{j}));
                for k=1:size(series,1)
                    if contains(series{k},series_list_date(s)) && contains(series{k},series_list_type(s))
                        licks_RZ_A = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_A(1)/4):ceil(RZ_A(2)/4),:),"omitnan")';
                        licks_nonRZ_A = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_A(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_A(2)/4):end,:),"omitnan")';
                        licks_RZ_Aa = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_Aa(1)/4):ceil(RZ_Aa(2)/4),:),"omitnan")';
                        licks_nonRZ_Aa = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_Aa(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_Aa(2)/4):end,:),"omitnan")';
                        licks_RZ_B = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(floor(RZ_B(1)/4):ceil(RZ_B(2)/4),:),"omitnan")';
                        licks_nonRZ_B = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(1:floor(RZ_B(1)/4),:),"omitnan")'+sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4(ceil(RZ_B(2)/4):end,:),"omitnan")';
                        licks_total = sum(s_work.(mice{i}).(sessions{j}).(series{k}).m_lick_bin_4,1,"omitnan")';
                        fraction_correct_trials_A1(s,i) = size(find(licks_RZ_A./licks_total>(1-fraction_correct_licks_chance(i))),1)/size(licks_total,1);
                        fraction_correct_trials_Aa(s,i) = size(find(licks_RZ_Aa./licks_total>(1-fraction_correct_licks_chance(i))),1)/size(licks_total,1);
                        fraction_correct_trials_A2(s,i) = size(find(licks_RZ_A./licks_total>(1-fraction_correct_licks_chance(i))),1)/size(licks_total,1);
                        fraction_correct_trials_B(s,i) = size(find(licks_RZ_B./licks_total>(1-fraction_correct_licks_chance(i))),1)/size(licks_total,1);
                    end
                end
            end
        end
    end
    fraction_correct_trials_GOL1_A1 = fraction_correct_trials_A1(find(contains(series_list,'_fam1_')),:);
    fraction_correct_trials_GOL1_Aa = fraction_correct_trials_Aa(find(contains(series_list,'_int_')),:);
    fraction_correct_trials_GOL1_A2 = fraction_correct_trials_A2(find(contains(series_list,'_fam2_')),:);
    fraction_correct_trials_GOL1_B = fraction_correct_trials_B(find(contains(series_list,'_nov_')),:);
    fraction_correct_trials_GOL2_C1 = fraction_correct_trials_A1(find(contains(series_list,["_A1_","_A_"])),:);
    fraction_correct_trials_GOL2_Cc = fraction_correct_trials_Aa(find(contains(series_list,'_Aa_')),:);
    fraction_correct_trials_GOL2_C2 = fraction_correct_trials_A2(find(contains(series_list,'_A2_')),:);
    fraction_correct_trials_GOL2_D = fraction_correct_trials_B(find(contains(series_list,'_B_')),:);
    fraction_correct_trials_GOL3_E1 = fraction_correct_trials_A1(find(contains(series_list,["_C1_","_C_"])),:);
    fraction_correct_trials_GOL3_Ee = fraction_correct_trials_Aa(find(contains(series_list,'_Cc_')),:);
    fraction_correct_trials_GOL3_E2 = fraction_correct_trials_A2(find(contains(series_list,'_C2_')),:);
    fraction_correct_trials_GOL3_F = fraction_correct_trials_B(find(contains(series_list,'_D_')),:);
    fraction_correct_licks_GOL1 = mean(cat(3,fraction_correct_licks_GOL1_A1,fraction_correct_licks_GOL1_Aa,fraction_correct_licks_GOL1_A2,fraction_correct_licks_GOL1_B),3,"omitnan");
    fraction_correct_licks_GOL2 = mean(cat(3,fraction_correct_licks_GOL2_C1,fraction_correct_licks_GOL2_Cc,fraction_correct_licks_GOL2_C2,fraction_correct_licks_GOL2_D),3,"omitnan");
    fraction_correct_licks_GOL3 = mean(cat(3,fraction_correct_licks_GOL3_E1,fraction_correct_licks_GOL3_Ee,fraction_correct_licks_GOL3_E2,fraction_correct_licks_GOL3_F),3,"omitnan");
    fraction_correct_trials_GOL1 = mean(cat(3,fraction_correct_trials_GOL1_A1,fraction_correct_trials_GOL1_Aa,fraction_correct_trials_GOL1_A2,fraction_correct_trials_GOL1_B),3,"omitnan");
    fraction_correct_trials_GOL2 = mean(cat(3,fraction_correct_trials_GOL2_C1,fraction_correct_trials_GOL2_Cc,fraction_correct_trials_GOL2_C2,fraction_correct_trials_GOL2_D),3,"omitnan");
    fraction_correct_trials_GOL3 = mean(cat(3,fraction_correct_trials_GOL3_E1,fraction_correct_trials_GOL3_Ee,fraction_correct_trials_GOL3_E2,fraction_correct_trials_GOL3_F),3,"omitnan");
    fraction_correct_licks_GOL1_avg = mean(fraction_correct_licks_GOL1,2,"omitnan");
    fraction_correct_licks_GOL1_sem = std(fraction_correct_licks_GOL1,1,2,"omitnan")/sqrt(size(fraction_correct_licks_GOL1(:,all(~isnan(fraction_correct_licks_GOL1))),2));
    fraction_correct_licks_GOL2_avg = mean(fraction_correct_licks_GOL2,2,"omitnan");
    fraction_correct_licks_GOL2_sem = std(fraction_correct_licks_GOL2,1,2,"omitnan")/sqrt(size(fraction_correct_licks_GOL2(:,all(~isnan(fraction_correct_licks_GOL2))),2));
    fraction_correct_licks_GOL3_avg = mean(fraction_correct_licks_GOL3,2,"omitnan");
    fraction_correct_licks_GOL3_sem = std(fraction_correct_licks_GOL3,1,2,"omitnan")/sqrt(size(fraction_correct_licks_GOL3(:,all(~isnan(fraction_correct_licks_GOL3))),2));
    fraction_correct_trials_GOL1_avg = mean(fraction_correct_trials_GOL1,2,"omitnan");
    fraction_correct_trials_GOL1_sem = std(fraction_correct_trials_GOL1,1,2,"omitnan")/sqrt(size(fraction_correct_trials_GOL1(:,all(~isnan(fraction_correct_trials_GOL1))),2));
    fraction_correct_trials_GOL2_avg = mean(fraction_correct_trials_GOL2,2,"omitnan");
    fraction_correct_trials_GOL2_sem = std(fraction_correct_trials_GOL2,1,2,"omitnan")/sqrt(size(fraction_correct_trials_GOL2(:,all(~isnan(fraction_correct_trials_GOL2))),2));
    fraction_correct_trials_GOL3_avg = mean(fraction_correct_trials_GOL3,2,"omitnan");
    fraction_correct_trials_GOL3_sem = std(fraction_correct_trials_GOL3,1,2,"omitnan")/sqrt(size(fraction_correct_trials_GOL3(:,all(~isnan(fraction_correct_trials_GOL3))),2));
    % fig = figure;
    % plot(fraction_correct_licks_GOL1,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_licks_GOL1_avg,1),size(fraction_correct_licks_GOL1_avg,1)),fraction_correct_licks_GOL1_avg,fraction_correct_licks_GOL1_sem)
    % hold off
    % title('GOL A-A*-A-B')
    % ylim([0 1])
    % ylabel('fraction of licks in reward zone')
    % xticks(linspace(1,size(fraction_correct_licks_GOL1_avg,1),size(fraction_correct_licks_GOL1_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_licks_GOL1.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
    % fig = figure;
    % plot(fraction_correct_licks_GOL2,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_licks_GOL2_avg,1),size(fraction_correct_licks_GOL2_avg,1)),fraction_correct_licks_GOL2_avg,fraction_correct_licks_GOL2_sem)
    % hold off
    % title('GOL C-C*-C-D')
    % ylim([0 1])
    % ylabel('fraction of licks in reward zone')
    % xticks(linspace(1,size(fraction_correct_licks_GOL2_avg,1),size(fraction_correct_licks_GOL2_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_licks_GOL2.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
    % fig = figure;
    % plot(fraction_correct_licks_GOL3,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_licks_GOL3_avg,1),size(fraction_correct_licks_GOL3_avg,1)),fraction_correct_licks_GOL3_avg,fraction_correct_licks_GOL3_sem)
    % hold off
    % title('GOL E-E*-E-F')
    % ylim([0 1])
    % ylabel('fraction of licks in reward zone')
    % xticks(linspace(1,size(fraction_correct_licks_GOL3_avg,1),size(fraction_correct_licks_GOL3_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_licks_GOL3.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
    % fig = figure;
    % plot(fraction_correct_trials_GOL1,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_trials_GOL1_avg,1),size(fraction_correct_trials_GOL1_avg,1)),fraction_correct_trials_GOL1_avg,fraction_correct_trials_GOL1_sem)
    % hold off
    % title('GOL A-A*-A-B')
    % ylim([0 1])
    % ylabel('fraction of correct trials')
    % xticks(linspace(1,size(fraction_correct_trials_GOL1_avg,1),size(fraction_correct_trials_GOL1_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_trials_GOL1.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
    % fig = figure;
    % plot(fraction_correct_trials_GOL2,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_trials_GOL2_avg,1),size(fraction_correct_trials_GOL2_avg,1)),fraction_correct_trials_GOL2_avg,fraction_correct_trials_GOL2_sem)
    % hold off
    % title('GOL C-C*-C-D')
    % ylim([0 1])
    % ylabel('fraction of correct trials')
    % xticks(linspace(1,size(fraction_correct_trials_GOL2_avg,1),size(fraction_correct_trials_GOL2_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_trials_GOL2.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
    % fig = figure;
    % plot(fraction_correct_trials_GOL3,'LineWidth',1.25)
    % hold on
    % shadedErrorBar(linspace(1,size(fraction_correct_trials_GOL3_avg,1),size(fraction_correct_trials_GOL3_avg,1)),fraction_correct_trials_GOL3_avg,fraction_correct_trials_GOL3_sem)
    % hold off
    % title('GOL E-E*-E-F')
    % ylim([0 1])
    % ylabel('fraction of correct trials')
    % xticks(linspace(1,size(fraction_correct_trials_GOL3_avg,1),size(fraction_correct_trials_GOL3_avg,1)))
    % xlabel('days')
    % print(fullfile(strrep(behav_file,'.mat','_fraction_correct_trials_GOL3.pdf')),'-dpdf','-r300','-bestfit');
    % close(fig);
	s_behav = struct;
	s_behav.fraction_correct_licks_RF = fraction_correct_licks_RF;
    s_behav.fraction_correct_licks_chance = fraction_correct_licks_chance;
    s_behav.fraction_correct_licks_GOL1_A1 = fraction_correct_licks_GOL1_A1;
    s_behav.fraction_correct_licks_GOL1_Aa = fraction_correct_licks_GOL1_Aa;
    s_behav.fraction_correct_licks_GOL1_A2 = fraction_correct_licks_GOL1_A2;
    s_behav.fraction_correct_licks_GOL1_B = fraction_correct_licks_GOL1_B;
    s_behav.fraction_correct_licks_GOL2_C1 = fraction_correct_licks_GOL2_C1;
    s_behav.fraction_correct_licks_GOL2_Cc = fraction_correct_licks_GOL2_Cc;
    s_behav.fraction_correct_licks_GOL2_C2 = fraction_correct_licks_GOL2_C2;
    s_behav.fraction_correct_licks_GOL2_D = fraction_correct_licks_GOL2_D;
    s_behav.fraction_correct_licks_GOL3_E1 = fraction_correct_licks_GOL3_E1;
    s_behav.fraction_correct_licks_GOL3_Ee = fraction_correct_licks_GOL3_Ee;
    s_behav.fraction_correct_licks_GOL3_E2 = fraction_correct_licks_GOL3_E2;
    s_behav.fraction_correct_licks_GOL3_F = fraction_correct_licks_GOL3_F;
    s_behav.discrimination_index_GOL1_A1_vs_Aa = discrimination_index_GOL1_A1_vs_Aa;
    s_behav.discrimination_index_GOL1_A1_vs_A2 = discrimination_index_GOL1_A1_vs_A2;
    s_behav.discrimination_index_GOL1_A1_vs_B = discrimination_index_GOL1_A1_vs_B;
    s_behav.discrimination_index_GOL1_Aa_vs_A1 = discrimination_index_GOL1_Aa_vs_A1;
    s_behav.discrimination_index_GOL1_Aa_vs_A2 = discrimination_index_GOL1_Aa_vs_A2;
    s_behav.discrimination_index_GOL1_Aa_vs_B = discrimination_index_GOL1_Aa_vs_B;
    s_behav.discrimination_index_GOL1_A2_vs_A1 = discrimination_index_GOL1_A2_vs_A1;
    s_behav.discrimination_index_GOL1_A2_vs_Aa = discrimination_index_GOL1_A2_vs_Aa;
    s_behav.discrimination_index_GOL1_A2_vs_B = discrimination_index_GOL1_A2_vs_B;
    s_behav.discrimination_index_GOL1_B_vs_A1 = discrimination_index_GOL1_B_vs_A1;
    s_behav.discrimination_index_GOL1_B_vs_Aa = discrimination_index_GOL1_B_vs_Aa;
    s_behav.discrimination_index_GOL1_B_vs_A2 = discrimination_index_GOL1_B_vs_A2;
    s_behav.discrimination_index_GOL1_C1_vs_Cc = discrimination_index_GOL1_C1_vs_Cc;
    s_behav.discrimination_index_GOL1_C1_vs_C2 = discrimination_index_GOL1_C1_vs_C2;
    s_behav.discrimination_index_GOL1_C1_vs_D = discrimination_index_GOL1_C1_vs_D;
    s_behav.discrimination_index_GOL1_Cc_vs_C1 = discrimination_index_GOL1_Cc_vs_C1;
    s_behav.discrimination_index_GOL1_Cc_vs_C2 = discrimination_index_GOL1_Cc_vs_C2;
    s_behav.discrimination_index_GOL1_Cc_vs_D = discrimination_index_GOL1_Cc_vs_D;
    s_behav.discrimination_index_GOL1_C2_vs_C1 = discrimination_index_GOL1_C2_vs_C1;
    s_behav.discrimination_index_GOL1_C2_vs_Cc = discrimination_index_GOL1_C2_vs_Cc;
    s_behav.discrimination_index_GOL1_C2_vs_D = discrimination_index_GOL1_C2_vs_D;
    s_behav.discrimination_index_GOL1_D_vs_C1 = discrimination_index_GOL1_D_vs_C1;
    s_behav.discrimination_index_GOL1_D_vs_Cc = discrimination_index_GOL1_D_vs_Cc;
    s_behav.discrimination_index_GOL1_D_vs_C2 = discrimination_index_GOL1_D_vs_C2;
    s_behav.discrimination_index_GOL1_E1_vs_Ee = discrimination_index_GOL1_E1_vs_Ee;
    s_behav.discrimination_index_GOL1_E1_vs_E2 = discrimination_index_GOL1_E1_vs_E2;
    s_behav.discrimination_index_GOL1_E1_vs_F = discrimination_index_GOL1_E1_vs_F;
    s_behav.discrimination_index_GOL1_Ee_vs_E1 = discrimination_index_GOL1_Ee_vs_E1;
    s_behav.discrimination_index_GOL1_Ee_vs_E2 = discrimination_index_GOL1_Ee_vs_E2;
    s_behav.discrimination_index_GOL1_Ee_vs_F = discrimination_index_GOL1_Ee_vs_F;
    s_behav.discrimination_index_GOL1_E2_vs_E1 = discrimination_index_GOL1_E2_vs_E1;
    s_behav.discrimination_index_GOL1_E2_vs_Ee = discrimination_index_GOL1_E2_vs_Ee;
    s_behav.discrimination_index_GOL1_E2_vs_F = discrimination_index_GOL1_E2_vs_F;
    s_behav.discrimination_index_GOL1_F_vs_E1 = discrimination_index_GOL1_F_vs_E1;
    s_behav.discrimination_index_GOL1_F_vs_Ee = discrimination_index_GOL1_F_vs_Ee;
    s_behav.discrimination_index_GOL1_F_vs_E2 = discrimination_index_GOL1_F_vs_E2;
	s_behav.fraction_correct_trials_GOL1_A1 = fraction_correct_trials_GOL1_A1;
    s_behav.fraction_correct_trials_GOL1_Aa = fraction_correct_trials_GOL1_Aa;
    s_behav.fraction_correct_trials_GOL1_A2 = fraction_correct_trials_GOL1_A2;
    s_behav.fraction_correct_trials_GOL1_B = fraction_correct_trials_GOL1_B;
    s_behav.fraction_correct_trials_GOL2_C1 = fraction_correct_trials_GOL2_C1;
    s_behav.fraction_correct_trials_GOL2_Cc = fraction_correct_trials_GOL2_Cc;
    s_behav.fraction_correct_trials_GOL2_C2 = fraction_correct_trials_GOL2_C2;
    s_behav.fraction_correct_trials_GOL2_D = fraction_correct_trials_GOL2_D;
    s_behav.fraction_correct_trials_GOL3_E1 = fraction_correct_trials_GOL3_E1;
    s_behav.fraction_correct_trials_GOL3_Ee = fraction_correct_trials_GOL3_Ee;
    s_behav.fraction_correct_trials_GOL3_E2 = fraction_correct_trials_GOL3_E2;
    s_behav.fraction_correct_trials_GOL3_F = fraction_correct_trials_GOL3_F;
    s_behav.fraction_correct_licks_GOL1 = fraction_correct_licks_GOL1;
    s_behav.fraction_correct_licks_GOL2 = fraction_correct_licks_GOL2;
    s_behav.fraction_correct_licks_GOL3 = fraction_correct_licks_GOL3;
    s_behav.fraction_correct_trials_GOL1 = fraction_correct_trials_GOL1;
    s_behav.fraction_correct_trials_GOL2 = fraction_correct_trials_GOL2;
    s_behav.fraction_correct_trials_GOL3 = fraction_correct_trials_GOL3;
    s_behav.fraction_correct_licks_GOL1_avg = fraction_correct_licks_GOL1_avg;
    s_behav.fraction_correct_licks_GOL1_sem = fraction_correct_licks_GOL1_sem;
    s_behav.fraction_correct_licks_GOL2_avg = fraction_correct_licks_GOL2_avg;
    s_behav.fraction_correct_licks_GOL2_sem = fraction_correct_licks_GOL2_sem;
    s_behav.fraction_correct_licks_GOL3_avg = fraction_correct_licks_GOL3_avg;
    s_behav.fraction_correct_licks_GOL3_sem = fraction_correct_licks_GOL3_sem;
    s_behav.fraction_correct_trials_GOL1_avg = fraction_correct_trials_GOL1_avg;
    s_behav.fraction_correct_trials_GOL1_sem = fraction_correct_trials_GOL1_sem;
    s_behav.fraction_correct_trials_GOL2_avg = fraction_correct_trials_GOL2_avg;
    s_behav.fraction_correct_trials_GOL2_sem = fraction_correct_trials_GOL2_sem;
    s_behav.fraction_correct_trials_GOL3_avg = fraction_correct_trials_GOL3_avg;
    s_behav.fraction_correct_trials_GOL3_sem = fraction_correct_trials_GOL3_sem;
	save(strrep(behav_file,'.mat','_analyzed.mat'),'s_behav','-v7.3');
end