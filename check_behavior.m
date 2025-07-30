function [] = check_behavior()
    root_path = '/gpfs/data/basulab/VR';
	addpath(genpath('code'));
    cohorts = dir(fullfile(root_path,'*cohort*'));
	for i=1:size(cohorts,1)
		mice = dir(fullfile(root_path,cohorts(i).name,'m*'));
		for j=1:size(mice,1)
			sessions = list_folders_VR(fullfile(root_path,cohorts(i).name,mice(j).name));
			for k=1:size(sessions,1)
				try
					[~,id,~] = fileparts(sessions(k));
					%fprintf(strcat('\nprinting:',id,'\n'));
					temp = load(fullfile(sessions(k),'behavior','Behavior.mat'));
					%plot(temp.Behavior.position);
					%print(fullfile('/gpfs/data/basulab/VR/behavior_check',strcat(id,'.pdf')),'-dpdf','-r300','-bestfit');
					if ~isempty(find(temp.Behavior.position>200))
						fprintf(strcat('\nissue:',id,'\n'));
					end
					close all;
					clear temp;
				catch
					[~,id,~] = fileparts(sessions(k));
					fprintf(strcat('\nmissing:',id,'\n'));
					close all;
					clear temp;
				end
			end
		end
	end
end