function [] = ADP_Cluster_From_Manual_ROI(input_folder,output_folder,roi_file)
    if(~exist(output_folder,'dir'))
        mkdir(output_folder);
    else
        if isempty(dir(strcat(output_folder,'/*.mat'))) == 0
            fprintf('\nROI already formatted\n');
            return
        end
    end
    if(isfile(roi_file) == 0)
        fprintf('\nROI file missing\n');
        return;
    end
    frames = Inf;             %Total frames to be loaded in
    downsample_factor = 5;     %How much to downsample by
    temporal_smoothing = 1;     %How much to smooth in time (after downsampling)
    spatial_smoothing = 3;      %How much to smooth in space
    plotting = 1;               %Do you want to plot as things are clustered?
    initial_points = 1000;       %The number of random initial points
    join_threshold = 0.3;       %The minimum correlation needed to join a cluster
    chunk_size = 1000;          %The number of points to process before recomputing means
    loops = 800;                %The number of times to repeat the process
    minimum_segment_size = 5;  %The smallest number of pixels a valid segment can be
    minimum_cluster_size = 15;  %The smallest number of pixels a valid cluster can be (A cluster is defined as the sum of all of its segments)
    filename = fullfile(input_folder,'MC_Video_nonrigid.tif');
    width = 512;
    height = 512;
    dur = NaN;
    fs = NaN;
    nFrames = frames;
    factor = downsample_factor;
    nFrames2 = floor(nFrames/factor);
    fprintf('\nformatting ROIs...\n'); 
    [sROI, ROI] = ReadImageJROI_C(roi_file, [height, width]);
    ROIconvhull = ROI;
    ROI = zeros(size(ROI));
    [aa,bb] = meshgrid(1:height,1:width);
    for i_roi = 1:size(ROI,3)
        temp = inpolygon(bb(:),aa(:),sROI{i_roi}.mnCoordinates(:,1),sROI{i_roi}.mnCoordinates(:,2));
        ROI(:,:,i_roi) = reshape(temp,[width height])';
    end
    names = cellfun(@(x) x.strName, sROI(:), 'UniformOutput', false);
    save(fullfile(output_folder,'ROI_nonrigid_Manual2'),'ROI','names');
    fprintf('\nROI formatted!!!\n');
end