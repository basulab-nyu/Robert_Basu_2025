function [output] = basic_decoding_2_folder(analysisFile1, analysisFile2, behaviorFile1, behaviorFile2, SMOOTHING)
	clear all;
	addpath(genpath('code'));
    SMOOTHING = 2;
	DS_FACTOR = 1;
	MAX_POSITION = 200; 
	RUNNING_THRESHOLD = 2;
	PERIOD = 4;
	input = '/gpfs/data/basulab/VR/cohort_7/m33b/spatial_tuning_fullsample/spatial_tuning_fullsample_light.mat';
	output = '/gpfs/data/basulab/VR/cohort_7/m33b/decoding2.mat';
	load(input);
	% matchlist = ...
	% {'240325'+wildcardPattern+'fam1','240325'+wildcardPattern+'int','240325'+wildcardPattern+'fam2','240325'+wildcardPattern+'nov',...
    % '240326'+wildcardPattern+'fam1','240326'+wildcardPattern+'int','240326'+wildcardPattern+'fam2','240326'+wildcardPattern+'nov',...
    % '240327'+wildcardPattern+'fam1','240327'+wildcardPattern+'int','240327'+wildcardPattern+'fam2','240327'+wildcardPattern+'nov',...
    % '240328'+wildcardPattern+'fam1','240328'+wildcardPattern+'int','240328'+wildcardPattern+'fam2','240328'+wildcardPattern+'nov',...
    % '240329'+wildcardPattern+'fam1','240329'+wildcardPattern+'int','240329'+wildcardPattern+'fam2','240329'+wildcardPattern+'nov'};
	% matchlist = ...
	% {'240520'+wildcardPattern+'fam1','240520'+wildcardPattern+'int','240520'+wildcardPattern+'fam2','240520'+wildcardPattern+'nov',...
    % '240521'+wildcardPattern+'fam1','240521'+wildcardPattern+'int','240521'+wildcardPattern+'fam2','240521'+wildcardPattern+'nov',...
    % '240522'+wildcardPattern+'fam1','240522'+wildcardPattern+'int','240522'+wildcardPattern+'fam2','240522'+wildcardPattern+'nov',...
    % '240523'+wildcardPattern+'fam1','240523'+wildcardPattern+'int','240523'+wildcardPattern+'fam2','240523'+wildcardPattern+'nov',...
	% '240524'+wildcardPattern+'fam1','240524'+wildcardPattern+'int','240524'+wildcardPattern+'fam2','240524'+wildcardPattern+'nov',...
	% '240525'+wildcardPattern+'fam1','240525'+wildcardPattern+'int','240525'+wildcardPattern+'fam2','240525'+wildcardPattern+'nov',...
	% '240526'+wildcardPattern+'fam1','240526'+wildcardPattern+'int','240526'+wildcardPattern+'fam2','240526'+wildcardPattern+'nov',...
    % '240527'+wildcardPattern+'fam1','240527'+wildcardPattern+'int','240527'+wildcardPattern+'fam2','240527'+wildcardPattern+'nov'};
	% matchlist = ...
	% {'240719'+wildcardPattern+'fam1','240719'+wildcardPattern+'int','240719'+wildcardPattern+'fam2','240719'+wildcardPattern+'nov',...
    % '240720'+wildcardPattern+'fam1','240720'+wildcardPattern+'int','240720'+wildcardPattern+'fam2','240720'+wildcardPattern+'nov',...
    % '240721'+wildcardPattern+'fam1','240721'+wildcardPattern+'int','240721'+wildcardPattern+'fam2','240721'+wildcardPattern+'nov',...
    % '240722'+wildcardPattern+'fam1','240722'+wildcardPattern+'int','240722'+wildcardPattern+'fam2','240722'+wildcardPattern+'nov',...
	% '240723'+wildcardPattern+'fam1','240723'+wildcardPattern+'int','240723'+wildcardPattern+'fam2','240723'+wildcardPattern+'nov',...
	% '240724'+wildcardPattern+'fam1','240724'+wildcardPattern+'int','240724'+wildcardPattern+'fam2','240724'+wildcardPattern+'nov',...
	% '240725'+wildcardPattern+'fam1','240725'+wildcardPattern+'int','240725'+wildcardPattern+'fam2','240725'+wildcardPattern+'nov',...
    % '240726'+wildcardPattern+'fam1','240726'+wildcardPattern+'int','240726'+wildcardPattern+'fam2','240726'+wildcardPattern+'nov'};
	% matchlist = ...
	% {'240817'+wildcardPattern+'fam1','240817'+wildcardPattern+'int','240817'+wildcardPattern+'fam2','240817'+wildcardPattern+'nov',...
    % '240818'+wildcardPattern+'fam1','240818'+wildcardPattern+'int','240818'+wildcardPattern+'fam2','240818'+wildcardPattern+'nov',...
    % '240819'+wildcardPattern+'fam1','240819'+wildcardPattern+'int','240819'+wildcardPattern+'fam2','240819'+wildcardPattern+'nov',...
    % '240820'+wildcardPattern+'fam1','240820'+wildcardPattern+'int','240820'+wildcardPattern+'fam2','240820'+wildcardPattern+'nov',...
	% '240821'+wildcardPattern+'fam1','240821'+wildcardPattern+'int','240821'+wildcardPattern+'fam2','240821'+wildcardPattern+'nov',...
	% '240822'+wildcardPattern+'fam1','240822'+wildcardPattern+'int','240822'+wildcardPattern+'fam2','240822'+wildcardPattern+'nov',...
	% '240823'+wildcardPattern+'fam1','240823'+wildcardPattern+'int','240823'+wildcardPattern+'fam2','240823'+wildcardPattern+'nov',...
    % '240824'+wildcardPattern+'fam1','240824'+wildcardPattern+'int','240824'+wildcardPattern+'fam2','240824'+wildcardPattern+'nov'};
	% matchlist = ...
	% {'240727'+wildcardPattern+'_A1_','240727'+wildcardPattern+'_Aa_','240727'+wildcardPattern+'_A2_','240727'+wildcardPattern+'_B_',...
    % '240728'+wildcardPattern+'_A1_','240728'+wildcardPattern+'_Aa_','240728'+wildcardPattern+'_A2_','240728'+wildcardPattern+'_B_',...
    % '240729'+wildcardPattern+'_A1_','240729'+wildcardPattern+'_Aa_','240729'+wildcardPattern+'_A2_','240729'+wildcardPattern+'_B_',...
    % '240730'+wildcardPattern+'_A1_','240730'+wildcardPattern+'_Aa_','240730'+wildcardPattern+'_A2_','240730'+wildcardPattern+'_B_',...
	% '240731'+wildcardPattern+'_A1_','240731'+wildcardPattern+'_Aa_','240731'+wildcardPattern+'_A2_','240731'+wildcardPattern+'_B_',...
	% '240801'+wildcardPattern+'_A1_','240801'+wildcardPattern+'_Aa_','240801'+wildcardPattern+'_A2_','240801'+wildcardPattern+'_B_',...
	% '240802'+wildcardPattern+'_A1_','240802'+wildcardPattern+'_Aa_','240802'+wildcardPattern+'_A2_','240802'+wildcardPattern+'_B_',...
    % '240803'+wildcardPattern+'_A1_','240803'+wildcardPattern+'_Aa_','240803'+wildcardPattern+'_A2_','240803'+wildcardPattern+'_B_'};
	matchlist = ...
	{'240825'+wildcardPattern+'_A1_','240825'+wildcardPattern+'_Aa_','240825'+wildcardPattern+'_A2_','240825'+wildcardPattern+'_B_',...
    '240826'+wildcardPattern+'_A1_','240826'+wildcardPattern+'_Aa_','240826'+wildcardPattern+'_A2_','240826'+wildcardPattern+'_B_',...
    '240827'+wildcardPattern+'_A1_','240827'+wildcardPattern+'_Aa_','240827'+wildcardPattern+'_A2_','240827'+wildcardPattern+'_B_',...
    '240828'+wildcardPattern+'_A1_','240828'+wildcardPattern+'_Aa_','240828'+wildcardPattern+'_A2_','240828'+wildcardPattern+'_B_',...
	'240829'+wildcardPattern+'_A1_','240829'+wildcardPattern+'_Aa_','240829'+wildcardPattern+'_A2_','240829'+wildcardPattern+'_B_',...
	'240830'+wildcardPattern+'_A1_','240830'+wildcardPattern+'_Aa_','240830'+wildcardPattern+'_A2_','240830'+wildcardPattern+'_B_',...
	'240831'+wildcardPattern+'_A1_','240831'+wildcardPattern+'_Aa_','240831'+wildcardPattern+'_A2_','240831'+wildcardPattern+'_B_',...
    '240901'+wildcardPattern+'_A1_','240901'+wildcardPattern+'_Aa_','240901'+wildcardPattern+'_A2_','240901'+wildcardPattern+'_B_'};
	s_output = struct;
	i=1;
	while(~any(cellfun(@(c) contains(s_light.session_id{i},c),matchlist)))
		i=i+1;
	end
	x=1;
	for j=i:PERIOD:i+size(matchlist,2)-1
		for k=j+1:j+PERIOD-1
			x=x+1;
			try
				A1 = s_light.s.spatial(j).all.rate_map;
				A2 = s_light.s.spatial(k).all.rate_map;
				B1 = s_light.s.spatial(j).split.roi_rate;
				B2 = s_light.s.spatial(k).split.roi_rate;
				smoothed_roi_rate1 = NaN(size(B1));
				smoothed_roi_rate2 = NaN(size(B2));
				N_ROIs = size(smoothed_roi_rate1,1);
				for i_roi = 1:N_ROIs
					smoothed_roi_rate1(i_roi,:) = gaussian_smooth_1d(B1(i_roi,:), SMOOTHING);
					smoothed_roi_rate2(i_roi,:) = gaussian_smooth_1d(B2(i_roi,:), SMOOTHING);
				end
				B1 = smoothed_roi_rate1;
				B2 = smoothed_roi_rate2;
				N_BINS = size(A1,2);
				positionBins = center(linspace(0,MAX_POSITION,N_BINS+1));
				temp1 = corr(A1, B2);
				[maxVal1, positionBin1] = max(temp1);
				predictedPosition_Folder2_from_Folder1 = positionBins(positionBin1);
				predictedPosition_Folder2_from_Folder1(isnan(maxVal1)) = NaN;
				temp2 = corr(A2, B1);
				[maxVal2, positionBin2] = max(temp2);
				predictedPosition_Folder1_from_Folder2 = positionBins(positionBin2);
				predictedPosition_Folder1_from_Folder2(isnan(maxVal2)) = NaN;
				Behavior1 = load_and_fix_behavior(s_light.behavior_path{j}, DS_FACTOR);
				Behavior2 = load_and_fix_behavior(s_light.behavior_path{k}, DS_FACTOR);
				L1 = length(positionBin1);
				ds_pos1 = Behavior1.ds_pos(1:L1);
				running1 = Behavior1.speed(1:L1)>RUNNING_THRESHOLD;
				L2 = length(positionBin2);
				ds_pos2 = Behavior2.ds_pos(1:L2);
				running2 = Behavior2.speed(1:L2)>RUNNING_THRESHOLD;
				s_output.cross(x).real_pos1 = ds_pos1;
				s_output.cross(x).real_pos2 = ds_pos2;
				s_output.cross(x).running1 = running1;
				s_output.cross(x).running2 = running2;
				s_output.cross(x).decoded_pos2 = predictedPosition_Folder2_from_Folder1(:);
				s_output.cross(x).decoded_pos1 = predictedPosition_Folder1_from_Folder2(:);
				s_output.cross(x).comp = strcat(s_light.session_id{j},'_vs_',s_light.session_id{k});
			end
		end
	end
	x=1;
	for j=i:i+size(matchlist,2)-1-PERIOD
		k=j+PERIOD;
		x=x+1;
		try
			A1 = s_light.s.spatial(j).all.rate_map;
			A2 = s_light.s.spatial(k).all.rate_map;
			B1 = s_light.s.spatial(j).split.roi_rate;
			B2 = s_light.s.spatial(k).split.roi_rate;
			smoothed_roi_rate1 = NaN(size(B1));
			smoothed_roi_rate2 = NaN(size(B2));
			N_ROIs = size(smoothed_roi_rate1,1);
			for i_roi = 1:N_ROIs
				smoothed_roi_rate1(i_roi,:) = gaussian_smooth_1d(B1(i_roi,:), SMOOTHING);
				smoothed_roi_rate2(i_roi,:) = gaussian_smooth_1d(B2(i_roi,:), SMOOTHING);
			end
			B1 = smoothed_roi_rate1;
			B2 = smoothed_roi_rate2;
			N_BINS = size(A1,2);
			positionBins = center(linspace(0,MAX_POSITION,N_BINS+1));
			temp1 = corr(A1, B2);
			[maxVal1, positionBin1] = max(temp1);
			predictedPosition_Folder2_from_Folder1 = positionBins(positionBin1);
			predictedPosition_Folder2_from_Folder1(isnan(maxVal1)) = NaN;
			temp2 = corr(A2, B1);
			[maxVal2, positionBin2] = max(temp2);
			predictedPosition_Folder1_from_Folder2 = positionBins(positionBin2);
			predictedPosition_Folder1_from_Folder2(isnan(maxVal2)) = NaN;
			Behavior1 = load_and_fix_behavior(s_light.behavior_path{j}, DS_FACTOR);
			Behavior2 = load_and_fix_behavior(s_light.behavior_path{k}, DS_FACTOR);
			L1 = length(positionBin1);
			ds_pos1 = Behavior1.ds_pos(1:L1);
			running1 = Behavior1.speed(1:L1)>RUNNING_THRESHOLD;
			L2 = length(positionBin2);
			ds_pos2 = Behavior2.ds_pos(1:L2);
			running2 = Behavior2.speed(1:L2)>RUNNING_THRESHOLD;
			s_output.pair(x).real_pos1 = ds_pos1;
			s_output.pair(x).real_pos2 = ds_pos2;
			s_output.pair(x).running1 = running1;
			s_output.pair(x).running2 = running2;
			s_output.pair(x).decoded_pos2 = predictedPosition_Folder2_from_Folder1(:);
			s_output.pair(x).decoded_pos1 = predictedPosition_Folder1_from_Folder2(:);
			s_output.pair(x).comp = strcat(s_light.session_id{j},'_vs_',s_light.session_id{k});
		end
	end
	x=1;
	c=0;
	for j=i+size(matchlist,2)-PERIOD:i+size(matchlist,2)-1
		c=c+1;
		for k=i+c-1:PERIOD:i+size(matchlist,2)-1-PERIOD
			x=x+1;
			try
				A1 = s_light.s.spatial(j).all.rate_map;
				A2 = s_light.s.spatial(k).all.rate_map;
				B1 = s_light.s.spatial(j).split.roi_rate;
				B2 = s_light.s.spatial(k).split.roi_rate;
				smoothed_roi_rate1 = NaN(size(B1));
				smoothed_roi_rate2 = NaN(size(B2));
				N_ROIs = size(smoothed_roi_rate1,1);
				for i_roi = 1:N_ROIs
					smoothed_roi_rate1(i_roi,:) = gaussian_smooth_1d(B1(i_roi,:), SMOOTHING);
					smoothed_roi_rate2(i_roi,:) = gaussian_smooth_1d(B2(i_roi,:), SMOOTHING);
				end
				B1 = smoothed_roi_rate1;
				B2 = smoothed_roi_rate2;
				N_BINS = size(A1,2);
				positionBins = center(linspace(0,MAX_POSITION,N_BINS+1));
				temp1 = corr(A1, B2);
				[maxVal1, positionBin1] = max(temp1);
				predictedPosition_Folder2_from_Folder1 = positionBins(positionBin1);
				predictedPosition_Folder2_from_Folder1(isnan(maxVal1)) = NaN;
				temp2 = corr(A2, B1);
				[maxVal2, positionBin2] = max(temp2);
				predictedPosition_Folder1_from_Folder2 = positionBins(positionBin2);
				predictedPosition_Folder1_from_Folder2(isnan(maxVal2)) = NaN;
				Behavior1 = load_and_fix_behavior(s_light.behavior_path{j}, DS_FACTOR);
				Behavior2 = load_and_fix_behavior(s_light.behavior_path{k}, DS_FACTOR);
				L1 = length(positionBin1);
				ds_pos1 = Behavior1.ds_pos(1:L1);
				running1 = Behavior1.speed(1:L1)>RUNNING_THRESHOLD;
				L2 = length(positionBin2);
				ds_pos2 = Behavior2.ds_pos(1:L2);
				running2 = Behavior2.speed(1:L2)>RUNNING_THRESHOLD;
				s_output.ref(x).real_pos1 = ds_pos1;
				s_output.ref(x).real_pos2 = ds_pos2;
				s_output.ref(x).running1 = running1;
				s_output.ref(x).running2 = running2;
				s_output.ref(x).decoded_pos2 = predictedPosition_Folder2_from_Folder1(:);
				s_output.ref(x).decoded_pos1 = predictedPosition_Folder1_from_Folder2(:);
				s_output.ref(x).comp = strcat(s_light.session_id{j},'_vs_',s_light.session_id{k});
			end
		end
	end
	save(output,'s_output','-v7.3');
