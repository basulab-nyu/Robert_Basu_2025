function [] = spatial_pool()
%inputs
	target_folder = 'spatial_tuning_fr02i02w02';
	mat_file = 'spatial_coding.mat';
	session_length = 600;
	spatial_bins = 40;
    input_folders = ...
	["/gpfs/data/basulab/VR/cohort_5/m4",...
	"/gpfs/data/basulab/VR/cohort_5/m5",...
	"/gpfs/data/basulab/VR/cohort_5/m6",...
	"/gpfs/data/basulab/VR/cohort_5/m8",...
	"/gpfs/data/basulab/VR/cohort_5/m9",...
	"/gpfs/data/basulab/VR/cohort_5/m12",...
	"/gpfs/data/basulab/VR/cohort_6/m14",...
	"/gpfs/data/basulab/VR/cohort_6/m16",...
	"/gpfs/data/basulab/VR/cohort_6/m17",...
	"/gpfs/data/basulab/VR/cohort_7/m24",...
	"/gpfs/data/basulab/VR/cohort_7/m25",...
	"/gpfs/data/basulab/VR/cohort_7/m26",...
	"/gpfs/data/basulab/VR/cohort_7/m27",...
	"/gpfs/data/basulab/VR/cohort_7/m28",...
	"/gpfs/data/basulab/VR/cohort_7/m30",...
	"/gpfs/data/basulab/VR/cohort_7/m33a",...
	"/gpfs/data/basulab/VR/cohort_7/m33b"];
	control_id = ["m4","m5","m6","m8","m9","m12"];
	control_sessions = {'RF_hab',...
	'RF'+wildcardPattern+'fam1','RF'+wildcardPattern+'fam2','RF'+wildcardPattern+'nov',...
	'GOL_learn'+wildcardPattern+'_A_','GOL_learn'+wildcardPattern+'_Aa_','GOL_learn'+wildcardPattern+'_A2_','GOL_learn'+wildcardPattern+'_B_',...
	'GOL_recall'+wildcardPattern+'_E_','GOL_recall'+wildcardPattern+'_Ee_','GOL_recall'+wildcardPattern+'_E2_','GOL_recall'+wildcardPattern+'_F_'};
	LECglu_id = ["m14","m17","m24","m25","m26","m27","m28","m30","m33a","m33b"];
	LECglu_id_alt = ["m14","m17","m24","m25","m26","m27","m28","m30","m33"];
	LECglu_sessions = {'RF_hab',...
	'RF_sham_fam1','RF_sham_fam2','RF_sham_nov',...
	'RF_glu_'+wildcardPattern+'fam1','RF_glu_'+wildcardPattern+'fam2','RF_glu_'+wildcardPattern+'nov',...
	'GOL_glu_learn'+wildcardPattern+'_A_','GOL_glu_learn'+wildcardPattern+'_Aa_','GOL_glu_learn'+wildcardPattern+'_A2_','GOL_glu_learn'+wildcardPattern+'_B_',...
	'GOL_glu'+wildcardPattern+'recall'+wildcardPattern+'_E_','GOL_glu'+wildcardPattern+'recall'+wildcardPattern+'_Ee_','GOL_glu'+wildcardPattern+'recall'+wildcardPattern+'_E2_','GOL_glu'+wildcardPattern+'recall'+wildcardPattern+'_F_'};
	LECgaba_id = ["m16","m24","m25","m26","m27","m28","m30","m33a","m33b"];
	LECgaba_id_alt = ["m16","m24","m25","m26","m27","m28","m30","m33"];
	LECgaba_sessions = {'RF_hab',...
	'RF_sham_fam1','RF_sham_fam2','RF_sham_nov',...
	'RF_gaba_'+wildcardPattern+'fam1','RF_gaba_'+wildcardPattern+'fam2','RF_gaba_'+wildcardPattern+'nov',...
	'GOL_gaba_learn'+wildcardPattern+'_C_','GOL_gaba_learn'+wildcardPattern+'_Cc_','GOL_gaba_learn'+wildcardPattern+'_C2_','GOL_gaba_learn'+wildcardPattern+'_D_',...
	'GOL'+wildcardPattern+'gaba_recall'+wildcardPattern+'_E_','GOL'+wildcardPattern+'gaba_recall'+wildcardPattern+'_Ee_','GOL'+wildcardPattern+'gaba_recall'+wildcardPattern+'_E2_','GOL'+wildcardPattern+'gaba_recall'+wildcardPattern+'_F_'};
	LECglugaba_id = ["m24","m25","m26","m27","m28","m30","m33a","m33b"];
	LECglugaba_id_alt = ["m24","m25","m26","m27","m28","m30","m33"];
	LECglugaba_sessions = {'RF_hab',...
	'RF_sham_fam1','RF_sham_fam2','RF_sham_nov',...
	'RF_glugaba_'+wildcardPattern+'fam1','RF_glugaba_'+wildcardPattern+'fam2','RF_glugaba_'+wildcardPattern+'nov',...
	'GOL_glu_gaba_recall'+wildcardPattern+'_E_','GOL_glu_gaba_recall'+wildcardPattern+'_Ee_','GOL_glu_gaba_recall'+wildcardPattern+'_E2_','GOL_glu_gaba_recall'+wildcardPattern+'_F_'};
	addpath(genpath('code'));
% first load
	s_pool = struct;
	for i=1:size(input_folders,2)
		fprintf(strcat('\nloading:',fullfile(input_folders(i),target_folder,mat_file),'...'));
		[~,m,~] = fileparts(input_folders(i));
		temp = load(fullfile(input_folders(i),target_folder,mat_file));
		s_pool(i).id = m;
		s_pool(i).data = temp.s_coding;
		clear m;
		clear temp;
		fprintf('\ndone!\n');
	end
	load('/gpfs/data/basulab/VR/id.mat');
	for i=1:size(id,2)
		s_pool(i).data.session_id = id{i};
	end
	fprintf('\nsaving pool mat...\n');
	save('/gpfs/data/basulab/VR/s_pool_fr02i02w02p02.mat','s_pool','-v7.3');
	fprintf('\ndone!\n');
%reload
	load('/gpfs/data/basulab/VR/s_pool_fr02i02w02p02.mat');
