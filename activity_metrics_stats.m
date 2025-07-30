function [] = activity_metrics_stats()
	input = 'C:\root\hpc\s_metric_fr02i02w02p02.mat';
	load(input);
	output = 'C:\root\hpc\metrics';
	s_out = struct;
%process data
	groups = fieldnames(s_metric);
	for i=1:size(groups,1)
		type = fieldnames(s_metric.(char(groups(i))));
		for j=1:size(type,1)
			s_out.(char(groups(i))).(char(type(j))).log = {};
			metric = fieldnames(s_metric.(char(groups{i})).(char(type{j})));
			metric = metric(find(~contains(metric,'rate_map')));
			metric = metric(find(~contains(metric,'corr')));
			metric = metric(find(~contains(metric,'roi_pc_binary')));
			metric = metric(find(~contains(metric,'pop')));
			metric = metric(find(~contains(metric,'center_place_fields')));
			metric = metric(find(~contains(metric,'spatial_info_norm')));
			k=1;
			data = s_metric.(char(groups{i})).(char(type{j})).(char(metric{k}));
			for d=1:size(data,1)
				s_out.(char(groups(i))).(char(type(j))).log{d,1} = {};
				for x=1:size(data{d},1)
					y=1;
					while(isempty(data{d}{x,y}))
						y=y+1;
					end
					s_out.(char(groups(i))).(char(type(j))).log{d,1}{x,1} = data{d}{x,y};
				end
				s_out.(char(groups(i))).(char(type(j))).log{d,1} = cellfun(@(c) replace(c,'_m'+digitsPattern+'_',''),s_out.(char(groups(i))).(char(type(j))).log{d,1},'UniformOutput',false);
				s_out.(char(groups(i))).(char(type(j))).log{d,1} = cellfun(@(c) replace(c,'t-'+digitsPattern(3),''),s_out.(char(groups(i))).(char(type(j))).log{d,1},'UniformOutput',false);
				s_out.(char(groups(i))).(char(type(j))).log{d,1} = cellfun(@(c) replace(c,'VR_'+digitsPattern(6),''),s_out.(char(groups(i))).(char(type(j))).log{d,1},'UniformOutput',false);		
			end
			for k=1:size(metric,1)
				s_out.(char(groups{i})).(char(type{j})).(char(metric{k})) = s_metric.(char(groups{i})).(char(type{j})).(char(metric{k}));
			end
		end
	end
