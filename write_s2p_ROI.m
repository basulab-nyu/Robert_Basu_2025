function [] = write_s2p_ROI()
    target_folder = '/gpfs/scratch/roberv04/Black_375/suite2p_reg_roi_RF_GOL';
    s2p_file = 'Fall.mat';
    output_folder = 'ROI_s2p_set';
    output_name = 'Black_375_batch_mc_RF_GOL';
    str_slash = '/';
    if ~contains(target_folder,str_slash)
        target_folder = strrep(target_folder,'\',str_slash);
    end
    addpath(genpath('ADP'));
	addpath(genpath('NoRMCorre'));
    addpath(genpath('JTools'));
	addpath(genpath('d-NMF-main'));
    if evalin('base','exist(''s2p_struct'',''var'') == 0')
        fprintf('\nloading s2p file...\n');
        tic;
        s2p_struct = load(strcat(target_folder,str_slash,s2p_file));
        assignin('base','s2p_struct',s2p_struct);
        fprintf('\ns2p file loaded!!!\n\n');
        toc;
    else
        s2p_struct = evalin('base','s2p_struct');
        fprintf('\n~found local s2p file~\n\n');
    end
    ROI_folder = strcat(target_folder,str_slash,output_folder,str_slash);
    if(~exist(ROI_folder,'dir'))
		mkdir(ROI_folder);
    end
    fprintf('\nwriting ROI files...\n\n');
    tic;
    for i=1:size(s2p_struct.stat,2)
        v_x = s2p_struct.stat{1,i}.xpix;
        v_y = s2p_struct.stat{1,i}.ypix;
        v_x = reshape(v_x,size(v_x,2),1);
        v_y = reshape(v_y,size(v_y,2),1);
        v_x = double(v_x);
        v_y = double(v_y);
        v_roi = boundary(v_y,v_x,0.95);
        writeImageJROI_3([v_y(v_roi) v_x(v_roi)],4,0,sprintf('r%04d',i),ROI_folder);
    end
    toc;
    fprintf('\nROI files done!!!\n\n');
    fprintf('\nzipping ROI folder...\n\n');
    tic;
    zip(strcat(target_folder,str_slash,output_folder,"_",output_name),'*',ROI_folder);
	rmdir(ROI_folder,'s');
    toc;
    fprintf('\nROI folder zipped!!!\n\n');
end
