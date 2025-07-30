function [] = spatial_coding()
    fprintf('\nanalyzing spatial coding...\n');
%setting up
    %inputs
	root_path = '/gpfs/data/basulab/VR/cohort_5';
    mouse_id = 'm12';
	input_folder = 'spatial_tuning_fr02i02w02';
	mat_file = 'spatial_tuning_fr02i02w02_light.mat';
    roi_type = ["ad","bd","s"];
	matchlist = ...
	{'240307','240308','240309','240310',...
    '240311'+wildcardPattern+'fam1','240311'+wildcardPattern+'fam2','240311'+wildcardPattern+'nov',...
	'240312'+wildcardPattern+'fam1','240312'+wildcardPattern+'fam2','240312'+wildcardPattern+'nov',...
	'240313'+wildcardPattern+'fam1','240313'+wildcardPattern+'fam2','240313'+wildcardPattern+'nov',...
    '240314'+wildcardPattern+'fam1','240314'+wildcardPattern+'fam2','240314'+wildcardPattern+'nov',...
    '240325'+wildcardPattern+'fam1','240325'+wildcardPattern+'int','240325'+wildcardPattern+'fam2','240325'+wildcardPattern+'nov',...
    '240326'+wildcardPattern+'fam1','240326'+wildcardPattern+'int','240326'+wildcardPattern+'fam2','240326'+wildcardPattern+'nov',...
    '240327'+wildcardPattern+'fam1','240327'+wildcardPattern+'int','240327'+wildcardPattern+'fam2','240327'+wildcardPattern+'nov',...
    '240328'+wildcardPattern+'fam1','240328'+wildcardPattern+'int','240328'+wildcardPattern+'fam2','240328'+wildcardPattern+'nov',...
    '240329'+wildcardPattern+'fam1','240329'+wildcardPattern+'int','240329'+wildcardPattern+'fam2','240329'+wildcardPattern+'nov',...
    '240330'+wildcardPattern+'A_','240330'+wildcardPattern+'Aa','240330'+wildcardPattern+'A2','240330'+wildcardPattern+'B',...
    '240331'+wildcardPattern+'A_','240331'+wildcardPattern+'Aa','240331'+wildcardPattern+'A2','240331'+wildcardPattern+'B',...
    '240401'+wildcardPattern+'A_','240401'+wildcardPattern+'Aa','240401'+wildcardPattern+'A2','240401'+wildcardPattern+'B',...
    '240402'+wildcardPattern+'A_','240402'+wildcardPattern+'Aa','240402'+wildcardPattern+'A2','240402'+wildcardPattern+'B'};
	label_groups = ...
	["RF_hab_d1","RF_hab_d2","RF_hab_d3","RF_hab_d4",...
	"RF_fam1_sal","RF_fam2_sal","RF_nov_sal",...
	"RF_fam1_CNO","RF_fam2_CNO","RF_nov_CNO",...
	"RF_fam1_PSEM","RF_fam2_PSEM","RF_nov_PSEM",...
	"RF_fam1_DCZ","RF_fam2_DCZ","RF_nov_DCZ",...
	"GOL_fam1_d1","GOL_int_d1","GOL_fam2_d1","GOL_nov_d1",...
	"GOL_fam1_d2","GOL_int_d2","GOL_fam2_d2","GOL_nov_d2",...
	"GOL_fam1_d3","GOL_int_d3","GOL_fam2_d3","GOL_nov_d3",...
	"GOL_fam1_d4","GOL_int_d4","GOL_fam2_d4","GOL_nov_d4",...
	"GOL_fam1_d5","GOL_int_d5","GOL_fam2_d5","GOL_nov_d5",...
	"GOL_A_d1","GOL_Aa_d1","GOL_A2_d1","GOL_B_d1",...
	"GOL_A_d2","GOL_Aa_d2","GOL_A2_d2","GOL_B_d2",...
	"GOL_A_d3","GOL_Aa_d3","GOL_A2_d3","GOL_B_d3",...
	"GOL_A_d4","GOL_Aa_d4","GOL_A2_d4","GOL_B_d4"];
	session_groups = [1 1 1 1 3 3 3 3 4 4 4 4 4 4 4 4 4];
	ref = ["_fam1_","_A_","_A1_"];
	addpath(genpath('code'));
    str_slash = '/';
    if ~contains(root_path,str_slash)
        str_slash = '\';
    end
    %loading data
    fprintf('\nloading mat file...\n');
    load(fullfile(root_path,mouse_id,input_folder,mat_file));
	s_work = s_light;
    fprintf('\nmat file loaded!\n');
    try
        s_work = s_work.s_light;
    end
