function [] = metrics_pool()
%inputs
	target_folder = 'spatial_tuning_fr02i02w02';
	mat_file = 'spatial_coding.mat';
	session_length = 600;
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
%first load
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
	% load('/gpfs/data/basulab/VR/s_pool_fr02i02w02.mat');
%pooling
	mouse_id = {};
	session_id = {};
	%soma
	event_rate_run_s = {};
	event_rate_rest_s = {};
	event_amp_run_s = {};
	event_amp_rest_s = {};
	event_width_run_s = {};
	event_width_rest_s = {};
	event_auc_run_s = {};
	event_auc_rest_s = {};
	event_rise_run_s = {};
	event_rise_rest_s = {};
	event_decay_run_s = {};
	event_decay_rest_s = {};
	event_rate_tuned_s = {};
	event_rate_untuned_s = {};
	event_amp_tuned_s = {};
	event_amp_untuned_s = {};
	event_width_tuned_s = {};
	event_width_untuned_s = {};
	event_auc_tuned_s = {};
	event_auc_untuned_s = {};
	event_rise_tuned_s = {};
	event_rise_untuned_s = {};
	event_decay_tuned_s = {};
	event_decay_untuned_s = {};
	event_rate_tuned_run_s = {};
	event_rate_tuned_rest_s = {};
	event_amp_tuned_run_s = {};
	event_amp_tuned_rest_s = {};
	event_width_tuned_run_s = {};
	event_width_tuned_rest_s = {};
	event_auc_tuned_run_s = {};
	event_auc_tuned_rest_s = {};
	event_rise_tuned_run_s = {};
	event_rise_tuned_rest_s = {};
	event_decay_tuned_run_s = {};
	event_decay_tuned_rest_s = {};
	event_rise_untuned_run_s = {};
	event_rise_untuned_rest_s = {};
	event_amp_untuned_run_s = {};
	event_amp_untuned_rest_s = {};
	event_width_untuned_run_s = {};
	event_width_untuned_rest_s = {};
	event_auc_untuned_run_s = {};
	event_auc_untuned_rest_s = {};
	event_decay_untuned_run_s = {};
	event_decay_untuned_rest_s = {};
	event_rate_untuned_run_s = {};
	event_rate_untuned_rest_s = {};
	event_rate_pop_run_s = {};
	event_rate_pop_rest_s = {};
	event_amp_pop_run_s = {};
	event_amp_pop_rest_s = {};
	event_width_pop_run_s = {};
	event_width_pop_rest_s = {};
	event_auc_pop_run_s = {};
	event_auc_pop_rest_s = {};
	event_rise_pop_run_s = {};
	event_rise_pop_rest_s = {};
	event_decay_pop_run_s = {};
	event_decay_pop_rest_s = {};
	event_rate_pop_tuned_s = {};
	event_rate_pop_untuned_s = {};
	event_amp_pop_tuned_s = {};
	event_amp_pop_untuned_s = {};
	event_width_pop_tuned_s = {};
	event_width_pop_untuned_s = {};
	event_auc_pop_tuned_s = {};
	event_auc_pop_untuned_s = {};
	event_rise_pop_tuned_s = {};
	event_rise_pop_untuned_s = {};
	event_decay_pop_tuned_s = {};
	event_decay_pop_untuned_s = {};
	event_rate_pop_tuned_run_s = {};
	event_rate_pop_tuned_rest_s = {};
	event_amp_pop_tuned_run_s = {};
	event_amp_pop_tuned_rest_s = {};
	event_width_pop_tuned_run_s = {};
	event_width_pop_tuned_rest_s = {};
	event_auc_pop_tuned_run_s = {};
	event_auc_pop_tuned_rest_s = {};
	event_rise_pop_tuned_run_s = {};
	event_rise_pop_tuned_rest_s = {};
	event_decay_pop_tuned_run_s = {};
	event_decay_pop_tuned_rest_s = {};
	event_rate_pop_untuned_run_s = {};
	event_rate_pop_untuned_rest_s = {};
	event_amp_pop_untuned_run_s = {};
	event_amp_pop_untuned_rest_s = {};
	event_width_pop_untuned_run_s = {};
	event_width_pop_untuned_rest_s = {};
	event_auc_pop_untuned_run_s = {};
	event_auc_pop_untuned_rest_s = {};
	event_rise_pop_untuned_run_s = {};
	event_rise_pop_untuned_rest_s = {};
	event_decay_pop_untuned_run_s = {};
	event_decay_pop_untuned_rest_s = {};
	fraction_active_ROIs_s = {};
	fraction_active_ROIs_run_s = {};
	fraction_active_ROIs_rest_s = {};
	fraction_place_cells_s = {};
	number_place_fields_s = {};
	width_place_fields_s = {};
	center_place_fields_s = {};
	center_place_fields_index_s = {};
	center_place_fields_active_s = {};
	center_place_fields_index_sorted_s = {};
	center_place_fields_active_sorted_s = {};
	rate_map_s = {};
	rate_map_z_s = {};
	rate_map_n_s = {};
	rate_map_active_s = {};
	rate_map_active_z_s = {};
	rate_map_active_n_s = {};
	rate_map_active_sorted_s = {};
	rate_map_active_sorted_z_s = {};
	rate_map_active_sorted_n_s = {};
	spatial_info_bits_s = {};
	spatial_info_norm_s = {};
	roi_pc_binary_s = {};
	TC_corr_z_cross_s = {};
	PV_corr_z_cross_s = {};
	TC_corr_z_pair_s = {};
	PV_corr_z_pair_s = {};
	TC_corr_z_ref_s = {};
	PV_corr_z_ref_s = {};	
	%dendrites
	event_rate_run_ad = {};
	event_rate_rest_ad = {};
	event_amp_run_ad = {};
	event_amp_rest_ad = {};
	event_width_run_ad = {};
	event_width_rest_ad = {};
	event_auc_run_ad = {};
	event_auc_rest_ad = {};
	event_rise_run_ad = {};
	event_rise_rest_ad = {};
	event_decay_run_ad = {};
	event_decay_rest_ad = {};
	event_rate_tuned_ad = {};
	event_rate_untuned_ad = {};
	event_amp_tuned_ad = {};
	event_amp_untuned_ad = {};
	event_width_tuned_ad = {};
	event_width_untuned_ad = {};
	event_auc_tuned_ad = {};
	event_auc_untuned_ad = {};
	event_rise_tuned_ad = {};
	event_rise_untuned_ad = {};
	event_decay_tuned_ad = {};
	event_decay_untuned_ad = {};
	event_rate_tuned_run_ad = {};
	event_rate_tuned_rest_ad = {};
	event_amp_tuned_run_ad = {};
	event_amp_tuned_rest_ad = {};
	event_width_tuned_run_ad = {};
	event_width_tuned_rest_ad = {};
	event_auc_tuned_run_ad = {};
	event_auc_tuned_rest_ad = {};
	event_rise_tuned_run_ad = {};
	event_rise_tuned_rest_ad = {};
	event_decay_tuned_run_ad = {};
	event_decay_tuned_rest_ad = {};
	event_rise_untuned_run_ad = {};
	event_rise_untuned_rest_ad = {};
	event_amp_untuned_run_ad = {};
	event_amp_untuned_rest_ad = {};
	event_width_untuned_run_ad = {};
	event_width_untuned_rest_ad = {};
	event_auc_untuned_run_ad = {};
	event_auc_untuned_rest_ad = {};
	event_decay_untuned_run_ad = {};
	event_decay_untuned_rest_ad = {};
	event_rate_untuned_run_ad = {};
	event_rate_untuned_rest_ad = {};
	event_rate_pop_run_ad = {};
	event_rate_pop_rest_ad = {};
	event_amp_pop_run_ad = {};
	event_amp_pop_rest_ad = {};
	event_width_pop_run_ad = {};
	event_width_pop_rest_ad = {};
	event_auc_pop_run_ad = {};
	event_auc_pop_rest_ad = {};
	event_rise_pop_run_ad = {};
	event_rise_pop_rest_ad = {};
	event_decay_pop_run_ad = {};
	event_decay_pop_rest_ad = {};
	event_rate_pop_tuned_ad = {};
	event_rate_pop_untuned_ad = {};
	event_amp_pop_tuned_ad = {};
	event_amp_pop_untuned_ad = {};
	event_width_pop_tuned_ad = {};
	event_width_pop_untuned_ad = {};
	event_auc_pop_tuned_ad = {};
	event_auc_pop_untuned_ad = {};
	event_rise_pop_tuned_ad = {};
	event_rise_pop_untuned_ad = {};
	event_decay_pop_tuned_ad = {};
	event_decay_pop_untuned_ad = {};
	event_rate_pop_tuned_run_ad = {};
	event_rate_pop_tuned_rest_ad = {};
	event_amp_pop_tuned_run_ad = {};
	event_amp_pop_tuned_rest_ad = {};
	event_width_pop_tuned_run_ad = {};
	event_width_pop_tuned_rest_ad = {};
	event_auc_pop_tuned_run_ad = {};
	event_auc_pop_tuned_rest_ad = {};
	event_rise_pop_tuned_run_ad = {};
	event_rise_pop_tuned_rest_ad = {};
	event_decay_pop_tuned_run_ad = {};
	event_decay_pop_tuned_rest_ad = {};
	event_rate_pop_untuned_run_ad = {};
	event_rate_pop_untuned_rest_ad = {};
	event_amp_pop_untuned_run_ad = {};
	event_amp_pop_untuned_rest_ad = {};
	event_width_pop_untuned_run_ad = {};
	event_width_pop_untuned_rest_ad = {};
	event_auc_pop_untuned_run_ad = {};
	event_auc_pop_untuned_rest_ad = {};
	event_rise_pop_untuned_run_ad = {};
	event_rise_pop_untuned_rest_ad = {};
	event_decay_pop_untuned_run_ad = {};
	event_decay_pop_untuned_rest_ad = {};
	fraction_active_ROIs_ad = {};
	fraction_active_ROIs_run_ad = {};
	fraction_active_ROIs_rest_ad = {};
	fraction_place_cells_ad = {};
	number_place_fields_ad = {};
	width_place_fields_ad = {};
	center_place_fields_ad = {};
	center_place_fields_index_ad = {};
	center_place_fields_active_ad = {};
	center_place_fields_index_sorted_ad = {};
	center_place_fields_active_sorted_ad = {};
	rate_map_ad = {};
	rate_map_z_ad = {};
	rate_map_n_ad = {};
	rate_map_active_ad = {};
	rate_map_active_z_ad = {};
	rate_map_active_n_ad = {};
	rate_map_active_sorted_ad = {};
	rate_map_active_sorted_z_ad = {};
	rate_map_active_sorted_n_ad = {};
	spatial_info_bits_ad = {};
	spatial_info_norm_ad = {};
	roi_pc_binary_ad = {};
	TC_corr_z_cross_ad = {};
	PV_corr_z_cross_ad = {};
	TC_corr_z_pair_ad = {};
	PV_corr_z_pair_ad = {};
	TC_corr_z_ref_ad = {};
	PV_corr_z_ref_ad = {};
	for i=1:size(s_pool,2)
		mouse_id{i} = s_pool(i).data.mouse_id;
		session_id{i} = s_pool(i).data.session_id;
		for j=1:size(session_id{i},1)
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_run,'UniformOutput',false)));
				event_rate_run_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_run,'UniformOutput',false)));
				event_rate_run_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_rest,'UniformOutput',false)));
				event_rate_rest_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_rest,'UniformOutput',false)));
				event_rate_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_run,'UniformOutput',false)));
				event_amp_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_run,'UniformOutput',false)));
				event_amp_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_rest,'UniformOutput',false)));
				event_amp_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_rest,'UniformOutput',false)));
				event_amp_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_run,'UniformOutput',false)));
				event_width_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_run,'UniformOutput',false)));
				event_width_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_rest,'UniformOutput',false)));
				event_width_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_rest,'UniformOutput',false)));
				event_width_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_run,'UniformOutput',false)));
				event_auc_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_run,'UniformOutput',false)));
				event_auc_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_rest,'UniformOutput',false)));
				event_auc_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_rest,'UniformOutput',false)));
				event_auc_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_run,'UniformOutput',false)));
				event_rise_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_run,'UniformOutput',false)));
				event_rise_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_rest,'UniformOutput',false)));
				event_rise_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_rest,'UniformOutput',false)));
				event_rise_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_run,'UniformOutput',false)));
				event_decay_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_run,'UniformOutput',false)));
				event_decay_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_rest,'UniformOutput',false)));
				event_decay_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_rest,'UniformOutput',false)));
				event_decay_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned,'UniformOutput',false)));
				event_rate_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned(idx),'UniformOutput',false))/session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned,'UniformOutput',false)));
				event_rate_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned(idx),'UniformOutput',false))/session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned,'UniformOutput',false)));
				event_rate_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned(idx),'UniformOutput',false))/session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned,'UniformOutput',false)));
				event_rate_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned(idx),'UniformOutput',false))/session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned,'UniformOutput',false)));
				event_amp_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned,'UniformOutput',false)));
				event_amp_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned,'UniformOutput',false)));
				event_amp_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned,'UniformOutput',false)));
				event_amp_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned,'UniformOutput',false)));
				event_width_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned,'UniformOutput',false)));
				event_width_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned,'UniformOutput',false)));
				event_width_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned,'UniformOutput',false)));
				event_width_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned,'UniformOutput',false)));
				event_auc_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned,'UniformOutput',false)));
				event_auc_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned,'UniformOutput',false)));
				event_auc_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned,'UniformOutput',false)));
				event_auc_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned,'UniformOutput',false)));
				event_rise_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned,'UniformOutput',false)));
				event_rise_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned,'UniformOutput',false)));
				event_rise_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned,'UniformOutput',false)));
				event_rise_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned,'UniformOutput',false)));
				event_decay_tuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned,'UniformOutput',false)));
				event_decay_tuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned,'UniformOutput',false)));
				event_decay_untuned_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned,'UniformOutput',false)));
				event_decay_untuned_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned_run,'UniformOutput',false)));
				event_rate_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned_run,'UniformOutput',false)));
				event_rate_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned_rest,'UniformOutput',false)));
				event_rate_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned_rest,'UniformOutput',false)));
				event_rate_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned_run,'UniformOutput',false)));
				event_rate_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned_run,'UniformOutput',false)));
				event_rate_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned_rest,'UniformOutput',false)));
				event_rate_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned_rest,'UniformOutput',false)));
				event_rate_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned_run,'UniformOutput',false)));
				event_amp_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_run,'UniformOutput',false)));
				event_amp_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned_rest,'UniformOutput',false)));
				event_amp_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_rest,'UniformOutput',false)));
				event_amp_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned_run,'UniformOutput',false)));
				event_amp_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_run,'UniformOutput',false)));
				event_amp_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned_rest,'UniformOutput',false)));
				event_amp_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_rest,'UniformOutput',false)));
				event_amp_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned_run,'UniformOutput',false)));
				event_width_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned_run,'UniformOutput',false)));
				event_width_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned_rest,'UniformOutput',false)));
				event_width_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned_rest,'UniformOutput',false)));
				event_width_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned_run,'UniformOutput',false)));
				event_width_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned_run,'UniformOutput',false)));
				event_width_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned_rest,'UniformOutput',false)));
				event_width_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned_rest,'UniformOutput',false)));
				event_width_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned_run,'UniformOutput',false)));
				event_auc_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_run,'UniformOutput',false)));
				event_auc_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned_rest,'UniformOutput',false)));
				event_auc_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_rest,'UniformOutput',false)));
				event_auc_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned_run,'UniformOutput',false)));
				event_auc_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_run,'UniformOutput',false)));
				event_auc_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned_rest,'UniformOutput',false)));
				event_auc_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_rest,'UniformOutput',false)));
				event_auc_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned_run,'UniformOutput',false)));
				event_rise_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_run,'UniformOutput',false)));
				event_rise_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned_rest,'UniformOutput',false)));
				event_rise_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_rest,'UniformOutput',false)));
				event_rise_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned_run,'UniformOutput',false)));
				event_rise_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_run,'UniformOutput',false)));
				event_rise_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned_rest,'UniformOutput',false)));
				event_rise_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_rest,'UniformOutput',false)));
				event_rise_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned_run,'UniformOutput',false)));
				event_decay_tuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_run,'UniformOutput',false)));
				event_decay_tuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned_rest,'UniformOutput',false)));
				event_decay_tuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_rest,'UniformOutput',false)));
				event_decay_tuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned_run,'UniformOutput',false)));
				event_decay_untuned_run_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_run,'UniformOutput',false)));
				event_decay_untuned_run_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_run(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned_rest,'UniformOutput',false)));
				event_decay_untuned_rest_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_rest,'UniformOutput',false)));
				event_decay_untuned_rest_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_rest(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_run,'UniformOutput',false)));
				event_rate_pop_run_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_run,'UniformOutput',false)));
				event_rate_pop_run_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_rest,'UniformOutput',false)));
				event_rate_pop_rest_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_rest,'UniformOutput',false)));
				event_rate_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_run,'UniformOutput',false)));
				event_amp_pop_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_run,'UniformOutput',false)));
				event_amp_pop_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_rest,'UniformOutput',false)));
				event_amp_pop_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_rest,'UniformOutput',false)));
				event_amp_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_run,'UniformOutput',false)));
				event_width_pop_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_run,'UniformOutput',false)));
				event_width_pop_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_rest,'UniformOutput',false)));
				event_width_pop_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_rest,'UniformOutput',false)));
				event_width_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_run,'UniformOutput',false)));
				event_auc_pop_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_run,'UniformOutput',false)));
				event_auc_pop_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_rest,'UniformOutput',false)));
				event_auc_pop_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_rest,'UniformOutput',false)));
				event_auc_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_run,'UniformOutput',false)));
				event_rise_pop_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_run,'UniformOutput',false)));
				event_rise_pop_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_rest,'UniformOutput',false)));
				event_rise_pop_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_rest,'UniformOutput',false)));
				event_rise_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_run,'UniformOutput',false)));
				event_decay_pop_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_run,'UniformOutput',false)));
				event_decay_pop_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_rest,'UniformOutput',false)));
				event_decay_pop_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_rest,'UniformOutput',false)));
				event_decay_pop_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned,'UniformOutput',false)));
				event_rate_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned(idx),'UniformOutput',false))/session_length;
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned,'UniformOutput',false)));
				event_rate_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned(idx),'UniformOutput',false))/session_length;
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned,'UniformOutput',false)));
				event_rate_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned(idx),'UniformOutput',false))/session_length;
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned,'UniformOutput',false)));
				event_rate_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned(idx),'UniformOutput',false))/session_length;
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned,'UniformOutput',false)));
				event_amp_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned,'UniformOutput',false)));
				event_amp_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned,'UniformOutput',false)));
				event_amp_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned,'UniformOutput',false)));
				event_amp_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned,'UniformOutput',false)));
				event_width_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned,'UniformOutput',false)));
				event_width_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned,'UniformOutput',false)));
				event_width_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned,'UniformOutput',false)));
				event_width_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned,'UniformOutput',false)));
				event_auc_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned,'UniformOutput',false)));
				event_auc_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned,'UniformOutput',false)));
				event_auc_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned,'UniformOutput',false)));
				event_auc_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned,'UniformOutput',false)));
				event_rise_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned,'UniformOutput',false)));
				event_rise_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned,'UniformOutput',false)));
				event_rise_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned,'UniformOutput',false)));
				event_rise_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned,'UniformOutput',false)));
				event_decay_pop_tuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned,'UniformOutput',false)));
				event_decay_pop_tuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned,'UniformOutput',false)));
				event_decay_pop_untuned_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned,'UniformOutput',false)));
				event_decay_pop_untuned_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned_run,'UniformOutput',false)));
				event_rate_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned_run,'UniformOutput',false)));
				event_rate_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_tuned_rest,'UniformOutput',false)));
				event_rate_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_tuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_tuned_rest,'UniformOutput',false)));
				event_rate_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_tuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned_run,'UniformOutput',false)));
				event_rate_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).run_epochs)/size(s_pool(i).data.s.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned_run,'UniformOutput',false)));
				event_rate_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned_run(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).run_epochs)/size(s_pool(i).data.ad.spatial(j).run_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_untuned_rest,'UniformOutput',false)));
				event_rate_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.s.spatial(j).event_peak_untuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.s.spatial(j).rest_epochs)/size(s_pool(i).data.s.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_untuned_rest,'UniformOutput',false)));
				event_rate_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) size(c,1),s_pool(i).data.ad.spatial(j).event_peak_untuned_rest(idx),'UniformOutput',false))/(sum(s_pool(i).data.ad.spatial(j).rest_epochs)/size(s_pool(i).data.ad.spatial(j).rest_epochs,1)*session_length);
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned_run,'UniformOutput',false)));
				event_amp_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_run,'UniformOutput',false)));
				event_amp_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_tuned_rest,'UniformOutput',false)));
				event_amp_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_rest,'UniformOutput',false)));
				event_amp_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned_run,'UniformOutput',false)));
				event_amp_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_run,'UniformOutput',false)));
				event_amp_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_amp_untuned_rest,'UniformOutput',false)));
				event_amp_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_amp_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_rest,'UniformOutput',false)));
				event_amp_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_amp_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned_run,'UniformOutput',false)));
				event_width_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned_run,'UniformOutput',false)));
				event_width_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_tuned_rest,'UniformOutput',false)));
				event_width_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_tuned_rest,'UniformOutput',false)));
				event_width_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned_run,'UniformOutput',false)));
				event_width_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned_run,'UniformOutput',false)));
				event_width_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_width_untuned_rest,'UniformOutput',false)));
				event_width_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_width_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_width_untuned_rest,'UniformOutput',false)));
				event_width_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_width_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned_run,'UniformOutput',false)));
				event_auc_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_run,'UniformOutput',false)));
				event_auc_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_tuned_rest,'UniformOutput',false)));
				event_auc_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_rest,'UniformOutput',false)));
				event_auc_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned_run,'UniformOutput',false)));
				event_auc_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_run,'UniformOutput',false)));
				event_auc_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_auc_untuned_rest,'UniformOutput',false)));
				event_auc_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_auc_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_rest,'UniformOutput',false)));
				event_auc_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_auc_untuned_rest(idx),'UniformOutput',false));
			end	
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned_run,'UniformOutput',false)));
				event_rise_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_run,'UniformOutput',false)));
				event_rise_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_tuned_rest,'UniformOutput',false)));
				event_rise_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_rest,'UniformOutput',false)));
				event_rise_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned_run,'UniformOutput',false)));
				event_rise_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_run,'UniformOutput',false)));
				event_rise_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_rise_untuned_rest,'UniformOutput',false)));
				event_rise_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_rise_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_rest,'UniformOutput',false)));
				event_rise_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_rise_untuned_rest(idx),'UniformOutput',false));
			end	
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned_run,'UniformOutput',false)));
				event_decay_pop_tuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_run,'UniformOutput',false)));
				event_decay_pop_tuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_tuned_rest,'UniformOutput',false)));
				event_decay_pop_tuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_rest,'UniformOutput',false)));
				event_decay_pop_tuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_tuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned_run,'UniformOutput',false)));
				event_decay_pop_untuned_run_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_run,'UniformOutput',false)));
				event_decay_pop_untuned_run_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_run(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_decay_untuned_rest,'UniformOutput',false)));
				event_decay_pop_untuned_rest_s{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.s.spatial(j).event_decay_untuned_rest(idx),'UniformOutput',false));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_rest,'UniformOutput',false)));
				event_decay_pop_untuned_rest_ad{i,j} = cell2mat(cellfun(@(c) mean(c),s_pool(i).data.ad.spatial(j).event_decay_untuned_rest(idx),'UniformOutput',false));
			end	
			try
				fraction_active_ROIs_s{i,j} = s_pool(i).data.s.spatial(j).active_ROI_counts/(s_pool(i).data.s.spatial(j).active_ROI_counts + s_pool(i).data.s.spatial(j).inactive_ROI_counts);
			end
			try
				fraction_active_ROIs_run_s{i,j} =  size(find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_run,'UniformOutput',false))),2)/size(s_pool(i).data.s.spatial(j).event_peak,2);
			end
			try
				fraction_active_ROIs_run_ad{i,j} =  size(find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_run,'UniformOutput',false))),2)/size(s_pool(i).data.ad.spatial(j).event_peak,2);
			end
			try
				fraction_active_ROIs_rest_s{i,j} =  size(find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).event_peak_rest,'UniformOutput',false))),2)/size(s_pool(i).data.s.spatial(j).event_peak,2);
			end
			try
				fraction_active_ROIs_rest_ad{i,j} =  size(find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).event_peak_rest,'UniformOutput',false))),2)/size(s_pool(i).data.ad.spatial(j).event_peak,2);
			end
			try
				fraction_active_ROIs_ad{i,j} = s_pool(i).data.ad.spatial(j).active_ROI_counts/(s_pool(i).data.ad.spatial(j).active_ROI_counts + s_pool(i).data.ad.spatial(j).inactive_ROI_counts);
			end
			try
				fraction_place_cells_s{i,j} = sum(s_pool(i).data.s.spatial(j).all.significant)/s_pool(i).data.s.spatial(j).active_ROI_counts;
			end
			try
				fraction_place_cells_ad{i,j} = sum(s_pool(i).data.ad.spatial(j).all.significant)/s_pool(i).data.ad.spatial(j).active_ROI_counts;
			end
			try
				number_place_fields_s{i,j} = mean(s_pool(i).data.s.spatial(j).all.nFields,'omitnan');
			end
			try
				number_place_fields_ad{i,j} = mean(s_pool(i).data.ad.spatial(j).all.nFields,'omitnan');
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.s.spatial(j).all.fieldWidth,'UniformOutput',false)));
				width_place_fields_s{i,j} = mean(cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.s.spatial(j).all.fieldWidth(idx),'UniformOutput',false)));
			end
			try
				idx = find(cell2mat(cellfun(@(c) ~isempty(c),s_pool(i).data.ad.spatial(j).all.fieldWidth,'UniformOutput',false)));
				width_place_fields_ad{i,j} = mean(cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.ad.spatial(j).all.fieldWidth(idx),'UniformOutput',false)));
			end
			try
				center_place_fields_s{i,j} = s_pool(i).data.s.spatial(j).all.fieldCenters;
			end
			try
				center_place_fields_ad{i,j} = s_pool(i).data.ad.spatial(j).all.fieldCenters;
			end
			try
				center_place_fields_index_s{i,j} = s_pool(i).data.s.spatial(j).all.field_center_index;
			end
			try
				center_place_fields_index_ad{i,j} = s_pool(i).data.ad.spatial(j).all.field_center_index;
			end
			try
				center_place_fields_active_s{i,j} = s_pool(i).data.s.spatial(j).all.field_center_active;
			end
			try
				center_place_fields_active_ad{i,j} = s_pool(i).data.ad.spatial(j).all.field_center_active;
			end
			try
				center_place_fields_index_sorted_s{i,j} = s_pool(i).data.s.spatial(j).all.field_center_sorted_index;
			end
			try
				center_place_fields_index_sorted_ad{i,j} = s_pool(i).data.ad.spatial(j).all.field_center_sorted_index;
			end
			try
				center_place_fields_active_sorted_s{i,j} = s_pool(i).data.s.spatial(j).all.field_center_sorted;
			end
			try
				center_place_fields_active_sorted_ad{i,j} = s_pool(i).data.ad.spatial(j).all.field_center_sorted;
			end
			try
				rate_map_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map;
			end
			try
				rate_map_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map;
			end
			try
				rate_map_z_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_z;
			end
			try
				rate_map_z_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_z;
			end
			try
				rate_map_n_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_n;
			end
			try
				rate_map_n_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_n;
			end
			try
				rate_map_active_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active;
			end
			try
				rate_map_active_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active;
			end
			try
				rate_map_active_z_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_z;
			end
			try
				rate_map_active_z_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_z;
			end
			try
				rate_map_active_n_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_n;
			end
			try
				rate_map_active_n_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_n;
			end
			try
				rate_map_active_sorted_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_sorted;
			end
			try
				rate_map_active_sorted_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_sorted;
			end
			try
				rate_map_active_sorted_z_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_sorted_z;
			end
			try
				rate_map_active_sorted_z_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_sorted_z;
			end
			try
				rate_map_active_sorted_n_s{i,j} = s_pool(i).data.s.spatial(j).all.rate_map_active_sorted_n;
			end
			try
				rate_map_active_sorted_n_ad{i,j} = s_pool(i).data.ad.spatial(j).all.rate_map_active_sorted_n;
			end			
			try
				spatial_info_bits_s{i,j} = mean(s_pool(i).data.s.spatial(j).all.infoContent(s_pool(i).data.s.spatial(j).all.significant),'omitnan');
			end
			try
				spatial_info_bits_ad{i,j} = mean(s_pool(i).data.ad.spatial(j).all.infoContent(s_pool(i).data.ad.spatial(j).all.significant),'omitnan');
			end
			try
				spatial_info_norm_s{i,j} = mean(s_pool(i).data.s.spatial(j).all.normalizedInfo(s_pool(i).data.s.spatial(j).all.significant),'omitnan');
			end
			try
				spatial_info_norm_ad{i,j} = mean(s_pool(i).data.ad.spatial(j).all.normalizedInfo(s_pool(i).data.ad.spatial(j).all.significant),'omitnan');
			end
			try
				roi_pc_binary_s{i,j} = s_pool(i).data.s.roi_pc_binary(:,j);
			end
			try
				roi_pc_binary_ad{i,j} = s_pool(i).data.ad.roi_pc_binary(:,j);
			end
		end
		for j=1:size(s_pool(i).data.s.session_cross,2)
			if(isfield(s_pool(i).data.s.session_cross(j),'comp_id'))
				if (~isempty(s_pool(i).data.s.session_cross(j).comp_id) && ~isempty(s_pool(i).data.s.session_cross(j).TC_corr_z) && ~isempty(s_pool(i).data.s.session_cross(j).PV_corr_map_z))
					try
						TC_corr_z_cross_s{i,j}{1} = s_pool(i).data.s.session_cross(j).comp_id;
						TC_corr_z_cross_s{i,j}{1}(strcmp(TC_corr_z_cross_s{i,j}{1},"")) = [];
						TC_corr_z_cross_s{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.s.session_cross(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_cross_s{i,j}{1} = s_pool(i).data.s.session_cross(j).comp_id;
						PV_corr_z_cross_s{i,j}{1}(strcmp(PV_corr_z_cross_s{i,j}{1},"")) = [];
						PV_corr_z_cross_s{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.s.session_cross(j).PV_corr_map_z,'UniformOutput',false));
					end
				end
			end
		end
		for j=1:size(s_pool(i).data.s.session_pairwise,2)
			if(isfield(s_pool(i).data.s.session_pairwise(j),'comp_id'))
				if (~isempty(s_pool(i).data.s.session_pairwise(j).comp_id) && ~isempty(s_pool(i).data.s.session_pairwise(j).TC_corr_z) && ~isempty(s_pool(i).data.s.session_pairwise(j).PV_corr_map_z))
					try
						TC_corr_z_pair_s{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.s.session_pairwise(j).comp_id,'UniformOutput',false));
						TC_corr_z_pair_s{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.s.session_pairwise(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_pair_s{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.s.session_pairwise(j).comp_id,'UniformOutput',false));
						PV_corr_z_pair_s{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.s.session_pairwise(j).PV_corr_map_z,'UniformOutput',false));
					end
				end
			end
		end
		for j=1:size(s_pool(i).data.s.session_ref,2)
			if(isfield(s_pool(i).data.s.session_ref(j),'comp_id'))
				if (~isempty(s_pool(i).data.s.session_ref(j).comp_id) && ~isempty(s_pool(i).data.s.session_ref(j).TC_corr_z) && ~isempty(s_pool(i).data.s.session_ref(j).PV_corr_map_z))
					try
						TC_corr_z_ref_s{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.s.session_ref(j).comp_id,'UniformOutput',false));
						TC_corr_z_ref_s{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.s.session_ref(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_ref_s{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.s.session_ref(j).comp_id,'UniformOutput',false));
						PV_corr_z_ref_s{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.s.session_ref(j).PV_corr_map_z,'UniformOutput',false));
					end
				end
			end
		end
		for j=1:size(s_pool(i).data.ad.session_cross,2)
			if(isfield(s_pool(i).data.ad.session_cross(j),'comp_id'))
				if (~isempty(s_pool(i).data.ad.session_cross(j).comp_id) && ~isempty(s_pool(i).data.ad.session_cross(j).TC_corr_z) && ~isempty(s_pool(i).data.ad.session_cross(j).PV_corr_map_z))
					try
						TC_corr_z_cross_ad{i,j}{1} = s_pool(i).data.ad.session_cross(j).comp_id;
						TC_corr_z_cross_ad{i,j}{1}(strcmp(TC_corr_z_cross_ad{i,j}{1},"")) = [];
						TC_corr_z_cross_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.ad.session_cross(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_cross_ad{i,j}{1} = s_pool(i).data.ad.session_cross(j).comp_id;
						PV_corr_z_cross_ad{i,j}{1}(strcmp(PV_corr_z_cross_ad{i,j}{1},"")) = [];
						PV_corr_z_cross_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.ad.session_cross(j).PV_corr_map_z,'UniformOutput',false));
					end
				end
			end
		end
		for j=1:size(s_pool(i).data.ad.session_pairwise,2)
			if(isfield(s_pool(i).data.ad.session_pairwise(j),'comp_id'))
				if (~isempty(s_pool(i).data.ad.session_pairwise(j).comp_id) && ~isempty(s_pool(i).data.ad.session_pairwise(j).TC_corr_z) && ~isempty(s_pool(i).data.ad.session_pairwise(j).PV_corr_map_z))
					try
						TC_corr_z_pair_ad{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.ad.session_pairwise(j).comp_id,'UniformOutput',false));
						TC_corr_z_pair_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.ad.session_pairwise(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_pair_ad{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.ad.session_pairwise(j).comp_id,'UniformOutput',false));
						PV_corr_z_pair_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.ad.session_pairwise(j).PV_corr_map_z,'UniformOutput',false));
					end
				end
			end
		end
		for j=1:size(s_pool(i).data.ad.session_ref,2)
			if(isfield(s_pool(i).data.ad.session_ref(j),'comp_id'))
				if (~isempty(s_pool(i).data.ad.session_ref(j).comp_id) && ~isempty(s_pool(i).data.ad.session_ref(j).TC_corr_z) && ~isempty(s_pool(i).data.ad.session_ref(j).PV_corr_map_z))
					try
						TC_corr_z_ref_ad{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.ad.session_ref(j).comp_id,'UniformOutput',false));
						TC_corr_z_ref_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(c,'omitnan'),s_pool(i).data.ad.session_ref(j).TC_corr_z,'UniformOutput',false));
						PV_corr_z_ref_ad{i,j}{1} = string(cellfun(@(c) string(c),s_pool(i).data.ad.session_ref(j).comp_id,'UniformOutput',false));
						PV_corr_z_ref_ad{i,j}{2} = cell2mat(cellfun(@(c) mean(diag(c),'omitnan'),s_pool(i).data.ad.session_ref(j).PV_corr_map_z,'UniformOutput',false));	
					end
				end
			end
		end
	end
%splitting
	%soma
	TC_cross_s_list = strings();
	TC_cross_s_data = NaN();
	for i=1:size(TC_corr_z_cross_s,1) %animals
		for j=1:size(TC_corr_z_cross_s,2) %sessions
			if ~isempty(TC_corr_z_cross_s{i,j})
				TC_cross_s_list = cat(1,TC_cross_s_list,TC_corr_z_cross_s{i,j}{1});
				TC_cross_s_data = cat(1,TC_cross_s_data,TC_corr_z_cross_s{i,j}{2});
			end
		end
	end
	TC_cross_s = {TC_cross_s_list,TC_cross_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_cross_s{1}));
	temp_id = TC_cross_s{1}(temp_idx);
	temp_data = TC_cross_s{2}(temp_idx);
	TC_cross_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_cross_s{1}));
	temp_id = TC_cross_s{1}(temp_idx);
	temp_data = TC_cross_s{2}(temp_idx);
	TC_cross_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_cross_s{1}));
	temp_id = TC_cross_s{1}(temp_idx);
	temp_data = TC_cross_s{2}(temp_idx);
	TC_cross_s_LECgaba = {temp_id,temp_data};
	TC_pair_s_list = strings();
	TC_pair_s_data = NaN();
	for i=1:size(TC_corr_z_pair_s,1) %animals
		for j=1:size(TC_corr_z_pair_s,2) %sessions
			if ~isempty(TC_corr_z_pair_s{i,j})
				TC_pair_s_list = cat(1,TC_pair_s_list,TC_corr_z_pair_s{i,j}{1});
				TC_pair_s_data = cat(1,TC_pair_s_data,TC_corr_z_pair_s{i,j}{2});
			end
		end
	end
	TC_pair_s = {TC_pair_s_list,TC_pair_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_pair_s{1}));
	temp_id = TC_pair_s{1}(temp_idx);
	temp_data = TC_pair_s{2}(temp_idx);
	TC_pair_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_pair_s{1}));
	temp_id = TC_pair_s{1}(temp_idx);
	temp_data = TC_pair_s{2}(temp_idx);
	TC_pair_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_pair_s{1}));
	temp_id = TC_pair_s{1}(temp_idx);
	temp_data = TC_pair_s{2}(temp_idx);
	TC_pair_s_LECgaba = {temp_id,temp_data};
	TC_ref_s_list = strings();
	TC_ref_s_data = NaN();
	for i=1:size(TC_corr_z_ref_s,1) %animals
		for j=1:size(TC_corr_z_ref_s,2) %sessions
			if ~isempty(TC_corr_z_ref_s{i,j})
				TC_ref_s_list = cat(1,TC_ref_s_list,TC_corr_z_ref_s{i,j}{1});
				TC_ref_s_data = cat(1,TC_ref_s_data,TC_corr_z_ref_s{i,j}{2});
			end
		end
	end
	TC_ref_s = {TC_ref_s_list,TC_ref_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_ref_s{1}));
	temp_id = TC_ref_s{1}(temp_idx);
	temp_data = TC_ref_s{2}(temp_idx);
	TC_ref_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_ref_s{1}));
	temp_id = TC_ref_s{1}(temp_idx);
	temp_data = TC_ref_s{2}(temp_idx);
	TC_ref_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_ref_s{1}));
	temp_id = TC_ref_s{1}(temp_idx);
	temp_data = TC_ref_s{2}(temp_idx);
	TC_ref_s_LECgaba = {temp_id,temp_data};
	PV_cross_s_list = strings();
	PV_cross_s_data = NaN();
	for i=1:size(PV_corr_z_cross_s,1) %animals
		for j=1:size(PV_corr_z_cross_s,2) %sessions
			if ~isempty(PV_corr_z_cross_s{i,j})
				PV_cross_s_list = cat(1,PV_cross_s_list,PV_corr_z_cross_s{i,j}{1});
				PV_cross_s_data = cat(1,PV_cross_s_data,PV_corr_z_cross_s{i,j}{2});
			end
		end
	end
	PV_cross_s = {PV_cross_s_list,PV_cross_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_cross_s{1}));
	temp_id = PV_cross_s{1}(temp_idx);
	temp_data = PV_cross_s{2}(temp_idx);
	PV_cross_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_cross_s{1}));
	temp_id = PV_cross_s{1}(temp_idx);
	temp_data = PV_cross_s{2}(temp_idx);
	PV_cross_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_cross_s{1}));
	temp_id = PV_cross_s{1}(temp_idx);
	temp_data = PV_cross_s{2}(temp_idx);
	PV_cross_s_LECgaba = {temp_id,temp_data};
	PV_pair_s_list = strings();
	PV_pair_s_data = NaN();
	for i=1:size(PV_corr_z_pair_s,1) %animals
		for j=1:size(PV_corr_z_pair_s,2) %sessions
			if ~isempty(PV_corr_z_pair_s{i,j})
				PV_pair_s_list = cat(1,PV_pair_s_list,PV_corr_z_pair_s{i,j}{1});
				PV_pair_s_data = cat(1,PV_pair_s_data,PV_corr_z_pair_s{i,j}{2});
			end
		end
	end
	PV_pair_s = {PV_pair_s_list,PV_pair_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_pair_s{1}));
	temp_id = PV_pair_s{1}(temp_idx);
	temp_data = PV_pair_s{2}(temp_idx);
	PV_pair_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_pair_s{1}));
	temp_id = PV_pair_s{1}(temp_idx);
	temp_data = PV_pair_s{2}(temp_idx);
	PV_pair_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_pair_s{1}));
	temp_id = PV_pair_s{1}(temp_idx);
	temp_data = PV_pair_s{2}(temp_idx);
	PV_pair_s_LECgaba = {temp_id,temp_data};
	PV_ref_s_list = strings();
	PV_ref_s_data = NaN();
	for i=1:size(PV_corr_z_ref_s,1) %animals
		for j=1:size(PV_corr_z_ref_s,2) %sessions
			if ~isempty(PV_corr_z_ref_s{i,j})
				PV_ref_s_list = cat(1,PV_ref_s_list,PV_corr_z_ref_s{i,j}{1});
				PV_ref_s_data = cat(1,PV_ref_s_data,PV_corr_z_ref_s{i,j}{2});
			end
		end
	end
	PV_ref_s = {PV_ref_s_list,PV_ref_s_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_ref_s{1}));
	temp_id = PV_ref_s{1}(temp_idx);
	temp_data = PV_ref_s{2}(temp_idx);
	PV_ref_s_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_ref_s{1}));
	temp_id = PV_ref_s{1}(temp_idx);
	temp_data = PV_ref_s{2}(temp_idx);
	PV_ref_s_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_ref_s{1}));
	temp_id = PV_ref_s{1}(temp_idx);
	temp_data = PV_ref_s{2}(temp_idx);
	PV_ref_s_LECgaba = {temp_id,temp_data};
	%dendrites
	TC_cross_ad_list = strings();
	TC_cross_ad_data = NaN();
	for i=1:size(TC_corr_z_cross_ad,1) %animals
		for j=1:size(TC_corr_z_cross_ad,2) %sessions
			if ~isempty(TC_corr_z_cross_ad{i,j})
				TC_cross_ad_list = cat(1,TC_cross_ad_list,TC_corr_z_cross_ad{i,j}{1});
				TC_cross_ad_data = cat(1,TC_cross_ad_data,TC_corr_z_cross_ad{i,j}{2});
			end
		end
	end
	TC_cross_ad = {TC_cross_ad_list,TC_cross_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_cross_ad{1}));
	temp_id = TC_cross_ad{1}(temp_idx);
	temp_data = TC_cross_ad{2}(temp_idx);
	TC_cross_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_cross_ad{1}));
	temp_id = TC_cross_ad{1}(temp_idx);
	temp_data = TC_cross_ad{2}(temp_idx);
	TC_cross_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_cross_ad{1}));
	temp_id = TC_cross_ad{1}(temp_idx);
	temp_data = TC_cross_ad{2}(temp_idx);
	TC_cross_ad_LECgaba = {temp_id,temp_data};
	TC_pair_ad_list = strings();
	TC_pair_ad_data = NaN();
	for i=1:size(TC_corr_z_pair_ad,1) %animals
		for j=1:size(TC_corr_z_pair_ad,2) %sessions
			if ~isempty(TC_corr_z_pair_ad{i,j})
				TC_pair_ad_list = cat(1,TC_pair_ad_list,TC_corr_z_pair_ad{i,j}{1});
				TC_pair_ad_data = cat(1,TC_pair_ad_data,TC_corr_z_pair_ad{i,j}{2});
			end
		end
	end
	TC_pair_ad = {TC_pair_ad_list,TC_pair_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_pair_ad{1}));
	temp_id = TC_pair_ad{1}(temp_idx);
	temp_data = TC_pair_ad{2}(temp_idx);
	TC_pair_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_pair_ad{1}));
	temp_id = TC_pair_ad{1}(temp_idx);
	temp_data = TC_pair_ad{2}(temp_idx);
	TC_pair_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_pair_ad{1}));
	temp_id = TC_pair_ad{1}(temp_idx);
	temp_data = TC_pair_ad{2}(temp_idx);
	TC_pair_ad_LECgaba = {temp_id,temp_data};
	TC_ref_ad_list = strings();
	TC_ref_ad_data = NaN();
	for i=1:size(TC_corr_z_ref_ad,1) %animals
		for j=1:size(TC_corr_z_ref_ad,2) %sessions
			if ~isempty(TC_corr_z_ref_ad{i,j})
				TC_ref_ad_list = cat(1,TC_ref_ad_list,TC_corr_z_ref_ad{i,j}{1});
				TC_ref_ad_data = cat(1,TC_ref_ad_data,TC_corr_z_ref_ad{i,j}{2});
			end
		end
	end
	TC_ref_ad = {TC_ref_ad_list,TC_ref_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),TC_ref_ad{1}));
	temp_id = TC_ref_ad{1}(temp_idx);
	temp_data = TC_ref_ad{2}(temp_idx);
	TC_ref_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),TC_ref_ad{1}));
	temp_id = TC_ref_ad{1}(temp_idx);
	temp_data = TC_ref_ad{2}(temp_idx);
	TC_ref_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),TC_ref_ad{1}));
	temp_id = TC_ref_ad{1}(temp_idx);
	temp_data = TC_ref_ad{2}(temp_idx);
	TC_ref_ad_LECgaba = {temp_id,temp_data};
	PV_cross_ad_list = strings();
	PV_cross_ad_data = NaN();
	for i=1:size(PV_corr_z_cross_ad,1) %animals
		for j=1:size(PV_corr_z_cross_ad,2) %sessions
			if ~isempty(PV_corr_z_cross_ad{i,j})
				PV_cross_ad_list = cat(1,PV_cross_ad_list,PV_corr_z_cross_ad{i,j}{1});
				PV_cross_ad_data = cat(1,PV_cross_ad_data,PV_corr_z_cross_ad{i,j}{2});
			end
		end
	end
	PV_cross_ad = {PV_cross_ad_list,PV_cross_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_cross_ad{1}));
	temp_id = PV_cross_ad{1}(temp_idx);
	temp_data = PV_cross_ad{2}(temp_idx);
	PV_cross_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_cross_ad{1}));
	temp_id = PV_cross_ad{1}(temp_idx);
	temp_data = PV_cross_ad{2}(temp_idx);
	PV_cross_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_cross_ad{1}));
	temp_id = PV_cross_ad{1}(temp_idx);
	temp_data = PV_cross_ad{2}(temp_idx);
	PV_cross_ad_LECgaba = {temp_id,temp_data};
	PV_pair_ad_list = strings();
	PV_pair_ad_data = NaN();
	for i=1:size(PV_corr_z_pair_ad,1) %animals
		for j=1:size(PV_corr_z_pair_ad,2) %sessions
			if ~isempty(PV_corr_z_pair_ad{i,j})
				PV_pair_ad_list = cat(1,PV_pair_ad_list,PV_corr_z_pair_ad{i,j}{1});
				PV_pair_ad_data = cat(1,PV_pair_ad_data,PV_corr_z_pair_ad{i,j}{2});
			end
		end
	end
	PV_pair_ad = {PV_pair_ad_list,PV_pair_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_pair_ad{1}));
	temp_id = PV_pair_ad{1}(temp_idx);
	temp_data = PV_pair_ad{2}(temp_idx);
	PV_pair_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_pair_ad{1}));
	temp_id = PV_pair_ad{1}(temp_idx);
	temp_data = PV_pair_ad{2}(temp_idx);
	PV_pair_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_pair_ad{1}));
	temp_id = PV_pair_ad{1}(temp_idx);
	temp_data = PV_pair_ad{2}(temp_idx);
	PV_pair_ad_LECgaba = {temp_id,temp_data};
	PV_ref_ad_list = strings();
	PV_ref_ad_data = NaN();
	for i=1:size(PV_corr_z_ref_ad,1) %animals
		for j=1:size(PV_corr_z_ref_ad,2) %sessions
			if ~isempty(PV_corr_z_ref_ad{i,j})
				PV_ref_ad_list = cat(1,PV_ref_ad_list,PV_corr_z_ref_ad{i,j}{1});
				PV_ref_ad_data = cat(1,PV_ref_ad_data,PV_corr_z_ref_ad{i,j}{2});
			end
		end
	end
	PV_ref_ad = {PV_ref_ad_list,PV_ref_ad_data};
	temp_idx = find(cellfun(@(c) contains(c,control_id),PV_ref_ad{1}));
	temp_id = PV_ref_ad{1}(temp_idx);
	temp_data = PV_ref_ad{2}(temp_idx);
	PV_ref_ad_control = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECglu_id_alt),PV_ref_ad{1}));
	temp_id = PV_ref_ad{1}(temp_idx);
	temp_data = PV_ref_ad{2}(temp_idx);
	PV_ref_ad_LECglu = {temp_id,temp_data};
	temp_idx = find(cellfun(@(c) contains(c,LECgaba_id_alt),PV_ref_ad{1}));
	temp_id = PV_ref_ad{1}(temp_idx);
	temp_data = PV_ref_ad{2}(temp_idx);
	PV_ref_ad_LECgaba = {temp_id,temp_data};
	%soma
	event_rate_run_s_control = {};
	event_rate_rest_s_control = {};
	event_amp_run_s_control = {};
	event_amp_rest_s_control = {};
	event_width_run_s_control = {};
	event_width_rest_s_control = {};
	event_auc_run_s_control = {};
	event_auc_rest_s_control = {};
	event_rise_run_s_control = {};
	event_rise_rest_s_control = {};
	event_decay_run_s_control = {};
	event_decay_rest_s_control = {};
	event_rate_tuned_s_control = {};
	event_rate_untuned_s_control = {};
	event_amp_tuned_s_control = {};
	event_amp_untuned_s_control = {};
	event_width_tuned_s_control = {};
	event_width_untuned_s_control = {};
	event_auc_tuned_s_control = {};
	event_auc_untuned_s_control = {};
	event_rise_tuned_s_control = {};
	event_rise_untuned_s_control = {};
	event_decay_tuned_s_control = {};
	event_decay_untuned_s_control = {};
	event_rate_tuned_run_s_control = {};
	event_rate_tuned_rest_s_control = {};
	event_amp_tuned_run_s_control = {};
	event_amp_tuned_rest_s_control = {};
	event_width_tuned_run_s_control = {};
	event_width_tuned_rest_s_control = {};
	event_auc_tuned_run_s_control = {};
	event_auc_tuned_rest_s_control = {};
	event_rise_tuned_run_s_control = {};
	event_rise_tuned_rest_s_control = {};
	event_decay_tuned_run_s_control = {};
	event_decay_tuned_rest_s_control = {};
	event_rate_untuned_run_s_control = {};
	event_rate_untuned_rest_s_control = {};
	event_amp_untuned_run_s_control = {};
	event_amp_untuned_rest_s_control = {};
	event_width_untuned_run_s_control = {};
	event_width_untuned_rest_s_control = {};
	event_auc_untuned_run_s_control = {};
	event_auc_untuned_rest_s_control = {};
	event_rise_untuned_run_s_control = {};
	event_rise_untuned_rest_s_control = {};
	event_decay_untuned_run_s_control = {};
	event_decay_untuned_rest_s_control = {};
	event_rate_pop_run_s_control = {};
	event_rate_pop_rest_s_control = {};
	event_amp_pop_run_s_control = {};
	event_amp_pop_rest_s_control = {};
	event_width_pop_run_s_control = {};
	event_width_pop_rest_s_control = {};
	event_auc_pop_run_s_control = {};
	event_auc_pop_rest_s_control = {};
	event_rise_pop_run_s_control = {};
	event_rise_pop_rest_s_control = {};
	event_decay_pop_run_s_control = {};
	event_decay_pop_rest_s_control = {};
	event_rate_pop_tuned_s_control = {};
	event_rate_pop_untuned_s_control = {};
	event_amp_pop_tuned_s_control = {};
	event_amp_pop_untuned_s_control = {};
	event_width_pop_tuned_s_control = {};
	event_width_pop_untuned_s_control = {};
	event_auc_pop_tuned_s_control = {};
	event_auc_pop_untuned_s_control = {};
	event_rise_pop_tuned_s_control = {};
	event_rise_pop_untuned_s_control = {};
	event_decay_pop_tuned_s_control = {};
	event_decay_pop_untuned_s_control = {};
	event_rate_pop_tuned_run_s_control = {};
	event_rate_pop_tuned_rest_s_control = {};
	event_amp_pop_tuned_run_s_control = {};
	event_amp_pop_tuned_rest_s_control = {};
	event_width_pop_tuned_run_s_control = {};
	event_width_pop_tuned_rest_s_control = {};
	event_auc_pop_tuned_run_s_control = {};
	event_auc_pop_tuned_rest_s_control = {};
	event_rise_pop_tuned_run_s_control = {};
	event_rise_pop_tuned_rest_s_control = {};
	event_decay_pop_tuned_run_s_control = {};
	event_decay_pop_tuned_rest_s_control = {};
	event_rate_pop_untuned_run_s_control = {};
	event_rate_pop_untuned_rest_s_control = {};
	event_amp_pop_untuned_run_s_control = {};
	event_amp_pop_untuned_rest_s_control = {};
	event_width_pop_untuned_run_s_control = {};
	event_width_pop_untuned_rest_s_control = {};
	event_auc_pop_untuned_run_s_control = {};
	event_auc_pop_untuned_rest_s_control = {};
	event_rise_pop_untuned_run_s_control = {};
	event_rise_pop_untuned_rest_s_control = {};
	event_decay_pop_untuned_run_s_control = {};
	event_decay_pop_untuned_rest_s_control = {};
	fraction_active_ROIs_s_control = {};
	fraction_active_ROIs_run_s_control = {};
	fraction_active_ROIs_rest_s_control = {};
	fraction_place_cells_s_control = {};
	number_place_fields_s_control = {};
	width_place_fields_s_control = {};
	center_place_fields_s_control = {};
	center_place_fields_index_s_control = {};
	center_place_fields_active_s_control = {};
	center_place_fields_index_sorted_s_control = {};
	center_place_fields_active_sorted_s_control = {};
	rate_map_s_control = {};
	rate_map_z_s_control = {};
	rate_map_n_s_control = {};
	rate_map_active_s_control = {};
	rate_map_active_z_s_control = {};
	rate_map_active_n_s_control = {};
	rate_map_active_sorted_s_control = {};
	rate_map_active_sorted_z_s_control = {};
	rate_map_active_sorted_n_s_control = {};
	spatial_info_bits_s_control = {};
	spatial_info_norm_s_control = {};
	roi_pc_binary_s_control = {};
	%dendrites
	event_rate_run_ad_control = {};
	event_rate_rest_ad_control = {};
	event_amp_run_ad_control = {};
	event_amp_rest_ad_control = {};
	event_width_run_ad_control = {};
	event_width_rest_ad_control = {};
	event_auc_run_ad_control = {};
	event_auc_rest_ad_control = {};
	event_rise_run_ad_control = {};
	event_rise_rest_ad_control = {};
	event_decay_run_ad_control = {};
	event_decay_rest_ad_control = {};
	event_rate_tuned_ad_control = {};
	event_rate_untuned_ad_control = {};
	event_amp_tuned_ad_control = {};
	event_amp_untuned_ad_control = {};
	event_width_tuned_ad_control = {};
	event_width_untuned_ad_control = {};
	event_auc_tuned_ad_control = {};
	event_auc_untuned_ad_control = {};
	event_rise_tuned_ad_control = {};
	event_rise_untuned_ad_control = {};
	event_decay_tuned_ad_control = {};
	event_decay_untuned_ad_control = {};
	event_rate_tuned_run_ad_control = {};
	event_rate_tuned_rest_ad_control = {};
	event_amp_tuned_run_ad_control = {};
	event_amp_tuned_rest_ad_control = {};
	event_width_tuned_run_ad_control = {};
	event_width_tuned_rest_ad_control = {};
	event_auc_tuned_run_ad_control = {};
	event_auc_tuned_rest_ad_control = {};
	event_rise_tuned_run_ad_control = {};
	event_rise_tuned_rest_ad_control = {};
	event_decay_tuned_run_ad_control = {};
	event_decay_tuned_rest_ad_control = {};
	event_rate_untuned_run_ad_control = {};
	event_rate_untuned_rest_ad_control = {};
	event_amp_untuned_run_ad_control = {};
	event_amp_untuned_rest_ad_control = {};
	event_width_untuned_run_ad_control = {};
	event_width_untuned_rest_ad_control = {};
	event_auc_untuned_run_ad_control = {};
	event_auc_untuned_rest_ad_control = {};
	event_rise_untuned_run_ad_control = {};
	event_rise_untuned_rest_ad_control = {};
	event_decay_untuned_run_ad_control = {};
	event_decay_untuned_rest_ad_control = {};
	event_rate_pop_run_ad_control = {};
	event_rate_pop_rest_ad_control = {};
	event_amp_pop_run_ad_control = {};
	event_amp_pop_rest_ad_control = {};
	event_width_pop_run_ad_control = {};
	event_width_pop_rest_ad_control = {};
	event_auc_pop_run_ad_control = {};
	event_auc_pop_rest_ad_control = {};
	event_rise_pop_run_ad_control = {};
	event_rise_pop_rest_ad_control = {};
	event_decay_pop_run_ad_control = {};
	event_decay_pop_rest_ad_control = {};
	event_rate_pop_tuned_ad_control = {};
	event_rate_pop_untuned_ad_control = {};
	event_amp_pop_tuned_ad_control = {};
	event_amp_pop_untuned_ad_control = {};
	event_width_pop_tuned_ad_control = {};
	event_width_pop_untuned_ad_control = {};
	event_auc_pop_tuned_ad_control = {};
	event_auc_pop_untuned_ad_control = {};
	event_rise_pop_tuned_ad_control = {};
	event_rise_pop_untuned_ad_control = {};
	event_decay_pop_tuned_ad_control = {};
	event_decay_pop_untuned_ad_control = {};
	event_rate_pop_tuned_run_ad_control = {};
	event_rate_pop_tuned_rest_ad_control = {};
	event_amp_pop_tuned_run_ad_control = {};
	event_amp_pop_tuned_rest_ad_control = {};
	event_width_pop_tuned_run_ad_control = {};
	event_width_pop_tuned_rest_ad_control = {};
	event_auc_pop_tuned_run_ad_control = {};
	event_auc_pop_tuned_rest_ad_control = {};
	event_rise_pop_tuned_run_ad_control = {};
	event_rise_pop_tuned_rest_ad_control = {};
	event_decay_pop_tuned_run_ad_control = {};
	event_decay_pop_tuned_rest_ad_control = {};
	event_rate_pop_untuned_run_ad_control = {};
	event_rate_pop_untuned_rest_ad_control = {};
	event_amp_pop_untuned_run_ad_control = {};
	event_amp_pop_untuned_rest_ad_control = {};
	event_width_pop_untuned_run_ad_control = {};
	event_width_pop_untuned_rest_ad_control = {};
	event_auc_pop_untuned_run_ad_control = {};
	event_auc_pop_untuned_rest_ad_control = {};
	event_rise_pop_untuned_run_ad_control = {};
	event_rise_pop_untuned_rest_ad_control = {};
	event_decay_pop_untuned_run_ad_control = {};
	event_decay_pop_untuned_rest_ad_control = {};
	fraction_active_ROIs_ad_control = {};
	fraction_active_ROIs_run_ad_control = {};
	fraction_active_ROIs_rest_ad_control = {};
	fraction_place_cells_ad_control = {};
	number_place_fields_ad_control = {};
	width_place_fields_ad_control = {};
	center_place_fields_ad_control = {};
	center_place_fields_index_ad_control = {};
	center_place_fields_active_ad_control = {};
	center_place_fields_index_sorted_ad_control = {};
	center_place_fields_active_sorted_ad_control = {};
	rate_map_ad_control = {};
	rate_map_z_ad_control = {};
	rate_map_n_ad_control = {};
	rate_map_active_ad_control = {};
	rate_map_active_z_ad_control = {};
	rate_map_active_n_ad_control = {};
	rate_map_active_sorted_ad_control = {};
	rate_map_active_sorted_z_ad_control = {};
	rate_map_active_sorted_n_ad_control = {};
	spatial_info_bits_ad_control = {};
	spatial_info_norm_ad_control = {};
	roi_pc_binary_ad_control = {};
	%correlations
	TC_corr_z_cross_s_control = {};
	TC_corr_z_cross_ad_control = {};
	PV_corr_z_cross_s_control = {};
	PV_corr_z_cross_ad_control = {};
	TC_corr_z_pair_s_control = {};
	TC_corr_z_pair_ad_control = {};
	PV_corr_z_pair_s_control = {};
	PV_corr_z_pair_ad_control = {};
	TC_corr_z_ref_s_control = {};
	TC_corr_z_ref_ad_control = {};
	PV_corr_z_ref_s_control = {};
	PV_corr_z_ref_ad_control = {};
	for i=1:size(control_sessions,2) %session groups
		for j=1:size(control_id,2) %aminals
			m = find(cellfun(@(c) contains(control_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,control_sessions{i})),session_id(m),'UniformOutput',false));
			%soma
			event_rate_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_s_control{i,2}(1:size(idx,1),j) = event_rate_run_s(m,idx)';
			end
			event_rate_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_rest_s(m,idx)';
			end
			event_amp_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_s_control{i,2}(1:size(idx,1),j) = event_amp_run_s(m,idx)';
			end
			event_amp_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_rest_s(m,idx)';
			end
			event_width_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_s_control{i,2}(1:size(idx,1),j) = event_width_run_s(m,idx)';
			end
			event_width_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_s_control{i,2}(1:size(idx,1),j) = event_width_rest_s(m,idx)';
			end
			event_auc_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_s_control{i,2}(1:size(idx,1),j) = event_auc_run_s(m,idx)';
			end
			event_auc_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_rest_s(m,idx)';
			end
			event_rise_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_s_control{i,2}(1:size(idx,1),j) = event_rise_run_s(m,idx)';
			end
			event_rise_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_rest_s(m,idx)';
			end
			event_decay_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_s_control{i,2}(1:size(idx,1),j) = event_decay_run_s(m,idx)';
			end
			event_decay_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_rest_s(m,idx)';
			end
			event_rate_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_run_s(m,idx)';
			end
			event_rate_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_rest_s(m,idx)';
			end
			event_amp_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_run_s(m,idx)';
			end
			event_amp_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_rest_s(m,idx)';
			end
			event_width_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_s_control{i,2}(1:size(idx,1),j) = event_width_pop_run_s(m,idx)';
			end
			event_width_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_width_pop_rest_s(m,idx)';
			end
			event_auc_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_run_s(m,idx)';
			end
			event_auc_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_rest_s(m,idx)';
			end
			event_rise_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_run_s(m,idx)';
			end
			event_rise_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_rest_s(m,idx)';
			end
			event_decay_pop_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_run_s(m,idx)';
			end
			event_decay_pop_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_rest_s(m,idx)';
			end
			fraction_active_ROIs_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_s_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_s(m,idx)';
			end
			fraction_active_ROIs_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_s_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_s(m,idx)';
			end
			fraction_active_ROIs_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_s_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_s(m,idx)';
			end
			fraction_place_cells_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_s_control{i,2}(1:size(idx,1),j) = fraction_place_cells_s(m,idx)';
			end
			number_place_fields_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_s_control{i,2}(1:size(idx,1),j) = number_place_fields_s(m,idx)';
			end
			width_place_fields_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_s_control{i,2}(1:size(idx,1),j) = width_place_fields_s(m,idx)';
			end
			center_place_fields_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_s_control{i,2}(1:size(idx,1),j) = center_place_fields_s(m,idx)';
			end
			center_place_fields_index_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_s_control{i,2}(1:size(idx,1),j) = center_place_fields_index_s(m,idx)';
			end
			center_place_fields_active_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_s_control{i,2}(1:size(idx,1),j) = center_place_fields_active_s(m,idx)';
			end
			center_place_fields_index_sorted_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_s_control{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_s(m,idx)';
			end
			center_place_fields_active_sorted_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_s_control{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_s(m,idx)';
			end
			rate_map_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_s_control{i,2}(1:size(idx,1),j) = rate_map_s(m,idx)';
			end
			rate_map_z_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_s_control{i,2}(1:size(idx,1),j) = rate_map_z_s(m,idx)';
			end
			rate_map_n_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_s_control{i,2}(1:size(idx,1),j) = rate_map_n_s(m,idx)';
			end
			rate_map_active_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_s_control{i,2}(1:size(idx,1),j) = rate_map_active_s(m,idx)';
			end
			rate_map_active_z_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_s_control{i,2}(1:size(idx,1),j) = rate_map_active_z_s(m,idx)';
			end
			rate_map_active_n_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_s_control{i,2}(1:size(idx,1),j) = rate_map_active_n_s(m,idx)';
			end
			rate_map_active_sorted_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_s_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_s(m,idx)';
			end
			rate_map_active_sorted_z_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_s_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_s(m,idx)';
			end
			rate_map_active_sorted_n_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_s_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_s(m,idx)';
			end
			spatial_info_bits_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_s_control{i,2}(1:size(idx,1),j) = spatial_info_bits_s(m,idx)';
			end
			spatial_info_norm_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_s_control{i,2}(1:size(idx,1),j) = spatial_info_norm_s(m,idx)';
			end
			event_rate_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_s_control{i,2}(1:size(idx,1),j) = event_rate_tuned_s(m,idx)';
			end
			event_rate_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_s_control{i,2}(1:size(idx,1),j) = event_rate_untuned_s(m,idx)';
			end
			event_amp_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_s_control{i,2}(1:size(idx,1),j) = event_amp_tuned_s(m,idx)';
			end
			event_amp_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_s_control{i,2}(1:size(idx,1),j) = event_amp_untuned_s(m,idx)';
			end
			event_width_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_s_control{i,2}(1:size(idx,1),j) = event_width_tuned_s(m,idx)';
			end
			event_width_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_s_control{i,2}(1:size(idx,1),j) = event_width_untuned_s(m,idx)';
			end
			event_auc_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_s_control{i,2}(1:size(idx,1),j) = event_auc_tuned_s(m,idx)';
			end
			event_auc_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_s_control{i,2}(1:size(idx,1),j) = event_auc_untuned_s(m,idx)';
			end
			event_rise_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_s_control{i,2}(1:size(idx,1),j) = event_rise_tuned_s(m,idx)';
			end
			event_rise_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_s_control{i,2}(1:size(idx,1),j) = event_rise_untuned_s(m,idx)';
			end
			event_decay_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_s_control{i,2}(1:size(idx,1),j) = event_decay_tuned_s(m,idx)';
			end
			event_decay_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_s_control{i,2}(1:size(idx,1),j) = event_decay_untuned_s(m,idx)';
			end
			event_rate_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_rate_tuned_run_s(m,idx)';
			end
			event_rate_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_s(m,idx)';
			end
			event_amp_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_amp_tuned_run_s(m,idx)';
			end
			event_amp_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_s(m,idx)';
			end
			event_width_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_width_tuned_run_s(m,idx)';
			end
			event_width_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_width_tuned_rest_s(m,idx)';
			end
			event_auc_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_auc_tuned_run_s(m,idx)';
			end
			event_auc_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_s(m,idx)';
			end
			event_rise_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_rise_tuned_run_s(m,idx)';
			end
			event_rise_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_s(m,idx)';
			end
			event_decay_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_decay_tuned_run_s(m,idx)';
			end
			event_decay_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_s(m,idx)';
			end
			event_rate_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_rate_untuned_run_s(m,idx)';
			end
			event_rate_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_s(m,idx)';
			end
			event_amp_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_amp_untuned_run_s(m,idx)';
			end
			event_amp_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_s(m,idx)';
			end
			event_width_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_width_untuned_run_s(m,idx)';
			end
			event_width_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_width_untuned_rest_s(m,idx)';
			end
			event_auc_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_auc_untuned_run_s(m,idx)';
			end
			event_auc_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_s(m,idx)';
			end
			event_rise_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_rise_untuned_run_s(m,idx)';
			end
			event_rise_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_s(m,idx)';
			end
			event_decay_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_decay_untuned_run_s(m,idx)';
			end
			event_decay_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_s(m,idx)';
			end
			event_rate_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_s(m,idx)';
			end
			event_rate_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_s(m,idx)';
			end
			event_amp_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_s(m,idx)';
			end
			event_amp_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_s(m,idx)';
			end
			event_width_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_s(m,idx)';
			end
			event_width_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_s(m,idx)';
			end
			event_auc_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_s(m,idx)';
			end
			event_auc_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_s(m,idx)';
			end
			event_rise_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_s(m,idx)';
			end
			event_rise_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_s(m,idx)';
			end
			event_decay_pop_tuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_s(m,idx)';
			end
			event_decay_pop_untuned_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_s(m,idx)';
			end
			event_rate_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_s(m,idx)';
			end
			event_rate_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_s(m,idx)';
			end
			event_amp_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_s(m,idx)';
			end
			event_amp_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_s(m,idx)';
			end
			event_width_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_s(m,idx)';
			end
			event_width_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_s(m,idx)';
			end
			event_auc_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_s(m,idx)';
			end
			event_auc_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_s(m,idx)';
			end
			event_rise_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_s(m,idx)';
			end
			event_rise_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_s(m,idx)';
			end
			event_decay_pop_tuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_s(m,idx)';
			end
			event_decay_pop_tuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_s(m,idx)';
			end
			event_rate_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_s(m,idx)';
			end
			event_rate_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_s(m,idx)';
			end
			event_amp_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_s(m,idx)';
			end
			event_amp_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_s(m,idx)';
			end
			event_width_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_s(m,idx)';
			end
			event_width_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_s(m,idx)';
			end
			event_auc_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_s(m,idx)';
			end
			event_auc_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_s(m,idx)';
			end
			event_rise_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_s(m,idx)';
			end
			event_rise_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_s(m,idx)';
			end
			event_decay_pop_untuned_run_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_s(m,idx)';
			end
			event_decay_pop_untuned_rest_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_s_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_s(m,idx)';
			end
			roi_pc_binary_s_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_s_control{i,2}(1:size(idx,1),j) = roi_pc_binary_s(m,idx)';
			end
			%dendrites
			event_rate_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_run_ad(m,idx)';
			end
			event_rate_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_rest_ad(m,idx)';
			end
			event_amp_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_run_ad(m,idx)';
			end
			event_amp_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_rest_ad(m,idx)';
			end
			event_width_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_ad_control{i,2}(1:size(idx,1),j) = event_width_run_ad(m,idx)';
			end
			event_width_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_rest_ad(m,idx)';
			end
			event_auc_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_run_ad(m,idx)';
			end
			event_auc_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_rest_ad(m,idx)';
			end
			event_rise_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_run_ad(m,idx)';
			end
			event_rise_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_rest_ad(m,idx)';
			end
			event_decay_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_run_ad(m,idx)';
			end
			event_decay_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_rest_ad(m,idx)';
			end
			event_rate_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_run_ad(m,idx)';
			end
			event_rate_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_rest_ad(m,idx)';
			end
			event_amp_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_run_ad(m,idx)';
			end
			event_amp_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_rest_ad(m,idx)';
			end
			event_width_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_run_ad(m,idx)';
			end
			event_width_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_rest_ad(m,idx)';
			end
			event_auc_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_run_ad(m,idx)';
			end
			event_auc_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_rest_ad(m,idx)';
			end
			event_rise_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_run_ad(m,idx)';
			end
			event_rise_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_rest_ad(m,idx)';
			end
			event_decay_pop_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_run_ad(m,idx)';
			end
			event_decay_pop_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_rest_ad(m,idx)';
			end
			fraction_active_ROIs_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_ad_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_ad(m,idx)';
			end
			fraction_active_ROIs_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_ad_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_ad(m,idx)';
			end
			fraction_active_ROIs_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_ad_control{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_ad(m,idx)';
			end
			fraction_place_cells_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_ad_control{i,2}(1:size(idx,1),j) = fraction_place_cells_ad(m,idx)';
			end
			number_place_fields_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_ad_control{i,2}(1:size(idx,1),j) = number_place_fields_ad(m,idx)';
			end
			width_place_fields_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_ad_control{i,2}(1:size(idx,1),j) = width_place_fields_ad(m,idx)';
			end
			center_place_fields_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_ad_control{i,2}(1:size(idx,1),j) = center_place_fields_ad(m,idx)';
			end
			center_place_fields_index_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_ad_control{i,2}(1:size(idx,1),j) = center_place_fields_index_ad(m,idx)';
			end
			center_place_fields_active_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_ad_control{i,2}(1:size(idx,1),j) = center_place_fields_active_ad(m,idx)';
			end
			center_place_fields_index_sorted_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_ad_control{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_ad(m,idx)';
			end
			center_place_fields_active_sorted_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_ad_control{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_ad(m,idx)';
			end
			rate_map_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_ad_control{i,2}(1:size(idx,1),j) = rate_map_ad(m,idx)';
			end
			rate_map_z_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_ad_control{i,2}(1:size(idx,1),j) = rate_map_z_ad(m,idx)';
			end
			rate_map_n_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_ad_control{i,2}(1:size(idx,1),j) = rate_map_n_ad(m,idx)';
			end
			rate_map_active_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_ad(m,idx)';
			end
			rate_map_active_z_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_z_ad(m,idx)';
			end
			rate_map_active_n_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_n_ad(m,idx)';
			end
			rate_map_active_sorted_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_ad(m,idx)';
			end
			rate_map_active_sorted_z_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_ad(m,idx)';
			end
			rate_map_active_sorted_n_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_ad_control{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_ad(m,idx)';
			end
			spatial_info_bits_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_ad_control{i,2}(1:size(idx,1),j) = spatial_info_bits_ad(m,idx)';
			end
			spatial_info_norm_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_ad_control{i,2}(1:size(idx,1),j) = spatial_info_norm_ad(m,idx)';
			end
			event_rate_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_ad_control{i,2}(1:size(idx,1),j) = event_rate_tuned_ad(m,idx)';
			end
			event_rate_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_ad_control{i,2}(1:size(idx,1),j) = event_rate_untuned_ad(m,idx)';
			end
			event_amp_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_ad_control{i,2}(1:size(idx,1),j) = event_amp_tuned_ad(m,idx)';
			end
			event_amp_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_ad_control{i,2}(1:size(idx,1),j) = event_amp_untuned_ad(m,idx)';
			end
			event_width_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_ad_control{i,2}(1:size(idx,1),j) = event_width_tuned_ad(m,idx)';
			end
			event_width_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_ad_control{i,2}(1:size(idx,1),j) = event_width_untuned_ad(m,idx)';
			end
			event_auc_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_ad_control{i,2}(1:size(idx,1),j) = event_auc_tuned_ad(m,idx)';
			end
			event_auc_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_ad_control{i,2}(1:size(idx,1),j) = event_auc_untuned_ad(m,idx)';
			end
			event_rise_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_ad_control{i,2}(1:size(idx,1),j) = event_rise_tuned_ad(m,idx)';
			end
			event_rise_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_ad_control{i,2}(1:size(idx,1),j) = event_rise_untuned_ad(m,idx)';
			end
			event_decay_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_ad_control{i,2}(1:size(idx,1),j) = event_decay_tuned_ad(m,idx)';
			end
			event_decay_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_ad_control{i,2}(1:size(idx,1),j) = event_decay_untuned_ad(m,idx)';
			end
			event_rate_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_tuned_run_ad(m,idx)';
			end
			event_rate_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_ad(m,idx)';
			end
			event_amp_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_tuned_run_ad(m,idx)';
			end
			event_amp_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_ad(m,idx)';
			end
			event_width_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_width_tuned_run_ad(m,idx)';
			end
			event_width_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_tuned_rest_ad(m,idx)';
			end
			event_auc_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_tuned_run_ad(m,idx)';
			end
			event_auc_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_ad(m,idx)';
			end
			event_rise_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_tuned_run_ad(m,idx)';
			end
			event_rise_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_ad(m,idx)';
			end
			event_decay_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_tuned_run_ad(m,idx)';
			end
			event_decay_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_ad(m,idx)';
			end
			event_rate_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_untuned_run_ad(m,idx)';
			end
			event_rate_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_ad(m,idx)';
			end
			event_amp_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_untuned_run_ad(m,idx)';
			end
			event_amp_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_ad(m,idx)';
			end
			event_width_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_width_untuned_run_ad(m,idx)';
			end
			event_width_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_untuned_rest_ad(m,idx)';
			end
			event_auc_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_untuned_run_ad(m,idx)';
			end
			event_auc_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_ad(m,idx)';
			end
			event_rise_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_untuned_run_ad(m,idx)';
			end
			event_rise_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_ad(m,idx)';
			end
			event_decay_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_untuned_run_ad(m,idx)';
			end
			event_decay_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_ad(m,idx)';
			end
			event_rate_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_ad(m,idx)';
			end
			event_rate_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_ad(m,idx)';
			end
			event_amp_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_ad(m,idx)';
			end
			event_amp_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_ad(m,idx)';
			end
			event_width_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_ad(m,idx)';
			end
			event_width_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_ad(m,idx)';
			end
			event_auc_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_ad(m,idx)';
			end
			event_auc_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_ad(m,idx)';
			end
			event_rise_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_ad(m,idx)';
			end
			event_rise_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_ad(m,idx)';
			end
			event_decay_pop_tuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_ad(m,idx)';
			end
			event_decay_pop_untuned_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_ad(m,idx)';
			end
			event_rate_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_ad(m,idx)';
			end
			event_rate_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_ad(m,idx)';
			end
			event_amp_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_ad(m,idx)';
			end
			event_amp_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_ad(m,idx)';
			end
			event_width_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_ad(m,idx)';
			end
			event_width_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_ad(m,idx)';
			end
			event_auc_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_ad(m,idx)';
			end
			event_auc_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_ad(m,idx)';
			end
			event_rise_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_ad(m,idx)';
			end
			event_rise_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_ad(m,idx)';
			end
			event_decay_pop_tuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_ad(m,idx)';
			end
			event_decay_pop_tuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_ad(m,idx)';
			end
			event_rate_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_ad(m,idx)';
			end
			event_rate_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_ad(m,idx)';
			end
			event_amp_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_ad(m,idx)';
			end
			event_amp_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_ad(m,idx)';
			end
			event_width_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_ad(m,idx)';
			end
			event_width_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_ad(m,idx)';
			end
			event_auc_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_ad(m,idx)';
			end
			event_auc_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_ad(m,idx)';
			end
			event_rise_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_ad(m,idx)';
			end
			event_rise_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_ad(m,idx)';
			end
			event_decay_pop_untuned_run_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_ad(m,idx)';
			end
			event_decay_pop_untuned_rest_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_ad_control{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_ad(m,idx)';
			end
			roi_pc_binary_ad_control{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_ad_control{i,2}(1:size(idx,1),j) = roi_pc_binary_ad(m,idx)';
			end
		end
		%soma
		try
			nanidx = cellfun('isempty',event_rate_run_s_control{i,2});
			event_rate_run_s_control{i,2}(nanidx) = {NaN};
			event_rate_run_s_control{i,2} = cell2mat(event_rate_run_s_control{i,2});
			event_rate_run_s_control{i,3} = mean(event_rate_run_s_control{i,2},2,'omitnan');
			event_rate_run_s_control{i,4} = std(event_rate_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_s_control{i,2});
			event_rate_rest_s_control{i,2}(nanidx) = {NaN};
			event_rate_rest_s_control{i,2} = cell2mat(event_rate_rest_s_control{i,2});
			event_rate_rest_s_control{i,3} = mean(event_rate_rest_s_control{i,2},2,'omitnan');
			event_rate_rest_s_control{i,4} = std(event_rate_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_s_control{i,2});
			event_amp_run_s_control{i,2}(nanidx) = {NaN};
			event_amp_run_s_control{i,2} = cellfun(@(c) double(c),event_amp_run_s_control{i,2},'UniformOutput',false);
			event_amp_run_s_control{i,2} = cell2mat(event_amp_run_s_control{i,2});
			event_amp_run_s_control{i,3} = mean(event_amp_run_s_control{i,2},2,'omitnan');
			event_amp_run_s_control{i,4} = std(event_amp_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_s_control{i,2});
			event_amp_rest_s_control{i,2}(nanidx) = {NaN};
			event_amp_rest_s_control{i,2} = cellfun(@(c) double(c),event_amp_rest_s_control{i,2},'UniformOutput',false);
			event_amp_rest_s_control{i,2} = cell2mat(event_amp_rest_s_control{i,2});
			event_amp_rest_s_control{i,3} = mean(event_amp_rest_s_control{i,2},2,'omitnan');
			event_amp_rest_s_control{i,4} = std(event_amp_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_s_control{i,2});
			event_width_run_s_control{i,2}(nanidx) = {NaN};
			event_width_run_s_control{i,2} = cell2mat(event_width_run_s_control{i,2});
			event_width_run_s_control{i,3} = mean(event_width_run_s_control{i,2},2,'omitnan');
			event_width_run_s_control{i,4} = std(event_width_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_s_control{i,2});
			event_width_rest_s_control{i,2}(nanidx) = {NaN};
			event_width_rest_s_control{i,2} = cell2mat(event_width_rest_s_control{i,2});
			event_width_rest_s_control{i,3} = mean(event_width_rest_s_control{i,2},2,'omitnan');
			event_width_rest_s_control{i,4} = std(event_width_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_s_control{i,2});
			event_auc_run_s_control{i,2}(nanidx) = {NaN};
			event_auc_run_s_control{i,2} = cell2mat(event_auc_run_s_control{i,2});
			event_auc_run_s_control{i,3} = mean(event_auc_run_s_control{i,2},2,'omitnan');
			event_auc_run_s_control{i,4} = std(event_auc_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_s_control{i,2});
			event_auc_rest_s_control{i,2}(nanidx) = {NaN};
			event_auc_rest_s_control{i,2} = cell2mat(event_auc_rest_s_control{i,2});
			event_auc_rest_s_control{i,3} = mean(event_auc_rest_s_control{i,2},2,'omitnan');
			event_auc_rest_s_control{i,4} = std(event_auc_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_s_control{i,2});
			event_rise_run_s_control{i,2}(nanidx) = {NaN};
			event_rise_run_s_control{i,2} = cell2mat(event_rise_run_s_control{i,2});
			event_rise_run_s_control{i,3} = mean(event_rise_run_s_control{i,2},2,'omitnan');
			event_rise_run_s_control{i,4} = std(event_rise_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_s_control{i,2});
			event_rise_rest_s_control{i,2}(nanidx) = {NaN};
			event_rise_rest_s_control{i,2} = cell2mat(event_rise_rest_s_control{i,2});
			event_rise_rest_s_control{i,3} = mean(event_rise_rest_s_control{i,2},2,'omitnan');
			event_rise_rest_s_control{i,4} = std(event_rise_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_s_control{i,2});
			event_decay_run_s_control{i,2}(nanidx) = {NaN};
			event_decay_run_s_control{i,2} = cell2mat(event_decay_run_s_control{i,2});
			event_decay_run_s_control{i,3} = mean(event_decay_run_s_control{i,2},2,'omitnan');
			event_decay_run_s_control{i,4} = std(event_decay_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_s_control{i,2});
			event_decay_rest_s_control{i,2}(nanidx) = {NaN};
			event_decay_rest_s_control{i,2} = cell2mat(event_decay_rest_s_control{i,2});
			event_decay_rest_s_control{i,3} = mean(event_decay_rest_s_control{i,2},2,'omitnan');
			event_decay_rest_s_control{i,4} = std(event_decay_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_s_control{i,2});
			fraction_active_ROIs_s_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_s_control{i,2} = cell2mat(fraction_active_ROIs_s_control{i,2});
			fraction_active_ROIs_s_control{i,3} = mean(fraction_active_ROIs_s_control{i,2},2,'omitnan');
			fraction_active_ROIs_s_control{i,4} = std(fraction_active_ROIs_s_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_s_control{i,2});
			fraction_active_ROIs_run_s_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_s_control{i,2} = cell2mat(fraction_active_ROIs_run_s_control{i,2});
			fraction_active_ROIs_run_s_control{i,3} = mean(fraction_active_ROIs_run_s_control{i,2},2,'omitnan');
			fraction_active_ROIs_run_s_control{i,4} = std(fraction_active_ROIs_run_s_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_s_control{i,2});
			fraction_active_ROIs_rest_s_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_s_control{i,2} = cell2mat(fraction_active_ROIs_rest_s_control{i,2});
			fraction_active_ROIs_rest_s_control{i,3} = mean(fraction_active_ROIs_rest_s_control{i,2},2,'omitnan');
			fraction_active_ROIs_rest_s_control{i,4} = std(fraction_active_ROIs_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_s_control{i,2});
			fraction_place_cells_s_control{i,2}(nanidx) = {NaN};
			fraction_place_cells_s_control{i,2} = cell2mat(fraction_place_cells_s_control{i,2});
			fraction_place_cells_s_control{i,3} = mean(fraction_place_cells_s_control{i,2},2,'omitnan');
			fraction_place_cells_s_control{i,4} = std(fraction_place_cells_s_control{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_s_control{i,2});
			number_place_fields_s_control{i,2}(nanidx) = {NaN};
			number_place_fields_s_control{i,2} = cell2mat(number_place_fields_s_control{i,2});
			number_place_fields_s_control{i,3} = mean(number_place_fields_s_control{i,2},2,'omitnan');
			number_place_fields_s_control{i,4} = std(number_place_fields_s_control{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_s_control{i,2});
			width_place_fields_s_control{i,2}(nanidx) = {NaN};
			width_place_fields_s_control{i,2} = cell2mat(width_place_fields_s_control{i,2});
			width_place_fields_s_control{i,3} = mean(width_place_fields_s_control{i,2},2,'omitnan');
			width_place_fields_s_control{i,4} = std(width_place_fields_s_control{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_s_control{i,2});
			center_place_fields_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_s_control{i,2});
			center_place_fields_index_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_s_control{i,2});
			center_place_fields_active_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_s_control{i,2});
			center_place_fields_index_sorted_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_s_control{i,2});
			center_place_fields_active_sorted_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_s_control{i,2});
			rate_map_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_s_control{i,2});
			rate_map_z_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_s_control{i,2});
			rate_map_n_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_s_control{i,2});
			rate_map_active_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_s_control{i,2});
			rate_map_active_z_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_s_control{i,2});
			rate_map_active_n_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_s_control{i,2});
			rate_map_active_sorted_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_s_control{i,2});
			rate_map_active_sorted_z_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_s_control{i,2});
			rate_map_active_sorted_n_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_s_control{i,2});
			spatial_info_bits_s_control{i,2}(nanidx) = {NaN};
			spatial_info_bits_s_control{i,2} = cell2mat(spatial_info_bits_s_control{i,2});
			spatial_info_bits_s_control{i,3} = mean(spatial_info_bits_s_control{i,2},2,'omitnan');
			spatial_info_bits_s_control{i,4} = std(spatial_info_bits_s_control{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_s_control{i,2});
			spatial_info_norm_s_control{i,2}(nanidx) = {NaN};
			spatial_info_norm_s_control{i,2} = cell2mat(spatial_info_norm_s_control{i,2});
			spatial_info_norm_s_control{i,3} = mean(spatial_info_norm_s_control{i,2},2,'omitnan');
			spatial_info_norm_s_control{i,4} = std(spatial_info_norm_s_control{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_s_control{i,2});
			event_rate_tuned_s_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_s_control{i,2} = cell2mat(event_rate_tuned_s_control{i,2});
			event_rate_tuned_s_control{i,3} = mean(event_rate_tuned_s_control{i,2},2,'omitnan');
			event_rate_tuned_s_control{i,4} = std(event_rate_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_s_control{i,2});
			event_rate_untuned_s_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_s_control{i,2} = cell2mat(event_rate_untuned_s_control{i,2});
			event_rate_untuned_s_control{i,3} = mean(event_rate_untuned_s_control{i,2},2,'omitnan');
			event_rate_untuned_s_control{i,4} = std(event_rate_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_s_control{i,2});
			event_amp_tuned_s_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_s_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_s_control{i,2},'UniformOutput',false);
			event_amp_tuned_s_control{i,2} = cell2mat(event_amp_tuned_s_control{i,2});
			event_amp_tuned_s_control{i,3} = mean(event_amp_tuned_s_control{i,2},2,'omitnan');
			event_amp_tuned_s_control{i,4} = std(event_amp_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_s_control{i,2});
			event_amp_untuned_s_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_s_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_s_control{i,2},'UniformOutput',false);
			event_amp_untuned_s_control{i,2} = cell2mat(event_amp_untuned_s_control{i,2});
			event_amp_untuned_s_control{i,3} = mean(event_amp_untuned_s_control{i,2},2,'omitnan');
			event_amp_untuned_s_control{i,4} = std(event_amp_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_s_control{i,2});
			event_width_tuned_s_control{i,2}(nanidx) = {NaN};
			event_width_tuned_s_control{i,2} = cell2mat(event_width_tuned_s_control{i,2});
			event_width_tuned_s_control{i,3} = mean(event_width_tuned_s_control{i,2},2,'omitnan');
			event_width_tuned_s_control{i,4} = std(event_width_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_s_control{i,2});
			event_width_untuned_s_control{i,2}(nanidx) = {NaN};
			event_width_untuned_s_control{i,2} = cell2mat(event_width_untuned_s_control{i,2});
			event_width_untuned_s_control{i,3} = mean(event_width_untuned_s_control{i,2},2,'omitnan');
			event_width_untuned_s_control{i,4} = std(event_width_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_s_control{i,2});
			event_auc_tuned_s_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_s_control{i,2} = cell2mat(event_auc_tuned_s_control{i,2});
			event_auc_tuned_s_control{i,3} = mean(event_auc_tuned_s_control{i,2},2,'omitnan');
			event_auc_tuned_s_control{i,4} = std(event_auc_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_s_control{i,2});
			event_auc_untuned_s_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_s_control{i,2} = cell2mat(event_auc_untuned_s_control{i,2});
			event_auc_untuned_s_control{i,3} = mean(event_auc_untuned_s_control{i,2},2,'omitnan');
			event_auc_untuned_s_control{i,4} = std(event_auc_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_s_control{i,2});
			event_rise_tuned_s_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_s_control{i,2} = cell2mat(event_rise_tuned_s_control{i,2});
			event_rise_tuned_s_control{i,3} = mean(event_rise_tuned_s_control{i,2},2,'omitnan');
			event_rise_tuned_s_control{i,4} = std(event_rise_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_s_control{i,2});
			event_rise_untuned_s_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_s_control{i,2} = cell2mat(event_rise_untuned_s_control{i,2});
			event_rise_untuned_s_control{i,3} = mean(event_rise_untuned_s_control{i,2},2,'omitnan');
			event_rise_untuned_s_control{i,4} = std(event_rise_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_s_control{i,2});
			event_decay_tuned_s_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_s_control{i,2} = cell2mat(event_decay_tuned_s_control{i,2});
			event_decay_tuned_s_control{i,3} = mean(event_decay_tuned_s_control{i,2},2,'omitnan');
			event_decay_tuned_s_control{i,4} = std(event_decay_tuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_s_control{i,2});
			event_decay_untuned_s_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_s_control{i,2} = cell2mat(event_decay_untuned_s_control{i,2});
			event_decay_untuned_s_control{i,3} = mean(event_decay_untuned_s_control{i,2},2,'omitnan');
			event_decay_untuned_s_control{i,4} = std(event_decay_untuned_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_s_control{i,2});
			event_rate_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_s_control{i,2} = cell2mat(event_rate_tuned_run_s_control{i,2});
			event_rate_tuned_run_s_control{i,3} = mean(event_rate_tuned_run_s_control{i,2},2,'omitnan');
			event_rate_tuned_run_s_control{i,4} = std(event_rate_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_s_control{i,2});
			event_rate_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_s_control{i,2} = cell2mat(event_rate_tuned_rest_s_control{i,2});
			event_rate_tuned_rest_s_control{i,3} = mean(event_rate_tuned_rest_s_control{i,2},2,'omitnan');
			event_rate_tuned_rest_s_control{i,4} = std(event_rate_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_s_control{i,2});
			event_amp_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_s_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_s_control{i,2},'UniformOutput',false);
			event_amp_tuned_run_s_control{i,2} = cell2mat(event_amp_tuned_run_s_control{i,2});
			event_amp_tuned_run_s_control{i,3} = mean(event_amp_tuned_run_s_control{i,2},2,'omitnan');
			event_amp_tuned_run_s_control{i,4} = std(event_amp_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_s_control{i,2});
			event_amp_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_s_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_s_control{i,2},'UniformOutput',false);
			event_amp_tuned_rest_s_control{i,2} = cell2mat(event_amp_tuned_rest_s_control{i,2});
			event_amp_tuned_rest_s_control{i,3} = mean(event_amp_tuned_rest_s_control{i,2},2,'omitnan');
			event_amp_tuned_rest_s_control{i,4} = std(event_amp_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_s_control{i,2});
			event_width_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_width_tuned_run_s_control{i,2} = cell2mat(event_width_tuned_run_s_control{i,2});
			event_width_tuned_run_s_control{i,3} = mean(event_width_tuned_run_s_control{i,2},2,'omitnan');
			event_width_tuned_run_s_control{i,4} = std(event_width_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_s_control{i,2});
			event_width_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_s_control{i,2} = cell2mat(event_width_tuned_rest_s_control{i,2});
			event_width_tuned_rest_s_control{i,3} = mean(event_width_tuned_rest_s_control{i,2},2,'omitnan');
			event_width_tuned_rest_s_control{i,4} = std(event_width_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_s_control{i,2});
			event_auc_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_s_control{i,2} = cell2mat(event_auc_tuned_run_s_control{i,2});
			event_auc_tuned_run_s_control{i,3} = mean(event_auc_tuned_run_s_control{i,2},2,'omitnan');
			event_auc_tuned_run_s_control{i,4} = std(event_auc_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_s_control{i,2});
			event_auc_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_s_control{i,2} = cell2mat(event_auc_tuned_rest_s_control{i,2});
			event_auc_tuned_rest_s_control{i,3} = mean(event_auc_tuned_rest_s_control{i,2},2,'omitnan');
			event_auc_tuned_rest_s_control{i,4} = std(event_auc_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_s_control{i,2});
			event_rise_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_s_control{i,2} = cell2mat(event_rise_tuned_run_s_control{i,2});
			event_rise_tuned_run_s_control{i,3} = mean(event_rise_tuned_run_s_control{i,2},2,'omitnan');
			event_rise_tuned_run_s_control{i,4} = std(event_rise_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_s_control{i,2});
			event_rise_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_s_control{i,2} = cell2mat(event_rise_tuned_rest_s_control{i,2});
			event_rise_tuned_rest_s_control{i,3} = mean(event_rise_tuned_rest_s_control{i,2},2,'omitnan');
			event_rise_tuned_rest_s_control{i,4} = std(event_rise_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_s_control{i,2});
			event_decay_tuned_run_s_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_s_control{i,2} = cell2mat(event_decay_tuned_run_s_control{i,2});
			event_decay_tuned_run_s_control{i,3} = mean(event_decay_tuned_run_s_control{i,2},2,'omitnan');
			event_decay_tuned_run_s_control{i,4} = std(event_decay_tuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_s_control{i,2});
			event_decay_tuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_s_control{i,2} = cell2mat(event_decay_tuned_rest_s_control{i,2});
			event_decay_tuned_rest_s_control{i,3} = mean(event_decay_tuned_rest_s_control{i,2},2,'omitnan');
			event_decay_tuned_rest_s_control{i,4} = std(event_decay_tuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_s_control{i,2});
			event_rate_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_s_control{i,2} = cell2mat(event_rate_untuned_run_s_control{i,2});
			event_rate_untuned_run_s_control{i,3} = mean(event_rate_untuned_run_s_control{i,2},2,'omitnan');
			event_rate_untuned_run_s_control{i,4} = std(event_rate_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_s_control{i,2});
			event_rate_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_s_control{i,2} = cell2mat(event_rate_untuned_rest_s_control{i,2});
			event_rate_untuned_rest_s_control{i,3} = mean(event_rate_untuned_rest_s_control{i,2},2,'omitnan');
			event_rate_untuned_rest_s_control{i,4} = std(event_rate_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_s_control{i,2});
			event_amp_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_s_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_s_control{i,2},'UniformOutput',false);
			event_amp_untuned_run_s_control{i,2} = cell2mat(event_amp_untuned_run_s_control{i,2});
			event_amp_untuned_run_s_control{i,3} = mean(event_amp_untuned_run_s_control{i,2},2,'omitnan');
			event_amp_untuned_run_s_control{i,4} = std(event_amp_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_s_control{i,2});
			event_amp_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_s_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_s_control{i,2},'UniformOutput',false);
			event_amp_untuned_rest_s_control{i,2} = cell2mat(event_amp_untuned_rest_s_control{i,2});
			event_amp_untuned_rest_s_control{i,3} = mean(event_amp_untuned_rest_s_control{i,2},2,'omitnan');
			event_amp_untuned_rest_s_control{i,4} = std(event_amp_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_s_control{i,2});
			event_width_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_width_untuned_run_s_control{i,2} = cell2mat(event_width_untuned_run_s_control{i,2});
			event_width_untuned_run_s_control{i,3} = mean(event_width_untuned_run_s_control{i,2},2,'omitnan');
			event_width_untuned_run_s_control{i,4} = std(event_width_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_s_control{i,2});
			event_width_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_s_control{i,2} = cell2mat(event_width_untuned_rest_s_control{i,2});
			event_width_untuned_rest_s_control{i,3} = mean(event_width_untuned_rest_s_control{i,2},2,'omitnan');
			event_width_untuned_rest_s_control{i,4} = std(event_width_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_s_control{i,2});
			event_auc_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_s_control{i,2} = cell2mat(event_auc_untuned_run_s_control{i,2});
			event_auc_untuned_run_s_control{i,3} = mean(event_auc_untuned_run_s_control{i,2},2,'omitnan');
			event_auc_untuned_run_s_control{i,4} = std(event_auc_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_s_control{i,2});
			event_auc_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_s_control{i,2} = cell2mat(event_auc_untuned_rest_s_control{i,2});
			event_auc_untuned_rest_s_control{i,3} = mean(event_auc_untuned_rest_s_control{i,2},2,'omitnan');
			event_auc_untuned_rest_s_control{i,4} = std(event_auc_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_s_control{i,2});
			event_rise_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_s_control{i,2} = cell2mat(event_rise_untuned_run_s_control{i,2});
			event_rise_untuned_run_s_control{i,3} = mean(event_rise_untuned_run_s_control{i,2},2,'omitnan');
			event_rise_untuned_run_s_control{i,4} = std(event_rise_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_s_control{i,2});
			event_rise_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_s_control{i,2} = cell2mat(event_rise_untuned_rest_s_control{i,2});
			event_rise_untuned_rest_s_control{i,3} = mean(event_rise_untuned_rest_s_control{i,2},2,'omitnan');
			event_rise_untuned_rest_s_control{i,4} = std(event_rise_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_s_control{i,2});
			event_decay_untuned_run_s_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_s_control{i,2} = cell2mat(event_decay_untuned_run_s_control{i,2});
			event_decay_untuned_run_s_control{i,3} = mean(event_decay_untuned_run_s_control{i,2},2,'omitnan');
			event_decay_untuned_run_s_control{i,4} = std(event_decay_untuned_run_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_s_control{i,2});
			event_decay_untuned_rest_s_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_s_control{i,2} = cell2mat(event_decay_untuned_rest_s_control{i,2});
			event_decay_untuned_rest_s_control{i,3} = mean(event_decay_untuned_rest_s_control{i,2},2,'omitnan');
			event_decay_untuned_rest_s_control{i,4} = std(event_decay_untuned_rest_s_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_s_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_s_control{i,2});
			roi_pc_binary_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_s_control{i,2});
			event_rate_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_s_control{i,2});
			event_rate_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_s_control{i,2});
			event_amp_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_s_control{i,2});
			event_amp_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_s_control{i,2});
			event_width_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_s_control{i,2});
			event_width_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_s_control{i,2});
			event_auc_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_s_control{i,2});
			event_auc_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_s_control{i,2});
			event_rise_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_s_control{i,2});
			event_rise_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_s_control{i,2});
			event_decay_pop_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_s_control{i,2});
			event_decay_pop_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_s_control{i,2});
			event_rate_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_s_control{i,2});
			event_rate_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_s_control{i,2});
			event_amp_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_s_control{i,2});
			event_amp_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_s_control{i,2});
			event_width_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_s_control{i,2});
			event_width_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_s_control{i,2});
			event_auc_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_s_control{i,2});
			event_auc_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_s_control{i,2});
			event_rise_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_s_control{i,2});
			event_rise_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_s_control{i,2});
			event_decay_pop_tuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_s_control{i,2});
			event_decay_pop_untuned_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_s_control{i,2});
			event_rate_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_s_control{i,2});
			event_rate_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_s_control{i,2});
			event_amp_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_s_control{i,2});
			event_amp_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_s_control{i,2});
			event_width_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_s_control{i,2});
			event_width_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_s_control{i,2});
			event_auc_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_s_control{i,2});
			event_auc_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_s_control{i,2});
			event_rise_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_s_control{i,2});
			event_rise_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_s_control{i,2});
			event_decay_pop_tuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_s_control{i,2});
			event_decay_pop_tuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_s_control{i,2});
			event_rate_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_s_control{i,2});
			event_rate_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_s_control{i,2});
			event_amp_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_s_control{i,2});
			event_amp_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_s_control{i,2});
			event_width_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_s_control{i,2});
			event_width_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_s_control{i,2});
			event_auc_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_s_control{i,2});
			event_auc_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_s_control{i,2});
			event_rise_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_s_control{i,2});
			event_rise_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_s_control{i,2});
			event_decay_pop_untuned_run_s_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_s_control{i,2});
			event_decay_pop_untuned_rest_s_control{i,2}(nanidx) = {NaN};
		end
		%dendrites
		try
			nanidx = cellfun('isempty',event_rate_run_ad_control{i,2});
			event_rate_run_ad_control{i,2}(nanidx) = {NaN};
			event_rate_run_ad_control{i,2} = cell2mat(event_rate_run_ad_control{i,2});
			event_rate_run_ad_control{i,3} = mean(event_rate_run_ad_control{i,2},2,'omitnan');
			event_rate_run_ad_control{i,4} = std(event_rate_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_ad_control{i,2});
			event_rate_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rate_rest_ad_control{i,2} = cell2mat(event_rate_rest_ad_control{i,2});
			event_rate_rest_ad_control{i,3} = mean(event_rate_rest_ad_control{i,2},2,'omitnan');
			event_rate_rest_ad_control{i,4} = std(event_rate_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_ad_control{i,2});
			event_amp_run_ad_control{i,2}(nanidx) = {NaN};
			event_amp_run_ad_control{i,2} = cellfun(@(c) double(c),event_amp_run_ad_control{i,2},'UniformOutput',false);
			event_amp_run_ad_control{i,2} = cell2mat(event_amp_run_ad_control{i,2});
			event_amp_run_ad_control{i,3} = mean(event_amp_run_ad_control{i,2},2,'omitnan');
			event_amp_run_ad_control{i,4} = std(event_amp_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_ad_control{i,2});
			event_amp_rest_ad_control{i,2}(nanidx) = {NaN};
			event_amp_rest_ad_control{i,2} = cellfun(@(c) double(c),event_amp_rest_ad_control{i,2},'UniformOutput',false);
			event_amp_rest_ad_control{i,2} = cell2mat(event_amp_rest_ad_control{i,2});
			event_amp_rest_ad_control{i,3} = mean(event_amp_rest_ad_control{i,2},2,'omitnan');
			event_amp_rest_ad_control{i,4} = std(event_amp_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_ad_control{i,2});
			event_width_run_ad_control{i,2}(nanidx) = {NaN};
			event_width_run_ad_control{i,2} = cell2mat(event_width_run_ad_control{i,2});
			event_width_run_ad_control{i,3} = mean(event_width_run_ad_control{i,2},2,'omitnan');
			event_width_run_ad_control{i,4} = std(event_width_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_ad_control{i,2});
			event_width_rest_ad_control{i,2}(nanidx) = {NaN};
			event_width_rest_ad_control{i,2} = cell2mat(event_width_rest_ad_control{i,2});
			event_width_rest_ad_control{i,3} = mean(event_width_rest_ad_control{i,2},2,'omitnan');
			event_width_rest_ad_control{i,4} = std(event_width_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_ad_control{i,2});
			event_auc_run_ad_control{i,2}(nanidx) = {NaN};
			event_auc_run_ad_control{i,2} = cell2mat(event_auc_run_ad_control{i,2});
			event_auc_run_ad_control{i,3} = mean(event_auc_run_ad_control{i,2},2,'omitnan');
			event_auc_run_ad_control{i,4} = std(event_auc_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_ad_control{i,2});
			event_auc_rest_ad_control{i,2}(nanidx) = {NaN};
			event_auc_rest_ad_control{i,2} = cell2mat(event_auc_rest_ad_control{i,2});
			event_auc_rest_ad_control{i,3} = mean(event_auc_rest_ad_control{i,2},2,'omitnan');
			event_auc_rest_ad_control{i,4} = std(event_auc_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_ad_control{i,2});
			event_rise_run_ad_control{i,2}(nanidx) = {NaN};
			event_rise_run_ad_control{i,2} = cell2mat(event_rise_run_ad_control{i,2});
			event_rise_run_ad_control{i,3} = mean(event_rise_run_ad_control{i,2},2,'omitnan');
			event_rise_run_ad_control{i,4} = std(event_rise_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_ad_control{i,2});
			event_rise_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rise_rest_ad_control{i,2} = cell2mat(event_rise_rest_ad_control{i,2});
			event_rise_rest_ad_control{i,3} = mean(event_rise_rest_ad_control{i,2},2,'omitnan');
			event_rise_rest_ad_control{i,4} = std(event_rise_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_ad_control{i,2});
			event_decay_run_ad_control{i,2}(nanidx) = {NaN};
			event_decay_run_ad_control{i,2} = cell2mat(event_decay_run_ad_control{i,2});
			event_decay_run_ad_control{i,3} = mean(event_decay_run_ad_control{i,2},2,'omitnan');
			event_decay_run_ad_control{i,4} = std(event_decay_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_ad_control{i,2});
			event_decay_rest_ad_control{i,2}(nanidx) = {NaN};
			event_decay_rest_ad_control{i,2} = cell2mat(event_decay_rest_ad_control{i,2});
			event_decay_rest_ad_control{i,3} = mean(event_decay_rest_ad_control{i,2},2,'omitnan');
			event_decay_rest_ad_control{i,4} = std(event_decay_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_ad_control{i,2});
			fraction_active_ROIs_ad_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_ad_control{i,2} = cell2mat(fraction_active_ROIs_ad_control{i,2});
			fraction_active_ROIs_ad_control{i,3} = mean(fraction_active_ROIs_ad_control{i,2},2,'omitnan');
			fraction_active_ROIs_ad_control{i,4} = std(fraction_active_ROIs_ad_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_ad_control{i,2});
			fraction_active_ROIs_run_ad_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_ad_control{i,2} = cell2mat(fraction_active_ROIs_run_ad_control{i,2});
			fraction_active_ROIs_run_ad_control{i,3} = mean(fraction_active_ROIs_run_ad_control{i,2},2,'omitnan');
			fraction_active_ROIs_run_ad_control{i,4} = std(fraction_active_ROIs_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_ad_control{i,2});
			fraction_active_ROIs_rest_ad_control{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_ad_control{i,2} = cell2mat(fraction_active_ROIs_rest_ad_control{i,2});
			fraction_active_ROIs_rest_ad_control{i,3} = mean(fraction_active_ROIs_rest_ad_control{i,2},2,'omitnan');
			fraction_active_ROIs_rest_ad_control{i,4} = std(fraction_active_ROIs_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_ad_control{i,2});
			fraction_place_cells_ad_control{i,2}(nanidx) = {NaN};
			fraction_place_cells_ad_control{i,2} = cell2mat(fraction_place_cells_ad_control{i,2});
			fraction_place_cells_ad_control{i,3} = mean(fraction_place_cells_ad_control{i,2},2,'omitnan');
			fraction_place_cells_ad_control{i,4} = std(fraction_place_cells_ad_control{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_ad_control{i,2});
			number_place_fields_ad_control{i,2}(nanidx) = {NaN};
			number_place_fields_ad_control{i,2} = cell2mat(number_place_fields_ad_control{i,2});
			number_place_fields_ad_control{i,3} = mean(number_place_fields_ad_control{i,2},2,'omitnan');
			number_place_fields_ad_control{i,4} = std(number_place_fields_ad_control{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_ad_control{i,2});
			width_place_fields_ad_control{i,2}(nanidx) = {NaN};
			width_place_fields_ad_control{i,2} = cell2mat(width_place_fields_ad_control{i,2});
			width_place_fields_ad_control{i,3} = mean(width_place_fields_ad_control{i,2},2,'omitnan');
			width_place_fields_ad_control{i,4} = std(width_place_fields_ad_control{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_ad_control{i,2});
			center_place_fields_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_ad_control{i,2});
			center_place_fields_index_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_ad_control{i,2});
			center_place_fields_active_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_ad_control{i,2});
			center_place_fields_index_sorted_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_ad_control{i,2});
			center_place_fields_active_sorted_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_ad_control{i,2});
			rate_map_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_ad_control{i,2});
			rate_map_z_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_ad_control{i,2});
			rate_map_n_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_ad_control{i,2});
			rate_map_active_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_ad_control{i,2});
			rate_map_active_z_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_ad_control{i,2});
			rate_map_active_n_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_ad_control{i,2});
			rate_map_active_sorted_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_ad_control{i,2});
			rate_map_active_sorted_z_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_ad_control{i,2});
			rate_map_active_sorted_n_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_ad_control{i,2});
			spatial_info_bits_ad_control{i,2}(nanidx) = {NaN};
			spatial_info_bits_ad_control{i,2} = cell2mat(spatial_info_bits_ad_control{i,2});
			spatial_info_bits_ad_control{i,3} = mean(spatial_info_bits_ad_control{i,2},2,'omitnan');
			spatial_info_bits_ad_control{i,4} = std(spatial_info_bits_ad_control{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_ad_control{i,2});
			spatial_info_norm_ad_control{i,2}(nanidx) = {NaN};
			spatial_info_norm_ad_control{i,2} = cell2mat(spatial_info_norm_ad_control{i,2});
			spatial_info_norm_ad_control{i,3} = mean(spatial_info_norm_ad_control{i,2},2,'omitnan');
			spatial_info_norm_ad_control{i,4} = std(spatial_info_norm_ad_control{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_ad_control{i,2});
			event_rate_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_ad_control{i,2} = cell2mat(event_rate_tuned_ad_control{i,2});
			event_rate_tuned_ad_control{i,3} = mean(event_rate_tuned_ad_control{i,2},2,'omitnan');
			event_rate_tuned_ad_control{i,4} = std(event_rate_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_ad_control{i,2});
			event_rate_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_ad_control{i,2} = cell2mat(event_rate_untuned_ad_control{i,2});
			event_rate_untuned_ad_control{i,3} = mean(event_rate_untuned_ad_control{i,2},2,'omitnan');
			event_rate_untuned_ad_control{i,4} = std(event_rate_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_ad_control{i,2});
			event_amp_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_ad_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_ad_control{i,2},'UniformOutput',false);
			event_amp_tuned_ad_control{i,2} = cell2mat(event_amp_tuned_ad_control{i,2});
			event_amp_tuned_ad_control{i,3} = mean(event_amp_tuned_ad_control{i,2},2,'omitnan');
			event_amp_tuned_ad_control{i,4} = std(event_amp_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_ad_control{i,2});
			event_amp_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_ad_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_ad_control{i,2},'UniformOutput',false);
			event_amp_untuned_ad_control{i,2} = cell2mat(event_amp_untuned_ad_control{i,2});
			event_amp_untuned_ad_control{i,3} = mean(event_amp_untuned_ad_control{i,2},2,'omitnan');
			event_amp_untuned_ad_control{i,4} = std(event_amp_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_ad_control{i,2});
			event_width_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_width_tuned_ad_control{i,2} = cell2mat(event_width_tuned_ad_control{i,2});
			event_width_tuned_ad_control{i,3} = mean(event_width_tuned_ad_control{i,2},2,'omitnan');
			event_width_tuned_ad_control{i,4} = std(event_width_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_ad_control{i,2});
			event_width_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_width_untuned_ad_control{i,2} = cell2mat(event_width_untuned_ad_control{i,2});
			event_width_untuned_ad_control{i,3} = mean(event_width_untuned_ad_control{i,2},2,'omitnan');
			event_width_untuned_ad_control{i,4} = std(event_width_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_ad_control{i,2});
			event_auc_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_ad_control{i,2} = cell2mat(event_auc_tuned_ad_control{i,2});
			event_auc_tuned_ad_control{i,3} = mean(event_auc_tuned_ad_control{i,2},2,'omitnan');
			event_auc_tuned_ad_control{i,4} = std(event_auc_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_ad_control{i,2});
			event_auc_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_ad_control{i,2} = cell2mat(event_auc_untuned_ad_control{i,2});
			event_auc_untuned_ad_control{i,3} = mean(event_auc_untuned_ad_control{i,2},2,'omitnan');
			event_auc_untuned_ad_control{i,4} = std(event_auc_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_ad_control{i,2});
			event_rise_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_ad_control{i,2} = cell2mat(event_rise_tuned_ad_control{i,2});
			event_rise_tuned_ad_control{i,3} = mean(event_rise_tuned_ad_control{i,2},2,'omitnan');
			event_rise_tuned_ad_control{i,4} = std(event_rise_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_ad_control{i,2});
			event_rise_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_ad_control{i,2} = cell2mat(event_rise_untuned_ad_control{i,2});
			event_rise_untuned_ad_control{i,3} = mean(event_rise_untuned_ad_control{i,2},2,'omitnan');
			event_rise_untuned_ad_control{i,4} = std(event_rise_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_ad_control{i,2});
			event_decay_tuned_ad_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_ad_control{i,2} = cell2mat(event_decay_tuned_ad_control{i,2});
			event_decay_tuned_ad_control{i,3} = mean(event_decay_tuned_ad_control{i,2},2,'omitnan');
			event_decay_tuned_ad_control{i,4} = std(event_decay_tuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_ad_control{i,2});
			event_decay_untuned_ad_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_ad_control{i,2} = cell2mat(event_decay_untuned_ad_control{i,2});
			event_decay_untuned_ad_control{i,3} = mean(event_decay_untuned_ad_control{i,2},2,'omitnan');
			event_decay_untuned_ad_control{i,4} = std(event_decay_untuned_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_ad_control{i,2});
			event_rate_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_ad_control{i,2} = cell2mat(event_rate_tuned_run_ad_control{i,2});
			event_rate_tuned_run_ad_control{i,3} = mean(event_rate_tuned_run_ad_control{i,2},2,'omitnan');
			event_rate_tuned_run_ad_control{i,4} = std(event_rate_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_ad_control{i,2});
			event_rate_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_ad_control{i,2} = cell2mat(event_rate_tuned_rest_ad_control{i,2});
			event_rate_tuned_rest_ad_control{i,3} = mean(event_rate_tuned_rest_ad_control{i,2},2,'omitnan');
			event_rate_tuned_rest_ad_control{i,4} = std(event_rate_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_ad_control{i,2});
			event_amp_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_ad_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_ad_control{i,2},'UniformOutput',false);
			event_amp_tuned_run_ad_control{i,2} = cell2mat(event_amp_tuned_run_ad_control{i,2});
			event_amp_tuned_run_ad_control{i,3} = mean(event_amp_tuned_run_ad_control{i,2},2,'omitnan');
			event_amp_tuned_run_ad_control{i,4} = std(event_amp_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_ad_control{i,2});
			event_amp_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_ad_control{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_ad_control{i,2},'UniformOutput',false);
			event_amp_tuned_rest_ad_control{i,2} = cell2mat(event_amp_tuned_rest_ad_control{i,2});
			event_amp_tuned_rest_ad_control{i,3} = mean(event_amp_tuned_rest_ad_control{i,2},2,'omitnan');
			event_amp_tuned_rest_ad_control{i,4} = std(event_amp_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_ad_control{i,2});
			event_width_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_width_tuned_run_ad_control{i,2} = cell2mat(event_width_tuned_run_ad_control{i,2});
			event_width_tuned_run_ad_control{i,3} = mean(event_width_tuned_run_ad_control{i,2},2,'omitnan');
			event_width_tuned_run_ad_control{i,4} = std(event_width_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_ad_control{i,2});
			event_width_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_ad_control{i,2} = cell2mat(event_width_tuned_rest_ad_control{i,2});
			event_width_tuned_rest_ad_control{i,3} = mean(event_width_tuned_rest_ad_control{i,2},2,'omitnan');
			event_width_tuned_rest_ad_control{i,4} = std(event_width_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_ad_control{i,2});
			event_auc_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_ad_control{i,2} = cell2mat(event_auc_tuned_run_ad_control{i,2});
			event_auc_tuned_run_ad_control{i,3} = mean(event_auc_tuned_run_ad_control{i,2},2,'omitnan');
			event_auc_tuned_run_ad_control{i,4} = std(event_auc_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_ad_control{i,2});
			event_auc_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_ad_control{i,2} = cell2mat(event_auc_tuned_rest_ad_control{i,2});
			event_auc_tuned_rest_ad_control{i,3} = mean(event_auc_tuned_rest_ad_control{i,2},2,'omitnan');
			event_auc_tuned_rest_ad_control{i,4} = std(event_auc_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_ad_control{i,2});
			event_rise_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_ad_control{i,2} = cell2mat(event_rise_tuned_run_ad_control{i,2});
			event_rise_tuned_run_ad_control{i,3} = mean(event_rise_tuned_run_ad_control{i,2},2,'omitnan');
			event_rise_tuned_run_ad_control{i,4} = std(event_rise_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_ad_control{i,2});
			event_rise_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_ad_control{i,2} = cell2mat(event_rise_tuned_rest_ad_control{i,2});
			event_rise_tuned_rest_ad_control{i,3} = mean(event_rise_tuned_rest_ad_control{i,2},2,'omitnan');
			event_rise_tuned_rest_ad_control{i,4} = std(event_rise_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_ad_control{i,2});
			event_decay_tuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_ad_control{i,2} = cell2mat(event_decay_tuned_run_ad_control{i,2});
			event_decay_tuned_run_ad_control{i,3} = mean(event_decay_tuned_run_ad_control{i,2},2,'omitnan');
			event_decay_tuned_run_ad_control{i,4} = std(event_decay_tuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_ad_control{i,2});
			event_decay_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_ad_control{i,2} = cell2mat(event_decay_tuned_rest_ad_control{i,2});
			event_decay_tuned_rest_ad_control{i,3} = mean(event_decay_tuned_rest_ad_control{i,2},2,'omitnan');
			event_decay_tuned_rest_ad_control{i,4} = std(event_decay_tuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_ad_control{i,2});
			event_rate_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_ad_control{i,2} = cell2mat(event_rate_untuned_run_ad_control{i,2});
			event_rate_untuned_run_ad_control{i,3} = mean(event_rate_untuned_run_ad_control{i,2},2,'omitnan');
			event_rate_untuned_run_ad_control{i,4} = std(event_rate_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_ad_control{i,2});
			event_rate_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_ad_control{i,2} = cell2mat(event_rate_untuned_rest_ad_control{i,2});
			event_rate_untuned_rest_ad_control{i,3} = mean(event_rate_untuned_rest_ad_control{i,2},2,'omitnan');
			event_rate_untuned_rest_ad_control{i,4} = std(event_rate_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_ad_control{i,2});
			event_amp_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_ad_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_ad_control{i,2},'UniformOutput',false);
			event_amp_untuned_run_ad_control{i,2} = cell2mat(event_amp_untuned_run_ad_control{i,2});
			event_amp_untuned_run_ad_control{i,3} = mean(event_amp_untuned_run_ad_control{i,2},2,'omitnan');
			event_amp_untuned_run_ad_control{i,4} = std(event_amp_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_ad_control{i,2});
			event_amp_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_ad_control{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_ad_control{i,2},'UniformOutput',false);
			event_amp_untuned_rest_ad_control{i,2} = cell2mat(event_amp_untuned_rest_ad_control{i,2});
			event_amp_untuned_rest_ad_control{i,3} = mean(event_amp_untuned_rest_ad_control{i,2},2,'omitnan');
			event_amp_untuned_rest_ad_control{i,4} = std(event_amp_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_ad_control{i,2});
			event_width_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_width_untuned_run_ad_control{i,2} = cell2mat(event_width_untuned_run_ad_control{i,2});
			event_width_untuned_run_ad_control{i,3} = mean(event_width_untuned_run_ad_control{i,2},2,'omitnan');
			event_width_untuned_run_ad_control{i,4} = std(event_width_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_ad_control{i,2});
			event_width_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_ad_control{i,2} = cell2mat(event_width_untuned_rest_ad_control{i,2});
			event_width_untuned_rest_ad_control{i,3} = mean(event_width_untuned_rest_ad_control{i,2},2,'omitnan');
			event_width_untuned_rest_ad_control{i,4} = std(event_width_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_ad_control{i,2});
			event_auc_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_ad_control{i,2} = cell2mat(event_auc_untuned_run_ad_control{i,2});
			event_auc_untuned_run_ad_control{i,3} = mean(event_auc_untuned_run_ad_control{i,2},2,'omitnan');
			event_auc_untuned_run_ad_control{i,4} = std(event_auc_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_ad_control{i,2});
			event_auc_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_ad_control{i,2} = cell2mat(event_auc_untuned_rest_ad_control{i,2});
			event_auc_untuned_rest_ad_control{i,3} = mean(event_auc_untuned_rest_ad_control{i,2},2,'omitnan');
			event_auc_untuned_rest_ad_control{i,4} = std(event_auc_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_ad_control{i,2});
			event_rise_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_ad_control{i,2} = cell2mat(event_rise_untuned_run_ad_control{i,2});
			event_rise_untuned_run_ad_control{i,3} = mean(event_rise_untuned_run_ad_control{i,2},2,'omitnan');
			event_rise_untuned_run_ad_control{i,4} = std(event_rise_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_ad_control{i,2});
			event_rise_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_ad_control{i,2} = cell2mat(event_rise_untuned_rest_ad_control{i,2});
			event_rise_untuned_rest_ad_control{i,3} = mean(event_rise_untuned_rest_ad_control{i,2},2,'omitnan');
			event_rise_untuned_rest_ad_control{i,4} = std(event_rise_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_ad_control{i,2});
			event_decay_untuned_run_ad_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_ad_control{i,2} = cell2mat(event_decay_untuned_run_ad_control{i,2});
			event_decay_untuned_run_ad_control{i,3} = mean(event_decay_untuned_run_ad_control{i,2},2,'omitnan');
			event_decay_untuned_run_ad_control{i,4} = std(event_decay_untuned_run_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_ad_control{i,2});
			event_decay_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_ad_control{i,2} = cell2mat(event_decay_untuned_rest_ad_control{i,2});
			event_decay_untuned_rest_ad_control{i,3} = mean(event_decay_untuned_rest_ad_control{i,2},2,'omitnan');
			event_decay_untuned_rest_ad_control{i,4} = std(event_decay_untuned_rest_ad_control{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_ad_control{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_ad_control{i,2});
			roi_pc_binary_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_ad_control{i,2});
			event_rate_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_ad_control{i,2});
			event_rate_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_ad_control{i,2});
			event_amp_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_ad_control{i,2});
			event_amp_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_ad_control{i,2});
			event_width_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_ad_control{i,2});
			event_width_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_ad_control{i,2});
			event_auc_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_ad_control{i,2});
			event_auc_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_ad_control{i,2});
			event_rise_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_ad_control{i,2});
			event_rise_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_ad_control{i,2});
			event_decay_pop_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_ad_control{i,2});
			event_decay_pop_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_ad_control{i,2});
			event_rate_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_ad_control{i,2});
			event_rate_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_ad_control{i,2});
			event_amp_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_ad_control{i,2});
			event_amp_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_ad_control{i,2});
			event_width_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_ad_control{i,2});
			event_width_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_ad_control{i,2});
			event_auc_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_ad_control{i,2});
			event_auc_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_ad_control{i,2});
			event_rise_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_ad_control{i,2});
			event_rise_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_ad_control{i,2});
			event_decay_pop_tuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_ad_control{i,2});
			event_decay_pop_untuned_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_ad_control{i,2});
			event_rate_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_ad_control{i,2});
			event_rate_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_ad_control{i,2});
			event_amp_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_ad_control{i,2});
			event_amp_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_ad_control{i,2});
			event_width_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_ad_control{i,2});
			event_width_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_ad_control{i,2});
			event_auc_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_ad_control{i,2});
			event_auc_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_ad_control{i,2});
			event_rise_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_ad_control{i,2});
			event_rise_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_ad_control{i,2});
			event_decay_pop_tuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_ad_control{i,2});
			event_decay_pop_tuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_ad_control{i,2});
			event_rate_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_ad_control{i,2});
			event_rate_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_ad_control{i,2});
			event_amp_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_ad_control{i,2});
			event_amp_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_ad_control{i,2});
			event_width_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_ad_control{i,2});
			event_width_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_ad_control{i,2});
			event_auc_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_ad_control{i,2});
			event_auc_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_ad_control{i,2});
			event_rise_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_ad_control{i,2});
			event_rise_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_ad_control{i,2});
			event_decay_pop_untuned_run_ad_control{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_ad_control{i,2});
			event_decay_pop_untuned_rest_ad_control{i,2}(nanidx) = {NaN};
		end
	end
	%soma
	event_rate_run_s_LECglu = {};
	event_rate_rest_s_LECglu = {};
	event_amp_run_s_LECglu = {};
	event_amp_rest_s_LECglu = {};
	event_width_run_s_LECglu = {};
	event_width_rest_s_LECglu = {};
	event_auc_run_s_LECglu = {};
	event_auc_rest_s_LECglu = {};
	event_rise_run_s_LECglu = {};
	event_rise_rest_s_LECglu = {};
	event_decay_run_s_LECglu = {};
	event_decay_rest_s_LECglu = {};
	event_rate_tuned_s_LECglu = {};
	event_rate_untuned_s_LECglu = {};
	event_amp_tuned_s_LECglu = {};
	event_amp_untuned_s_LECglu = {};
	event_width_tuned_s_LECglu = {};
	event_width_untuned_s_LECglu = {};
	event_auc_tuned_s_LECglu = {};
	event_auc_untuned_s_LECglu = {};
	event_rise_tuned_s_LECglu = {};
	event_rise_untuned_s_LECglu = {};
	event_decay_tuned_s_LECglu = {};
	event_decay_untuned_s_LECglu = {};
	event_rate_tuned_run_s_LECglu = {};
	event_rate_tuned_rest_s_LECglu = {};
	event_amp_tuned_run_s_LECglu = {};
	event_amp_tuned_rest_s_LECglu = {};
	event_width_tuned_run_s_LECglu = {};
	event_width_tuned_rest_s_LECglu = {};
	event_auc_tuned_run_s_LECglu = {};
	event_auc_tuned_rest_s_LECglu = {};
	event_rise_tuned_run_s_LECglu = {};
	event_rise_tuned_rest_s_LECglu = {};
	event_decay_tuned_run_s_LECglu = {};
	event_decay_tuned_rest_s_LECglu = {};
	event_rate_untuned_run_s_LECglu = {};
	event_rate_untuned_rest_s_LECglu = {};
	event_amp_untuned_run_s_LECglu = {};
	event_amp_untuned_rest_s_LECglu = {};
	event_width_untuned_run_s_LECglu = {};
	event_width_untuned_rest_s_LECglu = {};
	event_auc_untuned_run_s_LECglu = {};
	event_auc_untuned_rest_s_LECglu = {};
	event_rise_untuned_run_s_LECglu = {};
	event_rise_untuned_rest_s_LECglu = {};
	event_decay_untuned_run_s_LECglu = {};
	event_decay_untuned_rest_s_LECglu = {};
	event_rate_pop_run_s_LECglu = {};
	event_rate_pop_rest_s_LECglu = {};
	event_amp_pop_run_s_LECglu = {};
	event_amp_pop_rest_s_LECglu = {};
	event_width_pop_run_s_LECglu = {};
	event_width_pop_rest_s_LECglu = {};
	event_auc_pop_run_s_LECglu = {};
	event_auc_pop_rest_s_LECglu = {};
	event_rise_pop_run_s_LECglu = {};
	event_rise_pop_rest_s_LECglu = {};
	event_decay_pop_run_s_LECglu = {};
	event_decay_pop_rest_s_LECglu = {};
	event_rate_pop_tuned_s_LECglu = {};
	event_rate_pop_untuned_s_LECglu = {};
	event_amp_pop_tuned_s_LECglu = {};
	event_amp_pop_untuned_s_LECglu = {};
	event_width_pop_tuned_s_LECglu = {};
	event_width_pop_untuned_s_LECglu = {};
	event_auc_pop_tuned_s_LECglu = {};
	event_auc_pop_untuned_s_LECglu = {};
	event_rise_pop_tuned_s_LECglu = {};
	event_rise_pop_untuned_s_LECglu = {};
	event_decay_pop_tuned_s_LECglu = {};
	event_decay_pop_untuned_s_LECglu = {};
	event_rate_pop_tuned_run_s_LECglu = {};
	event_rate_pop_tuned_rest_s_LECglu = {};
	event_amp_pop_tuned_run_s_LECglu = {};
	event_amp_pop_tuned_rest_s_LECglu = {};
	event_width_pop_tuned_run_s_LECglu = {};
	event_width_pop_tuned_rest_s_LECglu = {};
	event_auc_pop_tuned_run_s_LECglu = {};
	event_auc_pop_tuned_rest_s_LECglu = {};
	event_rise_pop_tuned_run_s_LECglu = {};
	event_rise_pop_tuned_rest_s_LECglu = {};
	event_decay_pop_tuned_run_s_LECglu = {};
	event_decay_pop_tuned_rest_s_LECglu = {};
	event_rate_pop_untuned_run_s_LECglu = {};
	event_rate_pop_untuned_rest_s_LECglu = {};
	event_amp_pop_untuned_run_s_LECglu = {};
	event_amp_pop_untuned_rest_s_LECglu = {};
	event_width_pop_untuned_run_s_LECglu = {};
	event_width_pop_untuned_rest_s_LECglu = {};
	event_auc_pop_untuned_run_s_LECglu = {};
	event_auc_pop_untuned_rest_s_LECglu = {};
	event_rise_pop_untuned_run_s_LECglu = {};
	event_rise_pop_untuned_rest_s_LECglu = {};
	event_decay_pop_untuned_run_s_LECglu = {};
	event_decay_pop_untuned_rest_s_LECglu = {};
	fraction_active_ROIs_s_LECglu = {};
	fraction_active_ROIs_run_s_LECglu = {};
	fraction_active_ROIs_rest_s_LECglu = {};
	fraction_place_cells_s_LECglu = {};
	number_place_fields_s_LECglu = {};
	width_place_fields_s_LECglu = {};
	center_place_fields_s_LECglu = {};
	center_place_fields_index_s_LECglu = {};
	center_place_fields_active_s_LECglu = {};
	center_place_fields_index_sorted_s_LECglu = {};
	center_place_fields_active_sorted_s_LECglu = {};
	rate_map_s_LECglu = {};
	rate_map_z_s_LECglu = {};
	rate_map_n_s_LECglu = {};
	rate_map_active_s_LECglu = {};
	rate_map_active_z_s_LECglu = {};
	rate_map_active_n_s_LECglu = {};
	rate_map_active_sorted_s_LECglu = {};
	rate_map_active_sorted_z_s_LECglu = {};
	rate_map_active_sorted_n_s_LECglu = {};
	spatial_info_bits_s_LECglu = {};
	spatial_info_norm_s_LECglu = {};
	roi_pc_binary_s_LECglu = {};
	%dendrites
	event_rate_run_ad_LECglu = {};
	event_rate_rest_ad_LECglu = {};
	event_amp_run_ad_LECglu = {};
	event_amp_rest_ad_LECglu = {};
	event_width_run_ad_LECglu = {};
	event_width_rest_ad_LECglu = {};
	event_auc_run_ad_LECglu = {};
	event_auc_rest_ad_LECglu = {};
	event_rise_run_ad_LECglu = {};
	event_rise_rest_ad_LECglu = {};
	event_decay_run_ad_LECglu = {};
	event_decay_rest_ad_LECglu = {};
	event_rate_tuned_ad_LECglu = {};
	event_rate_untuned_ad_LECglu = {};
	event_amp_tuned_ad_LECglu = {};
	event_amp_untuned_ad_LECglu = {};
	event_width_tuned_ad_LECglu = {};
	event_width_untuned_ad_LECglu = {};
	event_auc_tuned_ad_LECglu = {};
	event_auc_untuned_ad_LECglu = {};
	event_rise_tuned_ad_LECglu = {};
	event_rise_untuned_ad_LECglu = {};
	event_decay_tuned_ad_LECglu = {};
	event_decay_untuned_ad_LECglu = {};
	event_rate_tuned_run_ad_LECglu = {};
	event_rate_tuned_rest_ad_LECglu = {};
	event_amp_tuned_run_ad_LECglu = {};
	event_amp_tuned_rest_ad_LECglu = {};
	event_width_tuned_run_ad_LECglu = {};
	event_width_tuned_rest_ad_LECglu = {};
	event_auc_tuned_run_ad_LECglu = {};
	event_auc_tuned_rest_ad_LECglu = {};
	event_rise_tuned_run_ad_LECglu = {};
	event_rise_tuned_rest_ad_LECglu = {};
	event_decay_tuned_run_ad_LECglu = {};
	event_decay_tuned_rest_ad_LECglu = {};
	event_rate_untuned_run_ad_LECglu = {};
	event_rate_untuned_rest_ad_LECglu = {};
	event_amp_untuned_run_ad_LECglu = {};
	event_amp_untuned_rest_ad_LECglu = {};
	event_width_untuned_run_ad_LECglu = {};
	event_width_untuned_rest_ad_LECglu = {};
	event_auc_untuned_run_ad_LECglu = {};
	event_auc_untuned_rest_ad_LECglu = {};
	event_rise_untuned_run_ad_LECglu = {};
	event_rise_untuned_rest_ad_LECglu = {};
	event_decay_untuned_run_ad_LECglu = {};
	event_decay_untuned_rest_ad_LECglu = {};
	event_rate_pop_run_ad_LECglu = {};
	event_rate_pop_rest_ad_LECglu = {};
	event_amp_pop_run_ad_LECglu = {};
	event_amp_pop_rest_ad_LECglu = {};
	event_width_pop_run_ad_LECglu = {};
	event_width_pop_rest_ad_LECglu = {};
	event_auc_pop_run_ad_LECglu = {};
	event_auc_pop_rest_ad_LECglu = {};
	event_rise_pop_run_ad_LECglu = {};
	event_rise_pop_rest_ad_LECglu = {};
	event_decay_pop_run_ad_LECglu = {};
	event_decay_pop_rest_ad_LECglu = {};
	event_rate_pop_tuned_ad_LECglu = {};
	event_rate_pop_untuned_ad_LECglu = {};
	event_amp_pop_tuned_ad_LECglu = {};
	event_amp_pop_untuned_ad_LECglu = {};
	event_width_pop_tuned_ad_LECglu = {};
	event_width_pop_untuned_ad_LECglu = {};
	event_auc_pop_tuned_ad_LECglu = {};
	event_auc_pop_untuned_ad_LECglu = {};
	event_rise_pop_tuned_ad_LECglu = {};
	event_rise_pop_untuned_ad_LECglu = {};
	event_decay_pop_tuned_ad_LECglu = {};
	event_decay_pop_untuned_ad_LECglu = {};
	event_rate_pop_tuned_run_ad_LECglu = {};
	event_rate_pop_tuned_rest_ad_LECglu = {};
	event_amp_pop_tuned_run_ad_LECglu = {};
	event_amp_pop_tuned_rest_ad_LECglu = {};
	event_width_pop_tuned_run_ad_LECglu = {};
	event_width_pop_tuned_rest_ad_LECglu = {};
	event_auc_pop_tuned_run_ad_LECglu = {};
	event_auc_pop_tuned_rest_ad_LECglu = {};
	event_rise_pop_tuned_run_ad_LECglu = {};
	event_rise_pop_tuned_rest_ad_LECglu = {};
	event_decay_pop_tuned_run_ad_LECglu = {};
	event_decay_pop_tuned_rest_ad_LECglu = {};
	event_rate_pop_untuned_run_ad_LECglu = {};
	event_rate_pop_untuned_rest_ad_LECglu = {};
	event_amp_pop_untuned_run_ad_LECglu = {};
	event_amp_pop_untuned_rest_ad_LECglu = {};
	event_width_pop_untuned_run_ad_LECglu = {};
	event_width_pop_untuned_rest_ad_LECglu = {};
	event_auc_pop_untuned_run_ad_LECglu = {};
	event_auc_pop_untuned_rest_ad_LECglu = {};
	event_rise_pop_untuned_run_ad_LECglu = {};
	event_rise_pop_untuned_rest_ad_LECglu = {};
	event_decay_pop_untuned_run_ad_LECglu = {};
	event_decay_pop_untuned_rest_ad_LECglu = {};
	fraction_active_ROIs_ad_LECglu = {};
	fraction_active_ROIs_run_ad_LECglu = {};
	fraction_active_ROIs_rest_ad_LECglu = {};
	fraction_place_cells_ad_LECglu = {};
	number_place_fields_ad_LECglu = {};
	width_place_fields_ad_LECglu = {};
	center_place_fields_ad_LECglu = {};
	center_place_fields_index_ad_LECglu = {};
	center_place_fields_active_ad_LECglu = {};
	center_place_fields_index_sorted_ad_LECglu = {};
	center_place_fields_active_sorted_ad_LECglu = {};
	rate_map_ad_LECglu = {};
	rate_map_z_ad_LECglu = {};
	rate_map_n_ad_LECglu = {};
	rate_map_active_ad_LECglu = {};
	rate_map_active_z_ad_LECglu = {};
	rate_map_active_n_ad_LECglu = {};
	rate_map_active_sorted_ad_LECglu = {};
	rate_map_active_sorted_z_ad_LECglu = {};
	rate_map_active_sorted_n_ad_LECglu = {};
	spatial_info_bits_ad_LECglu = {};
	spatial_info_norm_ad_LECglu = {};
	roi_pc_binary_ad_LECglu = {};
	%correlations
	TC_corr_z_cross_s_LECglu = {};
	TC_corr_z_cross_ad_LECglu = {};
	PV_corr_z_cross_s_LECglu = {};
	PV_corr_z_cross_ad_LECglu = {};
	TC_corr_z_pair_s_LECglu = {};
	TC_corr_z_pair_ad_LECglu = {};
	PV_corr_z_pair_s_LECglu = {};
	PV_corr_z_pair_ad_LECglu = {};
	TC_corr_z_ref_s_LECglu = {};
	TC_corr_z_ref_ad_LECglu = {};
	PV_corr_z_ref_s_LECglu = {};
	PV_corr_z_ref_ad_LECglu = {};
	for i=1:size(LECglu_sessions,2) %session groups
		for j=1:size(LECglu_id,2) %aminals
			m = find(cellfun(@(c) contains(LECglu_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECglu_sessions{i})),session_id(m),'UniformOutput',false));
			%soma
			event_rate_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_run_s(m,idx)';
			end
			event_rate_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_rest_s(m,idx)';
			end
			event_amp_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_run_s(m,idx)';
			end
			event_amp_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_rest_s(m,idx)';
			end
			event_width_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_run_s(m,idx)';
			end
			event_width_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_rest_s(m,idx)';
			end
			event_auc_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_run_s(m,idx)';
			end
			event_auc_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_rest_s(m,idx)';
			end
			event_rise_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_run_s(m,idx)';
			end
			event_rise_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_rest_s(m,idx)';
			end
			event_decay_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_run_s(m,idx)';
			end
			event_decay_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_rest_s(m,idx)';
			end
			event_rate_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_run_s(m,idx)';
			end
			event_rate_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_rest_s(m,idx)';
			end
			event_amp_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_run_s(m,idx)';
			end
			event_amp_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_rest_s(m,idx)';
			end
			event_width_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_run_s(m,idx)';
			end
			event_width_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_rest_s(m,idx)';
			end
			event_auc_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_run_s(m,idx)';
			end
			event_auc_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_rest_s(m,idx)';
			end
			event_rise_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_run_s(m,idx)';
			end
			event_rise_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_rest_s(m,idx)';
			end
			event_decay_pop_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_run_s(m,idx)';
			end
			event_decay_pop_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_rest_s(m,idx)';
			end
			fraction_active_ROIs_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_s_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_s(m,idx)';
			end
			fraction_active_ROIs_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_s_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_s(m,idx)';
			end
			fraction_active_ROIs_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_s_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_s(m,idx)';
			end
			fraction_place_cells_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_s_LECglu{i,2}(1:size(idx,1),j) = fraction_place_cells_s(m,idx)';
			end
			number_place_fields_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_s_LECglu{i,2}(1:size(idx,1),j) = number_place_fields_s(m,idx)';
			end
			width_place_fields_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_s_LECglu{i,2}(1:size(idx,1),j) = width_place_fields_s(m,idx)';
			end
			center_place_fields_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_s_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_s(m,idx)';
			end
			center_place_fields_index_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_s_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_index_s(m,idx)';
			end
			center_place_fields_active_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_s_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_active_s(m,idx)';
			end
			center_place_fields_index_sorted_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_s_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_s(m,idx)';
			end
			center_place_fields_active_sorted_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_s_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_s(m,idx)';
			end
			rate_map_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_s(m,idx)';
			end
			rate_map_z_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_z_s(m,idx)';
			end
			rate_map_n_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_n_s(m,idx)';
			end
			rate_map_active_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_s(m,idx)';
			end
			rate_map_active_z_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_z_s(m,idx)';
			end
			rate_map_active_n_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_n_s(m,idx)';
			end
			rate_map_active_sorted_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_s(m,idx)';
			end
			rate_map_active_sorted_z_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_s(m,idx)';
			end
			rate_map_active_sorted_n_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_s_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_s(m,idx)';
			end
			spatial_info_bits_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_s_LECglu{i,2}(1:size(idx,1),j) = spatial_info_bits_s(m,idx)';
			end
			spatial_info_norm_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_s_LECglu{i,2}(1:size(idx,1),j) = spatial_info_norm_s(m,idx)';
			end
			event_rate_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_s(m,idx)';
			end
			event_rate_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_s(m,idx)';
			end
			event_amp_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_s(m,idx)';
			end
			event_amp_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_s(m,idx)';
			end
			event_width_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_s(m,idx)';
			end
			event_width_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_s(m,idx)';
			end
			event_auc_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_s(m,idx)';
			end
			event_auc_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_s(m,idx)';
			end
			event_rise_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_s(m,idx)';
			end
			event_rise_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_s(m,idx)';
			end
			event_decay_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_s(m,idx)';
			end
			event_decay_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_s(m,idx)';
			end
			event_rate_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_run_s(m,idx)';
			end
			event_rate_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_s(m,idx)';
			end
			event_amp_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_run_s(m,idx)';
			end
			event_amp_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_s(m,idx)';
			end
			event_width_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_run_s(m,idx)';
			end
			event_width_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_rest_s(m,idx)';
			end
			event_auc_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_run_s(m,idx)';
			end
			event_auc_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_s(m,idx)';
			end
			event_rise_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_run_s(m,idx)';
			end
			event_rise_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_s(m,idx)';
			end
			event_decay_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_run_s(m,idx)';
			end
			event_decay_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_s(m,idx)';
			end
			event_rate_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_run_s(m,idx)';
			end
			event_rate_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_s(m,idx)';
			end
			event_amp_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_run_s(m,idx)';
			end
			event_amp_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_s(m,idx)';
			end
			event_width_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_run_s(m,idx)';
			end
			event_width_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_rest_s(m,idx)';
			end
			event_auc_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_run_s(m,idx)';
			end
			event_auc_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_s(m,idx)';
			end
			event_rise_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_run_s(m,idx)';
			end
			event_rise_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_s(m,idx)';
			end
			event_decay_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_run_s(m,idx)';
			end
			event_decay_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_s(m,idx)';
			end
			event_rate_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_s(m,idx)';
			end
			event_rate_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_s(m,idx)';
			end
			event_amp_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_s(m,idx)';
			end
			event_amp_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_s(m,idx)';
			end
			event_width_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_s(m,idx)';
			end
			event_width_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_s(m,idx)';
			end
			event_auc_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_s(m,idx)';
			end
			event_auc_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_s(m,idx)';
			end
			event_rise_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_s(m,idx)';
			end
			event_rise_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_s(m,idx)';
			end
			event_decay_pop_tuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_s(m,idx)';
			end
			event_decay_pop_untuned_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_s(m,idx)';
			end
			event_rate_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_s(m,idx)';
			end
			event_rate_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_s(m,idx)';
			end
			event_amp_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_s(m,idx)';
			end
			event_amp_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_s(m,idx)';
			end
			event_width_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_s(m,idx)';
			end
			event_width_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_s(m,idx)';
			end
			event_auc_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_s(m,idx)';
			end
			event_auc_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_s(m,idx)';
			end
			event_rise_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_s(m,idx)';
			end
			event_rise_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_s(m,idx)';
			end
			event_decay_pop_tuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_s(m,idx)';
			end
			event_decay_pop_tuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_s(m,idx)';
			end
			event_rate_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_s(m,idx)';
			end
			event_rate_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_s(m,idx)';
			end
			event_amp_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_s(m,idx)';
			end
			event_amp_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_s(m,idx)';
			end
			event_width_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_s(m,idx)';
			end
			event_width_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_s(m,idx)';
			end
			event_auc_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_s(m,idx)';
			end
			event_auc_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_s(m,idx)';
			end
			event_rise_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_s(m,idx)';
			end
			event_rise_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_s(m,idx)';
			end
			event_decay_pop_untuned_run_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_s(m,idx)';
			end
			event_decay_pop_untuned_rest_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_s_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_s(m,idx)';
			end
			roi_pc_binary_s_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_s_LECglu{i,2}(1:size(idx,1),j) = roi_pc_binary_s(m,idx)';
			end
			%dendrites
			event_rate_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_run_ad(m,idx)';
			end
			event_rate_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_rest_ad(m,idx)';
			end
			event_amp_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_run_ad(m,idx)';
			end
			event_amp_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_rest_ad(m,idx)';
			end
			event_width_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_run_ad(m,idx)';
			end
			event_width_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_rest_ad(m,idx)';
			end
			event_auc_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_run_ad(m,idx)';
			end
			event_auc_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_rest_ad(m,idx)';
			end
			event_rise_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_run_ad(m,idx)';
			end
			event_rise_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_rest_ad(m,idx)';
			end
			event_decay_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_run_ad(m,idx)';
			end
			event_decay_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_rest_ad(m,idx)';
			end
			event_rate_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_run_ad(m,idx)';
			end
			event_rate_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_rest_ad(m,idx)';
			end
			event_amp_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_run_ad(m,idx)';
			end
			event_amp_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_rest_ad(m,idx)';
			end
			event_width_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_run_ad(m,idx)';
			end
			event_width_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_rest_ad(m,idx)';
			end
			event_auc_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_run_ad(m,idx)';
			end
			event_auc_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_rest_ad(m,idx)';
			end
			event_rise_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_run_ad(m,idx)';
			end
			event_rise_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_rest_ad(m,idx)';
			end
			event_decay_pop_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_run_ad(m,idx)';
			end
			event_decay_pop_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_rest_ad(m,idx)';
			end
			fraction_active_ROIs_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_ad_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_ad(m,idx)';
			end
			fraction_active_ROIs_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_ad_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_ad(m,idx)';
			end
			fraction_active_ROIs_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_ad_LECglu{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_ad(m,idx)';
			end
			fraction_place_cells_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_ad_LECglu{i,2}(1:size(idx,1),j) = fraction_place_cells_ad(m,idx)';
			end
			number_place_fields_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_ad_LECglu{i,2}(1:size(idx,1),j) = number_place_fields_ad(m,idx)';
			end
			width_place_fields_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_ad_LECglu{i,2}(1:size(idx,1),j) = width_place_fields_ad(m,idx)';
			end
			center_place_fields_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_ad_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_ad(m,idx)';
			end
			center_place_fields_index_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_ad_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_index_ad(m,idx)';
			end
			center_place_fields_active_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_ad_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_active_ad(m,idx)';
			end
			center_place_fields_index_sorted_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_ad_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_ad(m,idx)';
			end
			center_place_fields_active_sorted_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_ad_LECglu{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_ad(m,idx)';
			end
			rate_map_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_ad(m,idx)';
			end
			rate_map_z_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_z_ad(m,idx)';
			end
			rate_map_n_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_n_ad(m,idx)';
			end
			rate_map_active_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_ad(m,idx)';
			end
			rate_map_active_z_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_z_ad(m,idx)';
			end
			rate_map_active_n_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_n_ad(m,idx)';
			end
			rate_map_active_sorted_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_ad(m,idx)';
			end
			rate_map_active_sorted_z_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_ad(m,idx)';
			end
			rate_map_active_sorted_n_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_ad_LECglu{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_ad(m,idx)';
			end
			spatial_info_bits_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_ad_LECglu{i,2}(1:size(idx,1),j) = spatial_info_bits_ad(m,idx)';
			end
			spatial_info_norm_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_ad_LECglu{i,2}(1:size(idx,1),j) = spatial_info_norm_ad(m,idx)';
			end
			event_rate_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_ad(m,idx)';
			end
			event_rate_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_ad(m,idx)';
			end
			event_amp_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_ad(m,idx)';
			end
			event_amp_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_ad(m,idx)';
			end
			event_width_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_ad(m,idx)';
			end
			event_width_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_ad(m,idx)';
			end
			event_auc_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_ad(m,idx)';
			end
			event_auc_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_ad(m,idx)';
			end
			event_rise_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_ad(m,idx)';
			end
			event_rise_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_ad(m,idx)';
			end
			event_decay_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_ad(m,idx)';
			end
			event_decay_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_ad(m,idx)';
			end
			event_rate_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_run_ad(m,idx)';
			end
			event_rate_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_ad(m,idx)';
			end
			event_amp_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_run_ad(m,idx)';
			end
			event_amp_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_ad(m,idx)';
			end
			event_width_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_run_ad(m,idx)';
			end
			event_width_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_tuned_rest_ad(m,idx)';
			end
			event_auc_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_run_ad(m,idx)';
			end
			event_auc_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_ad(m,idx)';
			end
			event_rise_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_run_ad(m,idx)';
			end
			event_rise_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_ad(m,idx)';
			end
			event_decay_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_run_ad(m,idx)';
			end
			event_decay_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_ad(m,idx)';
			end
			event_rate_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_run_ad(m,idx)';
			end
			event_rate_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_ad(m,idx)';
			end
			event_amp_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_run_ad(m,idx)';
			end
			event_amp_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_ad(m,idx)';
			end
			event_width_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_run_ad(m,idx)';
			end
			event_width_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_untuned_rest_ad(m,idx)';
			end
			event_auc_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_run_ad(m,idx)';
			end
			event_auc_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_ad(m,idx)';
			end
			event_rise_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_run_ad(m,idx)';
			end
			event_rise_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_ad(m,idx)';
			end
			event_decay_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_run_ad(m,idx)';
			end
			event_decay_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_ad(m,idx)';
			end
			event_rate_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_ad(m,idx)';
			end
			event_rate_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_ad(m,idx)';
			end
			event_amp_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_ad(m,idx)';
			end
			event_amp_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_ad(m,idx)';
			end
			event_width_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_ad(m,idx)';
			end
			event_width_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_ad(m,idx)';
			end
			event_auc_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_ad(m,idx)';
			end
			event_auc_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_ad(m,idx)';
			end
			event_rise_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_ad(m,idx)';
			end
			event_rise_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_ad(m,idx)';
			end
			event_decay_pop_tuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_ad(m,idx)';
			end
			event_decay_pop_untuned_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_ad(m,idx)';
			end
			event_rate_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_ad(m,idx)';
			end
			event_rate_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_ad(m,idx)';
			end
			event_amp_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_ad(m,idx)';
			end
			event_amp_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_ad(m,idx)';
			end
			event_width_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_ad(m,idx)';
			end
			event_width_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_ad(m,idx)';
			end
			event_auc_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_ad(m,idx)';
			end
			event_auc_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_ad(m,idx)';
			end
			event_rise_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_ad(m,idx)';
			end
			event_rise_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_ad(m,idx)';
			end
			event_decay_pop_tuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_ad(m,idx)';
			end
			event_decay_pop_tuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_ad(m,idx)';
			end
			event_rate_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_ad(m,idx)';
			end
			event_rate_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_ad(m,idx)';
			end
			event_amp_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_ad(m,idx)';
			end
			event_amp_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_ad(m,idx)';
			end
			event_width_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_ad(m,idx)';
			end
			event_width_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_ad(m,idx)';
			end
			event_auc_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_ad(m,idx)';
			end
			event_auc_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_ad(m,idx)';
			end
			event_rise_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_ad(m,idx)';
			end
			event_rise_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_ad(m,idx)';
			end
			event_decay_pop_untuned_run_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_ad(m,idx)';
			end
			event_decay_pop_untuned_rest_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_ad_LECglu{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_ad(m,idx)';
			end
			roi_pc_binary_ad_LECglu{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_ad_LECglu{i,2}(1:size(idx,1),j) = roi_pc_binary_ad(m,idx)';
			end
		end
		%soma
		try
			nanidx = cellfun('isempty',event_rate_run_s_LECglu{i,2});
			event_rate_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_run_s_LECglu{i,2} = cell2mat(event_rate_run_s_LECglu{i,2});
			event_rate_run_s_LECglu{i,3} = mean(event_rate_run_s_LECglu{i,2},2,'omitnan');
			event_rate_run_s_LECglu{i,4} = std(event_rate_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_s_LECglu{i,2});
			event_rate_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_rest_s_LECglu{i,2} = cell2mat(event_rate_rest_s_LECglu{i,2});
			event_rate_rest_s_LECglu{i,3} = mean(event_rate_rest_s_LECglu{i,2},2,'omitnan');
			event_rate_rest_s_LECglu{i,4} = std(event_rate_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_s_LECglu{i,2});
			event_amp_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_run_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_run_s_LECglu{i,2},'UniformOutput',false);
			event_amp_run_s_LECglu{i,2} = cell2mat(event_amp_run_s_LECglu{i,2});
			event_amp_run_s_LECglu{i,3} = mean(event_amp_run_s_LECglu{i,2},2,'omitnan');
			event_amp_run_s_LECglu{i,4} = std(event_amp_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_s_LECglu{i,2});
			event_amp_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_rest_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_rest_s_LECglu{i,2},'UniformOutput',false);
			event_amp_rest_s_LECglu{i,2} = cell2mat(event_amp_rest_s_LECglu{i,2});
			event_amp_rest_s_LECglu{i,3} = mean(event_amp_rest_s_LECglu{i,2},2,'omitnan');
			event_amp_rest_s_LECglu{i,4} = std(event_amp_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_s_LECglu{i,2});
			event_width_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_run_s_LECglu{i,2} = cell2mat(event_width_run_s_LECglu{i,2});
			event_width_run_s_LECglu{i,3} = mean(event_width_run_s_LECglu{i,2},2,'omitnan');
			event_width_run_s_LECglu{i,4} = std(event_width_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_s_LECglu{i,2});
			event_width_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_rest_s_LECglu{i,2} = cell2mat(event_width_rest_s_LECglu{i,2});
			event_width_rest_s_LECglu{i,3} = mean(event_width_rest_s_LECglu{i,2},2,'omitnan');
			event_width_rest_s_LECglu{i,4} = std(event_width_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_s_LECglu{i,2});
			event_auc_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_run_s_LECglu{i,2} = cell2mat(event_auc_run_s_LECglu{i,2});
			event_auc_run_s_LECglu{i,3} = mean(event_auc_run_s_LECglu{i,2},2,'omitnan');
			event_auc_run_s_LECglu{i,4} = std(event_auc_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_s_LECglu{i,2});
			event_auc_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_rest_s_LECglu{i,2} = cell2mat(event_auc_rest_s_LECglu{i,2});
			event_auc_rest_s_LECglu{i,3} = mean(event_auc_rest_s_LECglu{i,2},2,'omitnan');
			event_auc_rest_s_LECglu{i,4} = std(event_auc_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_s_LECglu{i,2});
			event_rise_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_run_s_LECglu{i,2} = cell2mat(event_rise_run_s_LECglu{i,2});
			event_rise_run_s_LECglu{i,3} = mean(event_rise_run_s_LECglu{i,2},2,'omitnan');
			event_rise_run_s_LECglu{i,4} = std(event_rise_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_s_LECglu{i,2});
			event_rise_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_rest_s_LECglu{i,2} = cell2mat(event_rise_rest_s_LECglu{i,2});
			event_rise_rest_s_LECglu{i,3} = mean(event_rise_rest_s_LECglu{i,2},2,'omitnan');
			event_rise_rest_s_LECglu{i,4} = std(event_rise_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_s_LECglu{i,2});
			event_decay_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_run_s_LECglu{i,2} = cell2mat(event_decay_run_s_LECglu{i,2});
			event_decay_run_s_LECglu{i,3} = mean(event_decay_run_s_LECglu{i,2},2,'omitnan');
			event_decay_run_s_LECglu{i,4} = std(event_decay_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_s_LECglu{i,2});
			event_decay_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_rest_s_LECglu{i,2} = cell2mat(event_decay_rest_s_LECglu{i,2});
			event_decay_rest_s_LECglu{i,3} = mean(event_decay_rest_s_LECglu{i,2},2,'omitnan');
			event_decay_rest_s_LECglu{i,4} = std(event_decay_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_s_LECglu{i,2});
			fraction_active_ROIs_s_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_s_LECglu{i,2} = cell2mat(fraction_active_ROIs_s_LECglu{i,2});
			fraction_active_ROIs_s_LECglu{i,3} = mean(fraction_active_ROIs_s_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_s_LECglu{i,4} = std(fraction_active_ROIs_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_s_LECglu{i,2});
			fraction_active_ROIs_run_s_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_s_LECglu{i,2} = cell2mat(fraction_active_ROIs_run_s_LECglu{i,2});
			fraction_active_ROIs_run_s_LECglu{i,3} = mean(fraction_active_ROIs_run_s_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_run_s_LECglu{i,4} = std(fraction_active_ROIs_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_s_LECglu{i,2});
			fraction_active_ROIs_rest_s_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_s_LECglu{i,2} = cell2mat(fraction_active_ROIs_rest_s_LECglu{i,2});
			fraction_active_ROIs_rest_s_LECglu{i,3} = mean(fraction_active_ROIs_rest_s_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_rest_s_LECglu{i,4} = std(fraction_active_ROIs_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_s_LECglu{i,2});
			fraction_place_cells_s_LECglu{i,2}(nanidx) = {NaN};
			fraction_place_cells_s_LECglu{i,2} = cell2mat(fraction_place_cells_s_LECglu{i,2});
			fraction_place_cells_s_LECglu{i,3} = mean(fraction_place_cells_s_LECglu{i,2},2,'omitnan');
			fraction_place_cells_s_LECglu{i,4} = std(fraction_place_cells_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_s_LECglu{i,2});
			number_place_fields_s_LECglu{i,2}(nanidx) = {NaN};
			number_place_fields_s_LECglu{i,2} = cell2mat(number_place_fields_s_LECglu{i,2});
			number_place_fields_s_LECglu{i,3} = mean(number_place_fields_s_LECglu{i,2},2,'omitnan');
			number_place_fields_s_LECglu{i,4} = std(number_place_fields_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_s_LECglu{i,2});
			width_place_fields_s_LECglu{i,2}(nanidx) = {NaN};
			width_place_fields_s_LECglu{i,2} = cell2mat(width_place_fields_s_LECglu{i,2});
			width_place_fields_s_LECglu{i,3} = mean(width_place_fields_s_LECglu{i,2},2,'omitnan');
			width_place_fields_s_LECglu{i,4} = std(width_place_fields_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_s_LECglu{i,2});
			center_place_fields_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_s_LECglu{i,2});
			center_place_fields_index_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_s_LECglu{i,2});
			center_place_fields_active_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_s_LECglu{i,2});
			center_place_fields_index_sorted_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_s_LECglu{i,2});
			center_place_fields_active_sorted_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_s_LECglu{i,2});
			rate_map_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_s_LECglu{i,2});
			rate_map_z_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_s_LECglu{i,2});
			rate_map_n_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_s_LECglu{i,2});
			rate_map_active_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_s_LECglu{i,2});
			rate_map_active_z_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_s_LECglu{i,2});
			rate_map_active_n_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_s_LECglu{i,2});
			rate_map_active_sorted_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_s_LECglu{i,2});
			rate_map_active_sorted_z_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_s_LECglu{i,2});
			rate_map_active_sorted_n_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_s_LECglu{i,2});
			spatial_info_bits_s_LECglu{i,2}(nanidx) = {NaN};
			spatial_info_bits_s_LECglu{i,2} = cell2mat(spatial_info_bits_s_LECglu{i,2});
			spatial_info_bits_s_LECglu{i,3} = mean(spatial_info_bits_s_LECglu{i,2},2,'omitnan');
			spatial_info_bits_s_LECglu{i,4} = std(spatial_info_bits_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_s_LECglu{i,2});
			spatial_info_norm_s_LECglu{i,2}(nanidx) = {NaN};
			spatial_info_norm_s_LECglu{i,2} = cell2mat(spatial_info_norm_s_LECglu{i,2});
			spatial_info_norm_s_LECglu{i,3} = mean(spatial_info_norm_s_LECglu{i,2},2,'omitnan');
			spatial_info_norm_s_LECglu{i,4} = std(spatial_info_norm_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_s_LECglu{i,2});
			event_rate_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_s_LECglu{i,2} = cell2mat(event_rate_tuned_s_LECglu{i,2});
			event_rate_tuned_s_LECglu{i,3} = mean(event_rate_tuned_s_LECglu{i,2},2,'omitnan');
			event_rate_tuned_s_LECglu{i,4} = std(event_rate_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_s_LECglu{i,2});
			event_rate_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_s_LECglu{i,2} = cell2mat(event_rate_untuned_s_LECglu{i,2});
			event_rate_untuned_s_LECglu{i,3} = mean(event_rate_untuned_s_LECglu{i,2},2,'omitnan');
			event_rate_untuned_s_LECglu{i,4} = std(event_rate_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_s_LECglu{i,2});
			event_amp_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_s_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_s_LECglu{i,2} = cell2mat(event_amp_tuned_s_LECglu{i,2});
			event_amp_tuned_s_LECglu{i,3} = mean(event_amp_tuned_s_LECglu{i,2},2,'omitnan');
			event_amp_tuned_s_LECglu{i,4} = std(event_amp_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_s_LECglu{i,2});
			event_amp_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_s_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_s_LECglu{i,2} = cell2mat(event_amp_untuned_s_LECglu{i,2});
			event_amp_untuned_s_LECglu{i,3} = mean(event_amp_untuned_s_LECglu{i,2},2,'omitnan');
			event_amp_untuned_s_LECglu{i,4} = std(event_amp_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_s_LECglu{i,2});
			event_width_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_s_LECglu{i,2} = cell2mat(event_width_tuned_s_LECglu{i,2});
			event_width_tuned_s_LECglu{i,3} = mean(event_width_tuned_s_LECglu{i,2},2,'omitnan');
			event_width_tuned_s_LECglu{i,4} = std(event_width_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_s_LECglu{i,2});
			event_width_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_s_LECglu{i,2} = cell2mat(event_width_untuned_s_LECglu{i,2});
			event_width_untuned_s_LECglu{i,3} = mean(event_width_untuned_s_LECglu{i,2},2,'omitnan');
			event_width_untuned_s_LECglu{i,4} = std(event_width_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_s_LECglu{i,2});
			event_auc_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_s_LECglu{i,2} = cell2mat(event_auc_tuned_s_LECglu{i,2});
			event_auc_tuned_s_LECglu{i,3} = mean(event_auc_tuned_s_LECglu{i,2},2,'omitnan');
			event_auc_tuned_s_LECglu{i,4} = std(event_auc_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_s_LECglu{i,2});
			event_auc_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_s_LECglu{i,2} = cell2mat(event_auc_untuned_s_LECglu{i,2});
			event_auc_untuned_s_LECglu{i,3} = mean(event_auc_untuned_s_LECglu{i,2},2,'omitnan');
			event_auc_untuned_s_LECglu{i,4} = std(event_auc_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_s_LECglu{i,2});
			event_rise_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_s_LECglu{i,2} = cell2mat(event_rise_tuned_s_LECglu{i,2});
			event_rise_tuned_s_LECglu{i,3} = mean(event_rise_tuned_s_LECglu{i,2},2,'omitnan');
			event_rise_tuned_s_LECglu{i,4} = std(event_rise_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_s_LECglu{i,2});
			event_rise_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_s_LECglu{i,2} = cell2mat(event_rise_untuned_s_LECglu{i,2});
			event_rise_untuned_s_LECglu{i,3} = mean(event_rise_untuned_s_LECglu{i,2},2,'omitnan');
			event_rise_untuned_s_LECglu{i,4} = std(event_rise_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_s_LECglu{i,2});
			event_decay_tuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_s_LECglu{i,2} = cell2mat(event_decay_tuned_s_LECglu{i,2});
			event_decay_tuned_s_LECglu{i,3} = mean(event_decay_tuned_s_LECglu{i,2},2,'omitnan');
			event_decay_tuned_s_LECglu{i,4} = std(event_decay_tuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_s_LECglu{i,2});
			event_decay_untuned_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_s_LECglu{i,2} = cell2mat(event_decay_untuned_s_LECglu{i,2});
			event_decay_untuned_s_LECglu{i,3} = mean(event_decay_untuned_s_LECglu{i,2},2,'omitnan');
			event_decay_untuned_s_LECglu{i,4} = std(event_decay_untuned_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_s_LECglu{i,2});
			event_rate_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_s_LECglu{i,2} = cell2mat(event_rate_tuned_run_s_LECglu{i,2});
			event_rate_tuned_run_s_LECglu{i,3} = mean(event_rate_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_rate_tuned_run_s_LECglu{i,4} = std(event_rate_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_s_LECglu{i,2});
			event_rate_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_s_LECglu{i,2} = cell2mat(event_rate_tuned_rest_s_LECglu{i,2});
			event_rate_tuned_rest_s_LECglu{i,3} = mean(event_rate_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_rate_tuned_rest_s_LECglu{i,4} = std(event_rate_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_s_LECglu{i,2});
			event_amp_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_s_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_run_s_LECglu{i,2} = cell2mat(event_amp_tuned_run_s_LECglu{i,2});
			event_amp_tuned_run_s_LECglu{i,3} = mean(event_amp_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_amp_tuned_run_s_LECglu{i,4} = std(event_amp_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_s_LECglu{i,2});
			event_amp_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_s_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_rest_s_LECglu{i,2} = cell2mat(event_amp_tuned_rest_s_LECglu{i,2});
			event_amp_tuned_rest_s_LECglu{i,3} = mean(event_amp_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_amp_tuned_rest_s_LECglu{i,4} = std(event_amp_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_s_LECglu{i,2});
			event_width_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_run_s_LECglu{i,2} = cell2mat(event_width_tuned_run_s_LECglu{i,2});
			event_width_tuned_run_s_LECglu{i,3} = mean(event_width_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_width_tuned_run_s_LECglu{i,4} = std(event_width_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_s_LECglu{i,2});
			event_width_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_s_LECglu{i,2} = cell2mat(event_width_tuned_rest_s_LECglu{i,2});
			event_width_tuned_rest_s_LECglu{i,3} = mean(event_width_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_width_tuned_rest_s_LECglu{i,4} = std(event_width_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_s_LECglu{i,2});
			event_auc_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_s_LECglu{i,2} = cell2mat(event_auc_tuned_run_s_LECglu{i,2});
			event_auc_tuned_run_s_LECglu{i,3} = mean(event_auc_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_auc_tuned_run_s_LECglu{i,4} = std(event_auc_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_s_LECglu{i,2});
			event_auc_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_s_LECglu{i,2} = cell2mat(event_auc_tuned_rest_s_LECglu{i,2});
			event_auc_tuned_rest_s_LECglu{i,3} = mean(event_auc_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_auc_tuned_rest_s_LECglu{i,4} = std(event_auc_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_s_LECglu{i,2});
			event_rise_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_s_LECglu{i,2} = cell2mat(event_rise_tuned_run_s_LECglu{i,2});
			event_rise_tuned_run_s_LECglu{i,3} = mean(event_rise_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_rise_tuned_run_s_LECglu{i,4} = std(event_rise_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_s_LECglu{i,2});
			event_rise_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_s_LECglu{i,2} = cell2mat(event_rise_tuned_rest_s_LECglu{i,2});
			event_rise_tuned_rest_s_LECglu{i,3} = mean(event_rise_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_rise_tuned_rest_s_LECglu{i,4} = std(event_rise_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_s_LECglu{i,2});
			event_decay_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_s_LECglu{i,2} = cell2mat(event_decay_tuned_run_s_LECglu{i,2});
			event_decay_tuned_run_s_LECglu{i,3} = mean(event_decay_tuned_run_s_LECglu{i,2},2,'omitnan');
			event_decay_tuned_run_s_LECglu{i,4} = std(event_decay_tuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_s_LECglu{i,2});
			event_decay_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_s_LECglu{i,2} = cell2mat(event_decay_tuned_rest_s_LECglu{i,2});
			event_decay_tuned_rest_s_LECglu{i,3} = mean(event_decay_tuned_rest_s_LECglu{i,2},2,'omitnan');
			event_decay_tuned_rest_s_LECglu{i,4} = std(event_decay_tuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_s_LECglu{i,2});
			event_rate_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_s_LECglu{i,2} = cell2mat(event_rate_untuned_run_s_LECglu{i,2});
			event_rate_untuned_run_s_LECglu{i,3} = mean(event_rate_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_rate_untuned_run_s_LECglu{i,4} = std(event_rate_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_s_LECglu{i,2});
			event_rate_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_s_LECglu{i,2} = cell2mat(event_rate_untuned_rest_s_LECglu{i,2});
			event_rate_untuned_rest_s_LECglu{i,3} = mean(event_rate_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_rate_untuned_rest_s_LECglu{i,4} = std(event_rate_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_s_LECglu{i,2});
			event_amp_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_s_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_run_s_LECglu{i,2} = cell2mat(event_amp_untuned_run_s_LECglu{i,2});
			event_amp_untuned_run_s_LECglu{i,3} = mean(event_amp_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_amp_untuned_run_s_LECglu{i,4} = std(event_amp_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_s_LECglu{i,2});
			event_amp_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_s_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_s_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_rest_s_LECglu{i,2} = cell2mat(event_amp_untuned_rest_s_LECglu{i,2});
			event_amp_untuned_rest_s_LECglu{i,3} = mean(event_amp_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_amp_untuned_rest_s_LECglu{i,4} = std(event_amp_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_s_LECglu{i,2});
			event_width_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_run_s_LECglu{i,2} = cell2mat(event_width_untuned_run_s_LECglu{i,2});
			event_width_untuned_run_s_LECglu{i,3} = mean(event_width_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_width_untuned_run_s_LECglu{i,4} = std(event_width_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_s_LECglu{i,2});
			event_width_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_s_LECglu{i,2} = cell2mat(event_width_untuned_rest_s_LECglu{i,2});
			event_width_untuned_rest_s_LECglu{i,3} = mean(event_width_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_width_untuned_rest_s_LECglu{i,4} = std(event_width_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_s_LECglu{i,2});
			event_auc_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_s_LECglu{i,2} = cell2mat(event_auc_untuned_run_s_LECglu{i,2});
			event_auc_untuned_run_s_LECglu{i,3} = mean(event_auc_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_auc_untuned_run_s_LECglu{i,4} = std(event_auc_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_s_LECglu{i,2});
			event_auc_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_s_LECglu{i,2} = cell2mat(event_auc_untuned_rest_s_LECglu{i,2});
			event_auc_untuned_rest_s_LECglu{i,3} = mean(event_auc_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_auc_untuned_rest_s_LECglu{i,4} = std(event_auc_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_s_LECglu{i,2});
			event_rise_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_s_LECglu{i,2} = cell2mat(event_rise_untuned_run_s_LECglu{i,2});
			event_rise_untuned_run_s_LECglu{i,3} = mean(event_rise_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_rise_untuned_run_s_LECglu{i,4} = std(event_rise_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_s_LECglu{i,2});
			event_rise_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_s_LECglu{i,2} = cell2mat(event_rise_untuned_rest_s_LECglu{i,2});
			event_rise_untuned_rest_s_LECglu{i,3} = mean(event_rise_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_rise_untuned_rest_s_LECglu{i,4} = std(event_rise_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_s_LECglu{i,2});
			event_decay_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_s_LECglu{i,2} = cell2mat(event_decay_untuned_run_s_LECglu{i,2});
			event_decay_untuned_run_s_LECglu{i,3} = mean(event_decay_untuned_run_s_LECglu{i,2},2,'omitnan');
			event_decay_untuned_run_s_LECglu{i,4} = std(event_decay_untuned_run_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_s_LECglu{i,2});
			event_decay_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_s_LECglu{i,2} = cell2mat(event_decay_untuned_rest_s_LECglu{i,2});
			event_decay_untuned_rest_s_LECglu{i,3} = mean(event_decay_untuned_rest_s_LECglu{i,2},2,'omitnan');
			event_decay_untuned_rest_s_LECglu{i,4} = std(event_decay_untuned_rest_s_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_s_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_s_LECglu{i,2});
			roi_pc_binary_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_s_LECglu{i,2});
			event_rate_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_s_LECglu{i,2});
			event_rate_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_s_LECglu{i,2});
			event_amp_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_s_LECglu{i,2});
			event_amp_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_s_LECglu{i,2});
			event_width_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_s_LECglu{i,2});
			event_width_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_s_LECglu{i,2});
			event_auc_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_s_LECglu{i,2});
			event_auc_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_s_LECglu{i,2});
			event_rise_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_s_LECglu{i,2});
			event_rise_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_s_LECglu{i,2});
			event_decay_pop_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_s_LECglu{i,2});
			event_decay_pop_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_s_LECglu{i,2});
			event_rate_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_s_LECglu{i,2});
			event_rate_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_s_LECglu{i,2});
			event_amp_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_s_LECglu{i,2});
			event_amp_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_s_LECglu{i,2});
			event_width_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_s_LECglu{i,2});
			event_width_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_s_LECglu{i,2});
			event_auc_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_s_LECglu{i,2});
			event_auc_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_s_LECglu{i,2});
			event_rise_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_s_LECglu{i,2});
			event_rise_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_s_LECglu{i,2});
			event_decay_pop_tuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_s_LECglu{i,2});
			event_decay_pop_untuned_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_s_LECglu{i,2});
			event_rate_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_s_LECglu{i,2});
			event_rate_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_s_LECglu{i,2});
			event_amp_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_s_LECglu{i,2});
			event_amp_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_s_LECglu{i,2});
			event_width_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_s_LECglu{i,2});
			event_width_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_s_LECglu{i,2});
			event_auc_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_s_LECglu{i,2});
			event_auc_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_s_LECglu{i,2});
			event_rise_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_s_LECglu{i,2});
			event_rise_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_s_LECglu{i,2});
			event_decay_pop_tuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_s_LECglu{i,2});
			event_decay_pop_tuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_s_LECglu{i,2});
			event_rate_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_s_LECglu{i,2});
			event_rate_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_s_LECglu{i,2});
			event_amp_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_s_LECglu{i,2});
			event_amp_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_s_LECglu{i,2});
			event_width_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_s_LECglu{i,2});
			event_width_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_s_LECglu{i,2});
			event_auc_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_s_LECglu{i,2});
			event_auc_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_s_LECglu{i,2});
			event_rise_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_s_LECglu{i,2});
			event_rise_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_s_LECglu{i,2});
			event_decay_pop_untuned_run_s_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_s_LECglu{i,2});
			event_decay_pop_untuned_rest_s_LECglu{i,2}(nanidx) = {NaN};
		end
		%dendrites
		try
			nanidx = cellfun('isempty',event_rate_run_ad_LECglu{i,2});
			event_rate_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_run_ad_LECglu{i,2} = cell2mat(event_rate_run_ad_LECglu{i,2});
			event_rate_run_ad_LECglu{i,3} = mean(event_rate_run_ad_LECglu{i,2},2,'omitnan');
			event_rate_run_ad_LECglu{i,4} = std(event_rate_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_ad_LECglu{i,2});
			event_rate_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_rest_ad_LECglu{i,2} = cell2mat(event_rate_rest_ad_LECglu{i,2});
			event_rate_rest_ad_LECglu{i,3} = mean(event_rate_rest_ad_LECglu{i,2},2,'omitnan');
			event_rate_rest_ad_LECglu{i,4} = std(event_rate_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_ad_LECglu{i,2});
			event_amp_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_run_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_run_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_run_ad_LECglu{i,2} = cell2mat(event_amp_run_ad_LECglu{i,2});
			event_amp_run_ad_LECglu{i,3} = mean(event_amp_run_ad_LECglu{i,2},2,'omitnan');
			event_amp_run_ad_LECglu{i,4} = std(event_amp_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_ad_LECglu{i,2});
			event_amp_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_rest_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_rest_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_rest_ad_LECglu{i,2} = cell2mat(event_amp_rest_ad_LECglu{i,2});
			event_amp_rest_ad_LECglu{i,3} = mean(event_amp_rest_ad_LECglu{i,2},2,'omitnan');
			event_amp_rest_ad_LECglu{i,4} = std(event_amp_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_ad_LECglu{i,2});
			event_width_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_run_ad_LECglu{i,2} = cell2mat(event_width_run_ad_LECglu{i,2});
			event_width_run_ad_LECglu{i,3} = mean(event_width_run_ad_LECglu{i,2},2,'omitnan');
			event_width_run_ad_LECglu{i,4} = std(event_width_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_ad_LECglu{i,2});
			event_width_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_rest_ad_LECglu{i,2} = cell2mat(event_width_rest_ad_LECglu{i,2});
			event_width_rest_ad_LECglu{i,3} = mean(event_width_rest_ad_LECglu{i,2},2,'omitnan');
			event_width_rest_ad_LECglu{i,4} = std(event_width_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_ad_LECglu{i,2});
			event_auc_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_run_ad_LECglu{i,2} = cell2mat(event_auc_run_ad_LECglu{i,2});
			event_auc_run_ad_LECglu{i,3} = mean(event_auc_run_ad_LECglu{i,2},2,'omitnan');
			event_auc_run_ad_LECglu{i,4} = std(event_auc_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_ad_LECglu{i,2});
			event_auc_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_rest_ad_LECglu{i,2} = cell2mat(event_auc_rest_ad_LECglu{i,2});
			event_auc_rest_ad_LECglu{i,3} = mean(event_auc_rest_ad_LECglu{i,2},2,'omitnan');
			event_auc_rest_ad_LECglu{i,4} = std(event_auc_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_ad_LECglu{i,2});
			event_rise_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_run_ad_LECglu{i,2} = cell2mat(event_rise_run_ad_LECglu{i,2});
			event_rise_run_ad_LECglu{i,3} = mean(event_rise_run_ad_LECglu{i,2},2,'omitnan');
			event_rise_run_ad_LECglu{i,4} = std(event_rise_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_ad_LECglu{i,2});
			event_rise_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_rest_ad_LECglu{i,2} = cell2mat(event_rise_rest_ad_LECglu{i,2});
			event_rise_rest_ad_LECglu{i,3} = mean(event_rise_rest_ad_LECglu{i,2},2,'omitnan');
			event_rise_rest_ad_LECglu{i,4} = std(event_rise_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_ad_LECglu{i,2});
			event_decay_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_run_ad_LECglu{i,2} = cell2mat(event_decay_run_ad_LECglu{i,2});
			event_decay_run_ad_LECglu{i,3} = mean(event_decay_run_ad_LECglu{i,2},2,'omitnan');
			event_decay_run_ad_LECglu{i,4} = std(event_decay_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_ad_LECglu{i,2});
			event_decay_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_rest_ad_LECglu{i,2} = cell2mat(event_decay_rest_ad_LECglu{i,2});
			event_decay_rest_ad_LECglu{i,3} = mean(event_decay_rest_ad_LECglu{i,2},2,'omitnan');
			event_decay_rest_ad_LECglu{i,4} = std(event_decay_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_ad_LECglu{i,2});
			fraction_active_ROIs_ad_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_ad_LECglu{i,2} = cell2mat(fraction_active_ROIs_ad_LECglu{i,2});
			fraction_active_ROIs_ad_LECglu{i,3} = mean(fraction_active_ROIs_ad_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_ad_LECglu{i,4} = std(fraction_active_ROIs_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_ad_LECglu{i,2});
			fraction_active_ROIs_run_ad_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_ad_LECglu{i,2} = cell2mat(fraction_active_ROIs_run_ad_LECglu{i,2});
			fraction_active_ROIs_run_ad_LECglu{i,3} = mean(fraction_active_ROIs_run_ad_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_run_ad_LECglu{i,4} = std(fraction_active_ROIs_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_ad_LECglu{i,2});
			fraction_active_ROIs_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_ad_LECglu{i,2} = cell2mat(fraction_active_ROIs_rest_ad_LECglu{i,2});
			fraction_active_ROIs_rest_ad_LECglu{i,3} = mean(fraction_active_ROIs_rest_ad_LECglu{i,2},2,'omitnan');
			fraction_active_ROIs_rest_ad_LECglu{i,4} = std(fraction_active_ROIs_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_ad_LECglu{i,2});
			fraction_place_cells_ad_LECglu{i,2}(nanidx) = {NaN};
			fraction_place_cells_ad_LECglu{i,2} = cell2mat(fraction_place_cells_ad_LECglu{i,2});
			fraction_place_cells_ad_LECglu{i,3} = mean(fraction_place_cells_ad_LECglu{i,2},2,'omitnan');
			fraction_place_cells_ad_LECglu{i,4} = std(fraction_place_cells_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_ad_LECglu{i,2});
			number_place_fields_ad_LECglu{i,2}(nanidx) = {NaN};
			number_place_fields_ad_LECglu{i,2} = cell2mat(number_place_fields_ad_LECglu{i,2});
			number_place_fields_ad_LECglu{i,3} = mean(number_place_fields_ad_LECglu{i,2},2,'omitnan');
			number_place_fields_ad_LECglu{i,4} = std(number_place_fields_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_ad_LECglu{i,2});
			width_place_fields_ad_LECglu{i,2}(nanidx) = {NaN};
			width_place_fields_ad_LECglu{i,2} = cell2mat(width_place_fields_ad_LECglu{i,2});
			width_place_fields_ad_LECglu{i,3} = mean(width_place_fields_ad_LECglu{i,2},2,'omitnan');
			width_place_fields_ad_LECglu{i,4} = std(width_place_fields_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_ad_LECglu{i,2});
			center_place_fields_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_ad_LECglu{i,2});
			center_place_fields_index_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_ad_LECglu{i,2});
			center_place_fields_active_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_ad_LECglu{i,2});
			center_place_fields_index_sorted_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_ad_LECglu{i,2});
			center_place_fields_active_sorted_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_ad_LECglu{i,2});
			rate_map_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_ad_LECglu{i,2});
			rate_map_z_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_ad_LECglu{i,2});
			rate_map_n_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_ad_LECglu{i,2});
			rate_map_active_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_ad_LECglu{i,2});
			rate_map_active_z_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_ad_LECglu{i,2});
			rate_map_active_n_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_ad_LECglu{i,2});
			rate_map_active_sorted_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_ad_LECglu{i,2});
			rate_map_active_sorted_z_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_ad_LECglu{i,2});
			rate_map_active_sorted_n_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_ad_LECglu{i,2});
			spatial_info_bits_ad_LECglu{i,2}(nanidx) = {NaN};
			spatial_info_bits_ad_LECglu{i,2} = cell2mat(spatial_info_bits_ad_LECglu{i,2});
			spatial_info_bits_ad_LECglu{i,3} = mean(spatial_info_bits_ad_LECglu{i,2},2,'omitnan');
			spatial_info_bits_ad_LECglu{i,4} = std(spatial_info_bits_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_ad_LECglu{i,2});
			spatial_info_norm_ad_LECglu{i,2}(nanidx) = {NaN};
			spatial_info_norm_ad_LECglu{i,2} = cell2mat(spatial_info_norm_ad_LECglu{i,2});
			spatial_info_norm_ad_LECglu{i,3} = mean(spatial_info_norm_ad_LECglu{i,2},2,'omitnan');
			spatial_info_norm_ad_LECglu{i,4} = std(spatial_info_norm_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_ad_LECglu{i,2});
			event_rate_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_ad_LECglu{i,2} = cell2mat(event_rate_tuned_ad_LECglu{i,2});
			event_rate_tuned_ad_LECglu{i,3} = mean(event_rate_tuned_ad_LECglu{i,2},2,'omitnan');
			event_rate_tuned_ad_LECglu{i,4} = std(event_rate_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_ad_LECglu{i,2});
			event_rate_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_ad_LECglu{i,2} = cell2mat(event_rate_untuned_ad_LECglu{i,2});
			event_rate_untuned_ad_LECglu{i,3} = mean(event_rate_untuned_ad_LECglu{i,2},2,'omitnan');
			event_rate_untuned_ad_LECglu{i,4} = std(event_rate_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_ad_LECglu{i,2});
			event_amp_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_ad_LECglu{i,2} = cell2mat(event_amp_tuned_ad_LECglu{i,2});
			event_amp_tuned_ad_LECglu{i,3} = mean(event_amp_tuned_ad_LECglu{i,2},2,'omitnan');
			event_amp_tuned_ad_LECglu{i,4} = std(event_amp_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_ad_LECglu{i,2});
			event_amp_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_ad_LECglu{i,2} = cell2mat(event_amp_untuned_ad_LECglu{i,2});
			event_amp_untuned_ad_LECglu{i,3} = mean(event_amp_untuned_ad_LECglu{i,2},2,'omitnan');
			event_amp_untuned_ad_LECglu{i,4} = std(event_amp_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_ad_LECglu{i,2});
			event_width_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_ad_LECglu{i,2} = cell2mat(event_width_tuned_ad_LECglu{i,2});
			event_width_tuned_ad_LECglu{i,3} = mean(event_width_tuned_ad_LECglu{i,2},2,'omitnan');
			event_width_tuned_ad_LECglu{i,4} = std(event_width_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_ad_LECglu{i,2});
			event_width_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_ad_LECglu{i,2} = cell2mat(event_width_untuned_ad_LECglu{i,2});
			event_width_untuned_ad_LECglu{i,3} = mean(event_width_untuned_ad_LECglu{i,2},2,'omitnan');
			event_width_untuned_ad_LECglu{i,4} = std(event_width_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_ad_LECglu{i,2});
			event_auc_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_ad_LECglu{i,2} = cell2mat(event_auc_tuned_ad_LECglu{i,2});
			event_auc_tuned_ad_LECglu{i,3} = mean(event_auc_tuned_ad_LECglu{i,2},2,'omitnan');
			event_auc_tuned_ad_LECglu{i,4} = std(event_auc_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_ad_LECglu{i,2});
			event_auc_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_ad_LECglu{i,2} = cell2mat(event_auc_untuned_ad_LECglu{i,2});
			event_auc_untuned_ad_LECglu{i,3} = mean(event_auc_untuned_ad_LECglu{i,2},2,'omitnan');
			event_auc_untuned_ad_LECglu{i,4} = std(event_auc_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_ad_LECglu{i,2});
			event_rise_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_ad_LECglu{i,2} = cell2mat(event_rise_tuned_ad_LECglu{i,2});
			event_rise_tuned_ad_LECglu{i,3} = mean(event_rise_tuned_ad_LECglu{i,2},2,'omitnan');
			event_rise_tuned_ad_LECglu{i,4} = std(event_rise_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_ad_LECglu{i,2});
			event_rise_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_ad_LECglu{i,2} = cell2mat(event_rise_untuned_ad_LECglu{i,2});
			event_rise_untuned_ad_LECglu{i,3} = mean(event_rise_untuned_ad_LECglu{i,2},2,'omitnan');
			event_rise_untuned_ad_LECglu{i,4} = std(event_rise_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_ad_LECglu{i,2});
			event_decay_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_ad_LECglu{i,2} = cell2mat(event_decay_tuned_ad_LECglu{i,2});
			event_decay_tuned_ad_LECglu{i,3} = mean(event_decay_tuned_ad_LECglu{i,2},2,'omitnan');
			event_decay_tuned_ad_LECglu{i,4} = std(event_decay_tuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_ad_LECglu{i,2});
			event_decay_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_ad_LECglu{i,2} = cell2mat(event_decay_untuned_ad_LECglu{i,2});
			event_decay_untuned_ad_LECglu{i,3} = mean(event_decay_untuned_ad_LECglu{i,2},2,'omitnan');
			event_decay_untuned_ad_LECglu{i,4} = std(event_decay_untuned_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_ad_LECglu{i,2});
			event_rate_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_ad_LECglu{i,2} = cell2mat(event_rate_tuned_run_ad_LECglu{i,2});
			event_rate_tuned_run_ad_LECglu{i,3} = mean(event_rate_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_rate_tuned_run_ad_LECglu{i,4} = std(event_rate_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_ad_LECglu{i,2});
			event_rate_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_ad_LECglu{i,2} = cell2mat(event_rate_tuned_rest_ad_LECglu{i,2});
			event_rate_tuned_rest_ad_LECglu{i,3} = mean(event_rate_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_rate_tuned_rest_ad_LECglu{i,4} = std(event_rate_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_ad_LECglu{i,2});
			event_amp_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_run_ad_LECglu{i,2} = cell2mat(event_amp_tuned_run_ad_LECglu{i,2});
			event_amp_tuned_run_ad_LECglu{i,3} = mean(event_amp_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_amp_tuned_run_ad_LECglu{i,4} = std(event_amp_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_ad_LECglu{i,2});
			event_amp_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_tuned_rest_ad_LECglu{i,2} = cell2mat(event_amp_tuned_rest_ad_LECglu{i,2});
			event_amp_tuned_rest_ad_LECglu{i,3} = mean(event_amp_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_amp_tuned_rest_ad_LECglu{i,4} = std(event_amp_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_ad_LECglu{i,2});
			event_width_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_run_ad_LECglu{i,2} = cell2mat(event_width_tuned_run_ad_LECglu{i,2});
			event_width_tuned_run_ad_LECglu{i,3} = mean(event_width_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_width_tuned_run_ad_LECglu{i,4} = std(event_width_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_ad_LECglu{i,2});
			event_width_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_ad_LECglu{i,2} = cell2mat(event_width_tuned_rest_ad_LECglu{i,2});
			event_width_tuned_rest_ad_LECglu{i,3} = mean(event_width_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_width_tuned_rest_ad_LECglu{i,4} = std(event_width_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_ad_LECglu{i,2});
			event_auc_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_ad_LECglu{i,2} = cell2mat(event_auc_tuned_run_ad_LECglu{i,2});
			event_auc_tuned_run_ad_LECglu{i,3} = mean(event_auc_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_auc_tuned_run_ad_LECglu{i,4} = std(event_auc_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_ad_LECglu{i,2});
			event_auc_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_ad_LECglu{i,2} = cell2mat(event_auc_tuned_rest_ad_LECglu{i,2});
			event_auc_tuned_rest_ad_LECglu{i,3} = mean(event_auc_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_auc_tuned_rest_ad_LECglu{i,4} = std(event_auc_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_ad_LECglu{i,2});
			event_rise_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_ad_LECglu{i,2} = cell2mat(event_rise_tuned_run_ad_LECglu{i,2});
			event_rise_tuned_run_ad_LECglu{i,3} = mean(event_rise_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_rise_tuned_run_ad_LECglu{i,4} = std(event_rise_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_ad_LECglu{i,2});
			event_rise_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_ad_LECglu{i,2} = cell2mat(event_rise_tuned_rest_ad_LECglu{i,2});
			event_rise_tuned_rest_ad_LECglu{i,3} = mean(event_rise_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_rise_tuned_rest_ad_LECglu{i,4} = std(event_rise_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_ad_LECglu{i,2});
			event_decay_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_ad_LECglu{i,2} = cell2mat(event_decay_tuned_run_ad_LECglu{i,2});
			event_decay_tuned_run_ad_LECglu{i,3} = mean(event_decay_tuned_run_ad_LECglu{i,2},2,'omitnan');
			event_decay_tuned_run_ad_LECglu{i,4} = std(event_decay_tuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_ad_LECglu{i,2});
			event_decay_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_ad_LECglu{i,2} = cell2mat(event_decay_tuned_rest_ad_LECglu{i,2});
			event_decay_tuned_rest_ad_LECglu{i,3} = mean(event_decay_tuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_decay_tuned_rest_ad_LECglu{i,4} = std(event_decay_tuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_ad_LECglu{i,2});
			event_rate_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_ad_LECglu{i,2} = cell2mat(event_rate_untuned_run_ad_LECglu{i,2});
			event_rate_untuned_run_ad_LECglu{i,3} = mean(event_rate_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_rate_untuned_run_ad_LECglu{i,4} = std(event_rate_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_ad_LECglu{i,2});
			event_rate_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_ad_LECglu{i,2} = cell2mat(event_rate_untuned_rest_ad_LECglu{i,2});
			event_rate_untuned_rest_ad_LECglu{i,3} = mean(event_rate_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_rate_untuned_rest_ad_LECglu{i,4} = std(event_rate_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_ad_LECglu{i,2});
			event_amp_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_run_ad_LECglu{i,2} = cell2mat(event_amp_untuned_run_ad_LECglu{i,2});
			event_amp_untuned_run_ad_LECglu{i,3} = mean(event_amp_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_amp_untuned_run_ad_LECglu{i,4} = std(event_amp_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_ad_LECglu{i,2});
			event_amp_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_ad_LECglu{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_ad_LECglu{i,2},'UniformOutput',false);
			event_amp_untuned_rest_ad_LECglu{i,2} = cell2mat(event_amp_untuned_rest_ad_LECglu{i,2});
			event_amp_untuned_rest_ad_LECglu{i,3} = mean(event_amp_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_amp_untuned_rest_ad_LECglu{i,4} = std(event_amp_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_ad_LECglu{i,2});
			event_width_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_run_ad_LECglu{i,2} = cell2mat(event_width_untuned_run_ad_LECglu{i,2});
			event_width_untuned_run_ad_LECglu{i,3} = mean(event_width_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_width_untuned_run_ad_LECglu{i,4} = std(event_width_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_ad_LECglu{i,2});
			event_width_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_ad_LECglu{i,2} = cell2mat(event_width_untuned_rest_ad_LECglu{i,2});
			event_width_untuned_rest_ad_LECglu{i,3} = mean(event_width_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_width_untuned_rest_ad_LECglu{i,4} = std(event_width_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_ad_LECglu{i,2});
			event_auc_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_ad_LECglu{i,2} = cell2mat(event_auc_untuned_run_ad_LECglu{i,2});
			event_auc_untuned_run_ad_LECglu{i,3} = mean(event_auc_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_auc_untuned_run_ad_LECglu{i,4} = std(event_auc_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_ad_LECglu{i,2});
			event_auc_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_ad_LECglu{i,2} = cell2mat(event_auc_untuned_rest_ad_LECglu{i,2});
			event_auc_untuned_rest_ad_LECglu{i,3} = mean(event_auc_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_auc_untuned_rest_ad_LECglu{i,4} = std(event_auc_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_ad_LECglu{i,2});
			event_rise_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_ad_LECglu{i,2} = cell2mat(event_rise_untuned_run_ad_LECglu{i,2});
			event_rise_untuned_run_ad_LECglu{i,3} = mean(event_rise_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_rise_untuned_run_ad_LECglu{i,4} = std(event_rise_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_ad_LECglu{i,2});
			event_rise_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_ad_LECglu{i,2} = cell2mat(event_rise_untuned_rest_ad_LECglu{i,2});
			event_rise_untuned_rest_ad_LECglu{i,3} = mean(event_rise_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_rise_untuned_rest_ad_LECglu{i,4} = std(event_rise_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_ad_LECglu{i,2});
			event_decay_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_ad_LECglu{i,2} = cell2mat(event_decay_untuned_run_ad_LECglu{i,2});
			event_decay_untuned_run_ad_LECglu{i,3} = mean(event_decay_untuned_run_ad_LECglu{i,2},2,'omitnan');
			event_decay_untuned_run_ad_LECglu{i,4} = std(event_decay_untuned_run_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_ad_LECglu{i,2});
			event_decay_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_ad_LECglu{i,2} = cell2mat(event_decay_untuned_rest_ad_LECglu{i,2});
			event_decay_untuned_rest_ad_LECglu{i,3} = mean(event_decay_untuned_rest_ad_LECglu{i,2},2,'omitnan');
			event_decay_untuned_rest_ad_LECglu{i,4} = std(event_decay_untuned_rest_ad_LECglu{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_ad_LECglu{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_ad_LECglu{i,2});
			roi_pc_binary_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_ad_LECglu{i,2});
			event_rate_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_ad_LECglu{i,2});
			event_rate_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_ad_LECglu{i,2});
			event_amp_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_ad_LECglu{i,2});
			event_amp_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_ad_LECglu{i,2});
			event_width_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_ad_LECglu{i,2});
			event_width_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_ad_LECglu{i,2});
			event_auc_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_ad_LECglu{i,2});
			event_auc_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_ad_LECglu{i,2});
			event_rise_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_ad_LECglu{i,2});
			event_rise_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_ad_LECglu{i,2});
			event_decay_pop_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_ad_LECglu{i,2});
			event_decay_pop_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_ad_LECglu{i,2});
			event_rate_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_ad_LECglu{i,2});
			event_rate_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_ad_LECglu{i,2});
			event_amp_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_ad_LECglu{i,2});
			event_amp_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_ad_LECglu{i,2});
			event_width_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_ad_LECglu{i,2});
			event_width_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_ad_LECglu{i,2});
			event_auc_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_ad_LECglu{i,2});
			event_auc_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_ad_LECglu{i,2});
			event_rise_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_ad_LECglu{i,2});
			event_rise_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_ad_LECglu{i,2});
			event_decay_pop_tuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_ad_LECglu{i,2});
			event_decay_pop_untuned_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_ad_LECglu{i,2});
			event_rate_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_ad_LECglu{i,2});
			event_rate_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_ad_LECglu{i,2});
			event_amp_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_ad_LECglu{i,2});
			event_amp_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_ad_LECglu{i,2});
			event_width_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_ad_LECglu{i,2});
			event_width_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_ad_LECglu{i,2});
			event_auc_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_ad_LECglu{i,2});
			event_auc_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_ad_LECglu{i,2});
			event_rise_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_ad_LECglu{i,2});
			event_rise_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_ad_LECglu{i,2});
			event_decay_pop_tuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_ad_LECglu{i,2});
			event_decay_pop_tuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_ad_LECglu{i,2});
			event_rate_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_ad_LECglu{i,2});
			event_rate_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_ad_LECglu{i,2});
			event_amp_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_ad_LECglu{i,2});
			event_amp_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_ad_LECglu{i,2});
			event_width_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_ad_LECglu{i,2});
			event_width_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_ad_LECglu{i,2});
			event_auc_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_ad_LECglu{i,2});
			event_auc_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_ad_LECglu{i,2});
			event_rise_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_ad_LECglu{i,2});
			event_rise_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_ad_LECglu{i,2});
			event_decay_pop_untuned_run_ad_LECglu{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_ad_LECglu{i,2});
			event_decay_pop_untuned_rest_ad_LECglu{i,2}(nanidx) = {NaN};
		end
	end
	%soma
	event_rate_run_s_LECgaba = {};
	event_rate_rest_s_LECgaba = {};
	event_amp_run_s_LECgaba = {};
	event_amp_rest_s_LECgaba = {};
	event_width_run_s_LECgaba = {};
	event_width_rest_s_LECgaba = {};
	event_auc_run_s_LECgaba = {};
	event_auc_rest_s_LECgaba = {};
	event_rise_run_s_LECgaba = {};
	event_rise_rest_s_LECgaba = {};
	event_decay_run_s_LECgaba = {};
	event_decay_rest_s_LECgaba = {};
	event_rate_tuned_s_LECgaba = {};
	event_rate_untuned_s_LECgaba = {};
	event_amp_tuned_s_LECgaba = {};
	event_amp_untuned_s_LECgaba = {};
	event_width_tuned_s_LECgaba = {};
	event_width_untuned_s_LECgaba = {};
	event_auc_tuned_s_LECgaba = {};
	event_auc_untuned_s_LECgaba = {};
	event_rise_tuned_s_LECgaba = {};
	event_rise_untuned_s_LECgaba = {};
	event_decay_tuned_s_LECgaba = {};
	event_decay_untuned_s_LECgaba = {};
	event_rate_tuned_run_s_LECgaba = {};
	event_rate_tuned_rest_s_LECgaba = {};
	event_amp_tuned_run_s_LECgaba = {};
	event_amp_tuned_rest_s_LECgaba = {};
	event_width_tuned_run_s_LECgaba = {};
	event_width_tuned_rest_s_LECgaba = {};
	event_auc_tuned_run_s_LECgaba = {};
	event_auc_tuned_rest_s_LECgaba = {};
	event_rise_tuned_run_s_LECgaba = {};
	event_rise_tuned_rest_s_LECgaba = {};
	event_decay_tuned_run_s_LECgaba = {};
	event_decay_tuned_rest_s_LECgaba = {};
	event_rate_untuned_run_s_LECgaba = {};
	event_rate_untuned_rest_s_LECgaba = {};
	event_amp_untuned_run_s_LECgaba = {};
	event_amp_untuned_rest_s_LECgaba = {};
	event_width_untuned_run_s_LECgaba = {};
	event_width_untuned_rest_s_LECgaba = {};
	event_auc_untuned_run_s_LECgaba = {};
	event_auc_untuned_rest_s_LECgaba = {};
	event_rise_untuned_run_s_LECgaba = {};
	event_rise_untuned_rest_s_LECgaba = {};
	event_decay_untuned_run_s_LECgaba = {};
	event_decay_untuned_rest_s_LECgaba = {};
	event_rate_pop_run_s_LECgaba = {};
	event_rate_pop_rest_s_LECgaba = {};
	event_amp_pop_run_s_LECgaba = {};
	event_amp_pop_rest_s_LECgaba = {};
	event_width_pop_run_s_LECgaba = {};
	event_width_pop_rest_s_LECgaba = {};
	event_auc_pop_run_s_LECgaba = {};
	event_auc_pop_rest_s_LECgaba = {};
	event_rise_pop_run_s_LECgaba = {};
	event_rise_pop_rest_s_LECgaba = {};
	event_decay_pop_run_s_LECgaba = {};
	event_decay_pop_rest_s_LECgaba = {};
	event_rate_pop_tuned_s_LECgaba = {};
	event_rate_pop_untuned_s_LECgaba = {};
	event_amp_pop_tuned_s_LECgaba = {};
	event_amp_pop_untuned_s_LECgaba = {};
	event_width_pop_tuned_s_LECgaba = {};
	event_width_pop_untuned_s_LECgaba = {};
	event_auc_pop_tuned_s_LECgaba = {};
	event_auc_pop_untuned_s_LECgaba = {};
	event_rise_pop_tuned_s_LECgaba = {};
	event_rise_pop_untuned_s_LECgaba = {};
	event_decay_pop_tuned_s_LECgaba = {};
	event_decay_pop_untuned_s_LECgaba = {};
	event_rate_pop_tuned_run_s_LECgaba = {};
	event_rate_pop_tuned_rest_s_LECgaba = {};
	event_amp_pop_tuned_run_s_LECgaba = {};
	event_amp_pop_tuned_rest_s_LECgaba = {};
	event_width_pop_tuned_run_s_LECgaba = {};
	event_width_pop_tuned_rest_s_LECgaba = {};
	event_auc_pop_tuned_run_s_LECgaba = {};
	event_auc_pop_tuned_rest_s_LECgaba = {};
	event_rise_pop_tuned_run_s_LECgaba = {};
	event_rise_pop_tuned_rest_s_LECgaba = {};
	event_decay_pop_tuned_run_s_LECgaba = {};
	event_decay_pop_tuned_rest_s_LECgaba = {};
	event_rate_pop_untuned_run_s_LECgaba = {};
	event_rate_pop_untuned_rest_s_LECgaba = {};
	event_amp_pop_untuned_run_s_LECgaba = {};
	event_amp_pop_untuned_rest_s_LECgaba = {};
	event_width_pop_untuned_run_s_LECgaba = {};
	event_width_pop_untuned_rest_s_LECgaba = {};
	event_auc_pop_untuned_run_s_LECgaba = {};
	event_auc_pop_untuned_rest_s_LECgaba = {};
	event_rise_pop_untuned_run_s_LECgaba = {};
	event_rise_pop_untuned_rest_s_LECgaba = {};
	event_decay_pop_untuned_run_s_LECgaba = {};
	event_decay_pop_untuned_rest_s_LECgaba = {};
	fraction_active_ROIs_s_LECgaba = {};
	fraction_active_ROIs_run_s_LECgaba = {};
	fraction_active_ROIs_rest_s_LECgaba = {};
	fraction_place_cells_s_LECgaba = {};
	number_place_fields_s_LECgaba = {};
	width_place_fields_s_LECgaba = {};
	center_place_fields_s_LECgaba = {};
	center_place_fields_index_s_LECgaba = {};
	center_place_fields_active_s_LECgaba = {};
	center_place_fields_index_sorted_s_LECgaba = {};
	center_place_fields_active_sorted_s_LECgaba = {};
	rate_map_s_LECgaba = {};
	rate_map_z_s_LECgaba = {};
	rate_map_n_s_LECgaba = {};
	rate_map_active_s_LECgaba = {};
	rate_map_active_z_s_LECgaba = {};
	rate_map_active_n_s_LECgaba = {};
	rate_map_active_sorted_s_LECgaba = {};
	rate_map_active_sorted_z_s_LECgaba = {};
	rate_map_active_sorted_n_s_LECgaba = {};
	spatial_info_bits_s_LECgaba = {};
	spatial_info_norm_s_LECgaba = {};
	roi_pc_binary_s_LECgaba = {};
	%dendrites
	event_rate_run_ad_LECgaba = {};
	event_rate_rest_ad_LECgaba = {};
	event_amp_run_ad_LECgaba = {};
	event_amp_rest_ad_LECgaba = {};
	event_width_run_ad_LECgaba = {};
	event_width_rest_ad_LECgaba = {};
	event_auc_run_ad_LECgaba = {};
	event_auc_rest_ad_LECgaba = {};
	event_rise_run_ad_LECgaba = {};
	event_rise_rest_ad_LECgaba = {};
	event_decay_run_ad_LECgaba = {};
	event_decay_rest_ad_LECgaba = {};
	event_rate_tuned_ad_LECgaba = {};
	event_rate_untuned_ad_LECgaba = {};
	event_amp_tuned_ad_LECgaba = {};
	event_amp_untuned_ad_LECgaba = {};
	event_width_tuned_ad_LECgaba = {};
	event_width_untuned_ad_LECgaba = {};
	event_auc_tuned_ad_LECgaba = {};
	event_auc_untuned_ad_LECgaba = {};
	event_rise_tuned_ad_LECgaba = {};
	event_rise_untuned_ad_LECgaba = {};
	event_decay_tuned_ad_LECgaba = {};
	event_decay_untuned_ad_LECgaba = {};
	event_rate_tuned_run_ad_LECgaba = {};
	event_rate_tuned_rest_ad_LECgaba = {};
	event_amp_tuned_run_ad_LECgaba = {};
	event_amp_tuned_rest_ad_LECgaba = {};
	event_width_tuned_run_ad_LECgaba = {};
	event_width_tuned_rest_ad_LECgaba = {};
	event_auc_tuned_run_ad_LECgaba = {};
	event_auc_tuned_rest_ad_LECgaba = {};
	event_rise_tuned_run_ad_LECgaba = {};
	event_rise_tuned_rest_ad_LECgaba = {};
	event_decay_tuned_run_ad_LECgaba = {};
	event_decay_tuned_rest_ad_LECgaba = {};
	event_rate_untuned_run_ad_LECgaba = {};
	event_rate_untuned_rest_ad_LECgaba = {};
	event_amp_untuned_run_ad_LECgaba = {};
	event_amp_untuned_rest_ad_LECgaba = {};
	event_width_untuned_run_ad_LECgaba = {};
	event_width_untuned_rest_ad_LECgaba = {};
	event_auc_untuned_run_ad_LECgaba = {};
	event_auc_untuned_rest_ad_LECgaba = {};
	event_rise_untuned_run_ad_LECgaba = {};
	event_rise_untuned_rest_ad_LECgaba = {};
	event_decay_untuned_run_ad_LECgaba = {};
	event_decay_untuned_rest_ad_LECgaba = {};
	event_rate_pop_run_ad_LECgaba = {};
	event_rate_pop_rest_ad_LECgaba = {};
	event_amp_pop_run_ad_LECgaba = {};
	event_amp_pop_rest_ad_LECgaba = {};
	event_width_pop_run_ad_LECgaba = {};
	event_width_pop_rest_ad_LECgaba = {};
	event_auc_pop_run_ad_LECgaba = {};
	event_auc_pop_rest_ad_LECgaba = {};
	event_rise_pop_run_ad_LECgaba = {};
	event_rise_pop_rest_ad_LECgaba = {};
	event_decay_pop_run_ad_LECgaba = {};
	event_decay_pop_rest_ad_LECgaba = {};
	event_rate_pop_tuned_ad_LECgaba = {};
	event_rate_pop_untuned_ad_LECgaba = {};
	event_amp_pop_tuned_ad_LECgaba = {};
	event_amp_pop_untuned_ad_LECgaba = {};
	event_width_pop_tuned_ad_LECgaba = {};
	event_width_pop_untuned_ad_LECgaba = {};
	event_auc_pop_tuned_ad_LECgaba = {};
	event_auc_pop_untuned_ad_LECgaba = {};
	event_rise_pop_tuned_ad_LECgaba = {};
	event_rise_pop_untuned_ad_LECgaba = {};
	event_decay_pop_tuned_ad_LECgaba = {};
	event_decay_pop_untuned_ad_LECgaba = {};
	event_rate_pop_tuned_run_ad_LECgaba = {};
	event_rate_pop_tuned_rest_ad_LECgaba = {};
	event_amp_pop_tuned_run_ad_LECgaba = {};
	event_amp_pop_tuned_rest_ad_LECgaba = {};
	event_width_pop_tuned_run_ad_LECgaba = {};
	event_width_pop_tuned_rest_ad_LECgaba = {};
	event_auc_pop_tuned_run_ad_LECgaba = {};
	event_auc_pop_tuned_rest_ad_LECgaba = {};
	event_rise_pop_tuned_run_ad_LECgaba = {};
	event_rise_pop_tuned_rest_ad_LECgaba = {};
	event_decay_pop_tuned_run_ad_LECgaba = {};
	event_decay_pop_tuned_rest_ad_LECgaba = {};
	event_rate_pop_untuned_run_ad_LECgaba = {};
	event_rate_pop_untuned_rest_ad_LECgaba = {};
	event_amp_pop_untuned_run_ad_LECgaba = {};
	event_amp_pop_untuned_rest_ad_LECgaba = {};
	event_width_pop_untuned_run_ad_LECgaba = {};
	event_width_pop_untuned_rest_ad_LECgaba = {};
	event_auc_pop_untuned_run_ad_LECgaba = {};
	event_auc_pop_untuned_rest_ad_LECgaba = {};
	event_rise_pop_untuned_run_ad_LECgaba = {};
	event_rise_pop_untuned_rest_ad_LECgaba = {};
	event_decay_pop_untuned_run_ad_LECgaba = {};
	event_decay_pop_untuned_rest_ad_LECgaba = {};
	fraction_active_ROIs_ad_LECgaba = {};
	fraction_active_ROIs_run_ad_LECgaba = {};
	fraction_active_ROIs_rest_ad_LECgaba = {};
	fraction_place_cells_ad_LECgaba = {};
	number_place_fields_ad_LECgaba = {};
	width_place_fields_ad_LECgaba = {};
	center_place_fields_ad_LECgaba = {};
	center_place_fields_index_ad_LECgaba = {};
	center_place_fields_active_ad_LECgaba = {};
	center_place_fields_index_sorted_ad_LECgaba = {};
	center_place_fields_active_sorted_ad_LECgaba = {};
	rate_map_ad_LECgaba = {};
	rate_map_z_ad_LECgaba = {};
	rate_map_n_ad_LECgaba = {};
	rate_map_active_ad_LECgaba = {};
	rate_map_active_z_ad_LECgaba = {};
	rate_map_active_n_ad_LECgaba = {};
	rate_map_active_sorted_ad_LECgaba = {};
	rate_map_active_sorted_z_ad_LECgaba = {};
	rate_map_active_sorted_n_ad_LECgaba = {};
	spatial_info_bits_ad_LECgaba = {};
	spatial_info_norm_ad_LECgaba = {};
	roi_pc_binary_ad_LECgaba = {};
	%correlations
	TC_corr_z_cross_s_LECgaba = {};
	TC_corr_z_cross_ad_LECgaba = {};
	PV_corr_z_cross_s_LECgaba = {};
	PV_corr_z_cross_ad_LECgaba = {};
	TC_corr_z_pair_s_LECgaba = {};
	TC_corr_z_pair_ad_LECgaba = {};
	PV_corr_z_pair_s_LECgaba = {};
	PV_corr_z_pair_ad_LECgaba = {};
	TC_corr_z_ref_s_LECgaba = {};
	TC_corr_z_ref_ad_LECgaba = {};
	PV_corr_z_ref_s_LECgaba = {};
	PV_corr_z_ref_ad_LECgaba = {};
	for i=1:size(LECgaba_sessions,2) %session groups
		for j=1:size(LECgaba_id,2) %aminals
			m = find(cellfun(@(c) contains(LECgaba_id(j),c),mouse_id));
			idx = cell2mat(cellfun(@(c) find(contains(c,LECgaba_sessions{i})),session_id(m),'UniformOutput',false));
			%soma
			event_rate_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_run_s(m,idx)';
			end
			event_rate_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_rest_s(m,idx)';
			end
			event_amp_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_run_s(m,idx)';
			end
			event_amp_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_rest_s(m,idx)';
			end
			event_width_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_run_s(m,idx)';
			end
			event_width_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_rest_s(m,idx)';
			end
			event_auc_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_run_s(m,idx)';
			end
			event_auc_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_rest_s(m,idx)';
			end
			event_rise_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_run_s(m,idx)';
			end
			event_rise_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_rest_s(m,idx)';
			end
			event_decay_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_run_s(m,idx)';
			end
			event_decay_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_rest_s(m,idx)';
			end
			event_rate_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_run_s(m,idx)';
			end
			event_rate_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_rest_s(m,idx)';
			end
			event_amp_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_run_s(m,idx)';
			end
			event_amp_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_rest_s(m,idx)';
			end
			event_width_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_run_s(m,idx)';
			end
			event_width_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_rest_s(m,idx)';
			end
			event_auc_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_run_s(m,idx)';
			end
			event_auc_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_rest_s(m,idx)';
			end
			event_rise_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_run_s(m,idx)';
			end
			event_rise_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_rest_s(m,idx)';
			end
			event_decay_pop_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_run_s(m,idx)';
			end
			event_decay_pop_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_rest_s(m,idx)';
			end
			fraction_active_ROIs_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_s_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_s(m,idx)';
			end
			fraction_active_ROIs_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_s_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_s(m,idx)';
			end
			fraction_active_ROIs_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_s_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_s(m,idx)';
			end
			fraction_place_cells_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_s_LECgaba{i,2}(1:size(idx,1),j) = fraction_place_cells_s(m,idx)';
			end
			number_place_fields_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_s_LECgaba{i,2}(1:size(idx,1),j) = number_place_fields_s(m,idx)';
			end
			width_place_fields_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_s_LECgaba{i,2}(1:size(idx,1),j) = width_place_fields_s(m,idx)';
			end
			center_place_fields_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_s_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_s(m,idx)';
			end
			center_place_fields_index_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_s_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_index_s(m,idx)';
			end
			center_place_fields_active_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_s_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_active_s(m,idx)';
			end
			center_place_fields_index_sorted_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_s_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_s(m,idx)';
			end
			center_place_fields_active_sorted_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_s_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_s(m,idx)';
			end
			rate_map_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_s(m,idx)';
			end
			rate_map_z_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_z_s(m,idx)';
			end
			rate_map_n_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_n_s(m,idx)';
			end
			rate_map_active_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_s(m,idx)';
			end
			rate_map_active_z_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_z_s(m,idx)';
			end
			rate_map_active_n_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_n_s(m,idx)';
			end
			rate_map_active_sorted_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_s(m,idx)';
			end
			rate_map_active_sorted_z_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_s(m,idx)';
			end
			rate_map_active_sorted_n_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_s_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_s(m,idx)';
			end
			spatial_info_bits_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_s_LECgaba{i,2}(1:size(idx,1),j) = spatial_info_bits_s(m,idx)';
			end
			spatial_info_norm_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_s_LECgaba{i,2}(1:size(idx,1),j) = spatial_info_norm_s(m,idx)';
			end
			event_rate_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_s(m,idx)';
			end
			event_rate_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_s(m,idx)';
			end
			event_amp_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_s(m,idx)';
			end
			event_amp_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_s(m,idx)';
			end
			event_width_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_s(m,idx)';
			end
			event_width_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_s(m,idx)';
			end
			event_auc_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_s(m,idx)';
			end
			event_auc_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_s(m,idx)';
			end
			event_rise_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_s(m,idx)';
			end
			event_rise_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_s(m,idx)';
			end
			event_decay_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_s(m,idx)';
			end
			event_decay_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_s(m,idx)';
			end
			event_rate_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_run_s(m,idx)';
			end
			event_rate_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_s(m,idx)';
			end
			event_amp_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_run_s(m,idx)';
			end
			event_amp_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_s(m,idx)';
			end
			event_width_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_run_s(m,idx)';
			end
			event_width_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_rest_s(m,idx)';
			end
			event_auc_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_run_s(m,idx)';
			end
			event_auc_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_s(m,idx)';
			end
			event_rise_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_run_s(m,idx)';
			end
			event_rise_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_s(m,idx)';
			end
			event_decay_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_run_s(m,idx)';
			end
			event_decay_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_s(m,idx)';
			end
			event_rate_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_run_s(m,idx)';
			end
			event_rate_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_s(m,idx)';
			end
			event_amp_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_run_s(m,idx)';
			end
			event_amp_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_s(m,idx)';
			end
			event_width_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_run_s(m,idx)';
			end
			event_width_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_rest_s(m,idx)';
			end
			event_auc_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_run_s(m,idx)';
			end
			event_auc_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_s(m,idx)';
			end
			event_rise_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_run_s(m,idx)';
			end
			event_rise_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_s(m,idx)';
			end
			event_decay_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_run_s(m,idx)';
			end
			event_decay_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_s(m,idx)';
			end
			event_rate_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_s(m,idx)';
			end
			event_rate_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_s(m,idx)';
			end
			event_amp_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_s(m,idx)';
			end
			event_amp_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_s(m,idx)';
			end
			event_width_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_s(m,idx)';
			end
			event_width_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_s(m,idx)';
			end
			event_auc_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_s(m,idx)';
			end
			event_auc_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_s(m,idx)';
			end
			event_rise_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_s(m,idx)';
			end
			event_rise_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_s(m,idx)';
			end
			event_decay_pop_tuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_s(m,idx)';
			end
			event_decay_pop_untuned_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_s(m,idx)';
			end
			event_rate_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_s(m,idx)';
			end
			event_rate_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_s(m,idx)';
			end
			event_amp_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_s(m,idx)';
			end
			event_amp_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_s(m,idx)';
			end
			event_width_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_s(m,idx)';
			end
			event_width_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_s(m,idx)';
			end
			event_auc_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_s(m,idx)';
			end
			event_auc_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_s(m,idx)';
			end
			event_rise_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_s(m,idx)';
			end
			event_rise_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_s(m,idx)';
			end
			event_decay_pop_tuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_s(m,idx)';
			end
			event_decay_pop_tuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_s(m,idx)';
			end
			event_rate_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_s(m,idx)';
			end
			event_rate_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_s(m,idx)';
			end
			event_amp_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_s(m,idx)';
			end
			event_amp_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_s(m,idx)';
			end
			event_width_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_s(m,idx)';
			end
			event_width_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_s(m,idx)';
			end
			event_auc_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_s(m,idx)';
			end
			event_auc_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_s(m,idx)';
			end
			event_rise_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_s(m,idx)';
			end
			event_rise_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_s(m,idx)';
			end
			event_decay_pop_untuned_run_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_s(m,idx)';
			end
			event_decay_pop_untuned_rest_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_s_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_s(m,idx)';
			end
			roi_pc_binary_s_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_s_LECgaba{i,2}(1:size(idx,1),j) = roi_pc_binary_s(m,idx)';
			end
			%dendrites
			event_rate_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_run_ad(m,idx)';
			end
			event_rate_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_rest_ad(m,idx)';
			end
			event_amp_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_run_ad(m,idx)';
			end
			event_amp_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_rest_ad(m,idx)';
			end
			event_width_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_run_ad(m,idx)';
			end
			event_width_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_rest_ad(m,idx)';
			end
			event_auc_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_run_ad(m,idx)';
			end
			event_auc_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_rest_ad(m,idx)';
			end
			event_rise_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_run_ad(m,idx)';
			end
			event_rise_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_rest_ad(m,idx)';
			end
			event_decay_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_run_ad(m,idx)';
			end
			event_decay_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_rest_ad(m,idx)';
			end
			event_rate_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_run_ad(m,idx)';
			end
			event_rate_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_rest_ad(m,idx)';
			end
			event_amp_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_run_ad(m,idx)';
			end
			event_amp_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_rest_ad(m,idx)';
			end
			event_width_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_run_ad(m,idx)';
			end
			event_width_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_rest_ad(m,idx)';
			end
			event_auc_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_run_ad(m,idx)';
			end
			event_auc_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_rest_ad(m,idx)';
			end
			event_rise_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_run_ad(m,idx)';
			end
			event_rise_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_rest_ad(m,idx)';
			end
			event_decay_pop_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_run_ad(m,idx)';
			end
			event_decay_pop_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_rest_ad(m,idx)';
			end
			fraction_active_ROIs_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_ad_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_ad(m,idx)';
			end
			fraction_active_ROIs_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_run_ad_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_run_ad(m,idx)';
			end
			fraction_active_ROIs_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_active_ROIs_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = fraction_active_ROIs_rest_ad(m,idx)';
			end
			fraction_place_cells_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				fraction_place_cells_ad_LECgaba{i,2}(1:size(idx,1),j) = fraction_place_cells_ad(m,idx)';
			end
			number_place_fields_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				number_place_fields_ad_LECgaba{i,2}(1:size(idx,1),j) = number_place_fields_ad(m,idx)';
			end
			width_place_fields_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				width_place_fields_ad_LECgaba{i,2}(1:size(idx,1),j) = width_place_fields_ad(m,idx)';
			end
			center_place_fields_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_ad_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_ad(m,idx)';
			end
			center_place_fields_index_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_ad_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_index_ad(m,idx)';
			end
			center_place_fields_active_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_ad_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_active_ad(m,idx)';
			end
			center_place_fields_index_sorted_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_index_sorted_ad_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_index_sorted_ad(m,idx)';
			end
			center_place_fields_active_sorted_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				center_place_fields_active_sorted_ad_LECgaba{i,2}(1:size(idx,1),j) = center_place_fields_active_sorted_ad(m,idx)';
			end
			rate_map_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_ad(m,idx)';
			end
			rate_map_z_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_z_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_z_ad(m,idx)';
			end
			rate_map_n_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_n_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_n_ad(m,idx)';
			end
			rate_map_active_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_ad(m,idx)';
			end
			rate_map_active_z_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_z_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_z_ad(m,idx)';
			end
			rate_map_active_n_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_n_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_n_ad(m,idx)';
			end
			rate_map_active_sorted_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_ad(m,idx)';
			end
			rate_map_active_sorted_z_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_z_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_z_ad(m,idx)';
			end
			rate_map_active_sorted_n_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				rate_map_active_sorted_n_ad_LECgaba{i,2}(1:size(idx,1),j) = rate_map_active_sorted_n_ad(m,idx)';
			end
			spatial_info_bits_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_bits_ad_LECgaba{i,2}(1:size(idx,1),j) = spatial_info_bits_ad(m,idx)';
			end
			spatial_info_norm_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				spatial_info_norm_ad_LECgaba{i,2}(1:size(idx,1),j) = spatial_info_norm_ad(m,idx)';
			end
			event_rate_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_ad(m,idx)';
			end
			event_rate_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_ad(m,idx)';
			end
			event_amp_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_ad(m,idx)';
			end
			event_amp_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_ad(m,idx)';
			end
			event_width_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_ad(m,idx)';
			end
			event_width_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_ad(m,idx)';
			end
			event_auc_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_ad(m,idx)';
			end
			event_auc_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_ad(m,idx)';
			end
			event_rise_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_ad(m,idx)';
			end
			event_rise_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_ad(m,idx)';
			end
			event_decay_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_ad(m,idx)';
			end
			event_decay_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_ad(m,idx)';
			end
			event_rate_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_run_ad(m,idx)';
			end
			event_rate_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_tuned_rest_ad(m,idx)';
			end
			event_amp_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_run_ad(m,idx)';
			end
			event_amp_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_tuned_rest_ad(m,idx)';
			end
			event_width_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_run_ad(m,idx)';
			end
			event_width_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_tuned_rest_ad(m,idx)';
			end
			event_auc_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_run_ad(m,idx)';
			end
			event_auc_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_tuned_rest_ad(m,idx)';
			end
			event_rise_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_run_ad(m,idx)';
			end
			event_rise_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_tuned_rest_ad(m,idx)';
			end
			event_decay_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_run_ad(m,idx)';
			end
			event_decay_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_tuned_rest_ad(m,idx)';
			end
			event_rate_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_run_ad(m,idx)';
			end
			event_rate_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_untuned_rest_ad(m,idx)';
			end
			event_amp_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_run_ad(m,idx)';
			end
			event_amp_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_untuned_rest_ad(m,idx)';
			end
			event_width_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_run_ad(m,idx)';
			end
			event_width_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_untuned_rest_ad(m,idx)';
			end
			event_auc_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_run_ad(m,idx)';
			end
			event_auc_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_untuned_rest_ad(m,idx)';
			end
			event_rise_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_run_ad(m,idx)';
			end
			event_rise_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_untuned_rest_ad(m,idx)';
			end
			event_decay_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_run_ad(m,idx)';
			end
			event_decay_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_untuned_rest_ad(m,idx)';
			end
			event_rate_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_ad(m,idx)';
			end
			event_rate_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_ad(m,idx)';
			end
			event_amp_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_ad(m,idx)';
			end
			event_amp_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_ad(m,idx)';
			end
			event_width_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_ad(m,idx)';
			end
			event_width_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_ad(m,idx)';
			end
			event_auc_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_ad(m,idx)';
			end
			event_auc_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_ad(m,idx)';
			end
			event_rise_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_ad(m,idx)';
			end
			event_rise_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_ad(m,idx)';
			end
			event_decay_pop_tuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_ad(m,idx)';
			end
			event_decay_pop_untuned_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_ad(m,idx)';
			end
			event_rate_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_run_ad(m,idx)';
			end
			event_rate_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_tuned_rest_ad(m,idx)';
			end
			event_amp_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_run_ad(m,idx)';
			end
			event_amp_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_tuned_rest_ad(m,idx)';
			end
			event_width_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_run_ad(m,idx)';
			end
			event_width_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_tuned_rest_ad(m,idx)';
			end
			event_auc_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_run_ad(m,idx)';
			end
			event_auc_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_tuned_rest_ad(m,idx)';
			end
			event_rise_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_run_ad(m,idx)';
			end
			event_rise_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_tuned_rest_ad(m,idx)';
			end
			event_decay_pop_tuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_run_ad(m,idx)';
			end
			event_decay_pop_tuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_tuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_tuned_rest_ad(m,idx)';
			end
			event_rate_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_run_ad(m,idx)';
			end
			event_rate_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rate_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rate_pop_untuned_rest_ad(m,idx)';
			end
			event_amp_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_run_ad(m,idx)';
			end
			event_amp_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_amp_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_amp_pop_untuned_rest_ad(m,idx)';
			end
			event_width_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_run_ad(m,idx)';
			end
			event_width_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_width_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_width_pop_untuned_rest_ad(m,idx)';
			end
			event_auc_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_run_ad(m,idx)';
			end
			event_auc_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_auc_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_auc_pop_untuned_rest_ad(m,idx)';
			end
			event_rise_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_run_ad(m,idx)';
			end
			event_rise_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_rise_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_rise_pop_untuned_rest_ad(m,idx)';
			end
			event_decay_pop_untuned_run_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_run_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_run_ad(m,idx)';
			end
			event_decay_pop_untuned_rest_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				event_decay_pop_untuned_rest_ad_LECgaba{i,2}(1:size(idx,1),j) = event_decay_pop_untuned_rest_ad(m,idx)';
			end
			roi_pc_binary_ad_LECgaba{i,1}(1:size(idx,1),j) = session_id{m}(idx);
			try
				roi_pc_binary_ad_LECgaba{i,2}(1:size(idx,1),j) = roi_pc_binary_ad(m,idx)';
			end
		end
		%soma
		try
			nanidx = cellfun('isempty',event_rate_run_s_LECgaba{i,2});
			event_rate_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_run_s_LECgaba{i,2} = cell2mat(event_rate_run_s_LECgaba{i,2});
			event_rate_run_s_LECgaba{i,3} = mean(event_rate_run_s_LECgaba{i,2},2,'omitnan');
			event_rate_run_s_LECgaba{i,4} = std(event_rate_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_s_LECgaba{i,2});
			event_rate_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_rest_s_LECgaba{i,2} = cell2mat(event_rate_rest_s_LECgaba{i,2});
			event_rate_rest_s_LECgaba{i,3} = mean(event_rate_rest_s_LECgaba{i,2},2,'omitnan');
			event_rate_rest_s_LECgaba{i,4} = std(event_rate_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_s_LECgaba{i,2});
			event_amp_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_run_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_run_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_run_s_LECgaba{i,2} = cell2mat(event_amp_run_s_LECgaba{i,2});
			event_amp_run_s_LECgaba{i,3} = mean(event_amp_run_s_LECgaba{i,2},2,'omitnan');
			event_amp_run_s_LECgaba{i,4} = std(event_amp_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_s_LECgaba{i,2});
			event_amp_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_rest_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_rest_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_rest_s_LECgaba{i,2} = cell2mat(event_amp_rest_s_LECgaba{i,2});
			event_amp_rest_s_LECgaba{i,3} = mean(event_amp_rest_s_LECgaba{i,2},2,'omitnan');
			event_amp_rest_s_LECgaba{i,4} = std(event_amp_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_s_LECgaba{i,2});
			event_width_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_run_s_LECgaba{i,2} = cell2mat(event_width_run_s_LECgaba{i,2});
			event_width_run_s_LECgaba{i,3} = mean(event_width_run_s_LECgaba{i,2},2,'omitnan');
			event_width_run_s_LECgaba{i,4} = std(event_width_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_s_LECgaba{i,2});
			event_width_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_rest_s_LECgaba{i,2} = cell2mat(event_width_rest_s_LECgaba{i,2});
			event_width_rest_s_LECgaba{i,3} = mean(event_width_rest_s_LECgaba{i,2},2,'omitnan');
			event_width_rest_s_LECgaba{i,4} = std(event_width_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_s_LECgaba{i,2});
			event_auc_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_run_s_LECgaba{i,2} = cell2mat(event_auc_run_s_LECgaba{i,2});
			event_auc_run_s_LECgaba{i,3} = mean(event_auc_run_s_LECgaba{i,2},2,'omitnan');
			event_auc_run_s_LECgaba{i,4} = std(event_auc_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_s_LECgaba{i,2});
			event_auc_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_rest_s_LECgaba{i,2} = cell2mat(event_auc_rest_s_LECgaba{i,2});
			event_auc_rest_s_LECgaba{i,3} = mean(event_auc_rest_s_LECgaba{i,2},2,'omitnan');
			event_auc_rest_s_LECgaba{i,4} = std(event_auc_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_s_LECgaba{i,2});
			event_rise_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_run_s_LECgaba{i,2} = cell2mat(event_rise_run_s_LECgaba{i,2});
			event_rise_run_s_LECgaba{i,3} = mean(event_rise_run_s_LECgaba{i,2},2,'omitnan');
			event_rise_run_s_LECgaba{i,4} = std(event_rise_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_s_LECgaba{i,2});
			event_rise_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_rest_s_LECgaba{i,2} = cell2mat(event_rise_rest_s_LECgaba{i,2});
			event_rise_rest_s_LECgaba{i,3} = mean(event_rise_rest_s_LECgaba{i,2},2,'omitnan');
			event_rise_rest_s_LECgaba{i,4} = std(event_rise_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_s_LECgaba{i,2});
			event_decay_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_run_s_LECgaba{i,2} = cell2mat(event_decay_run_s_LECgaba{i,2});
			event_decay_run_s_LECgaba{i,3} = mean(event_decay_run_s_LECgaba{i,2},2,'omitnan');
			event_decay_run_s_LECgaba{i,4} = std(event_decay_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_s_LECgaba{i,2});
			event_decay_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_rest_s_LECgaba{i,2} = cell2mat(event_decay_rest_s_LECgaba{i,2});
			event_decay_rest_s_LECgaba{i,3} = mean(event_decay_rest_s_LECgaba{i,2},2,'omitnan');
			event_decay_rest_s_LECgaba{i,4} = std(event_decay_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_s_LECgaba{i,2});
			fraction_active_ROIs_s_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_s_LECgaba{i,2} = cell2mat(fraction_active_ROIs_s_LECgaba{i,2});
			fraction_active_ROIs_s_LECgaba{i,3} = mean(fraction_active_ROIs_s_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_s_LECgaba{i,4} = std(fraction_active_ROIs_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_s_LECgaba{i,2});
			fraction_active_ROIs_run_s_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_s_LECgaba{i,2} = cell2mat(fraction_active_ROIs_run_s_LECgaba{i,2});
			fraction_active_ROIs_run_s_LECgaba{i,3} = mean(fraction_active_ROIs_run_s_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_run_s_LECgaba{i,4} = std(fraction_active_ROIs_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_s_LECgaba{i,2});
			fraction_active_ROIs_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_s_LECgaba{i,2} = cell2mat(fraction_active_ROIs_rest_s_LECgaba{i,2});
			fraction_active_ROIs_rest_s_LECgaba{i,3} = mean(fraction_active_ROIs_rest_s_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_rest_s_LECgaba{i,4} = std(fraction_active_ROIs_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_s_LECgaba{i,2});
			fraction_place_cells_s_LECgaba{i,2}(nanidx) = {NaN};
			fraction_place_cells_s_LECgaba{i,2} = cell2mat(fraction_place_cells_s_LECgaba{i,2});
			fraction_place_cells_s_LECgaba{i,3} = mean(fraction_place_cells_s_LECgaba{i,2},2,'omitnan');
			fraction_place_cells_s_LECgaba{i,4} = std(fraction_place_cells_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_s_LECgaba{i,2});
			number_place_fields_s_LECgaba{i,2}(nanidx) = {NaN};
			number_place_fields_s_LECgaba{i,2} = cell2mat(number_place_fields_s_LECgaba{i,2});
			number_place_fields_s_LECgaba{i,3} = mean(number_place_fields_s_LECgaba{i,2},2,'omitnan');
			number_place_fields_s_LECgaba{i,4} = std(number_place_fields_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_s_LECgaba{i,2});
			width_place_fields_s_LECgaba{i,2}(nanidx) = {NaN};
			width_place_fields_s_LECgaba{i,2} = cell2mat(width_place_fields_s_LECgaba{i,2});
			width_place_fields_s_LECgaba{i,3} = mean(width_place_fields_s_LECgaba{i,2},2,'omitnan');
			width_place_fields_s_LECgaba{i,4} = std(width_place_fields_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_s_LECgaba{i,2});
			center_place_fields_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_s_LECgaba{i,2});
			center_place_fields_index_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_s_LECgaba{i,2});
			center_place_fields_active_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_s_LECgaba{i,2});
			center_place_fields_index_sorted_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_s_LECgaba{i,2});
			center_place_fields_active_sorted_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_s_LECgaba{i,2});
			rate_map_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_s_LECgaba{i,2});
			rate_map_z_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_s_LECgaba{i,2});
			rate_map_n_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_s_LECgaba{i,2});
			rate_map_active_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_s_LECgaba{i,2});
			rate_map_active_z_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_s_LECgaba{i,2});
			rate_map_active_n_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_s_LECgaba{i,2});
			rate_map_active_sorted_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_s_LECgaba{i,2});
			rate_map_active_sorted_z_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_s_LECgaba{i,2});
			rate_map_active_sorted_n_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_s_LECgaba{i,2});
			spatial_info_bits_s_LECgaba{i,2}(nanidx) = {NaN};
			spatial_info_bits_s_LECgaba{i,2} = cell2mat(spatial_info_bits_s_LECgaba{i,2});
			spatial_info_bits_s_LECgaba{i,3} = mean(spatial_info_bits_s_LECgaba{i,2},2,'omitnan');
			spatial_info_bits_s_LECgaba{i,4} = std(spatial_info_bits_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_s_LECgaba{i,2});
			spatial_info_norm_s_LECgaba{i,2}(nanidx) = {NaN};
			spatial_info_norm_s_LECgaba{i,2} = cell2mat(spatial_info_norm_s_LECgaba{i,2});
			spatial_info_norm_s_LECgaba{i,3} = mean(spatial_info_norm_s_LECgaba{i,2},2,'omitnan');
			spatial_info_norm_s_LECgaba{i,4} = std(spatial_info_norm_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_s_LECgaba{i,2});
			event_rate_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_s_LECgaba{i,2} = cell2mat(event_rate_tuned_s_LECgaba{i,2});
			event_rate_tuned_s_LECgaba{i,3} = mean(event_rate_tuned_s_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_s_LECgaba{i,4} = std(event_rate_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_s_LECgaba{i,2});
			event_rate_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_s_LECgaba{i,2} = cell2mat(event_rate_untuned_s_LECgaba{i,2});
			event_rate_untuned_s_LECgaba{i,3} = mean(event_rate_untuned_s_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_s_LECgaba{i,4} = std(event_rate_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_s_LECgaba{i,2});
			event_amp_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_s_LECgaba{i,2} = cell2mat(event_amp_tuned_s_LECgaba{i,2});
			event_amp_tuned_s_LECgaba{i,3} = mean(event_amp_tuned_s_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_s_LECgaba{i,4} = std(event_amp_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_s_LECgaba{i,2});
			event_amp_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_s_LECgaba{i,2} = cell2mat(event_amp_untuned_s_LECgaba{i,2});
			event_amp_untuned_s_LECgaba{i,3} = mean(event_amp_untuned_s_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_s_LECgaba{i,4} = std(event_amp_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_s_LECgaba{i,2});
			event_width_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_s_LECgaba{i,2} = cell2mat(event_width_tuned_s_LECgaba{i,2});
			event_width_tuned_s_LECgaba{i,3} = mean(event_width_tuned_s_LECgaba{i,2},2,'omitnan');
			event_width_tuned_s_LECgaba{i,4} = std(event_width_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_s_LECgaba{i,2});
			event_width_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_s_LECgaba{i,2} = cell2mat(event_width_untuned_s_LECgaba{i,2});
			event_width_untuned_s_LECgaba{i,3} = mean(event_width_untuned_s_LECgaba{i,2},2,'omitnan');
			event_width_untuned_s_LECgaba{i,4} = std(event_width_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_s_LECgaba{i,2});
			event_auc_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_s_LECgaba{i,2} = cell2mat(event_auc_tuned_s_LECgaba{i,2});
			event_auc_tuned_s_LECgaba{i,3} = mean(event_auc_tuned_s_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_s_LECgaba{i,4} = std(event_auc_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_s_LECgaba{i,2});
			event_auc_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_s_LECgaba{i,2} = cell2mat(event_auc_untuned_s_LECgaba{i,2});
			event_auc_untuned_s_LECgaba{i,3} = mean(event_auc_untuned_s_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_s_LECgaba{i,4} = std(event_auc_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_s_LECgaba{i,2});
			event_rise_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_s_LECgaba{i,2} = cell2mat(event_rise_tuned_s_LECgaba{i,2});
			event_rise_tuned_s_LECgaba{i,3} = mean(event_rise_tuned_s_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_s_LECgaba{i,4} = std(event_rise_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_s_LECgaba{i,2});
			event_rise_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_s_LECgaba{i,2} = cell2mat(event_rise_untuned_s_LECgaba{i,2});
			event_rise_untuned_s_LECgaba{i,3} = mean(event_rise_untuned_s_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_s_LECgaba{i,4} = std(event_rise_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_s_LECgaba{i,2});
			event_decay_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_s_LECgaba{i,2} = cell2mat(event_decay_tuned_s_LECgaba{i,2});
			event_decay_tuned_s_LECgaba{i,3} = mean(event_decay_tuned_s_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_s_LECgaba{i,4} = std(event_decay_tuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_s_LECgaba{i,2});
			event_decay_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_s_LECgaba{i,2} = cell2mat(event_decay_untuned_s_LECgaba{i,2});
			event_decay_untuned_s_LECgaba{i,3} = mean(event_decay_untuned_s_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_s_LECgaba{i,4} = std(event_decay_untuned_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_s_LECgaba{i,2});
			event_rate_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_s_LECgaba{i,2} = cell2mat(event_rate_tuned_run_s_LECgaba{i,2});
			event_rate_tuned_run_s_LECgaba{i,3} = mean(event_rate_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_run_s_LECgaba{i,4} = std(event_rate_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_s_LECgaba{i,2});
			event_rate_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_s_LECgaba{i,2} = cell2mat(event_rate_tuned_rest_s_LECgaba{i,2});
			event_rate_tuned_rest_s_LECgaba{i,3} = mean(event_rate_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_rest_s_LECgaba{i,4} = std(event_rate_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_s_LECgaba{i,2});
			event_amp_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_run_s_LECgaba{i,2} = cell2mat(event_amp_tuned_run_s_LECgaba{i,2});
			event_amp_tuned_run_s_LECgaba{i,3} = mean(event_amp_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_run_s_LECgaba{i,4} = std(event_amp_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_s_LECgaba{i,2});
			event_amp_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_rest_s_LECgaba{i,2} = cell2mat(event_amp_tuned_rest_s_LECgaba{i,2});
			event_amp_tuned_rest_s_LECgaba{i,3} = mean(event_amp_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_rest_s_LECgaba{i,4} = std(event_amp_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_s_LECgaba{i,2});
			event_width_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_run_s_LECgaba{i,2} = cell2mat(event_width_tuned_run_s_LECgaba{i,2});
			event_width_tuned_run_s_LECgaba{i,3} = mean(event_width_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_width_tuned_run_s_LECgaba{i,4} = std(event_width_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_s_LECgaba{i,2});
			event_width_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_s_LECgaba{i,2} = cell2mat(event_width_tuned_rest_s_LECgaba{i,2});
			event_width_tuned_rest_s_LECgaba{i,3} = mean(event_width_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_width_tuned_rest_s_LECgaba{i,4} = std(event_width_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_s_LECgaba{i,2});
			event_auc_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_s_LECgaba{i,2} = cell2mat(event_auc_tuned_run_s_LECgaba{i,2});
			event_auc_tuned_run_s_LECgaba{i,3} = mean(event_auc_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_run_s_LECgaba{i,4} = std(event_auc_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_s_LECgaba{i,2});
			event_auc_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_s_LECgaba{i,2} = cell2mat(event_auc_tuned_rest_s_LECgaba{i,2});
			event_auc_tuned_rest_s_LECgaba{i,3} = mean(event_auc_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_rest_s_LECgaba{i,4} = std(event_auc_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_s_LECgaba{i,2});
			event_rise_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_s_LECgaba{i,2} = cell2mat(event_rise_tuned_run_s_LECgaba{i,2});
			event_rise_tuned_run_s_LECgaba{i,3} = mean(event_rise_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_run_s_LECgaba{i,4} = std(event_rise_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_s_LECgaba{i,2});
			event_rise_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_s_LECgaba{i,2} = cell2mat(event_rise_tuned_rest_s_LECgaba{i,2});
			event_rise_tuned_rest_s_LECgaba{i,3} = mean(event_rise_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_rest_s_LECgaba{i,4} = std(event_rise_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_s_LECgaba{i,2});
			event_decay_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_s_LECgaba{i,2} = cell2mat(event_decay_tuned_run_s_LECgaba{i,2});
			event_decay_tuned_run_s_LECgaba{i,3} = mean(event_decay_tuned_run_s_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_run_s_LECgaba{i,4} = std(event_decay_tuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_s_LECgaba{i,2});
			event_decay_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_s_LECgaba{i,2} = cell2mat(event_decay_tuned_rest_s_LECgaba{i,2});
			event_decay_tuned_rest_s_LECgaba{i,3} = mean(event_decay_tuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_rest_s_LECgaba{i,4} = std(event_decay_tuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_s_LECgaba{i,2});
			event_rate_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_s_LECgaba{i,2} = cell2mat(event_rate_untuned_run_s_LECgaba{i,2});
			event_rate_untuned_run_s_LECgaba{i,3} = mean(event_rate_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_run_s_LECgaba{i,4} = std(event_rate_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_s_LECgaba{i,2});
			event_rate_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_s_LECgaba{i,2} = cell2mat(event_rate_untuned_rest_s_LECgaba{i,2});
			event_rate_untuned_rest_s_LECgaba{i,3} = mean(event_rate_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_rest_s_LECgaba{i,4} = std(event_rate_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_s_LECgaba{i,2});
			event_amp_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_run_s_LECgaba{i,2} = cell2mat(event_amp_untuned_run_s_LECgaba{i,2});
			event_amp_untuned_run_s_LECgaba{i,3} = mean(event_amp_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_run_s_LECgaba{i,4} = std(event_amp_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_s_LECgaba{i,2});
			event_amp_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_s_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_s_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_rest_s_LECgaba{i,2} = cell2mat(event_amp_untuned_rest_s_LECgaba{i,2});
			event_amp_untuned_rest_s_LECgaba{i,3} = mean(event_amp_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_rest_s_LECgaba{i,4} = std(event_amp_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_s_LECgaba{i,2});
			event_width_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_run_s_LECgaba{i,2} = cell2mat(event_width_untuned_run_s_LECgaba{i,2});
			event_width_untuned_run_s_LECgaba{i,3} = mean(event_width_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_width_untuned_run_s_LECgaba{i,4} = std(event_width_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_s_LECgaba{i,2});
			event_width_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_s_LECgaba{i,2} = cell2mat(event_width_untuned_rest_s_LECgaba{i,2});
			event_width_untuned_rest_s_LECgaba{i,3} = mean(event_width_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_width_untuned_rest_s_LECgaba{i,4} = std(event_width_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_s_LECgaba{i,2});
			event_auc_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_s_LECgaba{i,2} = cell2mat(event_auc_untuned_run_s_LECgaba{i,2});
			event_auc_untuned_run_s_LECgaba{i,3} = mean(event_auc_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_run_s_LECgaba{i,4} = std(event_auc_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_s_LECgaba{i,2});
			event_auc_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_s_LECgaba{i,2} = cell2mat(event_auc_untuned_rest_s_LECgaba{i,2});
			event_auc_untuned_rest_s_LECgaba{i,3} = mean(event_auc_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_rest_s_LECgaba{i,4} = std(event_auc_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_s_LECgaba{i,2});
			event_rise_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_s_LECgaba{i,2} = cell2mat(event_rise_untuned_run_s_LECgaba{i,2});
			event_rise_untuned_run_s_LECgaba{i,3} = mean(event_rise_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_run_s_LECgaba{i,4} = std(event_rise_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_s_LECgaba{i,2});
			event_rise_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_s_LECgaba{i,2} = cell2mat(event_rise_untuned_rest_s_LECgaba{i,2});
			event_rise_untuned_rest_s_LECgaba{i,3} = mean(event_rise_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_rest_s_LECgaba{i,4} = std(event_rise_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_s_LECgaba{i,2});
			event_decay_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_s_LECgaba{i,2} = cell2mat(event_decay_untuned_run_s_LECgaba{i,2});
			event_decay_untuned_run_s_LECgaba{i,3} = mean(event_decay_untuned_run_s_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_run_s_LECgaba{i,4} = std(event_decay_untuned_run_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_s_LECgaba{i,2});
			event_decay_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_s_LECgaba{i,2} = cell2mat(event_decay_untuned_rest_s_LECgaba{i,2});
			event_decay_untuned_rest_s_LECgaba{i,3} = mean(event_decay_untuned_rest_s_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_rest_s_LECgaba{i,4} = std(event_decay_untuned_rest_s_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_s_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_s_LECgaba{i,2});
			roi_pc_binary_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_s_LECgaba{i,2});
			event_rate_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_s_LECgaba{i,2});
			event_rate_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_s_LECgaba{i,2});
			event_amp_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_s_LECgaba{i,2});
			event_amp_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_s_LECgaba{i,2});
			event_width_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_s_LECgaba{i,2});
			event_width_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_s_LECgaba{i,2});
			event_auc_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_s_LECgaba{i,2});
			event_auc_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_s_LECgaba{i,2});
			event_rise_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_s_LECgaba{i,2});
			event_rise_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_s_LECgaba{i,2});
			event_decay_pop_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_s_LECgaba{i,2});
			event_decay_pop_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_s_LECgaba{i,2});
			event_rate_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_s_LECgaba{i,2});
			event_rate_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_s_LECgaba{i,2});
			event_amp_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_s_LECgaba{i,2});
			event_amp_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_s_LECgaba{i,2});
			event_width_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_s_LECgaba{i,2});
			event_width_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_s_LECgaba{i,2});
			event_auc_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_s_LECgaba{i,2});
			event_auc_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_s_LECgaba{i,2});
			event_rise_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_s_LECgaba{i,2});
			event_rise_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_s_LECgaba{i,2});
			event_decay_pop_tuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_s_LECgaba{i,2});
			event_decay_pop_untuned_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_s_LECgaba{i,2});
			event_rate_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_s_LECgaba{i,2});
			event_rate_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_s_LECgaba{i,2});
			event_amp_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_s_LECgaba{i,2});
			event_amp_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_s_LECgaba{i,2});
			event_width_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_s_LECgaba{i,2});
			event_width_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_s_LECgaba{i,2});
			event_auc_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_s_LECgaba{i,2});
			event_auc_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_s_LECgaba{i,2});
			event_rise_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_s_LECgaba{i,2});
			event_rise_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_s_LECgaba{i,2});
			event_decay_pop_tuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_s_LECgaba{i,2});
			event_decay_pop_tuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_s_LECgaba{i,2});
			event_rate_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_s_LECgaba{i,2});
			event_rate_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_s_LECgaba{i,2});
			event_amp_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_s_LECgaba{i,2});
			event_amp_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_s_LECgaba{i,2});
			event_width_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_s_LECgaba{i,2});
			event_width_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_s_LECgaba{i,2});
			event_auc_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_s_LECgaba{i,2});
			event_auc_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_s_LECgaba{i,2});
			event_rise_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_s_LECgaba{i,2});
			event_rise_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_s_LECgaba{i,2});
			event_decay_pop_untuned_run_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_s_LECgaba{i,2});
			event_decay_pop_untuned_rest_s_LECgaba{i,2}(nanidx) = {NaN};
		end
		%dendrites
		try
			nanidx = cellfun('isempty',event_rate_run_ad_LECgaba{i,2});
			event_rate_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_run_ad_LECgaba{i,2} = cell2mat(event_rate_run_ad_LECgaba{i,2});
			event_rate_run_ad_LECgaba{i,3} = mean(event_rate_run_ad_LECgaba{i,2},2,'omitnan');
			event_rate_run_ad_LECgaba{i,4} = std(event_rate_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_rest_ad_LECgaba{i,2});
			event_rate_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_rest_ad_LECgaba{i,2} = cell2mat(event_rate_rest_ad_LECgaba{i,2});
			event_rate_rest_ad_LECgaba{i,3} = mean(event_rate_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rate_rest_ad_LECgaba{i,4} = std(event_rate_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_run_ad_LECgaba{i,2});
			event_amp_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_run_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_run_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_run_ad_LECgaba{i,2} = cell2mat(event_amp_run_ad_LECgaba{i,2});
			event_amp_run_ad_LECgaba{i,3} = mean(event_amp_run_ad_LECgaba{i,2},2,'omitnan');
			event_amp_run_ad_LECgaba{i,4} = std(event_amp_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_rest_ad_LECgaba{i,2});
			event_amp_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_rest_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_rest_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_rest_ad_LECgaba{i,2} = cell2mat(event_amp_rest_ad_LECgaba{i,2});
			event_amp_rest_ad_LECgaba{i,3} = mean(event_amp_rest_ad_LECgaba{i,2},2,'omitnan');
			event_amp_rest_ad_LECgaba{i,4} = std(event_amp_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_run_ad_LECgaba{i,2});
			event_width_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_run_ad_LECgaba{i,2} = cell2mat(event_width_run_ad_LECgaba{i,2});
			event_width_run_ad_LECgaba{i,3} = mean(event_width_run_ad_LECgaba{i,2},2,'omitnan');
			event_width_run_ad_LECgaba{i,4} = std(event_width_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_rest_ad_LECgaba{i,2});
			event_width_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_rest_ad_LECgaba{i,2} = cell2mat(event_width_rest_ad_LECgaba{i,2});
			event_width_rest_ad_LECgaba{i,3} = mean(event_width_rest_ad_LECgaba{i,2},2,'omitnan');
			event_width_rest_ad_LECgaba{i,4} = std(event_width_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_run_ad_LECgaba{i,2});
			event_auc_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_run_ad_LECgaba{i,2} = cell2mat(event_auc_run_ad_LECgaba{i,2});
			event_auc_run_ad_LECgaba{i,3} = mean(event_auc_run_ad_LECgaba{i,2},2,'omitnan');
			event_auc_run_ad_LECgaba{i,4} = std(event_auc_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_rest_ad_LECgaba{i,2});
			event_auc_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_rest_ad_LECgaba{i,2} = cell2mat(event_auc_rest_ad_LECgaba{i,2});
			event_auc_rest_ad_LECgaba{i,3} = mean(event_auc_rest_ad_LECgaba{i,2},2,'omitnan');
			event_auc_rest_ad_LECgaba{i,4} = std(event_auc_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_run_ad_LECgaba{i,2});
			event_rise_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_run_ad_LECgaba{i,2} = cell2mat(event_rise_run_ad_LECgaba{i,2});
			event_rise_run_ad_LECgaba{i,3} = mean(event_rise_run_ad_LECgaba{i,2},2,'omitnan');
			event_rise_run_ad_LECgaba{i,4} = std(event_rise_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_rest_ad_LECgaba{i,2});
			event_rise_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_rest_ad_LECgaba{i,2} = cell2mat(event_rise_rest_ad_LECgaba{i,2});
			event_rise_rest_ad_LECgaba{i,3} = mean(event_rise_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rise_rest_ad_LECgaba{i,4} = std(event_rise_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_run_ad_LECgaba{i,2});
			event_decay_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_run_ad_LECgaba{i,2} = cell2mat(event_decay_run_ad_LECgaba{i,2});
			event_decay_run_ad_LECgaba{i,3} = mean(event_decay_run_ad_LECgaba{i,2},2,'omitnan');
			event_decay_run_ad_LECgaba{i,4} = std(event_decay_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_rest_ad_LECgaba{i,2});
			event_decay_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_rest_ad_LECgaba{i,2} = cell2mat(event_decay_rest_ad_LECgaba{i,2});
			event_decay_rest_ad_LECgaba{i,3} = mean(event_decay_rest_ad_LECgaba{i,2},2,'omitnan');
			event_decay_rest_ad_LECgaba{i,4} = std(event_decay_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_ad_LECgaba{i,2});
			fraction_active_ROIs_ad_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_ad_LECgaba{i,2} = cell2mat(fraction_active_ROIs_ad_LECgaba{i,2});
			fraction_active_ROIs_ad_LECgaba{i,3} = mean(fraction_active_ROIs_ad_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_ad_LECgaba{i,4} = std(fraction_active_ROIs_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_run_ad_LECgaba{i,2});
			fraction_active_ROIs_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_run_ad_LECgaba{i,2} = cell2mat(fraction_active_ROIs_run_ad_LECgaba{i,2});
			fraction_active_ROIs_run_ad_LECgaba{i,3} = mean(fraction_active_ROIs_run_ad_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_run_ad_LECgaba{i,4} = std(fraction_active_ROIs_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_active_ROIs_rest_ad_LECgaba{i,2});
			fraction_active_ROIs_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			fraction_active_ROIs_rest_ad_LECgaba{i,2} = cell2mat(fraction_active_ROIs_rest_ad_LECgaba{i,2});
			fraction_active_ROIs_rest_ad_LECgaba{i,3} = mean(fraction_active_ROIs_rest_ad_LECgaba{i,2},2,'omitnan');
			fraction_active_ROIs_rest_ad_LECgaba{i,4} = std(fraction_active_ROIs_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_active_ROIs_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',fraction_place_cells_ad_LECgaba{i,2});
			fraction_place_cells_ad_LECgaba{i,2}(nanidx) = {NaN};
			fraction_place_cells_ad_LECgaba{i,2} = cell2mat(fraction_place_cells_ad_LECgaba{i,2});
			fraction_place_cells_ad_LECgaba{i,3} = mean(fraction_place_cells_ad_LECgaba{i,2},2,'omitnan');
			fraction_place_cells_ad_LECgaba{i,4} = std(fraction_place_cells_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(fraction_place_cells_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',number_place_fields_ad_LECgaba{i,2});
			number_place_fields_ad_LECgaba{i,2}(nanidx) = {NaN};
			number_place_fields_ad_LECgaba{i,2} = cell2mat(number_place_fields_ad_LECgaba{i,2});
			number_place_fields_ad_LECgaba{i,3} = mean(number_place_fields_ad_LECgaba{i,2},2,'omitnan');
			number_place_fields_ad_LECgaba{i,4} = std(number_place_fields_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(number_place_fields_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',width_place_fields_ad_LECgaba{i,2});
			width_place_fields_ad_LECgaba{i,2}(nanidx) = {NaN};
			width_place_fields_ad_LECgaba{i,2} = cell2mat(width_place_fields_ad_LECgaba{i,2});
			width_place_fields_ad_LECgaba{i,3} = mean(width_place_fields_ad_LECgaba{i,2},2,'omitnan');
			width_place_fields_ad_LECgaba{i,4} = std(width_place_fields_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(width_place_fields_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',center_place_fields_ad_LECgaba{i,2});
			center_place_fields_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_ad_LECgaba{i,2});
			center_place_fields_index_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_ad_LECgaba{i,2});
			center_place_fields_active_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_index_sorted_ad_LECgaba{i,2});
			center_place_fields_index_sorted_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',center_place_fields_active_sorted_ad_LECgaba{i,2});
			center_place_fields_active_sorted_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_ad_LECgaba{i,2});
			rate_map_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_z_ad_LECgaba{i,2});
			rate_map_z_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_n_ad_LECgaba{i,2});
			rate_map_n_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_ad_LECgaba{i,2});
			rate_map_active_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_z_ad_LECgaba{i,2});
			rate_map_active_z_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_n_ad_LECgaba{i,2});
			rate_map_active_n_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_ad_LECgaba{i,2});
			rate_map_active_sorted_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_z_ad_LECgaba{i,2});
			rate_map_active_sorted_z_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',rate_map_active_sorted_n_ad_LECgaba{i,2});
			rate_map_active_sorted_n_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',spatial_info_bits_ad_LECgaba{i,2});
			spatial_info_bits_ad_LECgaba{i,2}(nanidx) = {NaN};
			spatial_info_bits_ad_LECgaba{i,2} = cell2mat(spatial_info_bits_ad_LECgaba{i,2});
			spatial_info_bits_ad_LECgaba{i,3} = mean(spatial_info_bits_ad_LECgaba{i,2},2,'omitnan');
			spatial_info_bits_ad_LECgaba{i,4} = std(spatial_info_bits_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(spatial_info_bits_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',spatial_info_norm_ad_LECgaba{i,2});
			spatial_info_norm_ad_LECgaba{i,2}(nanidx) = {NaN};
			spatial_info_norm_ad_LECgaba{i,2} = cell2mat(spatial_info_norm_ad_LECgaba{i,2});
			spatial_info_norm_ad_LECgaba{i,3} = mean(spatial_info_norm_ad_LECgaba{i,2},2,'omitnan');
			spatial_info_norm_ad_LECgaba{i,4} = std(spatial_info_norm_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(spatial_info_norm_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_ad_LECgaba{i,2});
			event_rate_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_ad_LECgaba{i,2} = cell2mat(event_rate_tuned_ad_LECgaba{i,2});
			event_rate_tuned_ad_LECgaba{i,3} = mean(event_rate_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_ad_LECgaba{i,4} = std(event_rate_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_ad_LECgaba{i,2});
			event_rate_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_ad_LECgaba{i,2} = cell2mat(event_rate_untuned_ad_LECgaba{i,2});
			event_rate_untuned_ad_LECgaba{i,3} = mean(event_rate_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_ad_LECgaba{i,4} = std(event_rate_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_ad_LECgaba{i,2});
			event_amp_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_ad_LECgaba{i,2} = cell2mat(event_amp_tuned_ad_LECgaba{i,2});
			event_amp_tuned_ad_LECgaba{i,3} = mean(event_amp_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_ad_LECgaba{i,4} = std(event_amp_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_ad_LECgaba{i,2});
			event_amp_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_ad_LECgaba{i,2} = cell2mat(event_amp_untuned_ad_LECgaba{i,2});
			event_amp_untuned_ad_LECgaba{i,3} = mean(event_amp_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_ad_LECgaba{i,4} = std(event_amp_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_ad_LECgaba{i,2});
			event_width_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_ad_LECgaba{i,2} = cell2mat(event_width_tuned_ad_LECgaba{i,2});
			event_width_tuned_ad_LECgaba{i,3} = mean(event_width_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_width_tuned_ad_LECgaba{i,4} = std(event_width_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_ad_LECgaba{i,2});
			event_width_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_ad_LECgaba{i,2} = cell2mat(event_width_untuned_ad_LECgaba{i,2});
			event_width_untuned_ad_LECgaba{i,3} = mean(event_width_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_width_untuned_ad_LECgaba{i,4} = std(event_width_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_ad_LECgaba{i,2});
			event_auc_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_ad_LECgaba{i,2} = cell2mat(event_auc_tuned_ad_LECgaba{i,2});
			event_auc_tuned_ad_LECgaba{i,3} = mean(event_auc_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_ad_LECgaba{i,4} = std(event_auc_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_ad_LECgaba{i,2});
			event_auc_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_ad_LECgaba{i,2} = cell2mat(event_auc_untuned_ad_LECgaba{i,2});
			event_auc_untuned_ad_LECgaba{i,3} = mean(event_auc_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_ad_LECgaba{i,4} = std(event_auc_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_ad_LECgaba{i,2});
			event_rise_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_ad_LECgaba{i,2} = cell2mat(event_rise_tuned_ad_LECgaba{i,2});
			event_rise_tuned_ad_LECgaba{i,3} = mean(event_rise_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_ad_LECgaba{i,4} = std(event_rise_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_ad_LECgaba{i,2});
			event_rise_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_ad_LECgaba{i,2} = cell2mat(event_rise_untuned_ad_LECgaba{i,2});
			event_rise_untuned_ad_LECgaba{i,3} = mean(event_rise_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_ad_LECgaba{i,4} = std(event_rise_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_ad_LECgaba{i,2});
			event_decay_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_ad_LECgaba{i,2} = cell2mat(event_decay_tuned_ad_LECgaba{i,2});
			event_decay_tuned_ad_LECgaba{i,3} = mean(event_decay_tuned_ad_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_ad_LECgaba{i,4} = std(event_decay_tuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_ad_LECgaba{i,2});
			event_decay_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_ad_LECgaba{i,2} = cell2mat(event_decay_untuned_ad_LECgaba{i,2});
			event_decay_untuned_ad_LECgaba{i,3} = mean(event_decay_untuned_ad_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_ad_LECgaba{i,4} = std(event_decay_untuned_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_run_ad_LECgaba{i,2});
			event_rate_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_run_ad_LECgaba{i,2} = cell2mat(event_rate_tuned_run_ad_LECgaba{i,2});
			event_rate_tuned_run_ad_LECgaba{i,3} = mean(event_rate_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_run_ad_LECgaba{i,4} = std(event_rate_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_tuned_rest_ad_LECgaba{i,2});
			event_rate_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_rate_tuned_rest_ad_LECgaba{i,2});
			event_rate_tuned_rest_ad_LECgaba{i,3} = mean(event_rate_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rate_tuned_rest_ad_LECgaba{i,4} = std(event_rate_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_run_ad_LECgaba{i,2});
			event_amp_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_run_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_run_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_run_ad_LECgaba{i,2} = cell2mat(event_amp_tuned_run_ad_LECgaba{i,2});
			event_amp_tuned_run_ad_LECgaba{i,3} = mean(event_amp_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_run_ad_LECgaba{i,4} = std(event_amp_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_tuned_rest_ad_LECgaba{i,2});
			event_amp_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_tuned_rest_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_tuned_rest_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_amp_tuned_rest_ad_LECgaba{i,2});
			event_amp_tuned_rest_ad_LECgaba{i,3} = mean(event_amp_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_amp_tuned_rest_ad_LECgaba{i,4} = std(event_amp_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_run_ad_LECgaba{i,2});
			event_width_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_run_ad_LECgaba{i,2} = cell2mat(event_width_tuned_run_ad_LECgaba{i,2});
			event_width_tuned_run_ad_LECgaba{i,3} = mean(event_width_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_width_tuned_run_ad_LECgaba{i,4} = std(event_width_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_tuned_rest_ad_LECgaba{i,2});
			event_width_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_width_tuned_rest_ad_LECgaba{i,2});
			event_width_tuned_rest_ad_LECgaba{i,3} = mean(event_width_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_width_tuned_rest_ad_LECgaba{i,4} = std(event_width_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_run_ad_LECgaba{i,2});
			event_auc_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_run_ad_LECgaba{i,2} = cell2mat(event_auc_tuned_run_ad_LECgaba{i,2});
			event_auc_tuned_run_ad_LECgaba{i,3} = mean(event_auc_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_run_ad_LECgaba{i,4} = std(event_auc_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_tuned_rest_ad_LECgaba{i,2});
			event_auc_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_auc_tuned_rest_ad_LECgaba{i,2});
			event_auc_tuned_rest_ad_LECgaba{i,3} = mean(event_auc_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_auc_tuned_rest_ad_LECgaba{i,4} = std(event_auc_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_run_ad_LECgaba{i,2});
			event_rise_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_run_ad_LECgaba{i,2} = cell2mat(event_rise_tuned_run_ad_LECgaba{i,2});
			event_rise_tuned_run_ad_LECgaba{i,3} = mean(event_rise_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_run_ad_LECgaba{i,4} = std(event_rise_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_tuned_rest_ad_LECgaba{i,2});
			event_rise_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_rise_tuned_rest_ad_LECgaba{i,2});
			event_rise_tuned_rest_ad_LECgaba{i,3} = mean(event_rise_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rise_tuned_rest_ad_LECgaba{i,4} = std(event_rise_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_run_ad_LECgaba{i,2});
			event_decay_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_run_ad_LECgaba{i,2} = cell2mat(event_decay_tuned_run_ad_LECgaba{i,2});
			event_decay_tuned_run_ad_LECgaba{i,3} = mean(event_decay_tuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_run_ad_LECgaba{i,4} = std(event_decay_tuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_tuned_rest_ad_LECgaba{i,2});
			event_decay_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_tuned_rest_ad_LECgaba{i,2} = cell2mat(event_decay_tuned_rest_ad_LECgaba{i,2});
			event_decay_tuned_rest_ad_LECgaba{i,3} = mean(event_decay_tuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_decay_tuned_rest_ad_LECgaba{i,4} = std(event_decay_tuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_tuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_run_ad_LECgaba{i,2});
			event_rate_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_run_ad_LECgaba{i,2} = cell2mat(event_rate_untuned_run_ad_LECgaba{i,2});
			event_rate_untuned_run_ad_LECgaba{i,3} = mean(event_rate_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_run_ad_LECgaba{i,4} = std(event_rate_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rate_untuned_rest_ad_LECgaba{i,2});
			event_rate_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rate_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_rate_untuned_rest_ad_LECgaba{i,2});
			event_rate_untuned_rest_ad_LECgaba{i,3} = mean(event_rate_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rate_untuned_rest_ad_LECgaba{i,4} = std(event_rate_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rate_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_run_ad_LECgaba{i,2});
			event_amp_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_run_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_run_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_run_ad_LECgaba{i,2} = cell2mat(event_amp_untuned_run_ad_LECgaba{i,2});
			event_amp_untuned_run_ad_LECgaba{i,3} = mean(event_amp_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_run_ad_LECgaba{i,4} = std(event_amp_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_amp_untuned_rest_ad_LECgaba{i,2});
			event_amp_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_amp_untuned_rest_ad_LECgaba{i,2} = cellfun(@(c) double(c),event_amp_untuned_rest_ad_LECgaba{i,2},'UniformOutput',false);
			event_amp_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_amp_untuned_rest_ad_LECgaba{i,2});
			event_amp_untuned_rest_ad_LECgaba{i,3} = mean(event_amp_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_amp_untuned_rest_ad_LECgaba{i,4} = std(event_amp_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_amp_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_run_ad_LECgaba{i,2});
			event_width_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_run_ad_LECgaba{i,2} = cell2mat(event_width_untuned_run_ad_LECgaba{i,2});
			event_width_untuned_run_ad_LECgaba{i,3} = mean(event_width_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_width_untuned_run_ad_LECgaba{i,4} = std(event_width_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_width_untuned_rest_ad_LECgaba{i,2});
			event_width_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_width_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_width_untuned_rest_ad_LECgaba{i,2});
			event_width_untuned_rest_ad_LECgaba{i,3} = mean(event_width_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_width_untuned_rest_ad_LECgaba{i,4} = std(event_width_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_width_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_run_ad_LECgaba{i,2});
			event_auc_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_run_ad_LECgaba{i,2} = cell2mat(event_auc_untuned_run_ad_LECgaba{i,2});
			event_auc_untuned_run_ad_LECgaba{i,3} = mean(event_auc_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_run_ad_LECgaba{i,4} = std(event_auc_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_auc_untuned_rest_ad_LECgaba{i,2});
			event_auc_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_auc_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_auc_untuned_rest_ad_LECgaba{i,2});
			event_auc_untuned_rest_ad_LECgaba{i,3} = mean(event_auc_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_auc_untuned_rest_ad_LECgaba{i,4} = std(event_auc_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_auc_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_run_ad_LECgaba{i,2});
			event_rise_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_run_ad_LECgaba{i,2} = cell2mat(event_rise_untuned_run_ad_LECgaba{i,2});
			event_rise_untuned_run_ad_LECgaba{i,3} = mean(event_rise_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_run_ad_LECgaba{i,4} = std(event_rise_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_rise_untuned_rest_ad_LECgaba{i,2});
			event_rise_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_rise_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_rise_untuned_rest_ad_LECgaba{i,2});
			event_rise_untuned_rest_ad_LECgaba{i,3} = mean(event_rise_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_rise_untuned_rest_ad_LECgaba{i,4} = std(event_rise_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_rise_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_run_ad_LECgaba{i,2});
			event_decay_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_run_ad_LECgaba{i,2} = cell2mat(event_decay_untuned_run_ad_LECgaba{i,2});
			event_decay_untuned_run_ad_LECgaba{i,3} = mean(event_decay_untuned_run_ad_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_run_ad_LECgaba{i,4} = std(event_decay_untuned_run_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_run_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',event_decay_untuned_rest_ad_LECgaba{i,2});
			event_decay_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
			event_decay_untuned_rest_ad_LECgaba{i,2} = cell2mat(event_decay_untuned_rest_ad_LECgaba{i,2});
			event_decay_untuned_rest_ad_LECgaba{i,3} = mean(event_decay_untuned_rest_ad_LECgaba{i,2},2,'omitnan');
			event_decay_untuned_rest_ad_LECgaba{i,4} = std(event_decay_untuned_rest_ad_LECgaba{i,2},0,2,'omitnan')/sqrt(size(event_decay_untuned_rest_ad_LECgaba{i,2},2));
		end
		try
			nanidx = cellfun('isempty',roi_pc_binary_ad_LECgaba{i,2});
			roi_pc_binary_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_run_ad_LECgaba{i,2});
			event_rate_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_rest_ad_LECgaba{i,2});
			event_rate_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_run_ad_LECgaba{i,2});
			event_amp_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_rest_ad_LECgaba{i,2});
			event_amp_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_run_ad_LECgaba{i,2});
			event_width_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_rest_ad_LECgaba{i,2});
			event_width_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_run_ad_LECgaba{i,2});
			event_auc_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_rest_ad_LECgaba{i,2});
			event_auc_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_run_ad_LECgaba{i,2});
			event_rise_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_rest_ad_LECgaba{i,2});
			event_rise_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_run_ad_LECgaba{i,2});
			event_decay_pop_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_rest_ad_LECgaba{i,2});
			event_decay_pop_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_ad_LECgaba{i,2});
			event_rate_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_ad_LECgaba{i,2});
			event_rate_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_ad_LECgaba{i,2});
			event_amp_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_ad_LECgaba{i,2});
			event_amp_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_ad_LECgaba{i,2});
			event_width_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_ad_LECgaba{i,2});
			event_width_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_ad_LECgaba{i,2});
			event_auc_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_ad_LECgaba{i,2});
			event_auc_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_ad_LECgaba{i,2});
			event_rise_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_ad_LECgaba{i,2});
			event_rise_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_ad_LECgaba{i,2});
			event_decay_pop_tuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_ad_LECgaba{i,2});
			event_decay_pop_untuned_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_run_ad_LECgaba{i,2});
			event_rate_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_tuned_rest_ad_LECgaba{i,2});
			event_rate_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_run_ad_LECgaba{i,2});
			event_amp_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_tuned_rest_ad_LECgaba{i,2});
			event_amp_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_run_ad_LECgaba{i,2});
			event_width_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_tuned_rest_ad_LECgaba{i,2});
			event_width_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_run_ad_LECgaba{i,2});
			event_auc_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_tuned_rest_ad_LECgaba{i,2});
			event_auc_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_run_ad_LECgaba{i,2});
			event_rise_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_tuned_rest_ad_LECgaba{i,2});
			event_rise_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_run_ad_LECgaba{i,2});
			event_decay_pop_tuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_tuned_rest_ad_LECgaba{i,2});
			event_decay_pop_tuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_run_ad_LECgaba{i,2});
			event_rate_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rate_pop_untuned_rest_ad_LECgaba{i,2});
			event_rate_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_run_ad_LECgaba{i,2});
			event_amp_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_amp_pop_untuned_rest_ad_LECgaba{i,2});
			event_amp_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_run_ad_LECgaba{i,2});
			event_width_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_width_pop_untuned_rest_ad_LECgaba{i,2});
			event_width_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_run_ad_LECgaba{i,2});
			event_auc_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_auc_pop_untuned_rest_ad_LECgaba{i,2});
			event_auc_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_run_ad_LECgaba{i,2});
			event_rise_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_rise_pop_untuned_rest_ad_LECgaba{i,2});
			event_rise_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_run_ad_LECgaba{i,2});
			event_decay_pop_untuned_run_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
		try
			nanidx = cellfun('isempty',event_decay_pop_untuned_rest_ad_LECgaba{i,2});
			event_decay_pop_untuned_rest_ad_LECgaba{i,2}(nanidx) = {NaN};
		end
	end
%output
	s_metric = struct;
	%soma
	s_metric.control.s.event_rate_run = event_rate_run_s_control;
	s_metric.control.s.event_rate_rest = event_rate_rest_s_control;
	s_metric.control.s.event_amp_run = event_amp_run_s_control;
	s_metric.control.s.event_amp_rest = event_amp_rest_s_control;
	s_metric.control.s.event_width_run = event_width_run_s_control;
	s_metric.control.s.event_width_rest = event_width_rest_s_control;
	s_metric.control.s.event_auc_run = event_auc_run_s_control;
	s_metric.control.s.event_auc_rest = event_auc_rest_s_control;
	s_metric.control.s.event_rise_run = event_rise_run_s_control;
	s_metric.control.s.event_rise_rest = event_rise_rest_s_control;
	s_metric.control.s.event_decay_run = event_decay_run_s_control;
	s_metric.control.s.event_decay_rest = event_decay_rest_s_control;
	s_metric.control.s.event_rate_tuned = event_rate_tuned_s_control;
	s_metric.control.s.event_rate_untuned = event_rate_untuned_s_control;
	s_metric.control.s.event_amp_tuned = event_amp_tuned_s_control;
	s_metric.control.s.event_amp_untuned = event_amp_untuned_s_control;
	s_metric.control.s.event_width_tuned = event_width_tuned_s_control;
	s_metric.control.s.event_width_untuned = event_width_untuned_s_control;
	s_metric.control.s.event_auc_tuned = event_auc_tuned_s_control;
	s_metric.control.s.event_auc_untuned = event_auc_untuned_s_control;
	s_metric.control.s.event_rise_tuned = event_rise_tuned_s_control;
	s_metric.control.s.event_rise_untuned = event_rise_untuned_s_control;
	s_metric.control.s.event_decay_tuned = event_decay_tuned_s_control;
	s_metric.control.s.event_decay_untuned = event_decay_untuned_s_control;
	s_metric.control.s.event_rate_tuned_run = event_rate_tuned_run_s_control;
	s_metric.control.s.event_rate_tuned_rest = event_rate_tuned_rest_s_control;
	s_metric.control.s.event_amp_tuned_run = event_amp_tuned_run_s_control;
	s_metric.control.s.event_amp_tuned_rest = event_amp_tuned_rest_s_control;
	s_metric.control.s.event_width_tuned_run = event_width_tuned_run_s_control;
	s_metric.control.s.event_width_tuned_rest = event_width_tuned_rest_s_control;
	s_metric.control.s.event_auc_tuned_run = event_auc_tuned_run_s_control;
	s_metric.control.s.event_auc_tuned_rest = event_auc_tuned_rest_s_control;
	s_metric.control.s.event_rise_tuned_run = event_rise_tuned_run_s_control;
	s_metric.control.s.event_rise_tuned_rest = event_rise_tuned_rest_s_control;
	s_metric.control.s.event_decay_tuned_run = event_decay_tuned_run_s_control;
	s_metric.control.s.event_decay_tuned_rest = event_decay_tuned_rest_s_control;
	s_metric.control.s.event_rate_untuned_run = event_rate_untuned_run_s_control;
	s_metric.control.s.event_rate_untuned_rest = event_rate_untuned_rest_s_control;
	s_metric.control.s.event_amp_untuned_run = event_amp_untuned_run_s_control;
	s_metric.control.s.event_amp_untuned_rest = event_amp_untuned_rest_s_control;
	s_metric.control.s.event_width_untuned_run = event_width_untuned_run_s_control;
	s_metric.control.s.event_width_untuned_rest = event_width_untuned_rest_s_control;
	s_metric.control.s.event_auc_untuned_run = event_auc_untuned_run_s_control;
	s_metric.control.s.event_auc_untuned_rest = event_auc_untuned_rest_s_control;
	s_metric.control.s.event_rise_untuned_run = event_rise_untuned_run_s_control;
	s_metric.control.s.event_rise_untuned_rest = event_rise_untuned_rest_s_control;
	s_metric.control.s.event_decay_untuned_run = event_decay_untuned_run_s_control;
	s_metric.control.s.event_decay_untuned_rest = event_decay_untuned_rest_s_control;
	s_metric.control.s.event_rate_pop_run = event_rate_pop_run_s_control;
	s_metric.control.s.event_rate_pop_rest = event_rate_pop_rest_s_control;
	s_metric.control.s.event_amp_pop_run = event_amp_pop_run_s_control;
	s_metric.control.s.event_amp_pop_rest = event_amp_pop_rest_s_control;
	s_metric.control.s.event_width_pop_run = event_width_pop_run_s_control;
	s_metric.control.s.event_width_pop_rest = event_width_pop_rest_s_control;
	s_metric.control.s.event_auc_pop_run = event_auc_pop_run_s_control;
	s_metric.control.s.event_auc_pop_rest = event_auc_pop_rest_s_control;
	s_metric.control.s.event_rise_pop_run = event_rise_pop_run_s_control;
	s_metric.control.s.event_rise_pop_rest = event_rise_pop_rest_s_control;
	s_metric.control.s.event_decay_pop_run = event_decay_pop_run_s_control;
	s_metric.control.s.event_decay_pop_rest = event_decay_pop_rest_s_control;
	s_metric.control.s.event_rate_pop_tuned = event_rate_pop_tuned_s_control;
	s_metric.control.s.event_rate_pop_untuned = event_rate_pop_untuned_s_control;
	s_metric.control.s.event_amp_pop_tuned = event_amp_pop_tuned_s_control;
	s_metric.control.s.event_amp_pop_untuned = event_amp_pop_untuned_s_control;
	s_metric.control.s.event_width_pop_tuned = event_width_pop_tuned_s_control;
	s_metric.control.s.event_width_pop_untuned = event_width_pop_untuned_s_control;
	s_metric.control.s.event_auc_pop_tuned = event_auc_pop_tuned_s_control;
	s_metric.control.s.event_auc_pop_untuned = event_auc_pop_untuned_s_control;
	s_metric.control.s.event_rise_pop_tuned = event_rise_pop_tuned_s_control;
	s_metric.control.s.event_rise_pop_untuned = event_rise_pop_untuned_s_control;
	s_metric.control.s.event_decay_pop_tuned = event_decay_pop_tuned_s_control;
	s_metric.control.s.event_decay_pop_untuned = event_decay_pop_untuned_s_control;
	s_metric.control.s.event_rate_pop_tuned_run = event_rate_pop_tuned_run_s_control;
	s_metric.control.s.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_s_control;
	s_metric.control.s.event_amp_pop_tuned_run = event_amp_pop_tuned_run_s_control;
	s_metric.control.s.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_s_control;
	s_metric.control.s.event_width_pop_tuned_run = event_width_pop_tuned_run_s_control;
	s_metric.control.s.event_width_pop_tuned_rest = event_width_pop_tuned_rest_s_control;
	s_metric.control.s.event_auc_pop_tuned_run = event_auc_pop_tuned_run_s_control;
	s_metric.control.s.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_s_control;
	s_metric.control.s.event_rise_pop_tuned_run = event_rise_pop_tuned_run_s_control;
	s_metric.control.s.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_s_control;
	s_metric.control.s.event_decay_pop_tuned_run = event_decay_pop_tuned_run_s_control;
	s_metric.control.s.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_s_control;
	s_metric.control.s.event_rate_pop_untuned_run = event_rate_pop_untuned_run_s_control;
	s_metric.control.s.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_s_control;
	s_metric.control.s.event_amp_pop_untuned_run = event_amp_pop_untuned_run_s_control;
	s_metric.control.s.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_s_control;
	s_metric.control.s.event_width_pop_untuned_run = event_width_pop_untuned_run_s_control;
	s_metric.control.s.event_width_pop_untuned_rest = event_width_pop_untuned_rest_s_control;
	s_metric.control.s.event_auc_pop_untuned_run = event_auc_pop_untuned_run_s_control;
	s_metric.control.s.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_s_control;
	s_metric.control.s.event_rise_pop_untuned_run = event_rise_pop_untuned_run_s_control;
	s_metric.control.s.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_s_control;
	s_metric.control.s.event_decay_pop_untuned_run = event_decay_pop_untuned_run_s_control;
	s_metric.control.s.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_s_control;
	s_metric.control.s.fraction_active_ROIs = fraction_active_ROIs_s_control;
	s_metric.control.s.fraction_active_ROIs_run = fraction_active_ROIs_run_s_control;
	s_metric.control.s.fraction_active_ROIs_rest = fraction_active_ROIs_rest_s_control;
	s_metric.control.s.fraction_place_cells = fraction_place_cells_s_control;
	s_metric.control.s.number_place_fields = number_place_fields_s_control;
	s_metric.control.s.width_place_fields = width_place_fields_s_control;
	s_metric.control.s.center_place_fields = center_place_fields_s_control;
	s_metric.control.s.center_place_fields_index = center_place_fields_index_s_control;
	s_metric.control.s.center_place_fields_active = center_place_fields_active_s_control;
	s_metric.control.s.center_place_fields_index_sorted = center_place_fields_index_sorted_s_control;
	s_metric.control.s.center_place_fields_active_sorted = center_place_fields_active_sorted_s_control;
	s_metric.control.s.rate_map = rate_map_s_control;
	s_metric.control.s.rate_map_z = rate_map_z_s_control;
	s_metric.control.s.rate_map_n = rate_map_n_s_control;
	s_metric.control.s.rate_map_active = rate_map_active_s_control;
	s_metric.control.s.rate_map_active_z = rate_map_active_z_s_control;
	s_metric.control.s.rate_map_active_n = rate_map_active_n_s_control;
	s_metric.control.s.rate_map_active_sorted = rate_map_active_sorted_s_control;
	s_metric.control.s.rate_map_active_sorted_z = rate_map_active_sorted_z_s_control;
	s_metric.control.s.rate_map_active_sorted_n = rate_map_active_sorted_n_s_control;
	s_metric.control.s.spatial_info_bits = spatial_info_bits_s_control;
	s_metric.control.s.spatial_info_norm = spatial_info_norm_s_control;
	s_metric.control.s.roi_pc_binary = roi_pc_binary_s_control;
	s_metric.control.s.TC_corr_cross = TC_cross_s_control;
	s_metric.control.s.PV_corr_cross = PV_cross_s_control;
	s_metric.control.s.TC_corr_pair = TC_pair_s_control;
	s_metric.control.s.PV_corr_pair = PV_pair_s_control;
	s_metric.control.s.TC_corr_ref = TC_ref_s_control;
	s_metric.control.s.PV_corr_ref = PV_ref_s_control;
	s_metric.LECglu.s.event_rate_run = event_rate_run_s_LECglu;
	s_metric.LECglu.s.event_rate_rest = event_rate_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_run = event_amp_run_s_LECglu;
	s_metric.LECglu.s.event_amp_rest = event_amp_rest_s_LECglu;
	s_metric.LECglu.s.event_width_run = event_width_run_s_LECglu;
	s_metric.LECglu.s.event_width_rest = event_width_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_run = event_auc_run_s_LECglu;
	s_metric.LECglu.s.event_auc_rest = event_auc_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_run = event_rise_run_s_LECglu;
	s_metric.LECglu.s.event_rise_rest = event_rise_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_run = event_decay_run_s_LECglu;
	s_metric.LECglu.s.event_decay_rest = event_decay_rest_s_LECglu;
	s_metric.LECglu.s.event_rate_tuned = event_rate_tuned_s_LECglu;
	s_metric.LECglu.s.event_rate_untuned = event_rate_untuned_s_LECglu;
	s_metric.LECglu.s.event_amp_tuned = event_amp_tuned_s_LECglu;
	s_metric.LECglu.s.event_amp_untuned = event_amp_untuned_s_LECglu;
	s_metric.LECglu.s.event_width_tuned = event_width_tuned_s_LECglu;
	s_metric.LECglu.s.event_width_untuned = event_width_untuned_s_LECglu;
	s_metric.LECglu.s.event_auc_tuned = event_auc_tuned_s_LECglu;
	s_metric.LECglu.s.event_auc_untuned = event_auc_untuned_s_LECglu;
	s_metric.LECglu.s.event_rise_tuned = event_rise_tuned_s_LECglu;
	s_metric.LECglu.s.event_rise_untuned = event_rise_untuned_s_LECglu;
	s_metric.LECglu.s.event_decay_tuned = event_decay_tuned_s_LECglu;
	s_metric.LECglu.s.event_decay_untuned = event_decay_untuned_s_LECglu;
	s_metric.LECglu.s.event_rate_tuned_run = event_rate_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_rate_tuned_rest = event_rate_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_tuned_run = event_amp_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_amp_tuned_rest = event_amp_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_width_tuned_run = event_width_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_width_tuned_rest = event_width_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_tuned_run = event_auc_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_auc_tuned_rest = event_auc_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_tuned_run = event_rise_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_rise_tuned_rest = event_rise_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_tuned_run = event_decay_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_decay_tuned_rest = event_decay_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rate_untuned_run = event_rate_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_rate_untuned_rest = event_rate_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_untuned_run = event_amp_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_amp_untuned_rest = event_amp_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_width_untuned_run = event_width_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_width_untuned_rest = event_width_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_untuned_run = event_auc_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_auc_untuned_rest = event_auc_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_untuned_run = event_rise_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_rise_untuned_rest = event_rise_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_untuned_run = event_decay_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_decay_untuned_rest = event_decay_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_run = event_rate_pop_run_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_rest = event_rate_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_run = event_amp_pop_run_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_rest = event_amp_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_width_pop_run = event_width_pop_run_s_LECglu;
	s_metric.LECglu.s.event_width_pop_rest = event_width_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_run = event_auc_pop_run_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_rest = event_auc_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_run = event_rise_pop_run_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_rest = event_rise_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_run = event_decay_pop_run_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_rest = event_decay_pop_rest_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_tuned = event_rate_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_untuned = event_rate_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_tuned = event_amp_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_untuned = event_amp_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_width_pop_tuned = event_width_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_width_pop_untuned = event_width_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_tuned = event_auc_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_untuned = event_auc_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_tuned = event_rise_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_untuned = event_rise_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_tuned = event_decay_pop_tuned_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_untuned = event_decay_pop_untuned_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_tuned_run = event_rate_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_tuned_run = event_amp_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_width_pop_tuned_run = event_width_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_width_pop_tuned_rest = event_width_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_tuned_run = event_auc_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_tuned_run = event_rise_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_tuned_run = event_decay_pop_tuned_run_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_untuned_run = event_rate_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_untuned_run = event_amp_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_width_pop_untuned_run = event_width_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_width_pop_untuned_rest = event_width_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_untuned_run = event_auc_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_untuned_run = event_rise_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_untuned_run = event_decay_pop_untuned_run_s_LECglu;
	s_metric.LECglu.s.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_s_LECglu;
	s_metric.LECglu.s.fraction_active_ROIs = fraction_active_ROIs_s_LECglu;
	s_metric.LECglu.s.fraction_active_ROIs_run = fraction_active_ROIs_run_s_LECglu;
	s_metric.LECglu.s.fraction_active_ROIs_rest = fraction_active_ROIs_rest_s_LECglu;
	s_metric.LECglu.s.fraction_place_cells = fraction_place_cells_s_LECglu;
	s_metric.LECglu.s.number_place_fields = number_place_fields_s_LECglu;
	s_metric.LECglu.s.width_place_fields = width_place_fields_s_LECglu;
	s_metric.LECglu.s.center_place_fields = center_place_fields_s_LECglu;
	s_metric.LECglu.s.center_place_fields_index = center_place_fields_index_s_LECglu;
	s_metric.LECglu.s.center_place_fields_active = center_place_fields_active_s_LECglu;
	s_metric.LECglu.s.center_place_fields_index_sorted = center_place_fields_index_sorted_s_LECglu;
	s_metric.LECglu.s.center_place_fields_active_sorted = center_place_fields_active_sorted_s_LECglu;
	s_metric.LECglu.s.rate_map = rate_map_s_LECglu;
	s_metric.LECglu.s.rate_map_z = rate_map_z_s_LECglu;
	s_metric.LECglu.s.rate_map_n = rate_map_n_s_LECglu;
	s_metric.LECglu.s.rate_map_active = rate_map_active_s_LECglu;
	s_metric.LECglu.s.rate_map_active_z = rate_map_active_z_s_LECglu;
	s_metric.LECglu.s.rate_map_active_n = rate_map_active_n_s_LECglu;
	s_metric.LECglu.s.rate_map_active_sorted = rate_map_active_sorted_s_LECglu;
	s_metric.LECglu.s.rate_map_active_sorted_z = rate_map_active_sorted_z_s_LECglu;
	s_metric.LECglu.s.rate_map_active_sorted_n = rate_map_active_sorted_n_s_LECglu;
	s_metric.LECglu.s.spatial_info_bits = spatial_info_bits_s_LECglu;
	s_metric.LECglu.s.spatial_info_norm = spatial_info_norm_s_LECglu;
	s_metric.LECglu.s.roi_pc_binary = roi_pc_binary_s_LECglu;
	s_metric.LECglu.s.TC_corr_cross = TC_cross_s_LECglu;
	s_metric.LECglu.s.PV_corr_cross = PV_cross_s_LECglu;
	s_metric.LECglu.s.TC_corr_pair = TC_pair_s_LECglu;
	s_metric.LECglu.s.PV_corr_pair = PV_pair_s_LECglu;
	s_metric.LECglu.s.TC_corr_ref = TC_ref_s_LECglu;
	s_metric.LECglu.s.PV_corr_ref = PV_ref_s_LECglu;
	s_metric.LECgaba.s.event_rate_run = event_rate_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_rest = event_rate_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_run = event_amp_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_rest = event_amp_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_run = event_width_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_rest = event_width_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_run = event_auc_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_rest = event_auc_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_run = event_rise_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_rest = event_rise_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_run = event_decay_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_rest = event_decay_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rate_tuned = event_rate_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_rate_untuned = event_rate_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_amp_tuned = event_amp_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_amp_untuned = event_amp_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_width_tuned = event_width_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_width_untuned = event_width_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_auc_tuned = event_auc_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_auc_untuned = event_auc_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_rise_tuned = event_rise_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_rise_untuned = event_rise_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_decay_tuned = event_decay_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_decay_untuned = event_decay_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_rate_tuned_run = event_rate_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_tuned_rest = event_rate_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_tuned_run = event_amp_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_tuned_rest = event_amp_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_tuned_run = event_width_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_tuned_rest = event_width_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_tuned_run = event_auc_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_tuned_rest = event_auc_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_tuned_run = event_rise_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_tuned_rest = event_rise_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_tuned_run = event_decay_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_tuned_rest = event_decay_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rate_untuned_run = event_rate_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_untuned_rest = event_rate_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_untuned_run = event_amp_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_untuned_rest = event_amp_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_untuned_run = event_width_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_untuned_rest = event_width_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_untuned_run = event_auc_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_untuned_rest = event_auc_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_untuned_run = event_rise_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_untuned_rest = event_rise_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_untuned_run = event_decay_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_untuned_rest = event_decay_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_run = event_rate_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_rest = event_rate_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_run = event_amp_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_rest = event_amp_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_run = event_width_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_rest = event_width_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_run = event_auc_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_rest = event_auc_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_run = event_rise_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_rest = event_rise_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_run = event_decay_pop_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_rest = event_decay_pop_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_tuned = event_rate_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_untuned = event_rate_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_tuned = event_amp_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_untuned = event_amp_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_tuned = event_width_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_untuned = event_width_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_tuned = event_auc_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_untuned = event_auc_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_tuned = event_rise_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_untuned = event_rise_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_tuned = event_decay_pop_tuned_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_untuned = event_decay_pop_untuned_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_tuned_run = event_rate_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_tuned_run = event_amp_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_tuned_run = event_width_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_tuned_rest = event_width_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_tuned_run = event_auc_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_tuned_run = event_rise_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_tuned_run = event_decay_pop_tuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_untuned_run = event_rate_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_untuned_run = event_amp_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_untuned_run = event_width_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_width_pop_untuned_rest = event_width_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_untuned_run = event_auc_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_untuned_run = event_rise_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_untuned_run = event_decay_pop_untuned_run_s_LECgaba;
	s_metric.LECgaba.s.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_s_LECgaba;
	s_metric.LECgaba.s.fraction_active_ROIs = fraction_active_ROIs_s_LECgaba;
	s_metric.LECgaba.s.fraction_active_ROIs_run = fraction_active_ROIs_run_s_LECgaba;
	s_metric.LECgaba.s.fraction_active_ROIs_rest = fraction_active_ROIs_rest_s_LECgaba;
	s_metric.LECgaba.s.fraction_place_cells = fraction_place_cells_s_LECgaba;
	s_metric.LECgaba.s.number_place_fields = number_place_fields_s_LECgaba;
	s_metric.LECgaba.s.width_place_fields = width_place_fields_s_LECgaba;
	s_metric.LECgaba.s.center_place_fields = center_place_fields_s_LECgaba;
	s_metric.LECgaba.s.center_place_fields_index = center_place_fields_index_s_LECgaba;
	s_metric.LECgaba.s.center_place_fields_active = center_place_fields_active_s_LECgaba;
	s_metric.LECgaba.s.center_place_fields_index_sorted = center_place_fields_index_sorted_s_LECgaba;
	s_metric.LECgaba.s.center_place_fields_active_sorted = center_place_fields_active_sorted_s_LECgaba;
	s_metric.LECgaba.s.rate_map = rate_map_s_LECgaba;
	s_metric.LECgaba.s.rate_map_z = rate_map_z_s_LECgaba;
	s_metric.LECgaba.s.rate_map_n = rate_map_n_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active = rate_map_active_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active_z = rate_map_active_z_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active_n = rate_map_active_n_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active_sorted = rate_map_active_sorted_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active_sorted_z = rate_map_active_sorted_z_s_LECgaba;
	s_metric.LECgaba.s.rate_map_active_sorted_n = rate_map_active_sorted_n_s_LECgaba;
	s_metric.LECgaba.s.spatial_info_bits = spatial_info_bits_s_LECgaba;
	s_metric.LECgaba.s.spatial_info_norm = spatial_info_norm_s_LECgaba;
	s_metric.LECgaba.s.roi_pc_binary = roi_pc_binary_s_LECgaba;
	s_metric.LECgaba.s.TC_corr_cross = TC_cross_s_LECgaba;
	s_metric.LECgaba.s.PV_corr_cross = PV_cross_s_LECgaba;
	s_metric.LECgaba.s.TC_corr_pair = TC_pair_s_LECgaba;
	s_metric.LECgaba.s.PV_corr_pair = PV_pair_s_LECgaba;
	s_metric.LECgaba.s.TC_corr_ref = TC_ref_s_LECgaba;
	s_metric.LECgaba.s.PV_corr_ref = PV_ref_s_LECgaba;
	%dendrites
	s_metric.control.ad.event_rate_run = event_rate_run_ad_control;
	s_metric.control.ad.event_rate_rest = event_rate_rest_ad_control;
	s_metric.control.ad.event_amp_run = event_amp_run_ad_control;
	s_metric.control.ad.event_amp_rest = event_amp_rest_ad_control;
	s_metric.control.ad.event_width_run = event_width_run_ad_control;
	s_metric.control.ad.event_width_rest = event_width_rest_ad_control;
	s_metric.control.ad.event_auc_run = event_auc_run_ad_control;
	s_metric.control.ad.event_auc_rest = event_auc_rest_ad_control;
	s_metric.control.ad.event_rise_run = event_rise_run_ad_control;
	s_metric.control.ad.event_rise_rest = event_rise_rest_ad_control;
	s_metric.control.ad.event_decay_run = event_decay_run_ad_control;
	s_metric.control.ad.event_decay_rest = event_decay_rest_ad_control;
	s_metric.control.ad.event_rate_tuned = event_rate_tuned_ad_control;
	s_metric.control.ad.event_rate_untuned = event_rate_untuned_ad_control;
	s_metric.control.ad.event_amp_tuned = event_amp_tuned_ad_control;
	s_metric.control.ad.event_amp_untuned = event_amp_untuned_ad_control;
	s_metric.control.ad.event_width_tuned = event_width_tuned_ad_control;
	s_metric.control.ad.event_width_untuned = event_width_untuned_ad_control;
	s_metric.control.ad.event_auc_tuned = event_auc_tuned_ad_control;
	s_metric.control.ad.event_auc_untuned = event_auc_untuned_ad_control;
	s_metric.control.ad.event_rise_tuned = event_rise_tuned_ad_control;
	s_metric.control.ad.event_rise_untuned = event_rise_untuned_ad_control;
	s_metric.control.ad.event_decay_tuned = event_decay_tuned_ad_control;
	s_metric.control.ad.event_decay_untuned = event_decay_untuned_ad_control;
	s_metric.control.ad.event_rate_tuned_run = event_rate_tuned_run_ad_control;
	s_metric.control.ad.event_rate_tuned_rest = event_rate_tuned_rest_ad_control;
	s_metric.control.ad.event_amp_tuned_run = event_amp_tuned_run_ad_control;
	s_metric.control.ad.event_amp_tuned_rest = event_amp_tuned_rest_ad_control;
	s_metric.control.ad.event_width_tuned_run = event_width_tuned_run_ad_control;
	s_metric.control.ad.event_width_tuned_rest = event_width_tuned_rest_ad_control;
	s_metric.control.ad.event_auc_tuned_run = event_auc_tuned_run_ad_control;
	s_metric.control.ad.event_auc_tuned_rest = event_auc_tuned_rest_ad_control;
	s_metric.control.ad.event_rise_tuned_run = event_rise_tuned_run_ad_control;
	s_metric.control.ad.event_rise_tuned_rest = event_rise_tuned_rest_ad_control;
	s_metric.control.ad.event_decay_tuned_run = event_decay_tuned_run_ad_control;
	s_metric.control.ad.event_decay_tuned_rest = event_decay_tuned_rest_ad_control;
	s_metric.control.ad.event_rate_untuned_run = event_rate_untuned_run_ad_control;
	s_metric.control.ad.event_rate_untuned_rest = event_rate_untuned_rest_ad_control;
	s_metric.control.ad.event_amp_untuned_run = event_amp_untuned_run_ad_control;
	s_metric.control.ad.event_amp_untuned_rest = event_amp_untuned_rest_ad_control;
	s_metric.control.ad.event_width_untuned_run = event_width_untuned_run_ad_control;
	s_metric.control.ad.event_width_untuned_rest = event_width_untuned_rest_ad_control;
	s_metric.control.ad.event_auc_untuned_run = event_auc_untuned_run_ad_control;
	s_metric.control.ad.event_auc_untuned_rest = event_auc_untuned_rest_ad_control;
	s_metric.control.ad.event_rise_untuned_run = event_rise_untuned_run_ad_control;
	s_metric.control.ad.event_rise_untuned_rest = event_rise_untuned_rest_ad_control;
	s_metric.control.ad.event_decay_untuned_run = event_decay_untuned_run_ad_control;
	s_metric.control.ad.event_decay_untuned_rest = event_decay_untuned_rest_ad_control;
	s_metric.control.ad.event_rate_pop_run = event_rate_pop_run_ad_control;
	s_metric.control.ad.event_rate_pop_rest = event_rate_pop_rest_ad_control;
	s_metric.control.ad.event_amp_pop_run = event_amp_pop_run_ad_control;
	s_metric.control.ad.event_amp_pop_rest = event_amp_pop_rest_ad_control;
	s_metric.control.ad.event_width_pop_run = event_width_pop_run_ad_control;
	s_metric.control.ad.event_width_pop_rest = event_width_pop_rest_ad_control;
	s_metric.control.ad.event_auc_pop_run = event_auc_pop_run_ad_control;
	s_metric.control.ad.event_auc_pop_rest = event_auc_pop_rest_ad_control;
	s_metric.control.ad.event_rise_pop_run = event_rise_pop_run_ad_control;
	s_metric.control.ad.event_rise_pop_rest = event_rise_pop_rest_ad_control;
	s_metric.control.ad.event_decay_pop_run = event_decay_pop_run_ad_control;
	s_metric.control.ad.event_decay_pop_rest = event_decay_pop_rest_ad_control;
	s_metric.control.ad.event_rate_pop_tuned = event_rate_pop_tuned_ad_control;
	s_metric.control.ad.event_rate_pop_untuned = event_rate_pop_untuned_ad_control;
	s_metric.control.ad.event_amp_pop_tuned = event_amp_pop_tuned_ad_control;
	s_metric.control.ad.event_amp_pop_untuned = event_amp_pop_untuned_ad_control;
	s_metric.control.ad.event_width_pop_tuned = event_width_pop_tuned_ad_control;
	s_metric.control.ad.event_width_pop_untuned = event_width_pop_untuned_ad_control;
	s_metric.control.ad.event_auc_pop_tuned = event_auc_pop_tuned_ad_control;
	s_metric.control.ad.event_auc_pop_untuned = event_auc_pop_untuned_ad_control;
	s_metric.control.ad.event_rise_pop_tuned = event_rise_pop_tuned_ad_control;
	s_metric.control.ad.event_rise_pop_untuned = event_rise_pop_untuned_ad_control;
	s_metric.control.ad.event_decay_pop_tuned = event_decay_pop_tuned_ad_control;
	s_metric.control.ad.event_decay_pop_untuned = event_decay_pop_untuned_ad_control;
	s_metric.control.ad.event_rate_pop_tuned_run = event_rate_pop_tuned_run_ad_control;
	s_metric.control.ad.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_amp_pop_tuned_run = event_amp_pop_tuned_run_ad_control;
	s_metric.control.ad.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_width_pop_tuned_run = event_width_pop_tuned_run_ad_control;
	s_metric.control.ad.event_width_pop_tuned_rest = event_width_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_auc_pop_tuned_run = event_auc_pop_tuned_run_ad_control;
	s_metric.control.ad.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_rise_pop_tuned_run = event_rise_pop_tuned_run_ad_control;
	s_metric.control.ad.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_decay_pop_tuned_run = event_decay_pop_tuned_run_ad_control;
	s_metric.control.ad.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_ad_control;
	s_metric.control.ad.event_rate_pop_untuned_run = event_rate_pop_untuned_run_ad_control;
	s_metric.control.ad.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_ad_control;
	s_metric.control.ad.event_amp_pop_untuned_run = event_amp_pop_untuned_run_ad_control;
	s_metric.control.ad.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_ad_control;
	s_metric.control.ad.event_width_pop_untuned_run = event_width_pop_untuned_run_ad_control;
	s_metric.control.ad.event_width_pop_untuned_rest = event_width_pop_untuned_rest_ad_control;
	s_metric.control.ad.event_auc_pop_untuned_run = event_auc_pop_untuned_run_ad_control;
	s_metric.control.ad.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_ad_control;
	s_metric.control.ad.event_rise_pop_untuned_run = event_rise_pop_untuned_run_ad_control;
	s_metric.control.ad.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_ad_control;
	s_metric.control.ad.event_decay_pop_untuned_run = event_decay_pop_untuned_run_ad_control;
	s_metric.control.ad.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_ad_control;
	s_metric.control.ad.fraction_active_ROIs = fraction_active_ROIs_ad_control;
	s_metric.control.ad.fraction_active_ROIs_run = fraction_active_ROIs_run_ad_control;
	s_metric.control.ad.fraction_active_ROIs_rest = fraction_active_ROIs_rest_ad_control;
	s_metric.control.ad.fraction_place_cells = fraction_place_cells_ad_control;
	s_metric.control.ad.number_place_fields = number_place_fields_ad_control;
	s_metric.control.ad.width_place_fields = width_place_fields_ad_control;
	s_metric.control.ad.center_place_fields = center_place_fields_ad_control;
	s_metric.control.ad.center_place_fields_index = center_place_fields_index_ad_control;
	s_metric.control.ad.center_place_fields_active = center_place_fields_active_ad_control;
	s_metric.control.ad.center_place_fields_index_sorted = center_place_fields_index_sorted_ad_control;
	s_metric.control.ad.center_place_fields_active_sorted = center_place_fields_active_sorted_ad_control;
	s_metric.control.ad.rate_map = rate_map_ad_control;
	s_metric.control.ad.rate_map_z = rate_map_z_ad_control;
	s_metric.control.ad.rate_map_n = rate_map_n_ad_control;
	s_metric.control.ad.rate_map_active = rate_map_active_ad_control;
	s_metric.control.ad.rate_map_active_z = rate_map_active_z_ad_control;
	s_metric.control.ad.rate_map_active_n = rate_map_active_n_ad_control;
	s_metric.control.ad.rate_map_active_sorted = rate_map_active_sorted_ad_control;
	s_metric.control.ad.rate_map_active_sorted_z = rate_map_active_sorted_z_ad_control;
	s_metric.control.ad.rate_map_active_sorted_n = rate_map_active_sorted_n_ad_control;
	s_metric.control.ad.spatial_info_bits = spatial_info_bits_ad_control;
	s_metric.control.ad.spatial_info_norm = spatial_info_norm_ad_control;
	s_metric.control.ad.roi_pc_binary = roi_pc_binary_ad_control;
	s_metric.control.ad.TC_corr_cross = TC_cross_ad_control;
	s_metric.control.ad.PV_corr_cross = PV_cross_ad_control;
	s_metric.control.ad.TC_corr_pair = TC_pair_ad_control;
	s_metric.control.ad.PV_corr_pair = PV_pair_ad_control;
	s_metric.control.ad.TC_corr_ref = TC_ref_ad_control;
	s_metric.control.ad.PV_corr_ref = PV_ref_ad_control;
	s_metric.LECglu.ad.event_rate_run = event_rate_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_rest = event_rate_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_run = event_amp_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_rest = event_amp_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_run = event_width_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_rest = event_width_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_run = event_auc_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_rest = event_auc_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_run = event_rise_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_rest = event_rise_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_run = event_decay_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_rest = event_decay_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rate_tuned = event_rate_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_rate_untuned = event_rate_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_amp_tuned = event_amp_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_amp_untuned = event_amp_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_width_tuned = event_width_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_width_untuned = event_width_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_auc_tuned = event_auc_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_auc_untuned = event_auc_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_rise_tuned = event_rise_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_rise_untuned = event_rise_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_decay_tuned = event_decay_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_decay_untuned = event_decay_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_rate_tuned_run = event_rate_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_tuned_rest = event_rate_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_tuned_run = event_amp_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_tuned_rest = event_amp_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_tuned_run = event_width_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_tuned_rest = event_width_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_tuned_run = event_auc_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_tuned_rest = event_auc_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_tuned_run = event_rise_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_tuned_rest = event_rise_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_tuned_run = event_decay_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_tuned_rest = event_decay_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rate_untuned_run = event_rate_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_untuned_rest = event_rate_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_untuned_run = event_amp_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_untuned_rest = event_amp_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_untuned_run = event_width_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_untuned_rest = event_width_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_untuned_run = event_auc_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_untuned_rest = event_auc_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_untuned_run = event_rise_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_untuned_rest = event_rise_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_untuned_run = event_decay_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_untuned_rest = event_decay_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_run = event_rate_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_rest = event_rate_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_run = event_amp_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_rest = event_amp_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_run = event_width_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_rest = event_width_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_run = event_auc_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_rest = event_auc_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_run = event_rise_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_rest = event_rise_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_run = event_decay_pop_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_rest = event_decay_pop_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_tuned = event_rate_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_untuned = event_rate_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_tuned = event_amp_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_untuned = event_amp_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_tuned = event_width_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_untuned = event_width_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_tuned = event_auc_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_untuned = event_auc_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_tuned = event_rise_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_untuned = event_rise_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_tuned = event_decay_pop_tuned_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_untuned = event_decay_pop_untuned_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_tuned_run = event_rate_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_tuned_run = event_amp_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_tuned_run = event_width_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_tuned_rest = event_width_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_tuned_run = event_auc_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_tuned_run = event_rise_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_tuned_run = event_decay_pop_tuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_untuned_run = event_rate_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_untuned_run = event_amp_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_untuned_run = event_width_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_width_pop_untuned_rest = event_width_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_untuned_run = event_auc_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_untuned_run = event_rise_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_untuned_run = event_decay_pop_untuned_run_ad_LECglu;
	s_metric.LECglu.ad.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_ad_LECglu;
	s_metric.LECglu.ad.fraction_active_ROIs = fraction_active_ROIs_ad_LECglu;
	s_metric.LECglu.ad.fraction_active_ROIs_run = fraction_active_ROIs_run_ad_LECglu;
	s_metric.LECglu.ad.fraction_active_ROIs_rest = fraction_active_ROIs_rest_ad_LECglu;
	s_metric.LECglu.ad.fraction_place_cells = fraction_place_cells_ad_LECglu;
	s_metric.LECglu.ad.number_place_fields = number_place_fields_ad_LECglu;
	s_metric.LECglu.ad.width_place_fields = width_place_fields_ad_LECglu;
	s_metric.LECglu.ad.center_place_fields = center_place_fields_ad_LECglu;
	s_metric.LECglu.ad.center_place_fields_index = center_place_fields_index_ad_LECglu;
	s_metric.LECglu.ad.center_place_fields_active = center_place_fields_active_ad_LECglu;
	s_metric.LECglu.ad.center_place_fields_index_sorted = center_place_fields_index_sorted_ad_LECglu;
	s_metric.LECglu.ad.center_place_fields_active_sorted = center_place_fields_active_sorted_ad_LECglu;
	s_metric.LECglu.ad.rate_map = rate_map_ad_LECglu;
	s_metric.LECglu.ad.rate_map_z = rate_map_z_ad_LECglu;
	s_metric.LECglu.ad.rate_map_n = rate_map_n_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active = rate_map_active_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active_z = rate_map_active_z_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active_n = rate_map_active_n_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active_sorted = rate_map_active_sorted_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active_sorted_z = rate_map_active_sorted_z_ad_LECglu;
	s_metric.LECglu.ad.rate_map_active_sorted_n = rate_map_active_sorted_n_ad_LECglu;
	s_metric.LECglu.ad.spatial_info_bits = spatial_info_bits_ad_LECglu;
	s_metric.LECglu.ad.spatial_info_norm = spatial_info_norm_ad_LECglu;
	s_metric.LECglu.ad.roi_pc_binary = roi_pc_binary_ad_LECglu;
	s_metric.LECglu.ad.TC_corr_cross = TC_cross_ad_LECglu;
	s_metric.LECglu.ad.PV_corr_cross = PV_cross_ad_LECglu;
	s_metric.LECglu.ad.TC_corr_pair = TC_pair_ad_LECglu;
	s_metric.LECglu.ad.PV_corr_pair = PV_pair_ad_LECglu;
	s_metric.LECglu.ad.TC_corr_ref = TC_ref_ad_LECglu;
	s_metric.LECglu.ad.PV_corr_ref = PV_ref_ad_LECglu;
	s_metric.LECgaba.ad.event_rate_run = event_rate_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_rest = event_rate_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_run = event_amp_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_rest = event_amp_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_run = event_width_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_rest = event_width_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_run = event_auc_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_rest = event_auc_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_run = event_rise_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_rest = event_rise_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_run = event_decay_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_rest = event_decay_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_tuned = event_rate_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_untuned = event_rate_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_tuned = event_amp_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_untuned = event_amp_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_tuned = event_width_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_untuned = event_width_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_tuned = event_auc_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_untuned = event_auc_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_tuned = event_rise_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_untuned = event_rise_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_tuned = event_decay_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_untuned = event_decay_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_tuned_run = event_rate_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_tuned_rest = event_rate_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_tuned_run = event_amp_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_tuned_rest = event_amp_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_tuned_run = event_width_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_tuned_rest = event_width_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_tuned_run = event_auc_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_tuned_rest = event_auc_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_tuned_run = event_rise_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_tuned_rest = event_rise_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_tuned_run = event_decay_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_tuned_rest = event_decay_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_untuned_run = event_rate_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_untuned_rest = event_rate_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_untuned_run = event_amp_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_untuned_rest = event_amp_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_untuned_run = event_width_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_untuned_rest = event_width_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_untuned_run = event_auc_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_untuned_rest = event_auc_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_untuned_run = event_rise_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_untuned_rest = event_rise_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_untuned_run = event_decay_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_untuned_rest = event_decay_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_run = event_rate_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_rest = event_rate_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_run = event_amp_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_rest = event_amp_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_run = event_width_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_rest = event_width_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_run = event_auc_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_rest = event_auc_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_run = event_rise_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_rest = event_rise_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_run = event_decay_pop_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_rest = event_decay_pop_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_tuned = event_rate_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_untuned = event_rate_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_tuned = event_amp_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_untuned = event_amp_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_tuned = event_width_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_untuned = event_width_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_tuned = event_auc_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_untuned = event_auc_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_tuned = event_rise_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_untuned = event_rise_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_tuned = event_decay_pop_tuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_untuned = event_decay_pop_untuned_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_tuned_run = event_rate_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_tuned_rest = event_rate_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_tuned_run = event_amp_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_tuned_rest = event_amp_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_tuned_run = event_width_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_tuned_rest = event_width_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_tuned_run = event_auc_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_tuned_rest = event_auc_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_tuned_run = event_rise_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_tuned_rest = event_rise_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_tuned_run = event_decay_pop_tuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_tuned_rest = event_decay_pop_tuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_untuned_run = event_rate_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rate_pop_untuned_rest = event_rate_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_untuned_run = event_amp_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_amp_pop_untuned_rest = event_amp_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_untuned_run = event_width_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_width_pop_untuned_rest = event_width_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_untuned_run = event_auc_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_auc_pop_untuned_rest = event_auc_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_untuned_run = event_rise_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_rise_pop_untuned_rest = event_rise_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_untuned_run = event_decay_pop_untuned_run_ad_LECgaba;
	s_metric.LECgaba.ad.event_decay_pop_untuned_rest = event_decay_pop_untuned_rest_ad_LECgaba;
	s_metric.LECgaba.ad.fraction_active_ROIs = fraction_active_ROIs_ad_LECgaba;
	s_metric.LECgaba.ad.fraction_active_ROIs_run = fraction_active_ROIs_run_ad_LECgaba;
	s_metric.LECgaba.ad.fraction_active_ROIs_rest = fraction_active_ROIs_rest_ad_LECgaba;
	s_metric.LECgaba.ad.fraction_place_cells = fraction_place_cells_ad_LECgaba;
	s_metric.LECgaba.ad.number_place_fields = number_place_fields_ad_LECgaba;
	s_metric.LECgaba.ad.width_place_fields = width_place_fields_ad_LECgaba;
	s_metric.LECgaba.ad.center_place_fields = center_place_fields_ad_LECgaba;
	s_metric.LECgaba.ad.center_place_fields_index = center_place_fields_index_ad_LECgaba;
	s_metric.LECgaba.ad.center_place_fields_active = center_place_fields_active_ad_LECgaba;
	s_metric.LECgaba.ad.center_place_fields_index_sorted = center_place_fields_index_sorted_ad_LECgaba;
	s_metric.LECgaba.ad.center_place_fields_active_sorted = center_place_fields_active_sorted_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map = rate_map_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_z = rate_map_z_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_n = rate_map_n_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active = rate_map_active_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active_z = rate_map_active_z_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active_n = rate_map_active_n_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active_sorted = rate_map_active_sorted_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active_sorted_z = rate_map_active_sorted_z_ad_LECgaba;
	s_metric.LECgaba.ad.rate_map_active_sorted_n = rate_map_active_sorted_n_ad_LECgaba;
	s_metric.LECgaba.ad.spatial_info_bits = spatial_info_bits_ad_LECgaba;
	s_metric.LECgaba.ad.spatial_info_norm = spatial_info_norm_ad_LECgaba;
	s_metric.LECgaba.ad.roi_pc_binary = roi_pc_binary_ad_LECgaba;
	s_metric.LECgaba.ad.TC_corr_cross = TC_cross_ad_LECgaba;
	s_metric.LECgaba.ad.PV_corr_cross = PV_cross_ad_LECgaba;
	s_metric.LECgaba.ad.TC_corr_pair = TC_pair_ad_LECgaba;
	s_metric.LECgaba.ad.PV_corr_pair = PV_pair_ad_LECgaba;
	s_metric.LECgaba.ad.TC_corr_ref = TC_ref_ad_LECgaba;
	s_metric.LECgaba.ad.PV_corr_ref = PV_ref_ad_LECgaba;
	fprintf('\nsaving output...\n');
	save('/gpfs/data/basulab/VR/s_metric_fr02i02w02p02.mat','s_metric','-v7.3');
	fprintf('\ndone!\n');
end