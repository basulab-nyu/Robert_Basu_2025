function [] = halves_pool()
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
	% s_pool = struct;
	% for i=1:size(input_folders,2)
		% fprintf(strcat('\nloading:',fullfile(input_folders(i),target_folder,mat_file),'...'));
		% [~,m,~] = fileparts(input_folders(i));
		% temp = load(fullfile(input_folders(i),target_folder,mat_file));
		% s_pool(i).id = m;
		% s_pool(i).data = temp.s_coding;
		% clear m;
		% clear temp;
		% fprintf('\ndone!\n');
	% end
	load('/gpfs/data/basulab/VR/id.mat');
	for i=1:size(id,2)
		s_pool(i).data.session_id = id{i};
	end
	% fprintf('\nsaving pool mat...\n');
	% save('/gpfs/data/basulab/VR/s_pool_fr02i02w02p02.mat','s_pool','-v7.3');
	% fprintf('\ndone!\n');
%reload
	load('/gpfs/data/basulab/VR/s_pool_fr02i02w02p02.mat');
%pooling
	ID_mouse = {};
	ID_session = {};
	ALL_map_s = {};
	PC_bin_s = {};
	H1_map_s = {};
	H2_map_s = {};
	ALL_map_ad = {};
	PC_bin_ad = {};
	H1_map_ad = {};
	H2_map_ad = {};
	for i=1:size(s_pool,2)
		ID_mouse{i} = s_pool(i).data.mouse_id;
		ID_session{i} = s_pool(i).data.session_id;
		for j=1:size(ID_session{i},1)
			try
				ALL_map_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_z;
			end
			try
				PC_bin_s{i,j} = s_pool(i).data.s.spatial(j).all.significant;
			end
			try
				H1_map_s{i,j} = s_pool(i).data.s.spatial(j).split.rate_map_half1;
			end
			try
				H2_map_s{i,j} = s_pool(i).data.s.spatial(j).split.rate_map_half2;
			end
			try
				ALL_map_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_z;
			end
			try
				PC_bin_ad{i,j} = s_pool(i).data.ad.spatial(j).all.significant;
			end
			try
				H1_map_ad{i,j} = s_pool(i).data.ad.spatial(j).split.rate_map_half1;
			end
			try
				H2_map_ad{i,j} = s_pool(i).data.ad.spatial(j).split.rate_map_half2;
			end
		end
	end
	log_s_control = {};
	ALL_map_s_control = {};
	PC_bin_s_control = {};
	H1_map_s_control = {};
	H2_map_s_control = {};
	log_ad_control = {};
	ALL_map_ad_control = {};
	PC_bin_ad_control = {};
	H1_map_ad_control = {};
	H2_map_ad_control = {};
	for i=1:size(control_sessions,2) %session groups
		for j=1:size(control_id,2) %aminals
			m = find(cellfun(@(c) contains(control_id(j),c),ID_mouse));
			idx = cell2mat(cellfun(@(c) find(contains(c,control_sessions{i})),ID_session(m),'UniformOutput',false));
			log_s_control{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_s_control{i,1}(1:size(idx,1),j) = ALL_map_s(m,idx)';
			end
			try
				PC_bin_s_control{i,1}(1:size(idx,1),j) = PC_bin_s(m,idx)';
			end
			try
				H1_map_s_control{i,1}(1:size(idx,1),j) = H1_map_s(m,idx)';
			end
			try
				H2_map_s_control{i,1}(1:size(idx,1),j) = H2_map_s(m,idx)';
			end
			log_ad_control{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_ad_control{i,1}(1:size(idx,1),j) = ALL_map_ad(m,idx)';
			end
			try
				PC_bin_ad_control{i,1}(1:size(idx,1),j) = PC_bin_ad(m,idx)';
			end
			try
				H1_map_ad_control{i,1}(1:size(idx,1),j) = H1_map_ad(m,idx)';
			end
			try
				H2_map_ad_control{i,1}(1:size(idx,1),j) = H2_map_ad(m,idx)';
			end
		end
	end
	log_s_LECglu = {};
	ALL_map_s_LECglu = {};
	PC_bin_s_LECglu = {};
	H1_map_s_LECglu = {};
	H2_map_s_LECglu = {};
	log_ad_LECglu = {};
	ALL_map_ad_LECglu = {};
	PC_bin_ad_LECglu = {};
	H1_map_ad_LECglu = {};
	H2_map_ad_LECglu = {};
	for i=1:size(LECglu_sessions,2) %session groups
		for j=1:size(LECglu_id,2) %aminals
			m = find(cellfun(@(c) contains(LECglu_id(j),c),ID_mouse));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECglu_sessions{i})),ID_session(m),'UniformOutput',false));
			log_s_LECglu{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_s_LECglu{i,1}(1:size(idx,1),j) = ALL_map_s(m,idx)';
			end
			try
				PC_bin_s_LECglu{i,1}(1:size(idx,1),j) = PC_bin_s(m,idx)';
			end
			try
				H1_map_s_LECglu{i,1}(1:size(idx,1),j) = H1_map_s(m,idx)';
			end
			try
				H2_map_s_LECglu{i,1}(1:size(idx,1),j) = H2_map_s(m,idx)';
			end
			log_ad_LECglu{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_ad_LECglu{i,1}(1:size(idx,1),j) = ALL_map_ad(m,idx)';
			end
			try
				PC_bin_ad_LECglu{i,1}(1:size(idx,1),j) = PC_bin_ad(m,idx)';
			end
			try
				H1_map_ad_LECglu{i,1}(1:size(idx,1),j) = H1_map_ad(m,idx)';
			end
			try
				H2_map_ad_LECglu{i,1}(1:size(idx,1),j) = H2_map_ad(m,idx)';
			end
		end
	end
	log_s_LECgaba = {};
	ALL_map_s_LECgaba = {};
	PC_bin_s_LECgaba = {};
	H1_map_s_LECgaba = {};
	H2_map_s_LECgaba = {};
	log_ad_LECgaba = {};
	ALL_map_ad_LECgaba = {};
	PC_bin_ad_LECgaba = {};
	H1_map_ad_LECgaba = {};
	H2_map_ad_LECgaba = {};
	for i=1:size(LECgaba_sessions,2) %session groups
		for j=1:size(LECgaba_id,2) %aminals
			m = find(cellfun(@(c) contains(LECgaba_id(j),c),ID_mouse));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECgaba_sessions{i})),ID_session(m),'UniformOutput',false));
			log_s_LECgaba{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_s_LECgaba{i,1}(1:size(idx,1),j) = ALL_map_s(m,idx)';
			end
			try
				PC_bin_s_LECgaba{i,1}(1:size(idx,1),j) = PC_bin_s(m,idx)';
			end
			try
				H1_map_s_LECgaba{i,1}(1:size(idx,1),j) = H1_map_s(m,idx)';
			end
			try
				H2_map_s_LECgaba{i,1}(1:size(idx,1),j) = H2_map_s(m,idx)';
			end
			log_ad_LECgaba{i,1}(1:size(idx,1),j) = ID_session{m}(idx);
			try
				ALL_map_ad_LECgaba{i,1}(1:size(idx,1),j) = ALL_map_ad(m,idx)';
			end
			try
				PC_bin_ad_LECgaba{i,1}(1:size(idx,1),j) = PC_bin_ad(m,idx)';
			end
			try
				H1_map_ad_LECgaba{i,1}(1:size(idx,1),j) = H1_map_ad(m,idx)';
			end
			try
				H2_map_ad_LECgaba{i,1}(1:size(idx,1),j) = H2_map_ad(m,idx)';
			end
		end
	end
	s_map = struct;
	s_map.control.s.log = log_s_control;
	s_map.control.s.ALL_map = ALL_map_s_control;
	s_map.control.s.PC_bin = PC_bin_s_control;
	s_map.control.s.H1_map = H1_map_s_control;
	s_map.control.s.H2_map = H2_map_s_control;
	s_map.control.ad.log = log_ad_control;
	s_map.control.ad.ALL_map = ALL_map_ad_control;
	s_map.control.ad.PC_bin = PC_bin_ad_control;
	s_map.control.ad.H1_map = H1_map_ad_control;
	s_map.control.ad.H2_map = H2_map_ad_control;
	s_map.LECglu.s.log = log_s_LECglu;
	s_map.LECglu.s.ALL_map = ALL_map_s_LECglu;
	s_map.LECglu.s.PC_bin = PC_bin_s_LECglu;
	s_map.LECglu.s.H1_map = H1_map_s_LECglu;
	s_map.LECglu.s.H2_map = H2_map_s_LECglu;
	s_map.LECglu.ad.log = log_ad_LECglu;
	s_map.LECglu.ad.ALL_map = ALL_map_ad_LECglu;
	s_map.LECglu.ad.PC_bin = PC_bin_ad_LECglu;
	s_map.LECglu.ad.H1_map = H1_map_ad_LECglu;
	s_map.LECglu.ad.H2_map = H2_map_ad_LECglu;
	s_map.LECgaba.s.log = log_s_LECgaba;
	s_map.LECgaba.s.ALL_map = ALL_map_s_LECgaba;
	s_map.LECgaba.s.PC_bin = PC_bin_s_LECgaba;
	s_map.LECgaba.s.H1_map = H1_map_s_LECgaba;
	s_map.LECgaba.s.H2_map = H2_map_s_LECgaba;
	s_map.LECgaba.ad.log = log_ad_LECgaba;
	s_map.LECgaba.ad.ALL_map = ALL_map_ad_LECgaba;
	s_map.LECgaba.ad.PC_bin = PC_bin_ad_LECgaba;
	s_map.LECgaba.ad.H1_map = H1_map_ad_LECgaba;
	s_map.LECgaba.ad.H2_map = H2_map_ad_LECgaba;
	save('/gpfs/data/basulab/VR/s_maps_S_DxA.mat','s_map','-v7.3');
end