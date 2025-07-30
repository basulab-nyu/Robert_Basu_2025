function [] = load_fiji_ROIs(input_folder,output_folder,roi_file,w,h)
	width = w;
	height = h;
    if(~exist(output_folder,'dir'))
        mkdir(output_folder);
    else
        if isempty(dir(fullfile(output_folder,'*.mat'))) == 0
            fprintf('\nROIs already formatted...\n');
            return
        end
    end
    if(isfile(roi_file) == 0)
        fprintf('\n***ROI file missing***\n');
        return;
    end
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
    fprintf('\nROIs formatted!!!\n');
end