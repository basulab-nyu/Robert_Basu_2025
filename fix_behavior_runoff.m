function [] = fix_behavior_runoff()
	clear all
	close all
    behav_file = '/gpfs/data/basulab/VR/cohort_7/m25/240811/VR_240811_m25_GOL_C2_t-000/behavior/Behavior.mat';
	addpath(genpath('code'));
    load(behav_file);
	plot(Behavior.position)
	close all
	d = diff(Behavior.position);
	d = 0-d;
	[~,pkidx] = findpeaks(d,'MinPeakProminence',20);
	pks = Behavior.position(pkidx);
	thr = round(mean(pks(2:end)));
	position = Behavior.position;
	while ~isempty(find(position(pkidx(end)+10:end)>thr))
		cutidx = find(position(pkidx(end)+10:end)>thr,1)+pkidx(end)+10;
		position(cutidx:end) = position(cutidx:end)-position(cutidx);
		pkidx = cat(1,pkidx,cutidx);
	end
	lapidx = Behavior.time(pkidx);
	lapidx2 = lapidx(2:end-1)+0.0001;
	lap{1} = [lapidx(1),lapidx(2)];
	for i=2:size(lapidx,1)-1
		lap{i} = [lapidx2(i-1),lapidx(i+1)];
	end
	d = diff(position);
	d = 0-d;
	[~,pkidx] = findpeaks(d,'MinPeakProminence',20);
	pkidx2 = pkidx+1;
	start = position(pkidx);
	stop = position(pkidx2);
	mid = [];
	for i=1:size(pkidx,1)-1
		mid(pkidx2(i)-pkidx(1):pkidx(i+1)-pkidx(1)) = position(pkidx2(i):pkidx(i+1))/(start(i+1)-stop(i));
	end
	mid = mid';
	first = position(1:pkidx(1));
	first = (first+thr-max(first))/thr;
	last = position(pkidx2(end):end);
	last = last/thr;
	norm = cat(1,first,mid,last);
	figure
	plot(position)
	hold on
	plot(Behavior.position)
	hold off
	figure
	plot(norm)
	hold on
	plot(Behavior.normalizedposition)
	hold off
	close all
	Behavior.position = position;
	Behavior.normalizedposition = norm;
	Behavior.lap = lap;
	save(behav_file,'Behavior','Imaging_Time','-v7.3');
end