%analyzing spatial coding
	valid_sessions_idx = cellfun(@(c) find(c),cellfun(@(c) contains(s_work.session_id,c),matchlist,'UniformOutput',false),'UniformOutput',false)';
	valid_sessions = cellfun(@(c) s_work.session_id(c),valid_sessions_idx,'UniformOutput',false);
	valid_sessions = cellfun(@(c) cell2mat(c),valid_sessions,'UniformOutput',false);
	valid_sessions_idx(cellfun(@isempty,valid_sessions_idx))=[];
	valid_sessions(cellfun(@isempty,valid_sessions))=[];
	for j=1:size(roi_type,2) %roi type
		for k=1:size(valid_sessions,1)
			idx = find(cellfun(@(c) contains(s_work.session_id{k},c),matchlist));
			s_work.(char(roi_type(j))).spatial(k).session = char(s_work(size(s_work,2)).session_id{idx});
		end
	end
    fprintf('\nprocessing data...\n');
	for j=1:size(roi_type,2) %roi type
		if(~isempty(s_work.(char(roi_type(j)))))
			s_work.(char(roi_type(j))).roi_pc_binary = zeros(size(s_work.(char(roi_type(j))).roi_id,1),size(s_work.(char(roi_type(j))).spatial,2));
			for k=1:size(s_work.(char(roi_type(j))).spatial,2) %sessions
				%sorting
				if(~isempty(s_work.(char(roi_type(j))).spatial(k).all))
					field_center_index = find(~cellfun(@isempty,s_work.(char(roi_type(j))).spatial(k).all.fieldCenters));
					s_work.(char(roi_type(j))).spatial(k).all.field_center_index = field_center_index;
					s_work.(char(roi_type(j))).roi_pc_binary(field_center_index,k) = 1;
					s_work.(char(roi_type(j))).spatial(k).all.field_center_active = cellfun(@(v)v(1),s_work.(char(roi_type(j))).spatial(k).all.fieldCenters(field_center_index));
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active = s_work.(char(roi_type(j))).spatial(k).all.rate_map(field_center_index,:);
					[field_center_sorted,field_center_sorted_index] = sort(s_work.(char(roi_type(j))).spatial(k).all.field_center_active);
					s_work.(char(roi_type(j))).spatial(k).all.field_center_sorted = field_center_sorted;
					s_work.(char(roi_type(j))).spatial(k).all.field_center_sorted_index = field_center_sorted_index;
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_sorted = s_work.(char(roi_type(j))).spatial(k).all.rate_map_active(field_center_sorted_index,:);
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_z = zscore(s_work.(char(roi_type(j))).spatial(k).all.rate_map,0,2);
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_n = normalize(s_work.(char(roi_type(j))).spatial(k).all.rate_map,2,'range');
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_z = zscore(s_work.(char(roi_type(j))).spatial(k).all.rate_map_active,0,2);
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_n = normalize(s_work.(char(roi_type(j))).spatial(k).all.rate_map_active,2,'range');
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_z = zscore(s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_sorted,0,2);
					s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_sorted_n = normalize(s_work.(char(roi_type(j))).spatial(k).all.rate_map_active_sorted,2,'range');
				end
			end
			valid_sessions_idx = cellfun(@(c) find(c),cellfun(@(c) contains(s_work.session_id,c),matchlist,'UniformOutput',false),'UniformOutput',false);
			valid_sessions = cellfun(@(c) s_work.session_id(c),valid_sessions_idx,'UniformOutput',false);
			valid_sessions = cellfun(@(c) cell2mat(c),valid_sessions,'UniformOutput',false)';
			skip=0;
			for k=1:size(session_groups,2)
				if(isempty(valid_sessions{sum(session_groups(1:k))-session_groups(k)+1}))
					skip = skip+1;
				end
				if(session_groups(k)>1 && all(cellfun(@(c) ~isempty(c),valid_sessions(sum(session_groups(1:k))-session_groups(k)+1:sum(session_groups(1:k))))))
					%correlations for ROIs active across sessions within groups
					s_work.(char(roi_type(j))).session_cross(k).roi_pc_binary = s_work.(char(roi_type(j))).roi_pc_binary(:,sum(session_groups(1:k))-session_groups(k)+1-skip:sum(session_groups(1:k))-skip);
					tempsum = sum(s_work.(char(roi_type(j))).session_cross(k).roi_pc_binary,2);
					s_work.(char(roi_type(j))).session_cross(k).roi_lg_active = find(tempsum == session_groups(k));
					if(~isempty(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active) && ~isempty(s_work.(char(roi_type(j))).spatial(k).all))
						s_work.(char(roi_type(j))).session_cross(k).rate_map = NaN(size(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map,2),session_groups(k));
						s_work.(char(roi_type(j))).session_cross(k).rate_map_z = NaN(size(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map_z,2),session_groups(k));
						s_work.(char(roi_type(j))).session_cross(k).rate_map_n = NaN(size(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map_n,2),session_groups(k));
						s_work.(char(roi_type(j))).session_cross(k).check_id = strings;
						for x=1:session_groups(k)
							s_work.(char(roi_type(j))).session_cross(k).rate_map(:,:,x) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k))-session_groups(k)+x-skip).all.rate_map(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,:);
							s_work.(char(roi_type(j))).session_cross(k).rate_map_z(:,:,x) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k))-session_groups(k)+x-skip).all.rate_map_z(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,:);
							s_work.(char(roi_type(j))).session_cross(k).rate_map_n(:,:,x) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k))-session_groups(k)+x-skip).all.rate_map_n(s_work.(char(roi_type(j))).session_cross(k).roi_lg_active,:);
							s_work.(char(roi_type(j))).session_cross(k).check_id(x) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k))-session_groups(k)+x-skip).session;
						end
						s_work.(char(roi_type(j))).session_cross(k).comp_id = strings;
						s_work.(char(roi_type(j))).session_cross(k).TC_corr = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr = {};
						s_work.(char(roi_type(j))).session_cross(k).TC_corr_z = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr_z = {};
						s_work.(char(roi_type(j))).session_cross(k).TC_corr_n = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr_n = {};
						s_work.(char(roi_type(j))).session_cross(k).TC_corr_map = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr_map = {};
						s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_z = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_z = {};
						s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_n = {};
						s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_n = {};
						for p=1:session_groups(k)
							for q=p+1:session_groups(k)
								s_work.(char(roi_type(j))).session_cross(k).comp_id(size(s_work.(char(roi_type(j))).session_cross(k).comp_id,1)+1,1) = strcat(s_work.session_id{sum(session_groups(1:k-1))+p-skip,1},"_vs_",s_work.session_id{sum(session_groups(1:k-1))+q-skip,1});
								tempSUBmap = s_work.(char(roi_type(j))).session_cross(k).rate_map(:,:,[p q]);
								tempSUBmap_z = s_work.(char(roi_type(j))).session_cross(k).rate_map_z(:,:,[p q]);
								tempSUBmap_n = s_work.(char(roi_type(j))).session_cross(k).rate_map_n(:,:,[p q]);
								tempTCmap = permute(tempSUBmap,[2 3 1]);
								tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
								tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
								s_work.(char(roi_type(j))).session_cross(k).TC_corr{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,3),1);
								s_work.(char(roi_type(j))).session_cross(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map_z,3),1);
								s_work.(char(roi_type(j))).session_cross(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map_n,3),1);
								for x=1:size(tempTCmap,3)
									try
										tempTC = corrcoef(tempTCmap(:,:,x));
										tempTC_z = corrcoef(tempTCmap_z(:,:,x));
										tempTC_n = corrcoef(tempTCmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_cross(k).TC_corr{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr,1),1}(x,1) = tempTC(1,2);
										s_work.(char(roi_type(j))).session_cross(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
										s_work.(char(roi_type(j))).session_cross(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_cross(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1));
								s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1));
								s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,1));
								for x=1:size(tempSUBmap,1)
									for y=1:size(tempSUBmap,1)
										try
											tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
											tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
											tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
											s_work.(char(roi_type(j))).session_cross(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
											s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
											s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_cross(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
										end
									end
								end
								tempPVmap = permute(tempSUBmap,[1 3 2]);
								tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
								tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
								s_work.(char(roi_type(j))).session_cross(k).PV_corr{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2),1);
								s_work.(char(roi_type(j))).session_cross(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map_z,2),1);
								s_work.(char(roi_type(j))).session_cross(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map_n,2),1);
								for x=1:size(tempPVmap,3)
									try
										tempPV = corrcoef(tempPVmap(:,:,x));
										tempPV_z = corrcoef(tempPVmap_z(:,:,x));
										tempPV_n = corrcoef(tempPVmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_cross(k).PV_corr{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr,1),1}(x,1) = tempPV(1,2);
										s_work.(char(roi_type(j))).session_cross(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
										s_work.(char(roi_type(j))).session_cross(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_cross(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2));
								s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2));
								s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2),size(s_work.(char(roi_type(j))).session_cross(k).rate_map,2));
								for x=1:size(tempSUBmap,2)
									for y=1:size(tempSUBmap,2)
										try
											tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
											tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
											tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
											s_work.(char(roi_type(j))).session_cross(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
											s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
											s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_cross(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
										end
									end
								end
							end
						end
					end
					%correlations for ROIs active in pairwise sessions within groups
					s_work.(char(roi_type(j))).session_pairwise(k).comp_id = {};
					s_work.(char(roi_type(j))).session_pairwise(k).roi_pc_binary = {};
					s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr = {};
					s_work.(char(roi_type(j))).session_pairwise(k).fields_center = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n = {};
					s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_n = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_n = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_z = {};
					s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_n = {};
					s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_n = {};
					for p=1:session_groups(k)
						for q=p+1:session_groups(k)
							s_work.(char(roi_type(j))).session_pairwise(k).roi_pc_binary{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_pc_binary,1)+1,1} = s_work.(char(roi_type(j))).roi_pc_binary(:,[sum(session_groups(1:k-1))+p-skip sum(session_groups(1:k-1))+q-skip]);
							tempsum = sum(s_work.(char(roi_type(j))).session_pairwise(k).roi_pc_binary{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_pc_binary,1),1},2);
							if(~isempty(find(tempsum == 2)) && ~isempty(s_work.(char(roi_type(j))).spatial(k).all))
								s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1)+1,1} = find(tempsum == 2);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map,2),2);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map_z,2),2);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(k).all.rate_map_n,2),2);
								s_work.(char(roi_type(j))).session_pairwise(k).comp_id{size(s_work.(char(roi_type(j))).session_pairwise(k).comp_id,1)+1,1} = {strcat(s_work.session_id{sum(session_groups(1:k-1))+p-skip,1},"_vs_",s_work.session_id{sum(session_groups(1:k-1))+q-skip,1})};
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q-skip).all.rate_map(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map_z(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q-skip).all.rate_map_z(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map_n(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+q-skip).all.rate_map_n(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work.(char(roi_type(j))).session_pairwise(k).fields_center,1)+1,1} = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.fieldCenters(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_pairwise(k).roi_lg_active,1),1});
								s_work.(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work.(char(roi_type(j))).session_pairwise(k).fields_center,1),1} = cellfun(@(v)v(1),s_work.(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work.(char(roi_type(j))).session_pairwise(k).fields_center,1),1});
								[~,field_center_sorted_index_pair] = sort(s_work.(char(roi_type(j))).session_pairwise(k).fields_center{size(s_work.(char(roi_type(j))).session_pairwise(k).fields_center,1),1});
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(field_center_sorted_index_pair,:,2);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_z,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,2);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_sorted_n,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,2);
								tempSUBmap = s_work.(char(roi_type(j))).session_pairwise(k).rate_map{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map,1),1}(:,:,[1 2]);
								tempSUBmap_z = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_z,1),1}(:,:,[1 2]);
								tempSUBmap_n = s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).rate_map_n,1),1}(:,:,[1 2]);
								tempTCmap = permute(tempSUBmap,[2 3 1]);
								tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
								tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr,1)+1,1} = NaN(size(tempSUBmap,3),1);
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,3),1);
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,3),1);
								for x=1:size(tempTCmap,3)
									try
										tempTC = corrcoef(tempTCmap(:,:,x));
										tempTC_z = corrcoef(tempTCmap_z(:,:,x));
										tempTC_n = corrcoef(tempTCmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_pairwise(k).TC_corr{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr,1),1}(x,1) = tempTC(1,2);
										s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
										s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map,1)+1,1} = NaN(size(tempSUBmap,1),size(tempSUBmap,1));
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,1),size(tempSUBmap_z,1));
								s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,1),size(tempSUBmap_n,1));
								for x=1:size(tempSUBmap,1)
									for y=1:size(tempSUBmap,1)
										try
											tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
											tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
											tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
											s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
											s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
											s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
										end
									end
								end
								tempPVmap = permute(tempSUBmap,[1 3 2]);
								tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
								tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr,1)+1,1} = NaN(size(tempSUBmap,2),1);
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,2),1);
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,2),1);
								for x=1:size(tempPVmap,3)
									try
										tempPV = corrcoef(tempPVmap(:,:,x));
										tempPV_z = corrcoef(tempPVmap_z(:,:,x));
										tempPV_n = corrcoef(tempPVmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_pairwise(k).PV_corr{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr,1),1}(x,1) = tempPV(1,2);
										s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
										s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map,1)+1,1} = NaN(size(tempSUBmap,2),size(tempSUBmap,2));
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,2),size(tempSUBmap_z,2));
								s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,2),size(tempSUBmap_n,2));
								for x=1:size(tempSUBmap,2)
									for y=1:size(tempSUBmap,2)
										try
											tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
											tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
											tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
											s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
											s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
											s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_pairwise(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
										end
									end
								end
							end
						end
					end
					%correlations within group to first session as reference
					s_work.(char(roi_type(j))).session_ref(k).comp_id = {};
					s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary = {};
					s_work.(char(roi_type(j))).session_ref(k).roi_lg_active = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr = {};
					s_work.(char(roi_type(j))).session_ref(k).fields_center = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map_z = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr_z = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr_z = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_z = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map_n = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr_n = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr_n = {};
					s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_n = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr_map = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr_map = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_z = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_z = {};
					s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_n = {};
					s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_n = {};
					for p=1:session_groups(k)
						if(~isempty(ref(arrayfun(@(a) contains(s_work.session_id{sum(session_groups(1:k-1))+p-skip},a),ref))))
							ref_idx = p;
						end
					end
					for p=1:session_groups(k)
						if(p~=ref_idx)
							s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary{size(s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary,1)+1,1} = s_work.(char(roi_type(j))).roi_pc_binary(:,sum(session_groups(1:k-1))+ref_idx-skip);
							if(~isempty(find(s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary{size(s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary,1),1})) && ~isempty(s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all))
								s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1)+1,1} = find(s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary{size(s_work.(char(roi_type(j))).session_ref(k).roi_pc_binary,1),1});
								s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map,2),2);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map_z,2),2);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1)+1,1} = NaN(size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},1),size(s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map_n,2),2);
								s_work.(char(roi_type(j))).session_ref(k).comp_id{size(s_work.(char(roi_type(j))).session_ref(k).comp_id,1)+1,1} = {strcat(s_work.session_id{sum(session_groups(1:k-1))+ref_idx-skip,1},"_vs_",s_work.session_id{sum(session_groups(1:k-1))+p-skip,1})};
								s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map_z(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map_z(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,1) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.rate_map_n(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,2) = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+p-skip).all.rate_map_n(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1},:);
								s_work.(char(roi_type(j))).session_ref(k).fields_center{size(s_work.(char(roi_type(j))).session_ref(k).fields_center,1)+1,1} = s_work.(char(roi_type(j))).spatial(sum(session_groups(1:k-1))+ref_idx-skip).all.fieldCenters(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active{size(s_work.(char(roi_type(j))).session_ref(k).roi_lg_active,1),1});
								s_work.(char(roi_type(j))).session_ref(k).fields_center{size(s_work.(char(roi_type(j))).session_ref(k).fields_center,1),1} = cellfun(@(v)v(1),s_work.(char(roi_type(j))).session_ref(k).fields_center{size(s_work.(char(roi_type(j))).session_ref(k).fields_center,1),1});
								[~,field_center_sorted_index_pair] = sort(s_work.(char(roi_type(j))).session_ref(k).fields_center{size(s_work.(char(roi_type(j))).session_ref(k).fields_center,1),1});
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1),1}(field_center_sorted_index_pair,:,2);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_z,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_z,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(field_center_sorted_index_pair,:,2);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_n,1)+1,1}(:,:,1) = s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,1);
								s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_sorted_n,1),1}(:,:,2) = s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(field_center_sorted_index_pair,:,2);
								tempSUBmap = s_work.(char(roi_type(j))).session_ref(k).rate_map{size(s_work.(char(roi_type(j))).session_ref(k).rate_map,1),1}(:,:,[1 2]);
								tempSUBmap_z = s_work.(char(roi_type(j))).session_ref(k).rate_map_z{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_z,1),1}(:,:,[1 2]);
								tempSUBmap_n = s_work.(char(roi_type(j))).session_ref(k).rate_map_n{size(s_work.(char(roi_type(j))).session_ref(k).rate_map_n,1),1}(:,:,[1 2]);
								tempTCmap = permute(tempSUBmap,[2 3 1]);
								tempTCmap_z = permute(tempSUBmap_z,[2 3 1]);
								tempTCmap_n = permute(tempSUBmap_n,[2 3 1]);
								s_work.(char(roi_type(j))).session_ref(k).TC_corr{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr,1)+1,1} = NaN(size(tempSUBmap,3),1);
								s_work.(char(roi_type(j))).session_ref(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,3),1);
								s_work.(char(roi_type(j))).session_ref(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,3),1);
								for x=1:size(tempTCmap,3)
									try
										tempTC = corrcoef(tempTCmap(:,:,x));
										tempTC_z = corrcoef(tempTCmap_z(:,:,x));
										tempTC_n = corrcoef(tempTCmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_ref(k).TC_corr{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr,1),1}(x,1) = tempTC(1,2);
										s_work.(char(roi_type(j))).session_ref(k).TC_corr_z{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_z,1),1}(x,1) = tempTC_z(1,2);
										s_work.(char(roi_type(j))).session_ref(k).TC_corr_n{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_n,1),1}(x,1) = tempTC_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_ref(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map,1)+1,1} = NaN(size(tempSUBmap,1),size(tempSUBmap,1));
								s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,1),size(tempSUBmap_z,1));
								s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,1),size(tempSUBmap_n,1));
								for x=1:size(tempSUBmap,1)
									for y=1:size(tempSUBmap,1)
										try
											tempTCm = corrcoef(tempSUBmap(x,:,1),tempSUBmap(y,:,2));
											tempTCm_z = corrcoef(tempSUBmap_z(x,:,1),tempSUBmap_z(y,:,2));
											tempTCm_n = corrcoef(tempSUBmap_n(x,:,1),tempSUBmap_n(y,:,2));
											s_work.(char(roi_type(j))).session_ref(k).TC_corr_map{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map,1),1}(x,y) = tempTCm(1,2);
											s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_z{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_z,1),1}(x,y) = tempTCm_z(1,2);
											s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_n{size(s_work.(char(roi_type(j))).session_ref(k).TC_corr_map_n,1),1}(x,y) = tempTCm_n(1,2);
										end
									end
								end
								tempPVmap = permute(tempSUBmap,[1 3 2]);
								tempPVmap_z = permute(tempSUBmap_z,[1 3 2]);
								tempPVmap_n = permute(tempSUBmap_n,[1 3 2]);
								s_work.(char(roi_type(j))).session_ref(k).PV_corr{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr,1)+1,1} = NaN(size(tempSUBmap,2),1);
								s_work.(char(roi_type(j))).session_ref(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_z,1)+1,1} = NaN(size(tempSUBmap_z,2),1);
								s_work.(char(roi_type(j))).session_ref(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_n,1)+1,1} = NaN(size(tempSUBmap_n,2),1);
								for x=1:size(tempPVmap,3)
									try
										tempPV = corrcoef(tempPVmap(:,:,x));
										tempPV_z = corrcoef(tempPVmap_z(:,:,x));
										tempPV_n = corrcoef(tempPVmap_n(:,:,x));
										s_work.(char(roi_type(j))).session_ref(k).PV_corr{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr,1),1}(x,1) = tempPV(1,2);
										s_work.(char(roi_type(j))).session_ref(k).PV_corr_z{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_z,1),1}(x,1) = tempPV_z(1,2);
										s_work.(char(roi_type(j))).session_ref(k).PV_corr_n{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_n,1),1}(x,1) = tempPV_n(1,2);
									end
								end
								s_work.(char(roi_type(j))).session_ref(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map,1)+1,1} = NaN(size(tempSUBmap,2),size(tempSUBmap,2));
								s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_z,1)+1,1} = NaN(size(tempSUBmap_z,2),size(tempSUBmap_z,2));
								s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_n,1)+1,1} = NaN(size(tempSUBmap_n,2),size(tempSUBmap_n,2));
								for x=1:size(tempSUBmap,2)
									for y=1:size(tempSUBmap,2)
										try
											tempPVm = corrcoef(tempSUBmap(:,x,1),tempSUBmap(:,y,2));
											tempPVm_z = corrcoef(tempSUBmap_z(:,x,1),tempSUBmap_z(:,y,2));
											tempPVm_n = corrcoef(tempSUBmap_n(:,x,1),tempSUBmap_n(:,y,2));
											s_work.(char(roi_type(j))).session_ref(k).PV_corr_map{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map,1),1}(x,y) = tempPVm(1,2);
											s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_z{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_z,1),1}(x,y) = tempPVm_z(1,2);
											s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_n{size(s_work.(char(roi_type(j))).session_ref(k).PV_corr_map_n,1),1}(x,y) = tempPVm_n(1,2);
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
    fprintf('\ndata processed!\n');
    s_coding = s_work;
    fprintf('\nsaving output...\n');
    save(fullfile(root_path,mouse_id,input_folder,'spatial_coding.mat'),'s_coding','-v7.3');
    fprintf('\noutput saved!\n');
    fprintf('\nspatial coding analyzed!!!\n');
end