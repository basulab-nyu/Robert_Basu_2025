function [] = roi_footprint()
	clear all
	input_folder = 'C:\root\hpc';
	input_file = 'ROI_set_m9.mat';
	s_foot = load(fullfile(input_folder,input_file));
	fig_roi = figure('position',[50,75,700,600]);
	view(axes(),2)
	ylim([0 512])
	xlim([0 512])
	set(gca, 'YDir','reverse')
	axis('square');
	ylabel('pixel #');
	xlabel('pixel #');
	hold on
	for i=1:size(s_foot.sROI,2)
		try
			if(contains(s_foot.sROI{i}.strName,'s'))
				fill(s_foot.sROI{i}.mnCoordinates(:,1),s_foot.sROI{i}.mnCoordinates(:,2),[0 0.4470 0.7410],'FaceAlpha',0.25,'EdgeColor',[0 0.4470 0.7410]);
			end
			if(contains(s_foot.sROI{i}.strName,'ad'))
				fill(s_foot.sROI{i}.mnCoordinates(:,1),s_foot.sROI{i}.mnCoordinates(:,2),[0.8500 0.3250 0.0980],'FaceAlpha',0.25,'EdgeColor',[0.8500 0.3250 0.0980]);
			end
		end
	end
	hold off
	print(fullfile(input_folder,replace(input_file,'.mat','.pdf')),'-dpdf','-r300','-bestfit');
	close(fig_roi);
end