function [] = fix_behavior_stutter()
	clear all
	close all
    behav_file = '/gpfs/data/basulab/VR/cohort_7/m33b/240904/VR_240904_m33_GOL_Cc_t-000/behavior/Behavior.mat';
	addpath(genpath('code'));
    load(behav_file);
	plot(Behavior.position)
	close all
	d = diff(Behavior.position);
	d = 0-d;
	[~,pkidx] = findpeaks(d,'MinPeakProminence',20);
	pks = Behavior.position(pkidx);
	thr = round(min(pks(2:end-1)));
	position = Behavior.position;
	if pks(1)>thr+10
		cutidx = find(position(1:pkidx(1))>thr,1);
		position(cutidx:pkidx(1)) = position(cutidx:pkidx(1))-thr;
		pks(1) = position(pkidx(1));
	end
	while ~isempty(find(pks>thr+10))
		for i=2:size(pks,1)
			if pks(i)>thr+10
				cutidx = find(position(pkidx(i-1)+1:pkidx(i))>thr,1)+pkidx(i-1);
				position(cutidx:pkidx(i)) = position(cutidx:pkidx(i))-thr;
				pks(i) = position(pkidx(i));
			end
		end
	end
	while ~isempty(find(position(pkidx(end):end)>thr+10))
		cutidx = find(position(pkidx(end)+1:end)>thr,1)+pkidx(end);
		position(cutidx:end) = position(cutidx:end)-thr;
		pkidx(end+1) = cutidx;
		pks(end+1) = position(cutidx);
	end
	d = diff(position);
	d = 0-d;
	[~,pkidx] = findpeaks(d,'MinPeakProminence',20);
	lapidx = Behavior.time(pkidx);
	lapidx2 = lapidx(2:end-1)+0.0001;
	lap{1} = [lapidx(1),lapidx(2)];
	for i=2:size(lapidx,1)-1
		lap{i} = [lapidx2(i-1),lapidx(i+1)];
	end
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