function [] = spatial_metrics_stats()
	input = 'C:\root\hpc\s_maps_S_DxA.mat';
	load(input);
	output = 'C:\root\hpc\S_DxA';
%process data
	s_work = struct;
	groups = fieldnames(s_map);
	for i=1:size(groups,1)
		type = fieldnames(s_map.(char(groups(i))));
		for j=1:size(type,1)
			log = s_map.(char(groups(i))).(char(type(j))).log;
			for k=1:size(log,1)
				s_work.(char(groups(i))).(char(type(j))).id{k,1} = strings(size(log{k},1),1);
				for x=1:size(log{k},1)
					y=1;
					while(isempty(log{k}{x,y}))
						y=y+1;
					end
					id = log{k}{x,y};
					id = replace(id,'_m'+digitsPattern+'_','');
					id = replace(id,'_t-'+digitsPattern(3),'');
					id = replace(id,'VR_'+digitsPattern(6),'');
					s_work.(char(groups(i))).(char(type(j))).id{k,1}(x,1) = id;
				end
			end
			ref = s_work.(char(groups(i))).(char(type(j))).id;
			idx = cellfun(@(c) contains(c,'GOL'+wildcardPattern+'learn'),ref,'UniformOutput',false);
			target = find(cellfun(@any,idx));
			s_work.(char(groups(i))).(char(type(j))).id = s_work.(char(groups(i))).(char(type(j))).id(target);
			data = fieldnames(s_map.(char(groups(i))).(char(type(j))));
			for k=1:size(data,1)
				s_work.(char(groups(i))).(char(type(j))).(char(data(k))) = s_map.(char(groups(i))).(char(type(j))).(char(data(k)))(target);
			end
		end
	end
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatment
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			for k=1:size(s_work.(char(groups(i))).(char(type(j))).log,1) %contexts
				for x=1:size(s_work.(char(groups(i))).(char(type(j))).log{k},1) %sessions
					for y=1:size(s_work.(char(groups(i))).(char(type(j))).log{k},2) %animals
						ALL_map = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
						PC_bin = s_work.(char(groups(i))).(char(type(j))).PC_bin{k}{x,y};
						ON_bin = any(ALL_map,2);
						PC_idx = find(PC_bin);
						ON_idx = find(ON_bin);
						H1_map = s_work.(char(groups(i))).(char(type(j))).H1_map{k}{x,y};
						H2_map = s_work.(char(groups(i))).(char(type(j))).H2_map{k}{x,y};
						H1_map = zscore(H1_map,0,2);
						H2_map = zscore(H2_map,0,2);
						H1_on = any(H1_map,2);
						H2_on = any(H2_map,2);
						H1_idx = find(H1_on);
						H2_idx = find(H2_on);
						s_work.(char(groups(i))).(char(type(j))).ON_bin{k,1}{x,y} = ON_bin;
						s_work.(char(groups(i))).(char(type(j))).PC_idx{k,1}{x,y} = PC_idx;
						s_work.(char(groups(i))).(char(type(j))).ON_idx{k,1}{x,y} = ON_idx;
						s_work.(char(groups(i))).(char(type(j))).H1_map{k,1}{x,y} = H1_map;
						s_work.(char(groups(i))).(char(type(j))).H2_map{k,1}{x,y} = H2_map;
						s_work.(char(groups(i))).(char(type(j))).H1_on{k,1}{x,y} = H1_on;
						s_work.(char(groups(i))).(char(type(j))).H2_on{k,1}{x,y} = H2_on;
						s_work.(char(groups(i))).(char(type(j))).H1_idx{k,1}{x,y} = H1_idx;
						s_work.(char(groups(i))).(char(type(j))).H2_idx{k,1}{x,y} = H2_idx;
					end
				end
			end
		end
	end
	s_halves = struct;
	span = 5;
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatment
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			for k=1:size(s_work.(char(groups(i))).(char(type(j))).log,1) %contexts
				s_halves.(char(groups(i))).(char(type(j))).log{k,1} = s_work.(char(groups(i))).(char(type(j))).log{k};
				s_halves.(char(groups(i))).(char(type(j))).id{k,1} = s_work.(char(groups(i))).(char(type(j))).id{k};
				s_halves.(char(groups(i))).(char(type(j))).PV_map{k,1} = cell(span,size(s_work.(char(groups(i))).(char(type(j))).log{k},2));
				s_halves.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = NaN(span,size(s_work.(char(groups(i))).(char(type(j))).log{k},2));
				s_halves.(char(groups(i))).(char(type(j))).H1_map{k,1} = cell(span,size(s_work.(char(groups(i))).(char(type(j))).log{k},2));
				s_halves.(char(groups(i))).(char(type(j))).H2_map{k,1} = cell(span,size(s_work.(char(groups(i))).(char(type(j))).log{k},2));
				for x=1:span %sessions
					for y=1:size(s_work.(char(groups(i))).(char(type(j))).log{k},2) %animals
						try
							H1_map = s_work.(char(groups(i))).(char(type(j))).H1_map{k,1}{x,y};
							H2_map = s_work.(char(groups(i))).(char(type(j))).H2_map{k,1}{x,y};
							H1_idx = s_work.(char(groups(i))).(char(type(j))).H1_idx{k,1}{x,y};
							H2_idx = s_work.(char(groups(i))).(char(type(j))).H2_idx{k,1}{x,y};
							H12_idx = intersect(H1_idx,H2_idx);
							H1_map = H1_map(H12_idx,:);
							H2_map = H2_map(H12_idx,:);
							PV_map = corr(H1_map,H2_map,'rows','pairwise');
							PV_coeff = mean(diag(PV_map),'omitnan');
							[~,pk] = max(H1_map,[],2);
							[~,ix] = sort(pk);
							H1_map = H1_map(ix,:);
							H2_map = H2_map(ix,:);
							s_halves.(char(groups(i))).(char(type(j))).PV_map{k,1}{x,y} = PV_map;
							s_halves.(char(groups(i))).(char(type(j))).PV_coeff{k,1}(x,y) = PV_coeff;
							s_halves.(char(groups(i))).(char(type(j))).H1_map{k,1}{x,y} = H1_map;
							s_halves.(char(groups(i))).(char(type(j))).H2_map{k,1}{x,y} = H2_map;
						end
					end
				end
			end
		end
	end
	span = 5;
	groups = fieldnames(s_halves);
	type = fieldnames(s_halves.(char(groups(1))));
	list = fieldnames(s_halves.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_halves.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_halves.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_halves.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_halves.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 5])
				xticks([1:1:5])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('halves_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_halves_treatments = struct;
	span = 5;
	groups = fieldnames(s_halves);
	type = fieldnames(s_halves.(char(groups(1))));
	list = fieldnames(s_halves.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_halves.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_halves.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_halves.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_halves.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_halves_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_halves_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_halves_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_halves_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_halves_compartments = struct;
	span = 5;
	groups = fieldnames(s_halves);
	type = fieldnames(s_halves.(char(groups(1))));
	list = fieldnames(s_halves.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_halves.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_halves.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_halves.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_halves.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_halves_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_halves_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_halves_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_halves_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_halves_envs = struct;
	span = 5;
	groups = fieldnames(s_halves);
	type = fieldnames(s_halves.(char(groups(1))));
	list = fieldnames(s_halves.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_halves.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_halves.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_halves.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_halves.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_halves_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_halves_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_halves_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_halves_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	s_cross = struct;
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatments
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			Ns = size(s_work.(char(groups(i))).(char(type(j))).log,1);
			Nd = size(s_work.(char(groups(i))).(char(type(j))).log{1},1);
			Nm = size(s_work.(char(groups(i))).(char(type(j))).log{1},2);
			kz = 1;
			for k=1:Ns %sessions
				for z=k+1:Ns %pairs
					s_cross.(char(groups(i))).(char(type(j))).id{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PV_idx{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PC_idx{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).TC_idx{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PC_map_ref{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PC_map_test{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PV_map{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).PV_coeff{kz,1} = NaN(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).TC_map{kz,1} = cell(Nd,Nm);
					s_cross.(char(groups(i))).(char(type(j))).TC_coeff{kz,1} = NaN(Nd,Nm);
					for x=1:Nd %days
						for y=1:Nm %mice
							try
								id = s_work.(char(groups(i))).(char(type(j))).log{k}{x,y};
								id = strcat(id,'_vs_',s_work.(char(groups(i))).(char(type(j))).log{z}{x,y});
								id = replace(id,'_t-'+digitsPattern(3),'');
								onK = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{x,y};
								onZ = s_work.(char(groups(i))).(char(type(j))).ON_idx{z}{x,y};
								PV_idx = intersect(onK,onZ);
								pcK = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{x,y};
								pcZ = s_work.(char(groups(i))).(char(type(j))).PC_idx{z}{x,y};
								PC_idx = union(pcK,pcZ);
								TC_idx = intersect(PV_idx,PC_idx);
								PC_mapK = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
								PC_mapZ = s_work.(char(groups(i))).(char(type(j))).ALL_map{z}{x,y};
								PC_mapK = PC_mapK(pcK,:);
								PC_mapZ = PC_mapZ(pcK,:);
								[~,pk] = max(PC_mapK,[],2);
								[~,ix] = sort(pk);
								PC_mapK = PC_mapK(ix,:);
								PC_mapZ = PC_mapZ(ix,:);
								PV_mapK = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
								PV_mapZ = s_work.(char(groups(i))).(char(type(j))).ALL_map{z}{x,y};
								PV_mapK = PV_mapK(PV_idx,:);
								PV_mapZ = PV_mapZ(PV_idx,:);
								PV_map = corr(PV_mapK,PV_mapZ,'rows','pairwise');
								PV_coeff = mean(diag(PV_map),'omitnan');
								TC_mapK = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
								TC_mapZ = s_work.(char(groups(i))).(char(type(j))).ALL_map{z}{x,y};
								TC_mapK = TC_mapK(TC_idx,:);
								TC_mapZ = TC_mapZ(TC_idx,:);
								TC_map = corr(TC_mapK',TC_mapZ','rows','pairwise');
								TC_coeff = mean(diag(TC_map),'omitnan');
								s_cross.(char(groups(i))).(char(type(j))).id{kz,1}{x,y} = id;
								s_cross.(char(groups(i))).(char(type(j))).PV_idx{kz,1}{x,y} = PV_idx;
								s_cross.(char(groups(i))).(char(type(j))).PC_idx{kz,1}{x,y}= PC_idx;
								s_cross.(char(groups(i))).(char(type(j))).TC_idx{kz,1}{x,y} = TC_idx;
								s_cross.(char(groups(i))).(char(type(j))).PC_map_ref{kz,1}{x,y} = PC_mapK;
								s_cross.(char(groups(i))).(char(type(j))).PC_map_test{kz,1}{x,y} = PC_mapZ;
								s_cross.(char(groups(i))).(char(type(j))).PV_map{kz,1}{x,y} = PV_map;
								s_cross.(char(groups(i))).(char(type(j))).PV_coeff{kz,1}(x,y) = PV_coeff;
								s_cross.(char(groups(i))).(char(type(j))).TC_map{kz,1}{x,y} = TC_map;
								s_cross.(char(groups(i))).(char(type(j))).TC_coeff{kz,1}(x,y) = TC_coeff;
							end
						end
					end
					kz = kz+1;
				end
			end
		end
	end
	span = 5;
	groups = fieldnames(s_cross);
	type = fieldnames(s_cross.(char(groups(1))));
	list = fieldnames(s_cross.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_cross.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_cross.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_cross.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_cross.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 5])
				xticks([1:1:5])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('cross_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_cross_treatments = struct;
	span = 5;
	groups = fieldnames(s_cross);
	type = fieldnames(s_cross.(char(groups(1))));
	list = fieldnames(s_cross.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_cross.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_cross.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_cross.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_cross.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_cross_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_cross_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_cross_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_cross_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_cross_compartments = struct;
	span = 5;
	groups = fieldnames(s_cross);
	type = fieldnames(s_cross.(char(groups(1))));
	list = fieldnames(s_cross.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_cross.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_cross.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_cross.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_cross.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_cross_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_cross_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_cross_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_cross_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_cross_envs = struct;
	span = 5;
	groups = fieldnames(s_cross);
	type = fieldnames(s_cross.(char(groups(1))));
	list = fieldnames(s_cross.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_cross.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_cross.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_cross.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_cross.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_cross_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_cross_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_cross_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_cross_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	s_last = struct;
	L = 5;
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatments
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			Ns = size(s_work.(char(groups(i))).(char(type(j))).log,1);
			Nm = size(s_work.(char(groups(i))).(char(type(j))).log{1},2);
			for k=1:Ns %sessions
				s_last.(char(groups(i))).(char(type(j))).id{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PV_idx{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PC_idx{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).TC_idx{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PC_map_ref{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PC_map_test{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PV_map{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = NaN(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).TC_map{k,1} = cell(L-1,Nm);
				s_last.(char(groups(i))).(char(type(j))).TC_coeff{k,1} = NaN(L-1,Nm);
				for x=1:L-1 %days
					for y=1:Nm %mice
						try
							id = s_work.(char(groups(i))).(char(type(j))).log{k}{x,y};
							id = strcat(id,'_vs_',s_work.(char(groups(i))).(char(type(j))).log{k}{L,y});
							id = replace(id,'_t-'+digitsPattern(3),'');
							onX = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{x,y};
							onL = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{L,y};
							PV_idx = intersect(onX,onL);
							pcX = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{x,y};
							pcL = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{L,y};
							PC_idx = union(pcX,pcL);
							TC_idx = intersect(PV_idx,PC_idx);
							PC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							PC_mapL = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{L,y};
							PC_mapX = PC_mapX(pcL,:);
							PC_mapL = PC_mapL(pcL,:);
							[~,pk] = max(PC_mapL,[],2);
							[~,ix] = sort(pk);
							PC_mapX = PC_mapX(ix,:);
							PC_mapL = PC_mapL(ix,:);
							PV_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							PV_mapL = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{L,y};
							PV_mapX = PV_mapX(PV_idx,:);
							PV_mapL = PV_mapL(PV_idx,:);
							PV_map = corr(PV_mapX,PV_mapL,'rows','pairwise');
							PV_coeff = mean(diag(PV_map),'omitnan');
							TC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							TC_mapL = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{L,y};
							TC_mapX = TC_mapX(TC_idx,:);
							TC_mapL = TC_mapL(TC_idx,:);
							TC_map = corr(TC_mapX',TC_mapL','rows','pairwise');
							TC_coeff = mean(diag(TC_map),'omitnan');
							s_last.(char(groups(i))).(char(type(j))).id{k,1}{x,y} = id;
							s_last.(char(groups(i))).(char(type(j))).PV_idx{k,1}{x,y} = PV_idx;
							s_last.(char(groups(i))).(char(type(j))).PC_idx{k,1}{x,y}= PC_idx;
							s_last.(char(groups(i))).(char(type(j))).TC_idx{k,1}{x,y} = TC_idx;
							s_last.(char(groups(i))).(char(type(j))).PC_map_ref{k,1}{x,y} = PC_mapL;
							s_last.(char(groups(i))).(char(type(j))).PC_map_test{k,1}{x,y} = PC_mapX;
							s_last.(char(groups(i))).(char(type(j))).PV_map{k,1}{x,y} = PV_map;
							s_last.(char(groups(i))).(char(type(j))).PV_coeff{k,1}(x,y) = PV_coeff;
							s_last.(char(groups(i))).(char(type(j))).TC_map{k,1}{x,y} = TC_map;
							s_last.(char(groups(i))).(char(type(j))).TC_coeff{k,1}(x,y) = TC_coeff;
						end
					end
				end
			end
		end
	end
	span = 4;
	groups = fieldnames(s_last);
	type = fieldnames(s_last.(char(groups(1))));
	list = fieldnames(s_last.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_last.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_last.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_last.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_last.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 4])
				xticks([1:1:4])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('last_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_last_treatments = struct;
	span = 4;
	groups = fieldnames(s_last);
	type = fieldnames(s_last.(char(groups(1))));
	list = fieldnames(s_last.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_last.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_last.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_last.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_last.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_last_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_last_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_last_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_last_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_last_compartments = struct;
	span = 4;
	groups = fieldnames(s_last);
	type = fieldnames(s_last.(char(groups(1))));
	list = fieldnames(s_last.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_last.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_last.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_last.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_last.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_last_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_last_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_last_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_last_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_last_envs = struct;
	span = 4;
	groups = fieldnames(s_last);
	type = fieldnames(s_last.(char(groups(1))));
	list = fieldnames(s_last.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_last.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_last.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_last.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_last.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_last_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_last_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_last_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_last_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	s_pair = struct;
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatments
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			Ns = size(s_work.(char(groups(i))).(char(type(j))).log,1);
			Nd = size(s_work.(char(groups(i))).(char(type(j))).log{1},1);
			Nm = size(s_work.(char(groups(i))).(char(type(j))).log{1},2);
			for k=1:Ns %sessions
				s_pair.(char(groups(i))).(char(type(j))).id{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PV_idx{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PC_idx{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).TC_idx{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PC_map_ref{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PC_map_test{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PV_map{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = NaN(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).TC_map{k,1} = cell(Nd-1,Nm);
				s_pair.(char(groups(i))).(char(type(j))).TC_coeff{k,1} = NaN(Nd-1,Nm);
				for x=1:Nd-1 %days
					for y=1:Nm %mice
						try
							id = s_work.(char(groups(i))).(char(type(j))).log{k}{x,y};
							id = strcat(id,'_vs_',s_work.(char(groups(i))).(char(type(j))).log{k}{x+1,y});
							id = replace(id,'_t-'+digitsPattern(3),'');
							onX = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{x,y};
							onN = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{x+1,y};
							PV_idx = intersect(onX,onN);
							pcX = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{x,y};
							pcN = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{x+1,y};
							PC_idx = union(pcX,pcN);
							TC_idx = intersect(PV_idx,PC_idx);
							PC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							PC_mapN = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x+1,y};
							PC_mapX = PC_mapX(pcX,:);
							PC_mapN = PC_mapN(pcX,:);
							[~,pk] = max(PC_mapX,[],2);
							[~,ix] = sort(pk);
							PC_mapX = PC_mapX(ix,:);
							PC_mapN = PC_mapN(ix,:);
							PV_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							PV_mapN = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x+1,y};
							PV_mapX = PV_mapX(PV_idx,:);
							PV_mapN = PV_mapN(PV_idx,:);
							PV_map = corr(PV_mapX,PV_mapN,'rows','pairwise');
							PV_coeff = mean(diag(PV_map),'omitnan');
							TC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x,y};
							TC_mapN = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{x+1,y};
							TC_mapX = TC_mapX(TC_idx,:);
							TC_mapN = TC_mapN(TC_idx,:);
							TC_map = corr(TC_mapX',TC_mapN','rows','pairwise');
							TC_coeff = mean(diag(TC_map),'omitnan');
							s_pair.(char(groups(i))).(char(type(j))).id{k,1}{x,y} = id;
							s_pair.(char(groups(i))).(char(type(j))).PV_idx{k,1}{x,y} = PV_idx;
							s_pair.(char(groups(i))).(char(type(j))).PC_idx{k,1}{x,y}= PC_idx;
							s_pair.(char(groups(i))).(char(type(j))).TC_idx{k,1}{x,y} = TC_idx;
							s_pair.(char(groups(i))).(char(type(j))).PC_map_ref{k,1}{x,y} = PC_mapX;
							s_pair.(char(groups(i))).(char(type(j))).PC_map_test{k,1}{x,y} = PC_mapN;
							s_pair.(char(groups(i))).(char(type(j))).PV_map{k,1}{x,y} = PV_map;
							s_pair.(char(groups(i))).(char(type(j))).PV_coeff{k,1}(x,y) = PV_coeff;
							s_pair.(char(groups(i))).(char(type(j))).TC_map{k,1}{x,y} = TC_map;
							s_pair.(char(groups(i))).(char(type(j))).TC_coeff{k,1}(x,y) = TC_coeff;
						end
					end
				end
			end
		end
	end
	span = 4;
	groups = fieldnames(s_pair);
	type = fieldnames(s_pair.(char(groups(1))));
	list = fieldnames(s_pair.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_pair.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_pair.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_pair.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 4])
				xticks([1:1:4])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('pair_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_pair_treatments = struct;
	span = 4;
	groups = fieldnames(s_pair);
	type = fieldnames(s_pair.(char(groups(1))));
	list = fieldnames(s_pair.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_pair.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_pair.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_pair.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_pair_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_pair_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_pair_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_pair_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_pair_compartments = struct;
	span = 4;
	groups = fieldnames(s_pair);
	type = fieldnames(s_pair.(char(groups(1))));
	list = fieldnames(s_pair.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_pair.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_pair.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_pair.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_pair_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_pair_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_pair_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_pair_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_pair_envs = struct;
	span = 4;
	groups = fieldnames(s_pair);
	type = fieldnames(s_pair.(char(groups(1))));
	list = fieldnames(s_pair.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_pair.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_pair.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_pair.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_pair.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_pair_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_pair_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_pair_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_pair_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	s_mid = struct;
	groups = fieldnames(s_work);
	for i=1:size(groups,1) %treatments
		type = fieldnames(s_work.(char(groups(i))));
		for j=1:size(type,1) %compartments
			Ns = size(s_work.(char(groups(i))).(char(type(j))).log,1);
			Nm = size(s_work.(char(groups(i))).(char(type(j))).log{1},2);
			for k=1:Ns %sessions
				s_mid.(char(groups(i))).(char(type(j))).id{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PV_idx{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PC_idx{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).TC_idx{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PC_map_ref{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PC_map_test{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PV_map{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = NaN(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).TC_map{k,1} = cell(2,Nm);
				s_mid.(char(groups(i))).(char(type(j))).TC_coeff{k,1} = NaN(2,Nm);
				for y=1:Nm %mice
					try
						id = s_work.(char(groups(i))).(char(type(j))).log{k}{3,y};
						id = strcat(id,'_vs_',s_work.(char(groups(i))).(char(type(j))).log{k}{1,y});
						id = replace(id,'_t-'+digitsPattern(3),'');
						onX = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{3,y};
						onY = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{1,y};
						PV_idx = intersect(onX,onY);
						pcX = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{3,y};
						pcY = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{1,y};
						PC_idx = union(pcX,pcY);
						TC_idx = intersect(PV_idx,PC_idx);
						PC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						PC_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{1,y};
						PC_mapX = PC_mapX(pcX,:);
						PC_mapY = PC_mapY(pcX,:);
						[~,pk] = max(PC_mapX,[],2);
						[~,ix] = sort(pk);
						PC_mapX = PC_mapX(ix,:);
						PC_mapY = PC_mapY(ix,:);
						PV_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						PV_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{1,y};
						PV_mapX = PV_mapX(PV_idx,:);
						PV_mapY = PV_mapY(PV_idx,:);
						PV_map = corr(PV_mapX,PV_mapY,'rows','pairwise');
						PV_coeff = mean(diag(PV_map),'omitnan');
						TC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						TC_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{1,y};
						TC_mapX = TC_mapX(TC_idx,:);
						TC_mapY = TC_mapY(TC_idx,:);
						TC_map = corr(TC_mapX',TC_mapY','rows','pairwise');
						TC_coeff = mean(diag(TC_map),'omitnan');
						s_mid.(char(groups(i))).(char(type(j))).id{k,1}{1,y} = id;
						s_mid.(char(groups(i))).(char(type(j))).PV_idx{k,1}{1,y} = PV_idx;
						s_mid.(char(groups(i))).(char(type(j))).PC_idx{k,1}{1,y}= PC_idx;
						s_mid.(char(groups(i))).(char(type(j))).TC_idx{k,1}{1,y} = TC_idx;
						s_mid.(char(groups(i))).(char(type(j))).PC_map_ref{k,1}{1,y} = PC_mapX;
						s_mid.(char(groups(i))).(char(type(j))).PC_map_test{k,1}{1,y} = PC_mapY;
						s_mid.(char(groups(i))).(char(type(j))).PV_map{k,1}{1,y} = PV_map;
						s_mid.(char(groups(i))).(char(type(j))).PV_coeff{k,1}(1,y) = PV_coeff;
						s_mid.(char(groups(i))).(char(type(j))).TC_map{k,1}{1,y} = TC_map;
						s_mid.(char(groups(i))).(char(type(j))).TC_coeff{k,1}(1,y) = TC_coeff;
					end
					try
						id = s_work.(char(groups(i))).(char(type(j))).log{k}{3,y};
						id = strcat(id,'_vs_',s_work.(char(groups(i))).(char(type(j))).log{k}{5,y});
						id = replace(id,'_t-'+digitsPattern(3),'');
						onX = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{3,y};
						onY = s_work.(char(groups(i))).(char(type(j))).ON_idx{k}{5,y};
						PV_idx = intersect(onX,onY);
						pcX = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{3,y};
						pcY = s_work.(char(groups(i))).(char(type(j))).PC_idx{k}{5,y};
						PC_idx = union(pcX,pcY);
						TC_idx = intersect(PV_idx,PC_idx);
						PC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						PC_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{5,y};
						PC_mapX = PC_mapX(pcX,:);
						PC_mapY = PC_mapY(pcX,:);
						[~,pk] = max(PC_mapX,[],2);
						[~,ix] = sort(pk);
						PC_mapX = PC_mapX(ix,:);
						PC_mapY = PC_mapY(ix,:);
						PV_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						PV_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{5,y};
						PV_mapX = PV_mapX(PV_idx,:);
						PV_mapY = PV_mapY(PV_idx,:);
						PV_map = corr(PV_mapX,PV_mapY,'rows','pairwise');
						PV_coeff = mean(diag(PV_map),'omitnan');
						TC_mapX = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{3,y};
						TC_mapY = s_work.(char(groups(i))).(char(type(j))).ALL_map{k}{5,y};
						TC_mapX = TC_mapX(TC_idx,:);
						TC_mapY = TC_mapY(TC_idx,:);
						TC_map = corr(TC_mapX',TC_mapY','rows','pairwise');
						TC_coeff = mean(diag(TC_map),'omitnan');
						s_mid.(char(groups(i))).(char(type(j))).id{k,1}{2,y} = id;
						s_mid.(char(groups(i))).(char(type(j))).PV_idx{k,1}{2,y} = PV_idx;
						s_mid.(char(groups(i))).(char(type(j))).PC_idx{k,1}{2,y}= PC_idx;
						s_mid.(char(groups(i))).(char(type(j))).TC_idx{k,1}{2,y} = TC_idx;
						s_mid.(char(groups(i))).(char(type(j))).PC_map_ref{k,1}{2,y} = PC_mapX;
						s_mid.(char(groups(i))).(char(type(j))).PC_map_test{k,1}{2,y} = PC_mapY;
						s_mid.(char(groups(i))).(char(type(j))).PV_map{k,1}{2,y} = PV_map;
						s_mid.(char(groups(i))).(char(type(j))).PV_coeff{k,1}(2,y) = PV_coeff;
						s_mid.(char(groups(i))).(char(type(j))).TC_map{k,1}{2,y} = TC_map;
						s_mid.(char(groups(i))).(char(type(j))).TC_coeff{k,1}(2,y) = TC_coeff;					
					end
				end
			end
		end
	end
	span = 2;
	groups = fieldnames(s_mid);
	type = fieldnames(s_mid.(char(groups(1))));
	list = fieldnames(s_mid.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_mid.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_mid.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_mid.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_mid.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 span])
				xticks([1:1:span])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('mid_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_mid_treatments = struct;
	span = 2;
	groups = fieldnames(s_mid);
	type = fieldnames(s_mid.(char(groups(1))));
	list = fieldnames(s_mid.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_mid.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_mid.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_mid.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_mid.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_mid_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_mid_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_mid_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_mid_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_mid_compartments = struct;
	span = 2;
	groups = fieldnames(s_mid);
	type = fieldnames(s_mid.(char(groups(1))));
	list = fieldnames(s_mid.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_mid.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_mid.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_mid.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_mid.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_mid_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_mid_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_mid_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_mid_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_mid_envs = struct;
	span = 2;
	groups = fieldnames(s_mid);
	type = fieldnames(s_mid.(char(groups(1))));
	list = fieldnames(s_mid.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_mid.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_mid.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_mid.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_mid.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				% [mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',1,'display','off');
				% [mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_mid_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_mid_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_mid_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_mid_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	s_pair_delta = struct;
	groups = fieldnames(s_pair);
	for i=1:size(groups,1) %treatments
		type = fieldnames(s_pair.(char(groups(i))));
		for j=1:size(type,1) %compartments
			Ns = size(s_pair.(char(groups(i))).(char(type(j))).id,1);
			Nd = size(s_pair.(char(groups(i))).(char(type(j))).id{1},1);
			Nm = size(s_pair.(char(groups(i))).(char(type(j))).id{1},2);
			for k=1:Ns %sessions
				s_pair_delta.(char(groups(i))).(char(type(j))).id{k,1} = cell(Nd,Nm);
				s_pair_delta.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = NaN(Nd,Nm);
				s_pair_delta.(char(groups(i))).(char(type(j))).TC_coeff{k,1} = NaN(Nd,Nm);
				s_pair_delta.(char(groups(i))).(char(type(j))).id{k,1} = s_pair.(char(groups(i))).(char(type(j))).id{k,1};
				s_pair_delta.(char(groups(i))).(char(type(j))).PV_coeff{k,1} = diff(s_pair.(char(groups(i))).(char(type(j))).PV_coeff{k,1},1,1);
				s_pair_delta.(char(groups(i))).(char(type(j))).TC_coeff{k,1} = diff(s_pair.(char(groups(i))).(char(type(j))).TC_coeff{k,1},1,1);
			end
		end
	end
	span = 3;
	groups = fieldnames(s_pair_delta);
	type = fieldnames(s_pair_delta.(char(groups(1))));
	list = fieldnames(s_pair_delta.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1)
		for j=1:size(type,1)
			for k=1:size(s_pair_delta.(char(groups(1))).(char(type(j))).id,1)
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair_delta.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_pair_delta.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				if(strcmp(char(type(j)),'s') == 1)
					id = strcat('somas_',id);
				end
				if(strcmp(char(type(j)),'ad') == 1)
					id = strcat('dendrites_',id);
				end
				fig = figure;
				hold on
				for i=1:size(groups,1)
					pop = s_pair_delta.(char(groups(i))).(char(type(j))).(char(list(z))){k}(1:span,:);
					avg = mean(pop,2,'omitnan');
					sem = std(pop,0,2,'omitnan')/sqrt(size(pop,2));
					lin = linspace(1,size(pop,1),size(pop,1));
					if(contains(string(groups(i)),'control'))
						plot(lin,pop,'k')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','k','LineWidth',2})
						id = strcat('CT_',id);
					end
					if(contains(string(groups(i)),'LECglu'))
						plot(lin,pop,'g')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','g','LineWidth',2})
						id = strcat('GLU_',id);
					end
					if(contains(string(groups(i)),'LECgaba'))
						plot(lin,pop,'r')
						shadedErrorBar(lin,avg,sem,'lineProps',{'Color','r','LineWidth',2})
						id = strcat('GABA_',id);
					end
				end
				hold off
				xlabel('days');
				xlim([1 span])
				xticks([1:1:span])
				ylabel('correlation');
				ylim([-1 1])
				yticks([-1:0.2:1])
				yline(0);
				id = strcat('pair_delta_',char(list(z)),'_',id);
				title(id,'Interpreter','none');
				fig_name = strcat(id,'.pdf');
				print(fullfile(output,fig_name),'-dpdf','-r300','-bestfit');
				close(fig);
			end
		end
	end
	s_stats_pair_delta_treatments = struct;
	span = 3;
	groups = fieldnames(s_pair_delta);
	type = fieldnames(s_pair_delta.(char(groups(1))));
	list = fieldnames(s_pair_delta.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for j=1:size(type,1) %compartments
			for k=1:size(s_pair_delta.(char(groups(1))).(char(type(j))).id,1) %contexts
				data = nan;
				sessions = [];
				treatment = strings;
				for i=1:size(groups,1) %treatments
					pop = s_pair_delta.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
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
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair_delta.(char(groups(1))).(char(type(j))).id{k}),1);
				id = s_pair_delta.(char(groups(1))).(char(type(j))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_pair_delta_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_pair_delta_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_pair_delta_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).treatment = treatment;
				s_stats_pair_delta_treatments.(char(type(j))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_pair_delta_compartments = struct;
	span = 3;
	groups = fieldnames(s_pair_delta);
	type = fieldnames(s_pair_delta.(char(groups(1))));
	list = fieldnames(s_pair_delta.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for k=1:size(s_pair_delta.(char(groups(i))).(char(type(1))).id,1) %contexts
				popsize = [];
				data = nan;
				sessions = [];
				compartment = strings;
				for j=1:size(type,1) %compartments
					pop = s_pair_delta.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							compartment = cat(1,compartment,type{j});
						end
					end
				end
				data(1) = [];
				compartment(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,compartment},'model','interaction','varnames',{'days','compartment'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',2,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				[x,y] = find(cellfun(@(c) ~isempty(c),s_pair_delta.(char(groups(i))).(char(type(1))).id{k}),1);
				id = s_pair_delta.(char(groups(i))).(char(type(1))).id{k}{x,y};
				id = replace(id,'_m'+digitsPattern+'_','');
				id = replace(id,'_t-'+digitsPattern(3),'');
				id = replace(id,'VR_'+digitsPattern(6),'');
				id = replace(id,'_d'+digitsPattern(1)+'_','_');
				s_stats_pair_delta_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).data = data;
				s_stats_pair_delta_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).sessions = sessions;
				s_stats_pair_delta_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).compartment = compartment;
				s_stats_pair_delta_compartments.(char(groups(i))).(strcat(char(list(z)),'_',id)).comparisons = outsts;
			end
		end
	end
	s_stats_pair_delta_envs = struct;
	span = 3;
	groups = fieldnames(s_pair_delta);
	type = fieldnames(s_pair_delta.(char(groups(1))));
	list = fieldnames(s_pair_delta.(char(groups(1))).(char(type(1))));
	list = list(find(contains(list,'coeff')));
	for z=1:size(list,1) %metrics
		for i=1:size(groups,1) %treatments
			for j=1:size(type,1) %compartments
				popsize = [];
				data = nan;
				sessions = [];
				env = strings;
				for k=1:size(s_pair_delta.(char(groups(i))).(char(type(j))).id,1) %contexts
					[x,y] = find(cellfun(@(c) ~isempty(c),s_pair_delta.(char(groups(i))).(char(type(j))).id{k}),1);
					ctx = s_pair_delta.(char(groups(i))).(char(type(j))).id{k}{x,y};
					ctx = char(extractAfter(ctx,'_d'+digitsPattern(1)+'_'));
					pop = s_pair_delta.(char(groups(i))).(char(type(j))).(char(list(z))){k};
					pop = pop(1:span,:);
					data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
					for x=1:size(pop,2)
						sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
						for y=1:size(pop,1)
							env = cat(1,env,ctx);
						end
					end
				end
				data(1) = [];
				env(1) = [];
				[pval,tbl,sts] = anovan(data,{sessions,env},'model','interaction','varnames',{'days','env'},'display','off');
				%[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',[1 2],'display','off');
				[mc_sts,~,~,gp_names] = multcompare(sts,'dimension',1,'display','off');
				%gp_names = cellfun(@(c) extractAfter(c,"="),gp_names,'UniformOutput',false);
				outsts = {};
				for x=1:size(pval,1)
					outsts{x,1} = tbl{x+1,1};
					outsts{x,2} = tbl{x+1,7};
				end
				for x=1:size(mc_sts,1)
					outsts{end+1,1} = strcat(gp_names{mc_sts(x,1)},'_vs_',gp_names{mc_sts(x,2)});
					outsts{end,2} = mc_sts(x,6);
				end
				s_stats_pair_delta_envs.(char(groups(i))).(char(type(j))).(char(list(z))).data = data;
				s_stats_pair_delta_envs.(char(groups(i))).(char(type(j))).(char(list(z))).sessions = sessions;
				s_stats_pair_delta_envs.(char(groups(i))).(char(type(j))).(char(list(z))).env = env;
				s_stats_pair_delta_envs.(char(groups(i))).(char(type(j))).(char(list(z))).comparisons = outsts;
			end
		end
	end
	
	save(fullfile(output,'stats_S_DxA.mat'),'s_work','s_halves','s_cross','s_last','s_pair',...
	's_stats_halves_treatments','s_stats_cross_treatments','s_stats_last_treatments','s_stats_pair_treatments',...
	's_stats_halves_compartments','s_stats_cross_compartments','s_stats_last_compartments','s_stats_pair_compartments',...
	's_stats_halves_envs','s_stats_cross_envs','s_stats_last_envs','s_stats_pair_envs','-v7.3');
end