function [] = NoRMCorre()
	input_tiffs = '/gpfs/scratch/roberv04/cohort_6/m14/240601/VR_240601_m14_GOL_B_t-000/stack_VR_240601_m14_GOL_B_t-000.tif';
	output_tiffs = '/gpfs/scratch/roberv04/cohort_6/m14/240601/VR_240601_m14_GOL_B_t-000/plane0/reg_tif/NoRMCorre.tif';
	addpath(genpath('code'));
	og_vid = bigread2(input_tiffs);
	[mc_vid,~,~,~,~] = normcorre(og_vid);
	fTIF_concat = Fast_BigTiff_Write(output_tiffs,1,0);
	for i = 1:size(mc_vid,3)
		fTIF_concat.WriteIMG(uint16(mc_vid(:,:,i)'));
	end
	fTIF_concat.close;
	save(strrep(output_tiffs,'.tif','.mat'),'mc_vid','-v7.3');
end