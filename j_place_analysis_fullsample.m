function [output0,outputOptimal,outputHalves,run_epochs,rest_epochs] = j_place_analysis_fullsample(binaryEvents, behavior_file)

%     THR1 = 2.3;
%     THR2 = 0.28;
% 
%     DETREND_FRAMES = 45;
%     tif_files = jdir(thisFolder,'*Tsub*.tif');
%     tif_file1 = fullfile(thisFolder,tif_files(1).name);
% %     roi_file = fullfile(thisFolder,'RoiSet_Auto10.zip');
%     DNMF_file = fullfile(thisFolder,'DNMF_Out_X6.mat');
%     behavior_file = fullfile(thisFolder,'Behavior.mat');
%     Y = bigread2(tif_file1);
%     Y = double(Y);
%     Y = j_detrend2b(Y,DETREND_FRAMES,3);
%     Y(isnan(Y) | isinf(Y)) = 0;
%     zy = zscore(Y,[],3);    
%     
%     load OPT_SKEW6 OPT_SKEW;
%     
%     A = load(DNMF_file);
%     load(classFile,'class');
%        
%     THIS1 = A.Cs';
%     temp = imerode(THIS1,ones([DETREND_FRAMES,1]));
%     THIS1 = zscore(THIS1-temp)';
%     skew = skewness(THIS1,[],2);
%     A.Cs = THIS1;
%     A.skew = skew;
%     
%     valid = A.skew>OPT_SKEW & (strcmp(class(:),'a') | strcmp(class(:),'s') | strcmp(class(:),'b'));
%     A.Cs = A.Cs(valid,:);
%     A.cROIs = A.cROIs(:,valid);
%     A.coherence = A.coherence(valid);
%     A.skew = A.skew(valid);
%     A.sz = A.sz(valid);
%     class = class(valid);
%     
%     isApic = strcmp(class,'a');
%     isSoma = strcmp(class,'s');
%     isBasal = strcmp(class,'b');
%     
%     CORR_THR = 0.8;
%     groups_apic = makeGroups(A.Cs(isApic,:)', CORR_THR);
%     groups_soma = makeGroups(A.Cs(isSoma,:)', CORR_THR);
%     groups_basal = makeGroups(A.Cs(isBasal,:)', CORR_THR);
%     
% %     cROI = reshape(A.ROIs,512*512,[]);
%     
%     SZ = [size(Y,1) size(Y,2)];
%     
%     zCCC = corrTrace2(zy, A.cROIs, 3);
    
    B = load(behavior_file);

%     THIS1 = A.Cs';
%     temp = imerode(THIS1,ones([DETREND_FRAMES,1]));
%     THIS1 = zscore(THIS1-temp)';
    A.Cs = binaryEvents;

    
    

    %% Correct behavior and downsample to imaging rate
    pos = B.Behavior.position;
	lapstart = nearestpoint(cellfun(@(x) x(1), B.Behavior.lap),B.Behavior.time);
	lapstop = nearestpoint(cellfun(@(x) x(2), B.Behavior.lap),B.Behavior.time);
	posn = pos;
	for i=1:size(lapstart,2)
		posn(lapstart(i):lapstop(i)) = 200*pos(lapstart(i):lapstop(i))/(pos(lapstop(i))-pos(lapstart(i)));
	end
	lap_length_avg = mean(pos(lapstop)-pos(lapstart),'omitnan');
	scale_factor = 200/lap_length_avg;
	posn(1:lapstart(1)-1) = scale_factor*posn(1:lapstart(1)-1);
	first_lap_delta = 200-posn(lapstart(1)-1);
	posn(1:lapstart(1)-1) = posn(1:lapstart(1)-1)+first_lap_delta;
	posn(lapstop(end)+1:end) = scale_factor*posn(lapstop(end)+1:end);
	pos = posn;
	
	laps = nearestpoint(cellfun(@(x) x(1), B.Behavior.lap),B.Behavior.time);
    medMax = median(pos(laps(2:end)-1));
    pos(1:laps(1)-1) = medMax + pos(1:laps(1)-1) - pos(laps(1)-1);

    t = B.Imaging_Time;
    %t = t(11:20:end);
    t = t(1:size(A.Cs,2));
    idx = nearestpoint(t, B.Behavior.time);
    ds_pos = pos(idx);
    ds_pos = mod(ds_pos,max(ds_pos));
    ds_cumpos = B.Behavior.cumulativeposition(idx);
    speed = [0 gaussian_smooth_1d(diff(ds_cumpos)./diff(t'),1)]';
    edges = [0 cellfun(@(x) x(1), B.Behavior.lap), max(t)+1];
    [~,lapNum] = histc(t,edges);
    dt = nanmedian(diff(t));


    %%
    DT = 1/30;
    METHOD = @(x,y) fp_detect(x, DT, y);
    nROI = size(A.Cs,1);
    event_rate = NaN(1,nROI);
    nEvents = NaN(1,nROI);
    valid = speed>2;
    run_epochs = speed>2;
    rest_epochs = speed<=2;
    total_time_running = dt*sum(valid);
    total_time_resting = dt*sum(rest_epochs);
    nbins = 40;
    all_rate_maps = NaN(nROI,nbins);
    all_rate_maps_weighted = NaN(nROI,nbins);
    occ = histc(ds_pos(valid),linspace(0,200,nbins+1))*dt;
    occ = occ(1:nbins);
    occ = gaussian_smooth_1d_circ(occ,1);
    event_std = NaN(1,nROI);
    event_std_weighted = NaN(1,nROI);
    alpha = center(linspace(0,2*pi,41))';
    info = NaN(1,nROI);
    info_weighted = NaN(1,nROI);
    shifts = -250:250;
    place_cell_stats = repmat(struct('rate_map',[],'rate_map_weighted',[],'event_std',[],'event_std_weighted',[],'info',[],'info_weighted',[]),nROI,length(shifts));

    min_shift = ceil(5/dt);
    max_shift = ceil(sum(speed>2)/2);
    run_indices = find(speed>2);    
    fprintf('\ncomputing tuning:\n');
    msg = 0;
    for i_roi = 1:size(A.Cs,1)
        fprintf(1,repmat('\b',[1,msg]));
        msg = fprintf(1,'ROI %d/%d',i_roi,size(A.Cs,1));
%         if(mod(i_roi,20)==1)
%             fprintf('\n');
%         end
%         fprintf('%d ',i_roi);

        
%         [startStop, peakIndex, amp, width] = METHOD(A.Cs(i_roi,:),THR1);
%         fitValues = zCCC(i_roi,peakIndex);            
%         valid = fitValues>THR2;
%         peak = peakIndex(valid);
        
        peak = find(A.Cs(i_roi,:)>0);
%         [start, stop, peak] = detectEventsRaw(A.Cs(i_roi,:),2,2);
    %     keep = speed(peak)'>2 & E(i_roi,peak)>0.75;
        keep = speed(peak)'>2;
        nEvents(i_roi) = sum(keep);
        event_rate(i_roi) = sum(keep)/total_time_running;
        if(sum(keep)==0)
            for i_shift = 1:length(shifts)
                place_cell_stats(i_roi,i_shift).rate_map = zeros(1,40);
                place_cell_stats(i_roi,i_shift).rate_map_weighted = zeros(1,40);
                place_cell_stats(i_roi,i_shift).event_std = NaN;
                place_cell_stats(i_roi,i_shift).event_std_weighted = NaN;
                place_cell_stats(i_roi,i_shift).info = NaN;
                place_cell_stats(i_roi,i_shift).info_weighted = NaN;
            end
            continue;
        end

        idx = nearestpoint(peak(keep),run_indices);

        for i_shift = 1:length(shifts)
            idx2 = mod(idx+shifts(i_shift)-1,length(run_indices))+1;
            peak2 = run_indices(idx2);

            peakHeight = A.Cs(i_roi,peak2);
            event_pos = ds_pos(peak2);
		%	if(event_pos>200)
        %        event_pos = 200;
        %    end
            place_cell_stats(i_roi,i_shift) = place_cell_wrapper(event_pos, occ, peakHeight, linspace(0,200,41));
        end

    end
    fprintf('\n');
    info = NaN(size(place_cell_stats));
    valid = arrayfun(@(x) ~isempty(x.info), place_cell_stats);
    info(valid) = arrayfun(@(x) x.info, place_cell_stats(valid));

    [peakInfo,peakIdx] = max(info(:,abs(shifts)*dt<=5),[],2);
    peakIdx = peakIdx+jzeroCrossing(shifts*dt+5,1);
    nullInfo = quantile(info(:,abs(shifts)*dt>5),0.99,2);

    normalizedInfo0 = info(:,shifts==0)./nullInfo;
    normalizedInfoOptimal = peakInfo./nullInfo;

    %%
    run_indices = find(speed>2);    
    nEvents_half = NaN(size(A.Cs,1),2);
    event_rate_half = NaN(size(A.Cs,1),2);
    place_cell_stats_half = repmat(struct('rate_map',[],'rate_map_weighted',[],'event_std',[],'event_std_weighted',[],'info',[],'info_weighted',[]),nROI,2);
    valid_half = false(length(t),2);
    roi_rate = zeros(nROI,length(t));
    for KEEP = 1:2
        if(KEEP==1)
            valid = t<t(run_indices(ceil(length(run_indices)/2))) & (speed'>2);
        elseif(KEEP==2)
            valid = t>=t(run_indices(ceil(length(run_indices)/2))) & (speed'>2);            
        end
        valid_half(:,KEEP) = valid;
        occ = histc(ds_pos(valid),linspace(0,200,nbins+1))*dt;
        occ = occ(1:nbins);
        occ = gaussian_smooth_1d_circ(occ,1);
        fprintf('\ncomputing halves:\n');
        msg = 0;
        for i_roi = 1:size(A.Cs,1)
            fprintf(1,repmat('\b',[1,msg]));
            msg = fprintf(1,'ROI %d/%d',i_roi,size(A.Cs,1));
%             if(mod(i_roi,20)==1)
%                 fprintf('\n');
%             end
%             fprintf('%d ',i_roi);


%             [startStop, peakIndex, amp, width] = METHOD(A.Cs(i_roi,:),THR1);
%             fitValues = zCCC(i_roi,peakIndex);            
%             valid2 = fitValues>THR2;
%             peak = peakIndex(valid2);
            
            peak = find(A.Cs(i_roi,:)>0);
            
            roi_rate(i_roi,peak(speed(peak)>2)) = 1/dt;
            keep = speed(peak)'>2 & valid(peak);
            nEvents_half(i_roi,KEEP) = sum(keep);
            event_rate_half(i_roi,KEEP) = sum(keep)/(dt*sum(valid));
            if(sum(keep)==0)
                place_cell_stats_half(i_roi,KEEP).rate_map = zeros(1,40);
                place_cell_stats_half(i_roi,KEEP).rate_map_weighted = zeros(1,40);
                place_cell_stats_half(i_roi,KEEP).event_std = NaN;
                place_cell_stats_half(i_roi,KEEP).event_std_weighted = NaN;
                place_cell_stats_half(i_roi,KEEP).info = NaN;
                place_cell_stats_half(i_roi,KEEP).info_weighted = NaN;
                continue;
            end

            idx = nearestpoint(peak(keep),run_indices);
            idx2 = idx;
            peak2 = run_indices(idx2);

            peakHeight = A.Cs(i_roi,peak2);
            event_pos = ds_pos(peak2);
		%	if(event_pos>200)
        %        event_pos = 200;
        %    end
            place_cell_stats_half(i_roi,KEEP) = place_cell_wrapper(event_pos, occ, peakHeight, linspace(0,200,41));
        end
    end

    outputHalves.rate_map_half1 = cell2mat(arrayfun(@(x) x.rate_map,place_cell_stats_half(:,1),'UniformOutput', false));
    outputHalves.rate_map_half2 = cell2mat(arrayfun(@(x) x.rate_map,place_cell_stats_half(:,2),'UniformOutput', false));
    outputHalves.nEvents_half = nEvents_half;
    outputHalves.event_rate_half = event_rate_half;
    outputHalves.roi_rate = roi_rate;
    outputHalves.valid_half = valid_half;
%     outputHalves.class = class;
    outputHalves.ds_pos = ds_pos;
    outputHalves.speed = speed;
    %%
    output0.timeRunning = dt*sum(speed>2);
    output0.nEvents = nEvents';
    output0.significant = normalizedInfo0>1;
    output0.peakIdx = repmat(find(shifts==0),length(nEvents),1);
    nFields = NaN(size(normalizedInfo0));
    fieldWidth = cell(size(normalizedInfo0));
    fieldCenters = cell(size(normalizedInfo0));
    conversion = diff(center(linspace(0,200,41)))/diff(center(linspace(0,2*pi,41)));
    xx = center(linspace(0,2*pi,41));
    count = 1;
    fprintf('\ncomputing fields:\n');
    msg = 0;
    for i_roi = 1:length(nFields)
        if(~output0.significant(i_roi))
            continue;
        end
        fprintf(1,repmat('\b',[1,msg]));
        msg = fprintf(1,'ROI %d/%d',i_roi,length(nFields));
        
        this = place_cell_stats(i_roi,output0.peakIdx(i_roi)).rate_map;
        [Y,B,F,C,L] = shakeVonMises3(xx,this,0.5);
        fieldCenters{i_roi} = L*conversion;
        fieldWidth{i_roi} = exp(B(3:2:end));
        nFields(i_roi) = length(L);
        count = count+1;
    end
    output0.fieldCenters = fieldCenters;
    output0.fieldWidth = fieldWidth;
    output0.nFields = nFields;
    output0.rate_map = cell2mat(arrayfun(@(x) x.rate_map, place_cell_stats(:,shifts==0),'UniformOutput',false));
%     output0.class = class;
    output0.infoContent = info(:,shifts==0);
    output0.normalizedInfo = normalizedInfo0;

    outputOptimal = output0;
    outputOptimal.significant = normalizedInfoOptimal>1;
    outputOptimal.peakIdx = peakIdx;
    xx = center(linspace(0,2*pi,41));
    count = 1;
    fprintf('\n');
    for i_roi = 1:length(nFields)
        if(~outputOptimal.significant(i_roi) || outputOptimal.peakIdx(i_roi)==output0.peakIdx(i_roi))
            continue;
        end
%         fprintf('%d ',i_roi);
%         if(mod(count,20)==0)
%             fprintf('\n');
%         end
        this = place_cell_stats(i_roi,outputOptimal.peakIdx(i_roi)).rate_map;
        [Y,B,F,C,L] = shakeVonMises3(xx,this,0.5);
        outputOptimal.fieldCenters{i_roi} = L*conversion;
        outputOptimal.fieldWidth{i_roi} = exp(B(3:2:end));
        outputOptimal.nFields(i_roi) = length(L);                
        count = count+1;
    end
    outputOptimal.rate_map = cell2mat(arrayfun(@(x) place_cell_stats(x,peakIdx(x)).rate_map, 1:length(nFields),'UniformOutput',false)');
    outputOptimal.infoContent = peakInfo;
    outputOptimal.normalizedInfo = normalizedInfoOptimal;

end