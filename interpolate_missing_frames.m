function [] = interpolate_missing_frames()
	input_folder = '/gpfs/data/basulab/VR/cohort_7/m27/240715/VR_240715_m27_fam2_t-000/plane0/reg_tif';
	output_folder = '/gpfs/data/basulab/VR/cohort_7/m27/240715/VR_240715_m27_fam2_t-000/interp';
	n_missing_frames = 60;
	addpath(genpath('code'));
    input_tiffs = dir(fullfile(input_folder,'*.tif'));
	n_interp = n_missing_frames/size(input_tiffs,1);
	if(~exist(output_folder,'dir'))
		mkdir(output_folder);
	end
	for i=1:size(input_tiffs,1)
		fprintf('\nworking on:\n');
		disp(fullfile(input_folder,input_tiffs(i).name));
		work_tiffs = bigread2(fullfile(input_folder,input_tiffs(i).name),1);
		base_index = 0.5*size(work_tiffs,3)/n_interp;
		insert_index = round(linspace(base_index,size(work_tiffs,3)-base_index,n_interp));
		fprintf('\ninterpolating tiffs...\n');
		for j=1:size(insert_index,2)
			fprintf(strcat('\ntargeting frames_',num2str(insert_index(j)),'_to_',num2str(insert_index(j)+1)));
			insert_tiff = mean(work_tiffs(:,:,insert_index(j):insert_index(j)+1),3);
			temp = work_tiffs(:,:,1:insert_index(j));
			temp(:,:,end+1) = insert_tiff;
			temp(:,:,end+1:size(work_tiffs,3)+1) = work_tiffs(:,:,insert_index(j)+1:size(work_tiffs,3));
			work_tiffs = temp;
			clear temp
		end
		fprintf('\nwriting file...\n');
		fTIF = Fast_BigTiff_Write(fullfile(output_folder,input_tiffs(i).name),1,0);
        msg = 0;
        for j = 1:size(work_tiffs,3)
            fprintf(1,repmat('\b',[1,msg]));
            msg = fprintf(1,'%.0f/%.0f',j,size(work_tiffs,3));
            fTIF.WriteIMG(uint16(work_tiffs(:,:,j)'));
        end
        fTIF.close;
		clear work_tiffs;
		fprintf('\ndone!\n');
	end
	fprintf('\nall done!\n');
end