%RF
	control_target = {'RF'+wildcardPattern+'_fam2',...
	'RF'+wildcardPattern+'_nov'};
	list = fieldnames(s_out.(char(groups(1))).(char(type(1))));
	list(cellfun(@(c) contains(c,'log'),list)) = [];
	lbl = {'SAL','CNO','PSEM','DCZ'};
	for k=1:size(list,1)
		for j=1:size(type,1)
			for s=1:size(control_target,2)
				fig = figure;
				hold on
				target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(1))).(char(type(j))).log,'UniformOutput',false)));				
				pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
				avg = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,3};
				sem = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,4};
				lin = linspace(1,size(pop,1),size(pop,1));
				plot(lin,pop,'k')
				shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
				hold off
				xlabel('treatment');
				xticks([1 2 3 4]);
				xticklabels(lbl);
				ylabel(char(list(k)),'Interpreter','none');
				if(contains(string(type(j)),'s'))
					cmpt = 'somas';
				end
				if(contains(string(type(j)),'ad'))
					cmpt = 'dendrites';
				end
				if(contains(string(control_target{s}),'fam2'))
					ssn = 'fam';
				end
				if(contains(string(control_target{s}),'nov'))
					ssn = 'nov';
				end
				title(strcat(cmpt,'_',ssn),'Interpreter','none');
				fig_name = strcat('CTvsGLUvsGABA_',cmpt,'_',ssn,'_',string(list(k)),'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
%control vs exp
	control_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Aa_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A2_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_B_'};
	LECglu_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Aa_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A2_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_B_'};
	LECgaba_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_C_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Cc_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_C2_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_D_'};
	list = fieldnames(s_out.(char(groups(1))).(char(type(1))));
	list(cellfun(@(c) contains(c,'log'),list)) = [];
	s_learn_cross = struct;
	for k=1:size(list,1)
		for j=1:size(type,1)
			for s=1:size(control_target,2)
				% fig = figure;
				% hold on
				for i=1:size(groups,1)
					if(contains(string(groups(i)),'control'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
					avg = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,3};
					sem = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,4};
					lin = linspace(1,size(pop,1),size(pop,1));
					name = char(unique(cellfun(@(c) replace(c,'_d'+digitsPattern+'_','_'),s_out.(char(groups(i))).(char(type(j))).log{target},'UniformOutput',false)));
					s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_',name,'pop')) = pop;
					s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_',name,'avg')) = avg;
					s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_',name,'sem')) = sem;
					% if(contains(string(groups(i)),'control'))
						% plot(lin,pop,'k')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
					% end
					% if(contains(string(groups(i)),'LECglu'))
						% plot(lin,pop,'g')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
					% end
					% if(contains(string(groups(i)),'LECgaba'))
						% plot(lin,pop,'r')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
					% end
				end
				% hold off
				% xlabel('days');
				% ylabel(char(list(k)),'Interpreter','none');
				% if(contains(string(type(j)),'s'))
					% cmpt = 'somas';
				% end
				% if(contains(string(type(j)),'ad'))
					% cmpt = 'dendrites';
				% end
				% if(contains(string(control_target{s}),'_A_'))
					% ssn = 'A';
				% end
				% if(contains(string(control_target{s}),'_A2_'))
					% ssn = 'A2';
				% end
				% if(contains(string(control_target{s}),'_Aa_'))
					% ssn = 'Aa';
				% end
				% if(contains(string(control_target{s}),'_B_'))
					% ssn = 'B';
				% end
				% title(strcat(cmpt,'_',ssn),'Interpreter','none');
				% fig_name = strcat('CTvsGLUvsGABA_',cmpt,'_',ssn,'_',string(list(k)),'.pdf');
				% print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				% close(fig);
			end
		end
	end
	s_stats_CTvsGLUvsGABA = struct;
	for k=1:size(list,1)
		for j=1:size(type,1)
			for s=1:size(control_target,2)
				popsize = [];
				for i=1:size(groups,1)
					if(contains(string(groups(i)),'control'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
					popsize(i) = size(pop,1);
				end
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1)
					if(contains(string(groups(i)),'control'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
					pop = pop(1:min(popsize),:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							treatment = cat(1,treatment,groups{i});
						end
					end
				end
				data(1) = [];
				treatment(1) = [];			
				[pval,tbl,sts] = anovan(data,{sessions,treatment},'model','interaction','varnames',{'days','treatment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for i=1:size(pval,1)
					outsts{i,1} = tbl{i+1,1};
					outsts{i,2} = tbl{i+1,7};
				end
				for i=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(i,1)},'_vs_',gp_names{mc_sts(i,2)});
					outsts{end,2} = mc_sts(i,6);
				end
				if(contains(string(control_target{s}),'_A_'))
					ssn = 'A';
				end
				if(contains(string(control_target{s}),'_A2_'))
					ssn = 'A2';
				end
				if(contains(string(control_target{s}),'_Aa_'))
					ssn = 'Aa';
				end
				if(contains(string(control_target{s}),'_B_'))
					ssn = 'B';
				end
				s_stats_CTvsGLUvsGABA.(char(type(j))).(char(list(k))).(char(ssn)).data = data;
				s_stats_CTvsGLUvsGABA.(char(type(j))).(char(list(k))).(char(ssn)).sessions = sessions;
				s_stats_CTvsGLUvsGABA.(char(type(j))).(char(list(k))).(char(ssn)).treatment = treatment;
				s_stats_CTvsGLUvsGABA.(char(type(j))).(char(list(k))).(char(ssn)).comparisons = outsts;
			end
		end
	end
	c_pval_CTvsGLUvsGABA = {};
	type = fieldnames(s_stats_CTvsGLUvsGABA);
	for j=1:size(type,1)
		metric = fieldnames(s_stats_CTvsGLUvsGABA.(char(type(j))));
		for k=1:size(metric,1)
			session = fieldnames(s_stats_CTvsGLUvsGABA.(char(type(j))).(char(metric(k))));
			for s=1:size(session,1)
				c_pval_CTvsGLUvsGABA{end+1,1} = strcat(char(type(j)),'_',char(metric(k)),'_',char(session(s)));
				c_pval_CTvsGLUvsGABA{end,2} = s_stats_CTvsGLUvsGABA.(char(type(j))).(char(metric(k))).(char(session(s))).comparisons{2,2};
			end
		end
	end
	[~,pidx] = sort(cell2mat(c_pval_CTvsGLUvsGABA(:,2)));
	c_pval_CTvsGLUvsGABA_sort = c_pval_CTvsGLUvsGABA(pidx,:);
	list_control = fieldnames(s_learn_cross.(char(groups(1))).(char(type(1))));
	list_control(cellfun(@(c) ~contains(c,'pop'),list_control)) = [];
	target_control = fieldnames(s_out.(char(groups(1))).(char(type(1))));
	target_control(cellfun(@(c) contains(c,'log'),target_control)) = [];
	list_glu = fieldnames(s_learn_cross.(char(groups(2))).(char(type(1))));
	list_glu(cellfun(@(c) ~contains(c,'pop'),list_glu)) = [];
	target_glu = fieldnames(s_out.(char(groups(2))).(char(type(1))));
	target_glu(cellfun(@(c) contains(c,'log'),target_glu)) = [];
	list_gaba = fieldnames(s_learn_cross.(char(groups(3))).(char(type(1))));
	list_gaba(cellfun(@(c) ~contains(c,'pop'),list_gaba)) = [];
	target_gaba = fieldnames(s_out.(char(groups(3))).(char(type(1))));
	target_gaba(cellfun(@(c) contains(c,'log'),target_gaba)) = [];
	for t=1:size(target,1)
		for j=1:size(type,1)
			fig = figure;
			hold on
			for i=1:size(groups,1)
				% if(contains(string(groups(i)),'control'))
					% tgtlist = list_control(find(contains(list_control,target_control{t})));
				% end
				% if(contains(string(groups(i)),'LECglu'))
					% tgtlist = list_glu(find(contains(list_glu,target_glu{t})));
				% end
				% if(contains(string(groups(i)),'LECgaba'))
					% tgtlist = list_gaba(find(contains(list_gaba,target_gaba{t})));
				% end
				% pop = [];
				% avg = [];
				% sem = [];
				% lin = [];
				% for tgt=1:size(tgtlist,1)
					% pop = cat(3,pop,s_learn_cross.(char(groups(i))).(char(type(j))).(char(tgtlist(tgt))));
				% end
				% pop = mean(pop,3,'omitnan');
				% avg = mean(pop,2,'omitnan');
				% sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
				% lin = linspace(1,size(pop,1),size(pop,1));
				% s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_mean')) = pop;
				% s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_avg')) = avg;
				% s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_sem')) = sem;
				
				pop = s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_mean'));
				avg = mean(pop,2,'omitnan');
				sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
				lin = linspace(1,size(pop,1),size(pop,1));
				s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_avg')) = avg;
				s_learn_cross.(char(groups(i))).(char(type(j))).(strcat(char(target(t)),'_ssn_sem')) = sem;
				
				if(contains(string(groups(i)),'control'))
					plot(lin,pop,'k')
					shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
				end
				if(contains(string(groups(i)),'LECglu'))
					plot(lin,pop,'g')
					shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
				end
				if(contains(string(groups(i)),'LECgaba'))
					plot(lin,pop,'r')
					shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
				end
			end
			hold off
			xlabel('days');
			ylabel((char(target_control(t))),'Interpreter','none');
			if(contains(string(type(j)),'s'))
				cmpt = 'somas';
			end
			if(contains(string(type(j)),'ad'))
				cmpt = 'dendrites';
			end
			title(strcat(string(target_control(t)),'_',cmpt,'_ssn_mean'),'Interpreter','none');
			fig_name = strcat(string(target_control(t)),'_',cmpt,'_ssn_mean.pdf');
			print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
			close(fig);
		end
	end
	list = fieldnames(s_learn_cross.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'ssn_mean')));
	s_stats_crossdays_mean = struct;
	for k=1:size(list,1)
		for j=1:size(type,1)
			popsize = [];
			for i=1:size(groups,1)
				popsize(i) = size(s_learn_cross.(char(groups(i))).(char(type(j))).(char(list(k))),1);
			end
			data = nan;
			sessions = [];
			treatment = strings;
			for i=1:size(groups,1)
				pop = s_learn_cross.(char(groups(i))).(char(type(j))).(char(list(k)));
				pop = pop(1:min(popsize),:);
				data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
				for x=1:size(pop,2)
					sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
					for y=1:size(pop,1)
						treatment = cat(1,treatment,groups{i});
					end
				end
			end
			data(1) = [];
			treatment(1) = [];			
			[pval,tbl,sts] = anovan(data,{sessions,treatment},'model','interaction','varnames',{'days','treatment'},'display','off');
			% [mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
			[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
			%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
			outsts = {};
			for i=1:size(pval,1)
				outsts{i,1} = tbl{i+1,1};
				outsts{i,2} = tbl{i+1,7};
			end
			for i=1:size(mc_sts,1)
				outsts{end+1,1} = strcat(gp_names{mc_sts(i,1)},'_vs_',gp_names{mc_sts(i,2)});
				outsts{end,2} = mc_sts(i,6);
			end
			s_stats_crossdays_mean.(char(type(j))).(extractBefore(char(list(k)),'_ssn_mean')).data = data;
			s_stats_crossdays_mean.(char(type(j))).(extractBefore(char(list(k)),'_ssn_mean')).sessions = sessions;
			s_stats_crossdays_mean.(char(type(j))).(extractBefore(char(list(k)),'_ssn_mean')).treatment = treatment;
			s_stats_crossdays_mean.(char(type(j))).(extractBefore(char(list(k)),'_ssn_mean')).comparisons = outsts;
		end
	end
	control_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Aa_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_B_'};
	LECglu_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Aa_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_B_'};
	LECgaba_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_C_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Cc_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_D_'};
	list = fieldnames(s_out.(char(groups(1))).(char(type(1))));
	list(cellfun(@(c) contains(c,'log'),list)) = [];
	s_comp_CTvsGLUvsGABA = struct;
	for k=1:size(list,1)
		for j=1:size(type,1)
			for s=1:size(control_target,2)
				popsize = [];
				for i=1:size(groups,1)
					if(contains(string(groups(i)),'control'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
					popsize(i) = size(pop,1);
				end
			end
			for i=1:size(groups,1)
				temp = nan;
				for s=1:size(control_target,2)
					if(contains(string(groups(i)),'control'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,control_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_out.(char(groups(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_out.(char(groups(i))).(char(type(j))).(char(list(k))){target,2};
					pop = pop(1:min(popsize),:);
					pop = reshape(pop',[1 size(pop,1)*size(pop,2)]);
					if(s == 1)
						temp = pop;
					else
						temp = cat(1,temp,pop);
					end
				end
				s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))) = temp(:,1:size(temp,2)/min(popsize));
				for d=1+size(temp,2)/min(popsize):size(temp,2)/min(popsize):size(temp,2)
					s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))) = cat(1,s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))),temp(:,d:d-1+size(temp,2)/min(popsize)));
				end
			end
		end
	end
	for k=1:size(list,1)
		for j=1:size(type,1)
			for i=1:size(groups,1)
				s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_avg')) = mean(s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))),2,'omitnan');
				s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_sem')) = std(s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))),0,2,'omitnan')/sqrt(size(s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))),2));
			end
		end
	end
	% xlbl = {'d1A','d1Aa','d1A2','d1B',...
	% 'd2A','d2Aa','d2A2','d2B',...
	% 'd3A','d3Aa','d3A2','d3B',...
	% 'd4A','d4Aa','d4A2','d4B',...
	% 'd5A','d5Aa','d5A2','d5B'};
	% period = 4;
	% for k=1:size(list,1)
		% for j=1:size(type,1)
			% fig = figure;
			% hold on
			% for i=1:size(groups,1)
				% pop = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k)));
				% lin = linspace(1,size(pop,1),size(pop,1));
				% avg = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_avg'));
				% sem = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_sem'));
				% for d=1:period:size(pop,1)
					% if(contains(string(groups(i)),'control'))
						% plot(lin(d:d+period-1),pop(d:d+period-1,:),'k')
						% shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','k','LineWidth',2})
					% end
					% if(contains(string(groups(i)),'LECglu'))
						% plot(lin(d:d+period-1),pop(d:d+period-1,:),'g')
						% shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','g','LineWidth',2})
					% end
					% if(contains(string(groups(i)),'LECgaba'))
						% plot(lin(d:d+period-1),pop(d:d+period-1,:),'r')
						% shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','r','LineWidth',2})
					% end
				% end
			% end
			% hold off
			% xticks(lin);
			% xticklabels(xlbl);
			% ylabel(char(list(k)),'Interpreter','none');
			% if(contains(string(type(j)),'s'))
				% cmpt = 'somas';
			% end
			% if(contains(string(type(j)),'ad'))
				% cmpt = 'dendrites';
			% end
			% fig_name = strcat('comp_CTvsGLUvsGABA_',cmpt,'_',string(list(k)),'.pdf');
			% print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
			% close(fig);
		% end
	% end
	xlbl = {'d1A','d1Aa','d1B',...
	'd2A','d2Aa','d2B',...
	'd3A','d3Aa','d3B',...
	'd4A','d4Aa','d4B',...
	'd5A','d5Aa','d5B'};
	period = 3;
	for k=1:size(list,1)
		fig = figure('Position',[100 100 1100 500]);
		hold on
		cumsize = zeros(1,1);
		for j=1:size(type,1)
			for i=1:size(groups,1)
				cumsize = cumsize+size(s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k))),1);
			end
		end
		lin = linspace(1,cumsize,cumsize);
		prev = zeros(1,1);
		for j=1:size(type,1)
			if(contains(string(type(j)),'s'))
				cmpt = 'somas';
			end
			if(contains(string(type(j)),'ad'))
				cmpt = 'dendrites';
			end
			for i=1:size(groups,1)
				pop = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(char(list(k)));
				avg = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_avg'));
				sem = s_comp_CTvsGLUvsGABA.(char(groups(i))).(char(type(j))).(strcat(char(list(k)),'_sem'));
				if(i == 1 && j == 1)
					prev = 0;
				else
					prev = prev+size(pop,1);
				end
				for d=1:period:size(pop,1)
					if(contains(string(groups(i)),'control'))
						plot(lin(prev+d:prev+d+period-1),pop(d:d+period-1,:),'k')
						shadedErrorBar(lin(prev+d:prev+d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','k','LineWidth',2})
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin(prev+d:prev+d+period-1),pop(d:d+period-1,:),'g')
						shadedErrorBar(lin(prev+d:prev+d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','g','LineWidth',2})
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin(prev+d:prev+d+period-1),pop(d:d+period-1,:),'r')
						shadedErrorBar(lin(prev+d:prev+d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','r','LineWidth',2})
					end
				end
				text(prev/cumsize,1,cmpt,'Units','normalized')
			end
		end
		hold off
		xticks(lin);
		xticklabels(repmat(xlbl,[1 i*j]));
		ylabel(char(list(k)),'Interpreter','none');
		fig_name = strcat('comp_CTvsGLUvsGABA_',string(list(k)),'.pdf');
		print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
		close(fig);
	end
%sham vs exp
	sham_target = {'GOL'+wildcardPattern+'recall'+wildcardPattern+'_E_',...
	'GOL'+wildcardPattern+'recall'+wildcardPattern+'_Ee_',...
	'GOL'+wildcardPattern+'recall'+wildcardPattern+'_E2_',...
	'GOL'+wildcardPattern+'recall'+wildcardPattern+'_F_'};
	LECglu_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Aa_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_A2_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_B_'};
	LECgaba_target = {'GOL'+wildcardPattern+'learn'+wildcardPattern+'_C_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_Cc_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_C2_',...
	'GOL'+wildcardPattern+'learn'+wildcardPattern+'_D_'};
	s_alt = struct;
	s_alt.LECglu = s_out.LECglu;
	s_alt.LECgaba = s_out.LECgaba;
	groups_alt = fieldnames(s_alt);
	list_alt = fieldnames(s_alt.(char(groups_alt(1))).(char(type(1))));
	list_alt(cellfun(@(c) contains(c,'log'),list_alt)) = [];
	for k=1:size(list_alt,1)
		for j=1:size(type,1)
			for s=1:size(sham_target,2)
				pop = [];
				for i=1:size(groups_alt,1)
					s_alt.sham.(char(type(j))).log = s_alt.(char(groups_alt(i))).(char(type(j))).log;
					target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					if(contains(string(groups_alt(i)),'LECglu'))
						pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						pop = cat(2,pop(:,1),s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2}(:,1),pop(:,2:end));
					end
				end
				s_alt.sham.(char(type(j))).(char(list_alt(k))){target,2} = pop;
				s_alt.sham.(char(type(j))).(char(list_alt(k))){target,3} = mean(pop,2,'omitnan');
				s_alt.sham.(char(type(j))).(char(list_alt(k))){target,4} = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
			end
		end
	end
	groups_alt = fieldnames(s_alt);
	list_alt = fieldnames(s_alt.(char(groups_alt(1))).(char(type(1))));
	list_alt(cellfun(@(c) contains(c,'log'),list_alt)) = [];
	% for k=1:size(list_alt,1)
		% for j=1:size(type,1)
			% for s=1:size(sham_target,2)
				% fig = figure;
				% hold on
				% for i=1:size(groups_alt,1)
					% if(contains(string(groups_alt(i)),'sham'))
						% target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					% end
					% if(contains(string(groups_alt(i)),'LECglu'))
						% target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					% end
					% if(contains(string(groups_alt(i)),'LECgaba'))
						% target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					% end
					% pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					% avg = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,3};
					% sem = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,4};
					% lin = linspace(1,size(pop,1),size(pop,1));
					% if(contains(string(groups_alt(i)),'sham'))
						% plot(lin,pop,'k')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
					% end
					% if(contains(string(groups_alt(i)),'LECglu'))
						% plot(lin,pop,'g')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
					% end
					% if(contains(string(groups_alt(i)),'LECgaba'))
						% plot(lin,pop,'r')
						% shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
					% end
				% end
				% hold off
				% xlabel('days');
				% ylabel(char(list_alt(k)),'Interpreter','none');
				% if(contains(string(type(j)),'s'))
					% cmpt = 'somas';
				% end
				% if(contains(string(type(j)),'ad'))
					% cmpt = 'dendrites';
				% end
				% if(contains(string(sham_target{s}),'_E_'))
					% ssn = 'A';
				% end
				% if(contains(string(sham_target{s}),'_E2_'))
					% ssn = 'A2';
				% end
				% if(contains(string(sham_target{s}),'_Ee_'))
					% ssn = 'Aa';
				% end
				% if(contains(string(sham_target{s}),'_F_'))
					% ssn = 'B';
				% end
				% title(strcat(cmpt,'_',ssn),'Interpreter','none');
				% fig_name = strcat('SHAMvsGLUvsGABA_',cmpt,'_',ssn,'_',string(list_alt(k)),'.pdf');
				% print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				% close(fig);
			% end
		% end
	% end
	s_stats_SHAMvsGLUvsGABA = struct;
	for k=1:size(list_alt,1)
		for j=1:size(type,1)
			for s=1:size(sham_target,2)
				popsize = [];
				for i=1:size(groups_alt,1)
					if(contains(string(groups_alt(i)),'sham'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					popsize(i) = size(pop,1);
				end
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups_alt,1)
					if(contains(string(groups_alt(i)),'sham'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					pop = pop(1:min(popsize),:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							treatment = cat(1,treatment,groups_alt{i});
						end
					end
				end
				data(1) = [];
				treatment(1) = [];			
				[pval,tbl,sts] = anovan(data,{sessions,treatment},'model','interaction','varnames',{'days','treatment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for i=1:size(pval,1)
					outsts{i,1} = tbl{i+1,1};
					outsts{i,2} = tbl{i+1,7};
				end
				for i=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(i,1)},'_vs_',gp_names{mc_sts(i,2)});
					outsts{end,2} = mc_sts(i,6);
				end
				if(contains(string(sham_target{s}),'_E_'))
					ssn = 'A';
				end
				if(contains(string(sham_target{s}),'_E2_'))
					ssn = 'A2';
				end
				if(contains(string(sham_target{s}),'_Ee_'))
					ssn = 'Aa';
				end
				if(contains(string(sham_target{s}),'_F_'))
					ssn = 'B';
				end
				s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(list_alt(k))).(char(ssn)).data = data;
				s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(list_alt(k))).(char(ssn)).sessions = sessions;
				s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(list_alt(k))).(char(ssn)).treatment = treatment;
				s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(list_alt(k))).(char(ssn)).comparisons = outsts;
			end
		end
	end
	c_pval_SHAMvsGLUvsGABA = {};
	type = fieldnames(s_stats_SHAMvsGLUvsGABA);
	for j=1:size(type,1)
		metric = fieldnames(s_stats_SHAMvsGLUvsGABA.(char(type(j))));
		for k=1:size(metric,1)
			session = fieldnames(s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(metric(k))));
			for s=1:size(session,1)
				c_pval_SHAMvsGLUvsGABA{end+1,1} = strcat(char(type(j)),'_',char(metric(k)),'_',char(session(s)));
				c_pval_SHAMvsGLUvsGABA{end,2} = s_stats_SHAMvsGLUvsGABA.(char(type(j))).(char(metric(k))).(char(session(s))).comparisons{2,2};
			end
		end
	end
	[~,pidx] = sort(cell2mat(c_pval_SHAMvsGLUvsGABA(:,2)));
	c_pval_SHAMvsGLUvsGABA_sort = c_pval_SHAMvsGLUvsGABA(pidx,:);
	for k=1:size(list_alt,1)
		for j=1:size(type,1)
			for s=1:size(sham_target,2)
				popsize = [];
				for i=1:size(groups_alt,1)
					if(contains(string(groups_alt(i)),'sham'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					popsize(i) = size(pop,1);
				end
			end
			for i=1:size(groups_alt,1)
				temp = nan;
				for s=1:size(sham_target,2)
					if(contains(string(groups_alt(i)),'sham'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,sham_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECglu'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECglu_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						target = find(cell2mat(cellfun(@(c) any(contains(c,LECgaba_target{s})),s_alt.(char(groups_alt(i))).(char(type(j))).log,'UniformOutput',false)));
					end
					pop = s_alt.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))){target,2};
					pop = pop(1:min(popsize),:);
					pop = reshape(pop',[1 size(pop,1)*size(pop,2)]);
					if(s == 1)
						temp = pop;
					else
						temp = cat(1,temp,pop);
					end
				end
				s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))) = temp(:,1:size(temp,2)/min(popsize));
				for d=1+size(temp,2)/min(popsize):size(temp,2)/min(popsize):size(temp,2)
					s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))) = cat(1,s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))),temp(:,d:d-1+size(temp,2)/min(popsize)));
				end
			end
		end
	end
	for k=1:size(list_alt,1)
		for j=1:size(type,1)
			for i=1:size(groups_alt,1)
				s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(strcat(char(list_alt(k)),'_avg')) = mean(s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))),2,'omitnan');
				s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(strcat(char(list_alt(k)),'_sem')) = std(s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))),0,2,'omitnan')/sqrt(size(s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k))),2));
			end
		end
	end
	xlbl = {'d1A','d1Aa','d1A2','d1B',...
	'd2A','d2Aa','d2A2','d2B',...
	'd3A','d3Aa','d3A2','d3B',...
	'd4A','d4Aa','d4A2','d4B',...
	'd5A','d5Aa','d5A2','d5B',...
	'd6A','d6Aa','d6A2','d6B',...
	'd7A','d7Aa','d7A2','d7B'};
	period = 4;
	for k=1:size(list_alt,1)
		for j=1:size(type,1)
			fig = figure;
			hold on
			for i=1:size(groups_alt,1)
				pop = s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(char(list_alt(k)));
				lin = linspace(1,size(pop,1),size(pop,1));
				avg = s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(strcat(char(list_alt(k)),'_avg'));
				sem = s_comp_SHAMvsGLUvsGABA.(char(groups_alt(i))).(char(type(j))).(strcat(char(list_alt(k)),'_sem'));
				for d=1:period:size(pop,1)
					if(contains(string(groups_alt(i)),'sham'))
						plot(lin(d:d+period-1),pop(d:d+period-1,:),'k')
						shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','k','LineWidth',2})
					end
					if(contains(string(groups_alt(i)),'LECglu'))
						plot(lin(d:d+period-1),pop(d:d+period-1,:),'g')
						shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','g','LineWidth',2})
					end
					if(contains(string(groups_alt(i)),'LECgaba'))
						plot(lin(d:d+period-1),pop(d:d+period-1,:),'r')
						shadedErrorBar(lin(d:d+period-1),avg(d:d+period-1,:),sem(d:d+period-1,:),'lineProps',{'Color','r','LineWidth',2})
					end
				end
			end
			hold off
			xticks(lin);
			xticklabels(xlbl);
			ylabel(char(list_alt(k)),'Interpreter','none');
			if(contains(string(type(j)),'s'))
				cmpt = 'somas';
			end
			if(contains(string(type(j)),'ad'))
				cmpt = 'dendrites';
			end
			fig_name = strcat('comp_SHAMvsGLUvsGABA_',cmpt,'_',string(list_alt(k)),'.pdf');
			print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
			close(fig);
		end
	end
end