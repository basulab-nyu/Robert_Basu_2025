function [] = anova2()
    clear all
	folder = 'C:\root\hpc\behav_stats';
    target = ...
	{'fraction_correct_licks_GOL_learn_A1_',...
	'fraction_correct_licks_GOL_learn_Aa_',...
	'fraction_correct_licks_GOL_learn_A2_',...
	'fraction_correct_licks_GOL_learn_B_',...
	'fraction_correct_licks_GOL_learn_all_',...
	'fraction_correct_trials_GOL_learn_A1_',...
	'fraction_correct_trials_GOL_learn_Aa_',...
	'fraction_correct_trials_GOL_learn_A2_',...
	'fraction_correct_trials_GOL_learn_B_',...
	'fraction_correct_trials_GOL_learn_all_',...
	'fraction_correct_licks_GOL_recall_C1_',...
	'fraction_correct_licks_GOL_recall_Cc_',...
	'fraction_correct_licks_GOL_recall_C2_',...
	'fraction_correct_licks_GOL_recall_D_',...
	'fraction_correct_licks_GOL_recall_all_',...
	'fraction_correct_trials_GOL_recall_C1_',...
	'fraction_correct_trials_GOL_recall_Cc_',...
	'fraction_correct_trials_GOL_recall_C2_',...
	'fraction_correct_trials_GOL_recall_D_',...
	'fraction_correct_trials_GOL_recall_all_'};
	for t=1:size(target,2)
		files = dir(fullfile(folder,strcat('*',target{t},'*')));
		fprintf('\nworking on:\n')
		for i=1:size(files,1)
			disp(files(i).name);
			input_cell{i,1} = files(i).name;
			input_cell{i,2} = readmatrix(fullfile(files(i).folder,files(i).name));
		end
		for i=2:size(input_cell,1)
			j=1;
			while(strcmp(input_cell{1,1}(1:j),input_cell{i,1}(1:j)))
				common = input_cell{1,1}(1:j);
				%disp(common)
				j=j+1;
			end
		end
		input = cellfun(@(c) extractAfter(c,common),input_cell(:,1),'UniformOutput',false);
		input = cellfun(@(c) extractBefore(c,'.csv'),input(:,1),'UniformOutput',false);
		data = nan;
		for i=1:size(input,1)
			data = cat(1,data,reshape(input_cell{i,2},[size(input_cell{i,2},1)*size(input_cell{i,2},2),1]));
		end
		data(1) = [];
		sessions = [];
		for i=1:size(input,1)
			for j=1:size(input_cell{i,2},2)
				sessions = cat(1,sessions,linspace(1,size(input_cell{i,2},1),size(input_cell{i,2},1))');
			end
		end
		groups = strings;
		for i=1:size(input,1)
			for j=1:size(input_cell{i,2},2)
				for k=1:size(input_cell{i,2},1)
					groups = cat(1,groups,input{i});
				end
			end
		end
		groups(1) = [];
		[pval,tbl,sts] = anovan(data,{sessions,groups},'model','interaction','varnames',{'days','groups'},'display','off');
		[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[2],'display','off');
		gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
		output = {};
		for i=1:size(pval,1)
			output{i,1} = tbl{i+1,1};
			output{i,2} = tbl{i+1,7};
		end
		for i=1:size(mc_sts,1)
			output{end+1,1} = strcat(gp_names{mc_sts(i,1)},'_vs_',gp_names{mc_sts(i,2)});
			output{end,2} = mc_sts(i,6);
		end
		writecell(output,fullfile(folder,strcat(target{t},'stats.csv')));
	end
end