%pooling
	mouse_id = {};
	session_id = {};
	rate_map_all_z_s = {};
	rate_map_tuned_z_s = {};
	binary_tuned_s = {};
	rate_map_all_z_ad = {};
	rate_map_tuned_z_ad = {};
	binary_tuned_ad = {};
	rate_map_half1_s = {};
	rate_map_half2_s = {};
	event_count_half_s = {};
	event_rate_half_s = {};
	rate_map_half1_ad = {};
	rate_map_half2_ad = {};
	event_count_half_ad = {};
	event_rate_half_ad = {};
	for i=1:size(s_pool,2)
		mouse_id{i} = s_pool(i).data.mouse_id;
		session_id{i} = s_pool(i).data.session_id;
		for j=1:size(session_id{i},1)
			try
				rate_map_all_z_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_z;
			end
			try
				rate_map_tuned_z_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_z;
			end
			try
				binary_tuned_s{i,j} = s_pool(i).data.s.spatial(j).all.significant;
			end
			try
				rate_map_all_z_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_z;
			end
			try
				rate_map_tuned_z_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_z;
			end
			try
				binary_tuned_ad{i,j} = s_pool(i).data.ad.spatial(j).all.significant;
			end
			try
				rate_map_half1_s{i,j} = s_pool(i).data.s.spatial(j).split.rate_map_half1;
			end
			try
				rate_map_half2_s{i,j} = s_pool(i).data.s.spatial(j).split.rate_map_half2;
			end
			try
				event_count_half_s{i,j} = s_pool(i).data.s.spatial(j).split.nEvents_half;
			end
			try
				event_rate_half_s{i,j} = s_pool(i).data.s.spatial(j).split.event_rate_half;
			end
			try
				rate_map_half1_ad{i,j} = s_pool(i).data.ad.spatial(j).split.rate_map_half1;
			end
			try
				rate_map_half2_ad{i,j} = s_pool(i).data.ad.spatial(j).split.rate_map_half2;
			end
			try
				event_count_half_ad{i,j} = s_pool(i).data.ad.spatial(j).split.nEvents_half;
			end
			try
				event_rate_half_ad{i,j} = s_pool(i).data.ad.spatial(j).split.event_rate_half;
			end
		end
	end
	log_s_control = {};
	rate_map_all_z_s_control = {};
	rate_map_tuned_z_s_control = {};
	binary_tuned_s_control = {};
	rate_map_half1_s_control = {};
	rate_map_half2_s_control = {};
	event_count_half_s_control = {};
	event_rate_half_s_control = {};
	for i=1:size(control_sessions,2) %session groups
		for j=1:size(control_id,2) %aminals
			m = find(cellfun(@(c) contains(control_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,control_sessions{i})),session_id(m),'UniformOutput',false));
			log_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_s_control{i,1}(1:size(idx,1),j) = rate_map_all_z_s(m,idx)';
			end
			try
				rate_map_tuned_z_s_control{i,1}(1:size(idx,1),j) = rate_map_tuned_z_s(m,idx)';
			end
			try
				binary_tuned_s_control{i,1}(1:size(idx,1),j) = binary_tuned_s(m,idx)';
			end
			try
				rate_map_half1_s_control{i,1}(1:size(idx,1),j) = rate_map_half1_s(m,idx)';
			end
			try
				rate_map_half2_s_control{i,1}(1:size(idx,1),j) = rate_map_half2_s(m,idx)';
			end
			try
				event_count_half_s_control{i,1}(1:size(idx,1),j) = event_count_half_s(m,idx)';
			end
			try
				event_rate_half_s_control{i,1}(1:size(idx,1),j) = event_rate_half_s(m,idx)';
			end
		end
	end
	pool_size_s_control = {};
	for i=1:size(rate_map_all_z_s_control,1)
		for j=1:size(rate_map_all_z_s_control{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_s_control{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_s_control{i,1}{k,j}))
					k=k+1;
				end
				pool_size_s_control{i,1}{j,1} = size(rate_map_all_z_s_control{i,1}{k,j},1);
			else
				pool_size_s_control{i,1}{j,1} = 0;
			end	
		end
		pool_size_s_control{i,1} = cell2mat(pool_size_s_control{i,1});
	end
	rate_map_all_z_s_control_pool = {};
	binary_tuned_s_control_pool = {};
	rate_map_tuned_z_s_control_pool = {};
	field_pos_s_control_pool = {};
	rate_map_tuned_z_s_control_pool_sorted = {};
	for i=1:size(rate_map_all_z_s_control,1)
		for j=1:size(rate_map_all_z_s_control{i,1},1)
			rate_map_all_z_s_control_pool{i,1}{j,1} = NaN(sum(pool_size_s_control{i,1}),spatial_bins);
			binary_tuned_s_control_pool{i,1}{j,1} = zeros(sum(pool_size_s_control{i,1}),1);
			if(~isempty(rate_map_all_z_s_control{i,1}{j,1}))
				rate_map_all_z_s_control_pool{i,1}{j,1}(1:pool_size_s_control{i,1}(1),:) = rate_map_all_z_s_control{i,1}{j,1};
				binary_tuned_s_control_pool{i,1}{j,1}(1:pool_size_s_control{i,1}(1)) = binary_tuned_s_control{i,1}{j,1};
			end
			limits = cumsum(pool_size_s_control{i,1});
			for k=2:size(rate_map_all_z_s_control{i,1},2)
				if(~isempty(rate_map_all_z_s_control{i,1}{j,k}))
					rate_map_all_z_s_control_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_s_control{i,1}{j,k};
					binary_tuned_s_control_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_s_control{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_s_control_pool{i,1}{j,1} = [];
			field_pos_s_control_pool{i,1}{j,1} = [];
			rate_map_tuned_z_s_control_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_s_control{i,1},2)
				rate_map_tuned_z_s_control_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_s_control_pool{i,1}{j,1},rate_map_tuned_z_s_control{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_s_control_pool{i,1}{j,1},[],2);
			[~,field_pos_s_control_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_s_control_pool_sorted{i,1}{j,1} = rate_map_tuned_z_s_control_pool{i,1}{j,1}(field_pos_s_control_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_s_control_pool_sorted = {};
	PV_map_s_control_pool = {};
	TC_map_s_control_pool = {};
	PV_corr_s_control_pool = {};
	TC_corr_s_control_pool = {};
	log_corr_s_control = {};
	for i=1:size(rate_map_all_z_s_control_pool,1)
		reflog = log_s_control{i,1}{1,1};
		rois = find(binary_tuned_s_control_pool{i,1}{1,1});
		refmap = rate_map_all_z_s_control_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_s_control_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_s_control_pool{i,1},1)
			sublog = log_s_control{i,1}{j,1};
			submap = rate_map_all_z_s_control_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_s_control_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_s_control_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_s_control_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_s_control_pool{i,1}{j,1} = diag(PV_map_s_control_pool{i,1}{j,1});
			TC_corr_s_control_pool{i,1}{j,1} = diag(TC_map_s_control_pool{i,1}{j,1});
			log_corr_s_control{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	log_ad_control = {};
	rate_map_all_z_ad_control = {};
	rate_map_tuned_z_ad_control = {};
	binary_tuned_ad_control = {};
	rate_map_half1_ad_control = {};
	rate_map_half2_ad_control = {};
	event_count_half_ad_control = {};
	event_rate_half_ad_control = {};
	for i=1:size(control_sessions,2) %session groups
		for j=1:size(control_id,2) %aminals
			m = find(cellfun(@(c) contains(control_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,control_sessions{i})),session_id(m),'UniformOutput',false));
			log_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_ad_control{i,1}(1:size(idx,1),j) = rate_map_all_z_ad(m,idx)';
			end
			try
				rate_map_tuned_z_ad_control{i,1}(1:size(idx,1),j) = rate_map_tuned_z_ad(m,idx)';
			end
			try
				binary_tuned_ad_control{i,1}(1:size(idx,1),j) = binary_tuned_ad(m,idx)';
			end
			try
				rate_map_half1_ad_control{i,1}(1:size(idx,1),j) = rate_map_half1_ad(m,idx)';
			end
			try
				rate_map_half2_ad_control{i,1}(1:size(idx,1),j) = rate_map_half2_ad(m,idx)';
			end
			try
				event_count_half_ad_control{i,1}(1:size(idx,1),j) = event_count_half_ad(m,idx)';
			end
			try
				event_rate_half_ad_control{i,1}(1:size(idx,1),j) = event_rate_half_ad(m,idx)';
			end
		end
	end
	pool_size_ad_control = {};
	for i=1:size(rate_map_all_z_ad_control,1)
		for j=1:size(rate_map_all_z_ad_control{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_ad_control{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_ad_control{i,1}{k,j}))
					k=k+1;
				end
				pool_size_ad_control{i,1}{j,1} = size(rate_map_all_z_ad_control{i,1}{k,j},1);
			else
				pool_size_ad_control{i,1}{j,1} = 0;
			end	
		end
		pool_size_ad_control{i,1} = cell2mat(pool_size_ad_control{i,1});
	end
	rate_map_all_z_ad_control_pool = {};
	binary_tuned_ad_control_pool = {};
	rate_map_tuned_z_ad_control_pool = {};
	field_pos_ad_control_pool = {};
	rate_map_tuned_z_ad_control_pool_sorted = {};
	for i=1:size(rate_map_all_z_ad_control,1)
		for j=1:size(rate_map_all_z_ad_control{i,1},1)
			rate_map_all_z_ad_control_pool{i,1}{j,1} = NaN(sum(pool_size_ad_control{i,1}),spatial_bins);
			binary_tuned_ad_control_pool{i,1}{j,1} = zeros(sum(pool_size_ad_control{i,1}),1);
			if(~isempty(rate_map_all_z_ad_control{i,1}{j,1}))
				rate_map_all_z_ad_control_pool{i,1}{j,1}(1:pool_size_ad_control{i,1}(1),:) = rate_map_all_z_ad_control{i,1}{j,1};
				binary_tuned_ad_control_pool{i,1}{j,1}(1:pool_size_ad_control{i,1}(1)) = binary_tuned_ad_control{i,1}{j,1};
			end
			limits = cumsum(pool_size_ad_control{i,1});
			for k=2:size(rate_map_all_z_ad_control{i,1},2)
				if(~isempty(rate_map_all_z_ad_control{i,1}{j,k}))
					rate_map_all_z_ad_control_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_ad_control{i,1}{j,k};
					binary_tuned_ad_control_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_ad_control{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_ad_control_pool{i,1}{j,1} = [];
			field_pos_ad_control_pool{i,1}{j,1} = [];
			rate_map_tuned_z_ad_control_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_ad_control{i,1},2)
				rate_map_tuned_z_ad_control_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_ad_control_pool{i,1}{j,1},rate_map_tuned_z_ad_control{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_ad_control_pool{i,1}{j,1},[],2);
			[~,field_pos_ad_control_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_ad_control_pool_sorted{i,1}{j,1} = rate_map_tuned_z_ad_control_pool{i,1}{j,1}(field_pos_ad_control_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_ad_control_pool_sorted = {};
	PV_map_ad_control_pool = {};
	TC_map_ad_control_pool = {};
	PV_corr_ad_control_pool = {};
	TC_corr_ad_control_pool = {};
	log_corr_ad_control = {};
	for i=1:size(rate_map_all_z_ad_control_pool,1)
		reflog = log_ad_control{i,1}{1,1};
		rois = find(binary_tuned_ad_control_pool{i,1}{1,1});
		refmap = rate_map_all_z_ad_control_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_ad_control_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_ad_control_pool{i,1},1)
			sublog = log_ad_control{i,1}{j,1};
			submap = rate_map_all_z_ad_control_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_ad_control_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_ad_control_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_ad_control_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_ad_control_pool{i,1}{j,1} = diag(PV_map_ad_control_pool{i,1}{j,1});
			TC_corr_ad_control_pool{i,1}{j,1} = diag(TC_map_ad_control_pool{i,1}{j,1});
			log_corr_ad_control{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	log_s_LECglu = {};
	rate_map_all_z_s_LECglu = {};
	rate_map_tuned_z_s_LECglu = {};
	binary_tuned_s_LECglu = {};
	rate_map_half1_s_LECglu = {};
	rate_map_half2_s_LECglu = {};
	event_count_half_s_LECglu = {};
	event_rate_half_s_LECglu = {};
	for i=1:size(LECglu_sessions,2) %session groups
		for j=1:size(LECglu_id,2) %aminals
			m = find(cellfun(@(c) contains(LECglu_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECglu_sessions{i})),session_id(m),'UniformOutput',false));
			log_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_s_LECglu{i,1}(1:size(idx,1),j) = rate_map_all_z_s(m,idx)';
			end
			try
				rate_map_tuned_z_s_LECglu{i,1}(1:size(idx,1),j) = rate_map_tuned_z_s(m,idx)';
			end
			try
				binary_tuned_s_LECglu{i,1}(1:size(idx,1),j) = binary_tuned_s(m,idx)';
			end
			try
				rate_map_half1_s_LECglu{i,1}(1:size(idx,1),j) = rate_map_half1_s(m,idx)';
			end
			try
				rate_map_half2_s_LECglu{i,1}(1:size(idx,1),j) = rate_map_half2_s(m,idx)';
			end
			try
				event_count_half_s_LECglu{i,1}(1:size(idx,1),j) = event_count_half_s(m,idx)';
			end
			try
				event_rate_half_s_LECglu{i,1}(1:size(idx,1),j) = event_rate_half_s(m,idx)';
			end
		end
	end
	pool_size_s_LECglu = {};
	for i=1:size(rate_map_all_z_s_LECglu,1)
		for j=1:size(rate_map_all_z_s_LECglu{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_s_LECglu{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_s_LECglu{i,1}{k,j}))
					k=k+1;
				end
				pool_size_s_LECglu{i,1}{j,1} = size(rate_map_all_z_s_LECglu{i,1}{k,j},1);
			else
				pool_size_s_LECglu{i,1}{j,1} = 0;
			end	
		end
		pool_size_s_LECglu{i,1} = cell2mat(pool_size_s_LECglu{i,1});
	end
	rate_map_all_z_s_LECglu_pool = {};
	binary_tuned_s_LECglu_pool = {};
	rate_map_tuned_z_s_LECglu_pool = {};
	field_pos_s_LECglu_pool = {};
	rate_map_tuned_z_s_LECglu_pool_sorted = {};
	for i=1:size(rate_map_all_z_s_LECglu,1)
		for j=1:size(rate_map_all_z_s_LECglu{i,1},1)
			rate_map_all_z_s_LECglu_pool{i,1}{j,1} = NaN(sum(pool_size_s_LECglu{i,1}),spatial_bins);
			binary_tuned_s_LECglu_pool{i,1}{j,1} = zeros(sum(pool_size_s_LECglu{i,1}),1);
			if(~isempty(rate_map_all_z_s_LECglu{i,1}{j,1}))
				rate_map_all_z_s_LECglu_pool{i,1}{j,1}(1:pool_size_s_LECglu{i,1}(1),:) = rate_map_all_z_s_LECglu{i,1}{j,1};
				binary_tuned_s_LECglu_pool{i,1}{j,1}(1:pool_size_s_LECglu{i,1}(1)) = binary_tuned_s_LECglu{i,1}{j,1};
			end
			limits = cumsum(pool_size_s_LECglu{i,1});
			for k=2:size(rate_map_all_z_s_LECglu{i,1},2)
				if(~isempty(rate_map_all_z_s_LECglu{i,1}{j,k}))
					rate_map_all_z_s_LECglu_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_s_LECglu{i,1}{j,k};
					binary_tuned_s_LECglu_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_s_LECglu{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_s_LECglu_pool{i,1}{j,1} = [];
			field_pos_s_LECglu_pool{i,1}{j,1} = [];
			rate_map_tuned_z_s_LECglu_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_s_LECglu{i,1},2)
				rate_map_tuned_z_s_LECglu_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_s_LECglu_pool{i,1}{j,1},rate_map_tuned_z_s_LECglu{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_s_LECglu_pool{i,1}{j,1},[],2);
			[~,field_pos_s_LECglu_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_s_LECglu_pool_sorted{i,1}{j,1} = rate_map_tuned_z_s_LECglu_pool{i,1}{j,1}(field_pos_s_LECglu_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_s_LECglu_pool_sorted = {};
	PV_map_s_LECglu_pool = {};
	TC_map_s_LECglu_pool = {};
	PV_corr_s_LECglu_pool = {};
	TC_corr_s_LECglu_pool = {};
	log_corr_s_LECglu = {};
	for i=1:size(rate_map_all_z_s_LECglu_pool,1)
		reflog = log_s_LECglu{i,1}{1,1};
		rois = find(binary_tuned_s_LECglu_pool{i,1}{1,1});
		refmap = rate_map_all_z_s_LECglu_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_s_LECglu_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_s_LECglu_pool{i,1},1)
			sublog = log_s_LECglu{i,1}{j,1};
			submap = rate_map_all_z_s_LECglu_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_s_LECglu_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_s_LECglu_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_s_LECglu_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_s_LECglu_pool{i,1}{j,1} = diag(PV_map_s_LECglu_pool{i,1}{j,1});
			TC_corr_s_LECglu_pool{i,1}{j,1} = diag(TC_map_s_LECglu_pool{i,1}{j,1});
			log_corr_s_LECglu{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	log_ad_LECglu = {};
	rate_map_all_z_ad_LECglu = {};
	rate_map_tuned_z_ad_LECglu = {};
	binary_tuned_ad_LECglu = {};
	rate_map_half1_ad_LECglu = {};
	rate_map_half2_ad_LECglu = {};
	event_count_half_ad_LECglu = {};
	event_rate_half_ad_LECglu = {};
	for i=1:size(LECglu_sessions,2) %session groups
		for j=1:size(LECglu_id,2) %aminals
			m = find(cellfun(@(c) contains(LECglu_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECglu_sessions{i})),session_id(m),'UniformOutput',false));
			log_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_ad_LECglu{i,1}(1:size(idx,1),j) = rate_map_all_z_ad(m,idx)';
			end
			try
				rate_map_tuned_z_ad_LECglu{i,1}(1:size(idx,1),j) = rate_map_tuned_z_ad(m,idx)';
			end
			try
				binary_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = binary_tuned_ad(m,idx)';
			end
			try
				rate_map_half1_ad_LECglu{i,1}(1:size(idx,1),j) = rate_map_half1_ad(m,idx)';
			end
			try
				rate_map_half2_ad_LECglu{i,1}(1:size(idx,1),j) = rate_map_half2_ad(m,idx)';
			end
			try
				event_count_half_ad_LECglu{i,1}(1:size(idx,1),j) = event_count_half_ad(m,idx)';
			end
			try
				event_rate_half_ad_LECglu{i,1}(1:size(idx,1),j) = event_rate_half_ad(m,idx)';
			end
		end
	end
	pool_size_ad_LECglu = {};
	for i=1:size(rate_map_all_z_ad_LECglu,1)
		for j=1:size(rate_map_all_z_ad_LECglu{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_ad_LECglu{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_ad_LECglu{i,1}{k,j}))
					k=k+1;
				end
				pool_size_ad_LECglu{i,1}{j,1} = size(rate_map_all_z_ad_LECglu{i,1}{k,j},1);
			else
				pool_size_ad_LECglu{i,1}{j,1} = 0;
			end	
		end
		pool_size_ad_LECglu{i,1} = cell2mat(pool_size_ad_LECglu{i,1});
	end
	rate_map_all_z_ad_LECglu_pool = {};
	binary_tuned_ad_LECglu_pool = {};
	rate_map_tuned_z_ad_LECglu_pool = {};
	field_pos_ad_LECglu_pool = {};
	rate_map_tuned_z_ad_LECglu_pool_sorted = {};
	for i=1:size(rate_map_all_z_ad_LECglu,1)
		for j=1:size(rate_map_all_z_ad_LECglu{i,1},1)
			rate_map_all_z_ad_LECglu_pool{i,1}{j,1} = NaN(sum(pool_size_ad_LECglu{i,1}),spatial_bins);
			binary_tuned_ad_LECglu_pool{i,1}{j,1} = zeros(sum(pool_size_ad_LECglu{i,1}),1);
			if(~isempty(rate_map_all_z_ad_LECglu{i,1}{j,1}))
				rate_map_all_z_ad_LECglu_pool{i,1}{j,1}(1:pool_size_ad_LECglu{i,1}(1),:) = rate_map_all_z_ad_LECglu{i,1}{j,1};
				binary_tuned_ad_LECglu_pool{i,1}{j,1}(1:pool_size_ad_LECglu{i,1}(1)) = binary_tuned_ad_LECglu{i,1}{j,1};
			end
			limits = cumsum(pool_size_ad_LECglu{i,1});
			for k=2:size(rate_map_all_z_ad_LECglu{i,1},2)
				if(~isempty(rate_map_all_z_ad_LECglu{i,1}{j,k}))
					rate_map_all_z_ad_LECglu_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_ad_LECglu{i,1}{j,k};
					binary_tuned_ad_LECglu_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_ad_LECglu{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_ad_LECglu_pool{i,1}{j,1} = [];
			field_pos_ad_LECglu_pool{i,1}{j,1} = [];
			rate_map_tuned_z_ad_LECglu_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_ad_LECglu{i,1},2)
				rate_map_tuned_z_ad_LECglu_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_ad_LECglu_pool{i,1}{j,1},rate_map_tuned_z_ad_LECglu{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_ad_LECglu_pool{i,1}{j,1},[],2);
			[~,field_pos_ad_LECglu_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_ad_LECglu_pool_sorted{i,1}{j,1} = rate_map_tuned_z_ad_LECglu_pool{i,1}{j,1}(field_pos_ad_LECglu_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_ad_LECglu_pool_sorted = {};
	PV_map_ad_LECglu_pool = {};
	TC_map_ad_LECglu_pool = {};
	PV_corr_ad_LECglu_pool = {};
	TC_corr_ad_LECglu_pool = {};
	log_corr_ad_LECglu = {};
	for i=1:size(rate_map_all_z_ad_LECglu_pool,1)
		reflog = log_ad_LECglu{i,1}{1,1};
		rois = find(binary_tuned_ad_LECglu_pool{i,1}{1,1});
		refmap = rate_map_all_z_ad_LECglu_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_ad_LECglu_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_ad_LECglu_pool{i,1},1)
			sublog = log_ad_LECglu{i,1}{j,1};
			submap = rate_map_all_z_ad_LECglu_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_ad_LECglu_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_ad_LECglu_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_ad_LECglu_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_ad_LECglu_pool{i,1}{j,1} = diag(PV_map_ad_LECglu_pool{i,1}{j,1});
			TC_corr_ad_LECglu_pool{i,1}{j,1} = diag(TC_map_ad_LECglu_pool{i,1}{j,1});
			log_corr_ad_LECglu{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	log_s_LECgaba = {};
	rate_map_all_z_s_LECgaba = {};
	rate_map_tuned_z_s_LECgaba = {};
	binary_tuned_s_LECgaba = {};
	rate_map_half1_s_LECgaba = {};
	rate_map_half2_s_LECgaba = {};
	event_count_half_s_LECgaba = {};
	event_rate_half_s_LECgaba = {};
	for i=1:size(LECgaba_sessions,2) %session groups
		for j=1:size(LECgaba_id,2) %aminals
			m = find(cellfun(@(c) contains(LECgaba_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECgaba_sessions{i})),session_id(m),'UniformOutput',false));
			log_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_s_LECgaba{i,1}(1:size(idx,1),j) = rate_map_all_z_s(m,idx)';
			end
			try
				rate_map_tuned_z_s_LECgaba{i,1}(1:size(idx,1),j) = rate_map_tuned_z_s(m,idx)';
			end
			try
				binary_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = binary_tuned_s(m,idx)';
			end
			try
				rate_map_half1_s_LECgaba{i,1}(1:size(idx,1),j) = rate_map_half1_s(m,idx)';
			end
			try
				rate_map_half2_s_LECgaba{i,1}(1:size(idx,1),j) = rate_map_half2_s(m,idx)';
			end
			try
				event_count_half_s_LECgaba{i,1}(1:size(idx,1),j) = event_count_half_s(m,idx)';
			end
			try
				event_rate_half_s_LECgaba{i,1}(1:size(idx,1),j) = event_rate_half_s(m,idx)';
			end
		end
	end
	pool_size_s_LECgaba = {};
	for i=1:size(rate_map_all_z_s_LECgaba,1)
		for j=1:size(rate_map_all_z_s_LECgaba{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_s_LECgaba{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_s_LECgaba{i,1}{k,j}))
					k=k+1;
				end
				pool_size_s_LECgaba{i,1}{j,1} = size(rate_map_all_z_s_LECgaba{i,1}{k,j},1);
			else
				pool_size_s_LECgaba{i,1}{j,1} = 0;
			end	
		end
		pool_size_s_LECgaba{i,1} = cell2mat(pool_size_s_LECgaba{i,1});
	end
	rate_map_all_z_s_LECgaba_pool = {};
	binary_tuned_s_LECgaba_pool = {};
	rate_map_tuned_z_s_LECgaba_pool = {};
	field_pos_s_LECgaba_pool = {};
	rate_map_tuned_z_s_LECgaba_pool_sorted = {};
	for i=1:size(rate_map_all_z_s_LECgaba,1)
		for j=1:size(rate_map_all_z_s_LECgaba{i,1},1)
			rate_map_all_z_s_LECgaba_pool{i,1}{j,1} = NaN(sum(pool_size_s_LECgaba{i,1}),spatial_bins);
			binary_tuned_s_LECgaba_pool{i,1}{j,1} = zeros(sum(pool_size_s_LECgaba{i,1}),1);
			if(~isempty(rate_map_all_z_s_LECgaba{i,1}{j,1}))
				rate_map_all_z_s_LECgaba_pool{i,1}{j,1}(1:pool_size_s_LECgaba{i,1}(1),:) = rate_map_all_z_s_LECgaba{i,1}{j,1};
				binary_tuned_s_LECgaba_pool{i,1}{j,1}(1:pool_size_s_LECgaba{i,1}(1)) = binary_tuned_s_LECgaba{i,1}{j,1};
			end
			limits = cumsum(pool_size_s_LECgaba{i,1});
			for k=2:size(rate_map_all_z_s_LECgaba{i,1},2)
				if(~isempty(rate_map_all_z_s_LECgaba{i,1}{j,k}))
					rate_map_all_z_s_LECgaba_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_s_LECgaba{i,1}{j,k};
					binary_tuned_s_LECgaba_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_s_LECgaba{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_s_LECgaba_pool{i,1}{j,1} = [];
			field_pos_s_LECgaba_pool{i,1}{j,1} = [];
			rate_map_tuned_z_s_LECgaba_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_s_LECgaba{i,1},2)
				rate_map_tuned_z_s_LECgaba_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_s_LECgaba_pool{i,1}{j,1},rate_map_tuned_z_s_LECgaba{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_s_LECgaba_pool{i,1}{j,1},[],2);
			[~,field_pos_s_LECgaba_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_s_LECgaba_pool_sorted{i,1}{j,1} = rate_map_tuned_z_s_LECgaba_pool{i,1}{j,1}(field_pos_s_LECgaba_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_s_LECgaba_pool_sorted = {};
	PV_map_s_LECgaba_pool = {};
	TC_map_s_LECgaba_pool = {};
	PV_corr_s_LECgaba_pool = {};
	TC_corr_s_LECgaba_pool = {};
	log_corr_s_LECgaba = {};
	for i=1:size(rate_map_all_z_s_LECgaba_pool,1)
		reflog = log_s_LECgaba{i,1}{1,1};
		rois = find(binary_tuned_s_LECgaba_pool{i,1}{1,1});
		refmap = rate_map_all_z_s_LECgaba_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_s_LECgaba_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_s_LECgaba_pool{i,1},1)
			sublog = log_s_LECgaba{i,1}{j,1};
			submap = rate_map_all_z_s_LECgaba_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_s_LECgaba_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_s_LECgaba_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_s_LECgaba_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_s_LECgaba_pool{i,1}{j,1} = diag(PV_map_s_LECgaba_pool{i,1}{j,1});
			TC_corr_s_LECgaba_pool{i,1}{j,1} = diag(TC_map_s_LECgaba_pool{i,1}{j,1});
			log_corr_s_LECgaba{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	log_ad_LECgaba = {};
	rate_map_all_z_ad_LECgaba = {};
	rate_map_tuned_z_ad_LECgaba = {};
	binary_tuned_ad_LECgaba = {};
	rate_map_half1_ad_LECgaba = {};
	rate_map_half2_ad_LECgaba = {};
	event_count_half_ad_LECgaba = {};
	event_rate_half_ad_LECgaba = {};
	for i=1:size(LECgaba_sessions,2) %session groups
		for j=1:size(LECgaba_id,2) %aminals
			m = find(cellfun(@(c) contains(LECgaba_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECgaba_sessions{i})),session_id(m),'UniformOutput',false));
			log_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_all_z_ad_LECgaba{i,1}(1:size(idx,1),j) = rate_map_all_z_ad(m,idx)';
			end
			try
				rate_map_tuned_z_ad_LECgaba{i,1}(1:size(idx,1),j) = rate_map_tuned_z_ad(m,idx)';
			end
			try
				binary_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = binary_tuned_ad(m,idx)';
			end
			try
				rate_map_half1_ad_LECgaba{i,1}(1:size(idx,1),j) = rate_map_half1_ad(m,idx)';
			end
			try
				rate_map_half2_ad_LECgaba{i,1}(1:size(idx,1),j) = rate_map_half2_ad(m,idx)';
			end
			try
				event_count_half_ad_LECgaba{i,1}(1:size(idx,1),j) = event_count_half_ad(m,idx)';
			end
			try
				event_rate_half_ad_LECgaba{i,1}(1:size(idx,1),j) = event_rate_half_ad(m,idx)';
			end
		end
	end
	pool_size_ad_LECgaba = {};
	for i=1:size(rate_map_all_z_ad_LECgaba,1)
		for j=1:size(rate_map_all_z_ad_LECgaba{i,1},2)
			if(~isempty(cell2mat(rate_map_all_z_ad_LECgaba{i,1}(:,j))))
				k=1;
				while(isempty(rate_map_all_z_ad_LECgaba{i,1}{k,j}))
					k=k+1;
				end
				pool_size_ad_LECgaba{i,1}{j,1} = size(rate_map_all_z_ad_LECgaba{i,1}{k,j},1);
			else
				pool_size_ad_LECgaba{i,1}{j,1} = 0;
			end	
		end
		pool_size_ad_LECgaba{i,1} = cell2mat(pool_size_ad_LECgaba{i,1});
	end
	rate_map_all_z_ad_LECgaba_pool = {};
	binary_tuned_ad_LECgaba_pool = {};
	rate_map_tuned_z_ad_LECgaba_pool = {};
	field_pos_ad_LECgaba_pool = {};
	rate_map_tuned_z_ad_LECgaba_pool_sorted = {};
	for i=1:size(rate_map_all_z_ad_LECgaba,1)
		for j=1:size(rate_map_all_z_ad_LECgaba{i,1},1)
			rate_map_all_z_ad_LECgaba_pool{i,1}{j,1} = NaN(sum(pool_size_ad_LECgaba{i,1}),spatial_bins);
			binary_tuned_ad_LECgaba_pool{i,1}{j,1} = zeros(sum(pool_size_ad_LECgaba{i,1}),1);
			if(~isempty(rate_map_all_z_ad_LECgaba{i,1}{j,1}))
				rate_map_all_z_ad_LECgaba_pool{i,1}{j,1}(1:pool_size_ad_LECgaba{i,1}(1),:) = rate_map_all_z_ad_LECgaba{i,1}{j,1};
				binary_tuned_ad_LECgaba_pool{i,1}{j,1}(1:pool_size_ad_LECgaba{i,1}(1)) = binary_tuned_ad_LECgaba{i,1}{j,1};
			end
			limits = cumsum(pool_size_ad_LECgaba{i,1});
			for k=2:size(rate_map_all_z_ad_LECgaba{i,1},2)
				if(~isempty(rate_map_all_z_ad_LECgaba{i,1}{j,k}))
					rate_map_all_z_ad_LECgaba_pool{i,1}{j,1}(limits(k-1)+1:limits(k),:) = rate_map_all_z_ad_LECgaba{i,1}{j,k};
					binary_tuned_ad_LECgaba_pool{i,1}{j,1}(limits(k-1)+1:limits(k)) = binary_tuned_ad_LECgaba{i,1}{j,k};
				end
			end			
			rate_map_tuned_z_ad_LECgaba_pool{i,1}{j,1} = [];
			field_pos_ad_LECgaba_pool{i,1}{j,1} = [];
			rate_map_tuned_z_ad_LECgaba_pool_sorted{i,1}{j,1} = [];
			for k=1:size(rate_map_tuned_z_ad_LECgaba{i,1},2)
				rate_map_tuned_z_ad_LECgaba_pool{i,1}{j,1} = cat(1,rate_map_tuned_z_ad_LECgaba_pool{i,1}{j,1},rate_map_tuned_z_ad_LECgaba{i,1}{j,k});
			end
			[~,pf] = max(rate_map_tuned_z_ad_LECgaba_pool{i,1}{j,1},[],2);
			[~,field_pos_ad_LECgaba_pool{i,1}{j,1}] = sort(pf);
			rate_map_tuned_z_ad_LECgaba_pool_sorted{i,1}{j,1} = rate_map_tuned_z_ad_LECgaba_pool{i,1}{j,1}(field_pos_ad_LECgaba_pool{i,1}{j,1},:);
		end
	end
	rate_map_ref_z_ad_LECgaba_pool_sorted = {};
	PV_map_ad_LECgaba_pool = {};
	TC_map_ad_LECgaba_pool = {};
	PV_corr_ad_LECgaba_pool = {};
	TC_corr_ad_LECgaba_pool = {};
	log_corr_ad_LECgaba = {};
	for i=1:size(rate_map_all_z_ad_LECgaba_pool,1)
		reflog = log_ad_LECgaba{i,1}{1,1};
		rois = find(binary_tuned_ad_LECgaba_pool{i,1}{1,1});
		refmap = rate_map_all_z_ad_LECgaba_pool{i,1}{1,1}(rois,:);
		[~,pf] = max(refmap,[],2);
		[~,order] = sort(pf);
		rate_map_ref_z_ad_LECgaba_pool_sorted{i,1}{1,1} = refmap(order,:);
		for j=1:size(rate_map_all_z_ad_LECgaba_pool{i,1},1)
			sublog = log_ad_LECgaba{i,1}{j,1};
			submap = rate_map_all_z_ad_LECgaba_pool{i,1}{j,1}(rois,:);
			rate_map_ref_z_ad_LECgaba_pool_sorted{i,1}{j,1} = submap(order,:);
			PV_map_ad_LECgaba_pool{i,1}{j,1} = corr(refmap,submap,'rows','pairwise');
			TC_map_ad_LECgaba_pool{i,1}{j,1} = corr(refmap',submap','rows','pairwise');
			PV_corr_ad_LECgaba_pool{i,1}{j,1} = diag(PV_map_ad_LECgaba_pool{i,1}{j,1});
			TC_corr_ad_LECgaba_pool{i,1}{j,1} = diag(TC_map_ad_LECgaba_pool{i,1}{j,1});
			log_corr_ad_LECgaba{i,1}{j,1} = strcat(reflog,'_vs_',sublog);
		end
	end
	s_map = struct;
	s_map.control.s.log = log_s_control;
	s_map.control.s.rate_map_all_z = rate_map_all_z_s_control;
	s_map.control.s.rate_map_tuned_z = rate_map_tuned_z_s_control;
	s_map.control.s.binary_tuned = binary_tuned_s_control;
	s_map.control.s.pool_size = pool_size_s_control;
	s_map.control.s.rate_map_all_z_pool = rate_map_all_z_s_control_pool;
	s_map.control.s.binary_tuned_pool = binary_tuned_s_control_pool;
	s_map.control.s.rate_map_tuned_z_pool = rate_map_tuned_z_s_control_pool;
	s_map.control.s.field_pos_pool = field_pos_s_control_pool;
	s_map.control.s.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_s_control_pool_sorted;
	s_map.control.s.rate_map_ref_z_pool_sorted = rate_map_ref_z_s_control_pool_sorted;
	s_map.control.s.PV_map_pool = PV_map_s_control_pool;
	s_map.control.s.TC_map_pool = TC_map_s_control_pool;
	s_map.control.s.PV_corr_pool = PV_corr_s_control_pool;
	s_map.control.s.TC_corr_pool = TC_corr_s_control_pool;
	s_map.control.s.log_corr = log_corr_s_control;
	s_map.control.s.rate_map_half1 = rate_map_half1_s_control;
	s_map.control.s.rate_map_half2 = rate_map_half2_s_control;
	s_map.control.s.event_count_half = event_count_half_s_control;
	s_map.control.s.event_rate_half = event_rate_half_s_control;
	s_map.control.ad.log = log_ad_control;
	s_map.control.ad.rate_map_all_z = rate_map_all_z_ad_control;
	s_map.control.ad.rate_map_tuned_z = rate_map_tuned_z_ad_control;
	s_map.control.ad.binary_tuned = binary_tuned_ad_control;
	s_map.control.ad.pool_size = pool_size_ad_control;
	s_map.control.ad.rate_map_all_z_pool = rate_map_all_z_ad_control_pool;
	s_map.control.ad.binary_tuned_pool = binary_tuned_ad_control_pool;
	s_map.control.ad.rate_map_tuned_z_pool = rate_map_tuned_z_ad_control_pool;
	s_map.control.ad.field_pos_pool = field_pos_ad_control_pool;
	s_map.control.ad.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_ad_control_pool_sorted;
	s_map.control.ad.rate_map_ref_z_pool_sorted = rate_map_ref_z_ad_control_pool_sorted;
	s_map.control.ad.PV_map_pool = PV_map_ad_control_pool;
	s_map.control.ad.TC_map_pool = TC_map_ad_control_pool;
	s_map.control.ad.PV_corr_pool = PV_corr_ad_control_pool;
	s_map.control.ad.TC_corr_pool = TC_corr_ad_control_pool;
	s_map.control.ad.log_corr = log_corr_ad_control;
	s_map.control.ad.rate_map_half1 = rate_map_half1_ad_control;
	s_map.control.ad.rate_map_half2 = rate_map_half2_ad_control;
	s_map.control.ad.event_count_half = event_count_half_ad_control;
	s_map.control.ad.event_rate_half = event_rate_half_ad_control;
	s_map.LECglu.s.log = log_s_LECglu;
	s_map.LECglu.s.rate_map_all_z = rate_map_all_z_s_LECglu;
	s_map.LECglu.s.rate_map_tuned_z = rate_map_tuned_z_s_LECglu;
	s_map.LECglu.s.binary_tuned = binary_tuned_s_LECglu;
	s_map.LECglu.s.pool_size = pool_size_s_LECglu;
	s_map.LECglu.s.rate_map_all_z_pool = rate_map_all_z_s_LECglu_pool;
	s_map.LECglu.s.binary_tuned_pool = binary_tuned_s_LECglu_pool;
	s_map.LECglu.s.rate_map_tuned_z_pool = rate_map_tuned_z_s_LECglu_pool;
	s_map.LECglu.s.field_pos_pool = field_pos_s_LECglu_pool;
	s_map.LECglu.s.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_s_LECglu_pool_sorted;
	s_map.LECglu.s.rate_map_ref_z_pool_sorted = rate_map_ref_z_s_LECglu_pool_sorted;
	s_map.LECglu.s.PV_map_pool = PV_map_s_LECglu_pool;
	s_map.LECglu.s.TC_map_pool = TC_map_s_LECglu_pool;
	s_map.LECglu.s.PV_corr_pool = PV_corr_s_LECglu_pool;
	s_map.LECglu.s.TC_corr_pool = TC_corr_s_LECglu_pool;
	s_map.LECglu.s.log_corr = log_corr_s_LECglu;
	s_map.LECglu.s.rate_map_half1 = rate_map_half1_s_LECglu;
	s_map.LECglu.s.rate_map_half2 = rate_map_half2_s_LECglu;
	s_map.LECglu.s.event_count_half = event_count_half_s_LECglu;
	s_map.LECglu.s.event_rate_half = event_rate_half_s_LECglu;
	s_map.LECglu.ad.log = log_ad_LECglu;
	s_map.LECglu.ad.rate_map_all_z = rate_map_all_z_ad_LECglu;
	s_map.LECglu.ad.rate_map_tuned_z = rate_map_tuned_z_ad_LECglu;
	s_map.LECglu.ad.binary_tuned = binary_tuned_ad_LECglu;
	s_map.LECglu.ad.pool_size = pool_size_ad_LECglu;
	s_map.LECglu.ad.rate_map_all_z_pool = rate_map_all_z_ad_LECglu_pool;
	s_map.LECglu.ad.binary_tuned_pool = binary_tuned_ad_LECglu_pool;
	s_map.LECglu.ad.rate_map_tuned_z_pool = rate_map_tuned_z_ad_LECglu_pool;
	s_map.LECglu.ad.field_pos_pool = field_pos_ad_LECglu_pool;
	s_map.LECglu.ad.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_ad_LECglu_pool_sorted;
	s_map.LECglu.ad.rate_map_ref_z_pool_sorted = rate_map_ref_z_ad_LECglu_pool_sorted;
	s_map.LECglu.ad.PV_map_pool = PV_map_ad_LECglu_pool;
	s_map.LECglu.ad.TC_map_pool = TC_map_ad_LECglu_pool;
	s_map.LECglu.ad.PV_corr_pool = PV_corr_ad_LECglu_pool;
	s_map.LECglu.ad.TC_corr_pool = TC_corr_ad_LECglu_pool;
	s_map.LECglu.ad.log_corr = log_corr_ad_LECglu;
	s_map.LECglu.ad.rate_map_half1 = rate_map_half1_ad_LECglu;
	s_map.LECglu.ad.rate_map_half2 = rate_map_half2_ad_LECglu;
	s_map.LECglu.ad.event_count_half = event_count_half_ad_LECglu;
	s_map.LECglu.ad.event_rate_half = event_rate_half_ad_LECglu;
	s_map.LECgaba.s.log = log_s_LECgaba;
	s_map.LECgaba.s.rate_map_all_z = rate_map_all_z_s_LECgaba;
	s_map.LECgaba.s.rate_map_tuned_z = rate_map_tuned_z_s_LECgaba;
	s_map.LECgaba.s.binary_tuned = binary_tuned_s_LECgaba;
	s_map.LECgaba.s.pool_size = pool_size_s_LECgaba;
	s_map.LECgaba.s.rate_map_all_z_pool = rate_map_all_z_s_LECgaba_pool;
	s_map.LECgaba.s.binary_tuned_pool = binary_tuned_s_LECgaba_pool;
	s_map.LECgaba.s.rate_map_tuned_z_pool = rate_map_tuned_z_s_LECgaba_pool;
	s_map.LECgaba.s.field_pos_pool = field_pos_s_LECgaba_pool;
	s_map.LECgaba.s.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_s_LECgaba_pool_sorted;
	s_map.LECgaba.s.rate_map_ref_z_pool_sorted = rate_map_ref_z_s_LECgaba_pool_sorted;
	s_map.LECgaba.s.PV_map_pool = PV_map_s_LECgaba_pool;
	s_map.LECgaba.s.TC_map_pool = TC_map_s_LECgaba_pool;
	s_map.LECgaba.s.PV_corr_pool = PV_corr_s_LECgaba_pool;
	s_map.LECgaba.s.TC_corr_pool = TC_corr_s_LECgaba_pool;
	s_map.LECgaba.s.log_corr = log_corr_s_LECgaba;
	s_map.LECgaba.s.rate_map_half1 = rate_map_half1_s_LECgaba;
	s_map.LECgaba.s.rate_map_half2 = rate_map_half2_s_LECgaba;
	s_map.LECgaba.s.event_count_half = event_count_half_s_LECgaba;
	s_map.LECgaba.s.event_rate_half = event_rate_half_s_LECgaba;
	s_map.LECgaba.ad.log = log_ad_LECgaba;
	s_map.LECgaba.ad.rate_map_all_z = rate_map_all_z_ad_LECgaba;
	s_map.LECgaba.ad.rate_map_tuned_z = rate_map_tuned_z_ad_LECgaba;
	s_map.LECgaba.ad.binary_tuned = binary_tuned_ad_LECgaba;
	s_map.LECgaba.ad.pool_size = pool_size_ad_LECgaba;
	s_map.LECgaba.ad.rate_map_all_z_pool = rate_map_all_z_ad_LECgaba_pool;
	s_map.LECgaba.ad.binary_tuned_pool = binary_tuned_ad_LECgaba_pool;
	s_map.LECgaba.ad.rate_map_tuned_z_pool = rate_map_tuned_z_ad_LECgaba_pool;
	s_map.LECgaba.ad.field_pos_pool = field_pos_ad_LECgaba_pool;
	s_map.LECgaba.ad.rate_map_tuned_z_pool_sorted = rate_map_tuned_z_ad_LECgaba_pool_sorted;
	s_map.LECgaba.ad.rate_map_ref_z_pool_sorted = rate_map_ref_z_ad_LECgaba_pool_sorted;
	s_map.LECgaba.ad.PV_map_pool = PV_map_ad_LECgaba_pool;
	s_map.LECgaba.ad.TC_map_pool = TC_map_ad_LECgaba_pool;
	s_map.LECgaba.ad.PV_corr_pool = PV_corr_ad_LECgaba_pool;
	s_map.LECgaba.ad.TC_corr_pool = TC_corr_ad_LECgaba_pool;
	s_map.LECgaba.ad.log_corr = log_corr_ad_LECgaba;	
	s_map.LECgaba.ad.rate_map_half1 = rate_map_half1_ad_LECgaba;
	s_map.LECgaba.ad.rate_map_half2 = rate_map_half2_ad_LECgaba;
	s_map.LECgaba.ad.event_count_half = event_count_half_s_LECgaba;
	s_map.LECgaba.ad.event_rate_half = event_rate_half_ad_LECgaba;
	groups = fieldnames(s_map);
	for i=1:size(groups,1)
		type = fieldnames(s_map.(char(groups(i))));
		for j=1:size(type,1)
			blocks = s_map.(char(groups(i))).(char(type(j))).rate_map_tuned_z;
			for k=1:size(blocks,1)
				for x=1:size(blocks{k},1)
					for y=1:size(blocks{k},2)
						try
							[~,pf] = max(s_map.(char(groups(i))).(char(type(j))).rate_map_tuned_z{k,1}{x,y},[],2);
							[~,idx] = sort(pf);						
							s_map.(char(groups(i))).(char(type(j))).rate_map_tuned_z_sorted{k,1}{x,y} = s_map.(char(groups(i))).(char(type(j))).rate_map_tuned_z{k,1}{x,y}(idx,:);
						end
					end
				end
			end
		end
	end
	save('/gpfs/data/basulab/VR/s_maps_fr02i02w02p02h.mat','s_map','-v7.3');
end