end


function [Behavior, Imaging_Time] = load_and_fix_behavior(file, DS_FACTOR)
    % [Behavior, Imaging_Time] = load_and_fix_behavior(file, DS_FACTOR)
    load(file,'Behavior','Imaging_Time');
    Behavior = fix_behavior(Behavior);
    pos = Behavior.position;    
    t = Imaging_Time;
    t = t(floor(DS_FACTOR/2)+1:DS_FACTOR:end);    
    idx = nearestpoint(t, Behavior.time);
    ds_pos = pos(idx);
    ds_pos = mod(ds_pos,max(ds_pos));
    speed = Behavior.speed(idx);
    
    Behavior.ds_pos = ds_pos;
    Behavior.speed = speed;    
end

function [Behavior] = fix_behavior(Behavior)
    % [Behavior] = fix_behavior(Behavior)
    jumps = diff(Behavior.position)<-2;
    jumpPos = Behavior.position(jumps);
    maxPos = max(jumpPos(jumpPos<200));
    position = mod(Behavior.position,maxPos);
    jumps = find(diff(position)<-2);
    
    lap = cell(1,length(jumps)-1);
    for i_lap = 1:length(jumps)-1
        lap{i_lap} = [Behavior.time(jumps(i_lap)+1) Behavior.time(jumps(i_lap+1))];        
    end
    Behavior.position = position;
    Behavior.lap = lap;
    
    
    pos = Behavior.position;
    laps = nearestpoint(cellfun(@(x) x(1), Behavior.lap),Behavior.time);
    medMax = median(pos(laps(2:end)-1));
    pos(1:laps(1)-1) = medMax + pos(1:laps(1)-1) - pos(laps(1)-1);
    Behavior.position = pos;
    
    speed = diff(Behavior.cumulativeposition)./diff(Behavior.time);
    fs = 1/nanmedian(diff(Behavior.time));
    speed = gaussian_smooth_1d(speed,fs*3/10);
    Behavior.speed = [0; speed(:)];
