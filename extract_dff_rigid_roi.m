function [] = extract_dff_rigid_roi(path_to_video, path_to_roi, output_folder)
    if(~exist(output_folder,'dir'))
        mkdir(output_folder);
    %else
    %    if isempty(dir(strcat(output_folder,'/J_Cdf_nonrigid_Manual2.mat'))) == 0
    %        fprintf('\n~~~df/f already extracted~~~\n\n');
    %        return
    %    end
    end
    if(~exist(path_to_roi, 'file'))
        return;
    end
    FOV = [512,512];
    d1 = FOV(1);
    d2 = FOV(2);  
    nam = path_to_video;
    sframe = 1;
    num2read = 19999;
    fprintf('\nreading frames...\n');
    Y = bigread2(nam,sframe);
    Y = Y - min(Y(:)); 
    if ~isa(Y,'single')
        Y = single(Y);
    end         
    [d1,d2,T] = size(Y);
    d = d1*d2;
	Cn_max =  max(Y,[],3);
    ROI_file = path_to_roi;
    load(ROI_file, 'ROI', 'names');
    A = ROI;
    fprintf('\nextracting df/f...\n');
    cY = reshape(Y,d,T);
    cA = reshape(A,d,size(A,3));
    C = cA'*cY;
	F = C;
    Df = medfilt1(C,1000,[],2,'truncate');
	C = C-Df;
    C_df = C./Df;
    clear Y;
	[Coor] = plot_contours(cA,Cn_max,'');
    fprintf('\nsaving matfiles...\n');
    save(fullfile(output_folder,'J_Cdf_nonrigid_Manual2'),'C_df','F');
    save(fullfile(output_folder,'J_ROI_nonrigid_Manual2'),'Coor' ,'names');
    fprintf('\ndone!!!\n');
end



