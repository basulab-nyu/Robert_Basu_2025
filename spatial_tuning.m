function [] = spatial_tuning()
    root_path = '/gpfs/data/basulab/VR/cohort_5';
    mouse_id = 'm12';
	input_data = 'fitness_fullsample';
	input_data_file = 'fitness.mat';
	input_behavior = 'behavior';
	input_behavior_file = 'Behavior.mat';
	roi_type = ["ad","bd","s"];
	min_rise = 0.2; %s
	min_interval = 0.2; %s
	min_width = 0.2; %s
	session_length = 20000; %samples
	session_duration = 600; %s
    output_name = 'spatial_tuning_fr02i02w02';
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
	session_groups = [1 1 1 1 3 3 3 3 4 4 4 4 4 4 4 4 4];
	addpath(genpath('code'));
    str_slash = '/';
    if ~contains(root_path,str_slash)
        str_slash = '\';
    end
    if(~exist(fullfile(root_path,mouse_id,output_name),'dir'))
        mkdir(fullfile(root_path,mouse_id,output_name));
    end
	min_rise = floor(min_rise*session_length/session_duration);
	min_interval = floor(min_interval*session_length/session_duration);
	tic;
	s_work = struct;
	fprintf('\nworking on:\n\n');
	disp(fullfile(root_path,mouse_id,input_data,input_data_file));
	fprintf('\nloading data files...\n\n');
	s_input = load(fullfile(root_path,mouse_id,input_data,input_data_file),'s_root');
	s_input.s_root(1).root_id = mouse_id;
	s_input.s_root(1).root_folder = fullfile(root_path,mouse_id);
	s_input.s_root(1).session_groups = session_groups;
	s_work.root_folder = fullfile(root_path,mouse_id);
	s_work.mouse_id = mouse_id;
	s_work.session_id = {};
	s_work.behavior_path = {};
	s_work.session_groups = session_groups';
	s_work.roi_id = s_input(1).s_root(1).roi_id.names;
	s_work.roi_coor = s_input(1).s_root(1).roi_coor.Coor;
	for j=1:size(s_input(1).s_root,2) %sessions
		s_work.session_id{j,1} = s_input(1).s_root(j).name;
		behav_folder = char(fullfile(root_path,mouse_id,extract(s_work.session_id{j,1},digitsPattern(6)),s_work.session_id{j,1},input_behavior));
		s_work.behavior_path{j,1} = fullfile(behav_folder,dir(fullfile(behav_folder,input_behavior_file)).name);
		s_work.event_onset{j,1} = cellfun(@(c) c(:,1),s_input(1).s_root(j).start_stop,'UniformOutput',false);
		s_work.event_offset{j,1} = cellfun(@(c) c(:,2),s_input(1).s_root(j).start_stop,'UniformOutput',false);
		s_work.event_rise{j,1} = cellfun(@(c,d) c-d,s_input(1).s_root(j).peak,s_work.event_onset{j,1},'UniformOutput',false);
		s_work.event_decay{j,1} = cellfun(@(c,d) d-c,s_input(1).s_root(j).peak,s_work.event_offset{j,1},'UniformOutput',false);
		s_work.event_peak{j,1} = s_input(1).s_root(j).peak;
		s_work.event_amp{j,1} = s_input(1).s_root(j).amp;
		s_work.event_width{j,1} = s_input(1).s_root(j).width;
		s_work.event_auc{j,1} = s_input(1).s_root(j).auc;
		start = cellfun(@(c) c(2:end),s_work.event_onset{j,1},'UniformOutput',false);
		stop = cellfun(@(c) c(1:end-1),s_work.event_offset{j,1},'UniformOutput',false);
		s_work.event_interval{j,1} = cellfun(@(c,d) c-d,start,stop,'UniformOutput',false);
		merge = cellfun(@(c) find(c<min_interval),s_work.event_interval{j,1},'UniformOutput',false);
		for k=1:size(merge,2)
			limit = 1;
			while(~isempty(limit)) %(merge{1,k}) = this one / (merge{1,k}+1) = next one
				s_work.event_onset{j,1}{1,k}(merge{1,k}+1) = [];
				s_work.event_offset{j,1}{1,k}(merge{1,k}) = [];
				s_work.event_rise{j,1}{1,k}(merge{1,k}+1) = [];
				s_work.event_decay{j,1}{1,k}(merge{1,k}) = [];
				s_work.event_peak{j,1}{1,k}(merge{1,k}+1) = [];
				s_work.event_amp{j,1}{1,k}(merge{1,k}+1) = [];
				s_work.event_width{j,1}{1,k}(merge{1,k}) = s_work.event_width{j,1}{1,k}(merge{1,k}) + s_work.event_width{j,1}{1,k}(merge{1,k}+1);
				s_work.event_width{j,1}{1,k}(merge{1,k}+1) = [];
				s_work.event_auc{j,1}{1,k}(merge{1,k}) = s_work.event_auc{j,1}{1,k}(merge{1,k}) + s_work.event_auc{j,1}{1,k}(merge{1,k}+1);
				s_work.event_auc{j,1}{1,k}(merge{1,k}+1) = [];
				on = s_work.event_onset{j,1}{1,k}(2:end);
				off = s_work.event_offset{j,1}{1,k}(1:end-1);
				interval = on-off;
				limit = find(interval<min_interval);
			end
		end
		s_work.event_onset{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_onset{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_offset{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_offset{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_decay{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_decay{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_peak{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_peak{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_amp{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_amp{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_width{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_width{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_auc{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_auc{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_rise{j,1} = cellfun(@(c,d) c(find(d>=min_rise)),s_work.event_rise{j,1},s_work.event_rise{j,1},'UniformOutput',false);
		s_work.event_onset{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_onset{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_offset{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_offset{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_decay{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_decay{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_peak{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_peak{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_amp{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_amp{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_width{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_width{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_auc{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_auc{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_rise{j,1} = cellfun(@(c,d) c(find(d>=min_width)),s_work.event_rise{j,1},s_work.event_width{j,1},'UniformOutput',false);
		s_work.event_binary{j,1} = zeros(session_length,size(s_work.event_peak{j,1},2));
		for k=1:size(s_work.event_peak{j,1},2) %ROIs
			for x=1:size(s_work.event_peak{j,1}{1,k},1) %events
				s_work.event_binary{j,1}(s_work.event_peak{j,1}{1,k}(x,1),k) = 1;
			end
		end
	end
	fprintf('\nanalyzing spatial properties...\n\n');
	v_roi_type_size = NaN(size(roi_type,2),1);
	m_roi_id_logic = zeros(size(s_work.roi_id,1),size(roi_type,2));
	for j=1:size(roi_type,2)
		v_roi_type_size(j) = sum(contains(s_work.roi_id,roi_type(j)));
		m_roi_id_logic(:,j) = contains(s_work.roi_id,roi_type(j));
	end
	for j=1:size(roi_type,2) %compartments
		if ~isempty(find(m_roi_id_logic(:,j)))
			s_work.(roi_type(j)).roi_id = s_work.roi_id((find(m_roi_id_logic(:,j))),:);
			for k=1:size(s_work.behavior_path,1) %sessions
				idx = find(m_roi_id_logic(:,j));
				for x=1:size(idx,1)
					s_work.(roi_type(j)).event_onset{k,1}{1,x} = s_work.event_onset{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_offset{k,1}{1,x} = s_work.event_offset{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_rise{k,1}{1,x} = s_work.event_rise{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_decay{k,1}{1,x} = s_work.event_decay{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_peak{k,1}{1,x} = s_work.event_peak{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_amp{k,1}{1,x} = s_work.event_amp{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_width{k,1}{1,x} = s_work.event_width{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_auc{k,1}{1,x} = s_work.event_auc{k,1}{1,idx(x)};
					s_work.(roi_type(j)).event_binary{k,1}(:,x) = s_work.event_binary{k,1}(:,idx(x));
				end
				if(contains(char(s_work.behavior_path{k,1}),input_session) && isfile(char(s_work.behavior_path{k,1})))
					fprintf(strcat('\nprocessing:',roi_type(j)+'_'+s_work.session_id{k,1},'\n'));
					s_work.(roi_type(j)).spatial(k).event_onset = s_work.(roi_type(j)).event_onset{k,1};
					s_work.(roi_type(j)).spatial(k).event_offset = s_work.(roi_type(j)).event_offset{k,1};
					s_work.(roi_type(j)).spatial(k).event_rise = s_work.(roi_type(j)).event_rise{k,1};
					s_work.(roi_type(j)).spatial(k).event_decay = s_work.(roi_type(j)).event_decay{k,1};
					s_work.(roi_type(j)).spatial(k).event_peak = s_work.(roi_type(j)).event_peak{k,1};
					s_work.(roi_type(j)).spatial(k).event_amp = s_work.(roi_type(j)).event_amp{k,1};
					s_work.(roi_type(j)).spatial(k).event_width = s_work.(roi_type(j)).event_width{k,1};
					s_work.(roi_type(j)).spatial(k).event_auc = s_work.(roi_type(j)).event_width{k,1};
					s_work.(roi_type(j)).spatial(k).event_binary = s_work.(roi_type(j)).event_binary{k,1}';
					try
						[output0,outputOptimal,outputHalves,run_epochs,rest_epochs] = j_place_analysis_fullsample(s_work.(roi_type(j)).spatial(k).event_binary,char(s_work.behavior_path{k,1}));
						s_work.(roi_type(j)).spatial(k).all = output0;
						s_work.(roi_type(j)).spatial(k).opt = outputOptimal;
						s_work.(roi_type(j)).spatial(k).split = outputHalves;
						s_work.(roi_type(j)).spatial(k).run_epochs = run_epochs;
						s_work.(roi_type(j)).spatial(k).rest_epochs = rest_epochs;
						s_work.(roi_type(j)).spatial(k).active_ROI_idx = find(cellfun(@(c) ~isempty(c),s_work.(roi_type(j)).spatial(k).event_peak));
						s_work.(roi_type(j)).spatial(k).active_ROI_bin = zeros(size(s_work.(roi_type(j)).spatial(k).event_peak,1),1);
						s_work.(roi_type(j)).spatial(k).active_ROI_bin(s_work.(roi_type(j)).spatial(k).active_ROI_idx) = 1;
						s_work.(roi_type(j)).spatial(k).active_ROI_counts = size(s_work.(roi_type(j)).spatial(k).active_ROI_idx,2);
						s_work.(roi_type(j)).spatial(k).inactive_ROI_counts = size(find(cellfun(@(c) isempty(c),s_work.(roi_type(j)).spatial(k).event_peak)),2);
						s_work.(roi_type(j)).spatial(k).event_onset_active = s_work.(roi_type(j)).spatial(k).event_onset(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_offset_active = s_work.(roi_type(j)).spatial(k).event_offset(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_rise_active = s_work.(roi_type(j)).spatial(k).event_rise(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_decay_active = s_work.(roi_type(j)).spatial(k).event_decay(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_peak_active = s_work.(roi_type(j)).spatial(k).event_peak(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_amp_active = s_work.(roi_type(j)).spatial(k).event_amp(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_width_active = s_work.(roi_type(j)).spatial(k).event_width(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).event_auc_active = s_work.(roi_type(j)).spatial(k).event_auc(find(s_work.(roi_type(j)).spatial(k).active_ROI_bin));
						s_work.(roi_type(j)).spatial(k).run_idx = cellfun(@(c) find(run_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_active,'UniformOutput',false);	
						s_work.(roi_type(j)).spatial(k).event_onset_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_active,s_work.(roi_type(j)).spatial(k).run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).rest_idx = cellfun(@(c) find(rest_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_active,'UniformOutput',false);	
						s_work.(roi_type(j)).spatial(k).event_onset_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_active,s_work.(roi_type(j)).spatial(k).rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_onset_tuned = s_work.(roi_type(j)).spatial(k).event_onset(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_onset_untuned = s_work.(roi_type(j)).spatial(k).event_onset(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_offset_tuned = s_work.(roi_type(j)).spatial(k).event_offset(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_offset_untuned = s_work.(roi_type(j)).spatial(k).event_offset(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_rise_tuned = s_work.(roi_type(j)).spatial(k).event_rise(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_rise_untuned = s_work.(roi_type(j)).spatial(k).event_rise(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_decay_tuned = s_work.(roi_type(j)).spatial(k).event_decay(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_decay_untuned = s_work.(roi_type(j)).spatial(k).event_decay(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_peak_tuned = s_work.(roi_type(j)).spatial(k).event_peak(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_peak_untuned = s_work.(roi_type(j)).spatial(k).event_peak(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_amp_tuned = s_work.(roi_type(j)).spatial(k).event_amp(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_amp_untuned = s_work.(roi_type(j)).spatial(k).event_amp(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_width_tuned = s_work.(roi_type(j)).spatial(k).event_width(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_width_untuned = s_work.(roi_type(j)).spatial(k).event_width(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_auc_tuned = s_work.(roi_type(j)).spatial(k).event_auc(find(s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).event_auc_untuned = s_work.(roi_type(j)).spatial(k).event_auc(find(~s_work.(roi_type(j)).spatial(k).all.significant));
						s_work.(roi_type(j)).spatial(k).tuned_run_idx = cellfun(@(c) find(run_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_tuned,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_onset_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_tuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_tuned,s_work.(roi_type(j)).spatial(k).tuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).untuned_run_idx = cellfun(@(c) find(run_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_untuned,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_onset_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_untuned_run = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_untuned,s_work.(roi_type(j)).spatial(k).untuned_run_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).tuned_rest_idx = cellfun(@(c) find(rest_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_tuned,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_onset_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_tuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_tuned,s_work.(roi_type(j)).spatial(k).tuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).untuned_rest_idx = cellfun(@(c) find(rest_epochs(c)),s_work.(roi_type(j)).spatial(k).event_peak_untuned,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_onset_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_onset_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_offset_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_offset_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_rise_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_rise_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_decay_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_decay_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_peak_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_peak_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_amp_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_amp_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_width_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_width_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						s_work.(roi_type(j)).spatial(k).event_auc_untuned_rest = cellfun(@(c,d)c(d),s_work.(roi_type(j)).spatial(k).event_auc_untuned,s_work.(roi_type(j)).spatial(k).untuned_rest_idx,'UniformOutput',false);
						fprintf('\ndone!\n');
					catch
						fprintf('\nERROR\n');
					end
				else
					fprintf(strcat('\n',roi_type(j)+'_'+s_work.session_id{k,1},' missing!\n'));
				end
			end
		else
			fprintf(strcat('\ninsufficient data in:',mouse_id,'_',roi_type(j),'\n'));
		end
	end
	clear s_input;
	%s_full = s_work;
	s_light = s_work;
	s_light = rmfield(s_light,{'event_onset','event_offset','event_rise','event_decay','event_peak','event_amp','event_width','event_auc','event_binary'});
	for j=1:size(roi_type,2) %compartments
		s_light.(roi_type(j)) = rmfield(s_light.(roi_type(j)),{'event_onset','event_offset','event_rise','event_decay','event_peak','event_amp','event_width','event_auc','event_binary'});
	end
	disp(mouse_id+" done!");
	fprintf('\nsaving output...\n\n');
	%save(fullfile(root_path,mouse_id,output_name,strcat(output_name,'_full.mat')),'s_full','-v7.3');
	save(fullfile(root_path,mouse_id,output_name,strcat(output_name,'_light.mat')),'s_light','-v7.3');
	fprintf('\nall done!!!\n\n');
	toc;
end