end


function [sm_data] = gaussian_smooth_1d(data,sig,windur)

    %1d gaussian smoothing function
    %inputs: 
    %   data: vector to be smoothed
    %   sig: sigma of gaussian kernel
    %   windur: number of sigma to extend kernel in either direction
    %outputs:
    %   sm_data: smoothed data
    
    if nargin > 2
        kern_length = windur;
    else
        kern_length = 3; %default
    end
    
    if size(data,1) > size(data,2) 
        data = data';
    end
    
    if(sig<=0)
        sm_data = data;
        return;
    end
    kern_grid = [-ceil(kern_length*sig):ceil(kern_length*sig)];
    gauss_kern = exp(-(kern_grid).^2/(2*sig^2));
    gauss_kern = gauss_kern/sum(gauss_kern); %normalize to unit area
    kern_size = length(gauss_kern);
    
    if kern_size >= length(data)
        disp('Error data not long enough for smoothing kernel')
        return
    end
    
    sm_data = conv(data,gauss_kern);
    
    %clip convolution artifact
    sm_data(end-(kern_size-1)/2+1:end) = [];
    sm_data(1:(kern_size-1)/2) = [];
    
    %find all points within a half kernel length of an edge
    boundary_points = 1:ceil(kern_length*sig);
    
    half_kern_length = ceil(kern_length*sig)+1;
    
    for i = 1:length(boundary_points)
       
        rescaled_kern = gauss_kern(half_kern_length-i+1:end);
        rescaled_kern = rescaled_kern/sum(rescaled_kern);
        
        sm_data(i) = data(1:half_kern_length-1+i)*rescaled_kern';
        sm_data(end-i+1) = data(end-half_kern_length-i+2:end)*flipud(rescaled_kern');
    
    end
end

function [centers] = center(edges)
    centers = (edges(1:end-1)+edges(2:end))/2;
end