function [dFF,START_STOP,PEAK,AMP,WIDTH,AUC] = fitness_detect_fullsample(traces_C, rois_A, video_Y)
    % [START_STOP, PEAK] = fitness_detect(traces_C, rois_A, video_Y)
    
    THR_DF = 2;
    THR_FIT = 0.27;
    DETREND_FRAMES = 900;
    DT = 1/30;

    video_Y = j_detrend2b_VR(video_Y,DETREND_FRAMES,3,1,1);
    video_Y(isnan(video_Y) | isinf(video_Y)) = 0;
    zy = zscore(video_Y,[],3);
    
	THIS1 = j_detrend2b_VR(traces_C,DETREND_FRAMES,2,1,1);
	dFF = THIS1';

    zCCC = corrTrace(zy, rois_A, 3);
    METHOD = @(x,y) fp_detect2(x, DT, y);
    
    START_STOP = cell(1,size(rois_A,3));
    PEAK = cell(1,size(rois_A,3));
	AMP = cell(1,size(rois_A,3));
	WIDTH = cell(1,size(rois_A,3));
	AUC = cell(1,size(rois_A,3));
    
    for i_roi = 1:size(rois_A,3)
        zcs2 = THIS1(i_roi,:);
        [startStop, peakIndex, amp, width, auc] = METHOD(zcs2,THR_DF);
        THIS2 = zCCC(i_roi,:);
        screenVals = THIS2(peakIndex);
        valid = screenVals>THR_FIT;
        START_STOP{i_roi} = startStop(valid,:);
        PEAK{i_roi} = peakIndex(valid);
		AMP{i_roi} = amp(valid);
		WIDTH{i_roi} = width(valid);
		AUC{i_roi} = auc(valid);
    end     

end