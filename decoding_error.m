function [] = decoding_error()
    path_list = {...
	'/gpfs/data/basulab/VR/cohort_5/m4/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_5/m5/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_5/m6/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_5/m8/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_5/m9/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_5/m12/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_6/m14/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_6/m16/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_6/m17/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m24/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m25/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m26/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m27/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m28/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m30/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m33b/decoding.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m24/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m25/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m26/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m27/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m28/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m30/decoding2.mat',...
	'/gpfs/data/basulab/VR/cohort_7/m33b/decoding2.mat',...
	};
	s_decod = struct;
	for x=1:size(path_list,2)
		load(path_list{x});
		temp = split(path_list{x},'/');
		id = temp{end-1};
		[~,temp2,~] = fileparts(path_list{x});
		if(~isempty(extract(temp2,digitsPattern)))
			id = strcat(id,'_',extract(temp2,digitsPattern));
		end
		types = fieldnames(s_output);
		for j=1:size(types,1)
			for k=1:size(s_output.(char(types(j))),2)
				try
					real_pos1 = s_output.(char(types(j)))(k).real_pos1;
					real_pos2 = s_output.(char(types(j)))(k).real_pos2;
					decoded_pos1 = s_output.(char(types(j)))(k).decoded_pos1;
					decoded_pos2 = s_output.(char(types(j)))(k).decoded_pos2;
					ang_real_1 = -pi+2*pi*real_pos1/200;
					ang_real_2 = -pi+2*pi*real_pos2/200;
					ang_decoded_1 = -pi+2*pi*decoded_pos1/200;
					ang_decoded_2 = -pi+2*pi*decoded_pos2/200;
					delta_ang_1 = angle(exp(i*(ang_real_1-ang_decoded_1)));
					delta_ang_2 = angle(exp(i*(ang_real_2-ang_decoded_2)));
					delta_pos_1 = abs(200*delta_ang_1/(2*pi));
					delta_pos_2 = abs(200*delta_ang_2/(2*pi));
					s_decod.(char(id)).(char(types(j)))(k).real_pos_1_pop = real_pos1;
					s_decod.(char(id)).(char(types(j)))(k).real_pos_2_pop = real_pos2;
					s_decod.(char(id)).(char(types(j)))(k).decoded_pos_1_pop = decoded_pos1;
					s_decod.(char(id)).(char(types(j)))(k).decoded_pos_2_pop = decoded_pos2;
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_1_pop = delta_pos_1;
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_2_pop = delta_pos_2;
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_1_avg = mean(delta_pos_1,1,'omitnan');
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_2_avg = mean(delta_pos_2,1,'omitnan');
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_1_std = std(delta_pos_1,0,1,'omitnan');
					s_decod.(char(id)).(char(types(j)))(k).delta_pos_2_std = std(delta_pos_2,0,1,'omitnan');
					s_decod.(char(id)).(char(types(j)))(k).comp = s_output.(char(types(j)))(k).comp;
				end
			end
		end
	end
	save('/gpfs/data/basulab/VR/decoding_error.mat','s_decod','-v7.3');
	control = {'m4','m5','m6','m8','m9','m12'};
	LECglu = {'m14','m17','m24','m25','m26','m27','m28','m30','m33b'};
	LECgaba = {'m16','m24_2','m25_2','m26_2','m27_2','m28_2','m30_2','m33b_2'};
	mice = fieldnames(s_decod);
	control_mice = intersect(control,mice);
	LECglu_mice = intersect(LECglu,mice);
	LECgaba_mice = intersect(LECgaba,mice);
	control_types = fieldnames(s_decod.(char(control_mice{1})));
	s_control_data = struct;
	for i=1:size(control_types,1)
		session_number = 0;
		for j=1:size(control_mice,1)
			session_number = max(session_number,size(s_decod.(char(control_mice{j})).(char(control_types{i})),2));
		end
		s_control_data.(char(control_types{i})).delta_pos_1 = NaN(session_number,size(control_mice,1));
		s_control_data.(char(control_types{i})).delta_pos_2 = NaN(session_number,size(control_mice,1));
		s_control_data.(char(control_types{i})).comp = strings(session_number,size(control_mice,1));
		for j=1:size(control_mice,1)
			for k=1:size(s_decod.(char(control_mice{j})).(char(control_types{i})),2)
				try
					s_control_data.(char(control_types{i})).delta_pos_1(k,j) = s_decod.(char(control_mice{j})).(char(control_types{i}))(k).delta_pos_1_avg;
					s_control_data.(char(control_types{i})).delta_pos_2(k,j) = s_decod.(char(control_mice{j})).(char(control_types{i}))(k).delta_pos_2_avg;
					s_control_data.(char(control_types{i})).comp(k,j) = s_decod.(char(control_mice{j})).(char(control_types{i}))(k).comp;
				end
			end
		end
		s_control_data.(char(control_types{i})).delta_pos_1_avg = mean(s_control_data.(char(control_types{i})).delta_pos_1,2,'omitnan');
		s_control_data.(char(control_types{i})).delta_pos_2_avg = mean(s_control_data.(char(control_types{i})).delta_pos_2,2,'omitnan');
		s_control_data.(char(control_types{i})).delta_pos_1_sem = std(s_control_data.(char(control_types{i})).delta_pos_1,0,2,'omitnan')/sqrt(size(s_control_data.(char(control_types{i})).delta_pos_1,2));
		s_control_data.(char(control_types{i})).delta_pos_2_sem = std(s_control_data.(char(control_types{i})).delta_pos_2,0,2,'omitnan')/sqrt(size(s_control_data.(char(control_types{i})).delta_pos_2,2));
	end
	LECglu_types = fieldnames(s_decod.(char(LECglu_mice{1})));
	s_LECglu_data = struct;
	for i=1:size(LECglu_types,1)
		session_number = 0;
		for j=1:size(LECglu_mice,1)
			session_number = max(session_number,size(s_decod.(char(LECglu_mice{j})).(char(LECglu_types{i})),2));
		end
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_1 = NaN(session_number,size(LECglu_mice,1));
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_2 = NaN(session_number,size(LECglu_mice,1));
		s_LECglu_data.(char(LECglu_types{i})).comp = strings(session_number,size(LECglu_mice,1));
		for j=1:size(LECglu_mice,1)
			for k=1:size(s_decod.(char(LECglu_mice{j})).(char(LECglu_types{i})),2)
				try
					s_LECglu_data.(char(LECglu_types{i})).delta_pos_1(k,j) = s_decod.(char(LECglu_mice{j})).(char(LECglu_types{i}))(k).delta_pos_1_avg;
					s_LECglu_data.(char(LECglu_types{i})).delta_pos_2(k,j) = s_decod.(char(LECglu_mice{j})).(char(LECglu_types{i}))(k).delta_pos_2_avg;
					s_LECglu_data.(char(LECglu_types{i})).comp(k,j) = s_decod.(char(LECglu_mice{j})).(char(LECglu_types{i}))(k).comp;
				end
			end
		end
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_1_avg = mean(s_LECglu_data.(char(LECglu_types{i})).delta_pos_1,2,'omitnan');
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_2_avg = mean(s_LECglu_data.(char(LECglu_types{i})).delta_pos_2,2,'omitnan');
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_1_sem = std(s_LECglu_data.(char(LECglu_types{i})).delta_pos_1,0,2,'omitnan')/sqrt(size(s_LECglu_data.(char(LECglu_types{i})).delta_pos_1,2));
		s_LECglu_data.(char(LECglu_types{i})).delta_pos_2_sem = std(s_LECglu_data.(char(LECglu_types{i})).delta_pos_2,0,2,'omitnan')/sqrt(size(s_LECglu_data.(char(LECglu_types{i})).delta_pos_2,2));
	end
	LECgaba_types = fieldnames(s_decod.(char(LECgaba_mice{1})));
	s_LECgaba_data = struct;
	for i=1:size(LECgaba_types,1)
		session_number = 0;
		for j=1:size(LECgaba_mice,1)
			session_number = max(session_number,size(s_decod.(char(LECgaba_mice{j})).(char(LECgaba_types{i})),2));
		end
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1 = NaN(session_number,size(LECgaba_mice,1));
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2 = NaN(session_number,size(LECgaba_mice,1));
		s_LECgaba_data.(char(LECgaba_types{i})).comp = strings(session_number,size(LECgaba_mice,1));
		for j=1:size(LECgaba_mice,1)
			for k=1:size(s_decod.(char(LECgaba_mice{j})).(char(LECgaba_types{i})),2)
				try
					s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1(k,j) = s_decod.(char(LECgaba_mice{j})).(char(LECgaba_types{i}))(k).delta_pos_1_avg;
					s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2(k,j) = s_decod.(char(LECgaba_mice{j})).(char(LECgaba_types{i}))(k).delta_pos_2_avg;
					s_LECgaba_data.(char(LECgaba_types{i})).comp(k,j) = s_decod.(char(LECgaba_mice{j})).(char(LECgaba_types{i}))(k).comp;
				end
			end
		end
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1_avg = mean(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1,2,'omitnan');
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2_avg = mean(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2,2,'omitnan');
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1_sem = std(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1,0,2,'omitnan')/sqrt(size(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_1,2));
		s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2_sem = std(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2,0,2,'omitnan')/sqrt(size(s_LECgaba_data.(char(LECgaba_types{i})).delta_pos_2,2));
	end
	s_pool = struct;
	for i=1:size(types,1)
		if(matches(types{i},'cross'))
			tmplbl = s_control_data.(char(types{i})).comp(:,1);
			lbl = strings(size(tmplbl,1),1);
			for j=1:size(tmplbl,1)
				try
					tmplbl2 = extractBetween(tmplbl(j),'m12_','_t-');
					lbl(j) = strcat(tmplbl2(1),'_vs_',tmplbl2(2));
				end
			end
			fig = figure;
			ct = s_control_data.(char(types{i})).delta_pos_2;
			glu = s_LECglu_data.(char(types{i})).delta_pos_2;
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2;
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			yspan = ylim;
			close(fig);
			f1f2_index = find(contains(lbl,'fam1_vs_fam2'));
			f1f2_lbl = lbl(f1f2_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f1f2_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f1f2_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f1f2_index,:);
			s_pool.(char(types{i})).f1f2.ct = ct;
			s_pool.(char(types{i})).f1f2.glu = glu;
			s_pool.(char(types{i})).f1f2.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f1f2_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f1f2_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f1f2_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f1f2_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f1f2_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f1f2_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f1f2_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f1f2_cross.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			f1i_index = find(contains(lbl,'fam1_vs_int'));
			f1i_lbl = lbl(f1i_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f1i_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f1i_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f1i_index,:);
			s_pool.(char(types{i})).f1i.ct = ct;
			s_pool.(char(types{i})).f1i.glu = glu;
			s_pool.(char(types{i})).f1i.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f1i_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f1i_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f1i_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f1i_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f1i_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f1i_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f1i_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f1i_cross.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			f1n_index = find(contains(lbl,'fam1_vs_nov'));
			f1n_lbl = lbl(f1n_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f1n_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f1n_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f1n_index,:);
			s_pool.(char(types{i})).f1n.ct = ct;
			s_pool.(char(types{i})).f1n.glu = glu;
			s_pool.(char(types{i})).f1n.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f1n_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f1n_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f1n_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f1n_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f1n_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f1n_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f1n_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f1n_cross.pdf','-dpdf','-r300','-bestfit');
			close(fig);
		end
		if(matches(types{i},'pair'))
			tmplbl = s_control_data.(char(types{i})).comp(:,1);
			lbl = strings(size(tmplbl,1),1);
			for j=1:size(tmplbl,1)
				try
					tmplbl2 = extractBetween(tmplbl(j),'m12_','_t-');
					lbl(j) = strcat(tmplbl2(1),'_vs_',tmplbl2(2));
				end
			end
			fig = figure;
			ct = s_control_data.(char(types{i})).delta_pos_2;
			glu = s_LECglu_data.(char(types{i})).delta_pos_2;
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2;
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			yspan = ylim;
			close(fig);
			f1f1_index = find(contains(lbl,'fam1_vs_fam1'));
			f1f1_lbl = lbl(f1f1_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			s_pool.(char(types{i})).f1f1.ct = ct;
			s_pool.(char(types{i})).f1f1.glu = glu;
			s_pool.(char(types{i})).f1f1.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f1f1_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f1f1_pair.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			f2f2_index = find(contains(lbl,'fam2_vs_fam2'));
			f2f2_lbl = lbl(f2f2_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			s_pool.(char(types{i})).f2f2.ct = ct;
			s_pool.(char(types{i})).f2f2.glu = glu;
			s_pool.(char(types{i})).f2f2.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f2f2_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f2f2_pair.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			ii_index = find(contains(lbl,'int_vs_int'));
			ii_lbl = lbl(ii_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(ii_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(ii_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(ii_index,:);
			s_pool.(char(types{i})).ii.ct = ct;
			s_pool.(char(types{i})).ii.glu = glu;
			s_pool.(char(types{i})).ii.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(ii_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(ii_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(ii_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(ii_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(ii_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(ii_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(ii_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_ii_pair.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			nn_index = find(contains(lbl,'nov_vs_nov'));
			nn_lbl = lbl(nn_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(nn_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(nn_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(nn_index,:);
			s_pool.(char(types{i})).nn.ct = ct;
			s_pool.(char(types{i})).nn.glu = glu;
			s_pool.(char(types{i})).nn.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(nn_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(nn_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(nn_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(nn_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(nn_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(nn_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(nn_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_nn_pair.pdf','-dpdf','-r300','-bestfit');
			close(fig);
		end
		if(matches(types{i},'ref'))
			tmplbl = s_control_data.(char(types{i})).comp(:,1);
			lbl = strings(size(tmplbl,1),1);
			for j=1:size(tmplbl,1)
				try
					tmplbl2 = extractBetween(tmplbl(j),'m12_','_t-');
					lbl(j) = strcat(tmplbl2(1),'_vs_',tmplbl2(2));
				end
			end
			fig = figure;
			ct = s_control_data.(char(types{i})).delta_pos_2;
			glu = s_LECglu_data.(char(types{i})).delta_pos_2;
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2;
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			yspan = ylim;
			close(fig);
			f1f1_index = find(contains(lbl,'fam1_vs_fam1'));
			f1f1_lbl = lbl(f1f1_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f1f1_index,:);
			s_pool.(char(types{i})).f1f1.ct = ct;
			s_pool.(char(types{i})).f1f1.glu = glu;
			s_pool.(char(types{i})).f1f1.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f1f1_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f1f1_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f1f1_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f1f1_ref.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			f2f2_index = find(contains(lbl,'fam2_vs_fam2'));
			f2f2_lbl = lbl(f2f2_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(f2f2_index,:);
			s_pool.(char(types{i})).f2f2.ct = ct;
			s_pool.(char(types{i})).f2f2.glu = glu;
			s_pool.(char(types{i})).f2f2.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(f2f2_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(f2f2_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(f2f2_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_f2f2_ref.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			ii_index = find(contains(lbl,'int_vs_int'));
			ii_lbl = lbl(ii_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(ii_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(ii_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(ii_index,:);
			s_pool.(char(types{i})).ii.ct = ct;
			s_pool.(char(types{i})).ii.glu = glu;
			s_pool.(char(types{i})).ii.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(ii_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(ii_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(ii_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(ii_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(ii_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(ii_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(ii_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_ii_ref.pdf','-dpdf','-r300','-bestfit');
			close(fig);
			nn_index = find(contains(lbl,'nov_vs_nov'));
			nn_lbl = lbl(nn_index);
			ct = s_control_data.(char(types{i})).delta_pos_2(nn_index,:);
			glu = s_LECglu_data.(char(types{i})).delta_pos_2(nn_index,:);
			gaba = s_LECgaba_data.(char(types{i})).delta_pos_2(nn_index,:);
			s_pool.(char(types{i})).nn.ct = ct;
			s_pool.(char(types{i})).nn.glu = glu;
			s_pool.(char(types{i})).nn.gaba = gaba;
			ct_avg = s_control_data.(char(types{i})).delta_pos_2_avg(nn_index);
			glu_avg = s_LECglu_data.(char(types{i})).delta_pos_2_avg(nn_index);
			gaba_avg = s_LECgaba_data.(char(types{i})).delta_pos_2_avg(nn_index);
			ct_sem = s_control_data.(char(types{i})).delta_pos_2_sem(nn_index);
			glu_sem = s_LECglu_data.(char(types{i})).delta_pos_2_sem(nn_index);
			gaba_sem = s_LECgaba_data.(char(types{i})).delta_pos_2_sem(nn_index);
			lin_ct = linspace(1,size(ct,1),size(ct,1));
			lin_glu = linspace(1,size(glu,1),size(glu,1));
			lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
			fig = figure;
			hold on
			plot(ct,'k')
			plot(glu,'g')
			plot(gaba,'r')
			shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
			shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
			shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
			hold off
			ylabel('decoding error (cm)')
			ylim([0 yspan(2)]);
			xticks(lin_ct);
			xticklabels(nn_lbl);
			ax = gca;
			ax.TickLabelInterpreter = 'none';
			print('C:\root\hpc\decod_nn_ref.pdf','-dpdf','-r300','-bestfit');
			close(fig);
		end
	end
	s_stats = struct;
	types = fieldnames(s_pool);
	for i=1:size(types,1)
		ssn = fieldnames(s_pool.(char(types{i})));
		for j=1:size(ssn,1)
			groups = fieldnames(s_pool.(char(types{i})).(char(ssn{j})));
			data = nan;
			sessions = [];
			treatment = strings;
			for k=1:size(groups,1)
				pop = s_pool.(char(types{i})).(char(ssn{j})).(char(groups{k}));
				data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
				for x=1:size(pop,2)
					sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
					for y=1:size(pop,1)
						treatment = cat(1,treatment,groups{k});
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
			for k=1:size(pval,1)
				outsts{k,1} = tbl{k+1,1};
				outsts{k,2} = tbl{k+1,7};
			end
			for k=1:size(mc_sts,1)
				outsts{end+1,1} = strcat(gp_names{mc_sts(k,1)},'_vs_',gp_names{mc_sts(k,2)});
				outsts{end,2} = mc_sts(k,6);
			end
			s_stats.(char(types{i})).(char(ssn{j})).data = data;
			s_stats.(char(types{i})).(char(ssn{j})).sessions = sessions;
			s_stats.(char(types{i})).(char(ssn{j})).treatment = treatment;
			s_stats.(char(types{i})).(char(ssn{j})).comparisons = outsts;
		end
	end
	s_pool_sub = s_pool;
	s_pool_sub = rmfield(s_pool_sub,'cross');
	s_pool_sub.pair = rmfield(s_pool_sub.pair,'f2f2');
	s_pool_sub.ref = rmfield(s_pool_sub.ref,'f2f2');
	types = fieldnames(s_pool_sub);
	for i=1:size(types,1)
		ssn = fieldnames(s_pool_sub.(char(types{i})));
		ct = NaN(size(s_pool_sub.(char(types{i})).(char(ssn{1})).ct,1),size(s_pool_sub.(char(types{i})).(char(ssn{1})).ct,2),size(ssn,1));
		glu = NaN(size(s_pool_sub.(char(types{i})).(char(ssn{1})).glu,1),size(s_pool_sub.(char(types{i})).(char(ssn{1})).glu,2),size(ssn,1));
		gaba = NaN(size(s_pool_sub.(char(types{i})).(char(ssn{1})).gaba,1),size(s_pool_sub.(char(types{i})).(char(ssn{1})).gaba,2),size(ssn,1));
		for j=1:size(ssn,1)
			ct(:,:,j) = s_pool_sub.(char(types{i})).(char(ssn{j})).ct;
			glu(:,:,j) = s_pool_sub.(char(types{i})).(char(ssn{j})).glu;
			gaba(:,:,j) = s_pool_sub.(char(types{i})).(char(ssn{j})).gaba;
		end
		s_pool_sub.(char(types{i})).ct = mean(ct,3,'omitnan');
		s_pool_sub.(char(types{i})).glu = mean(glu,3,'omitnan');
		s_pool_sub.(char(types{i})).gaba = mean(gaba,3,'omitnan');
		s_pool_sub.(char(types{i})) = rmfield(s_pool_sub.(char(types{i})),'f1f1');
		s_pool_sub.(char(types{i})) = rmfield(s_pool_sub.(char(types{i})),'ii');
		s_pool_sub.(char(types{i})) = rmfield(s_pool_sub.(char(types{i})),'nn');
	end
	s_stats_sub = struct;
	types = fieldnames(s_pool_sub);
	for i=1:size(types,1)
		groups = fieldnames(s_pool_sub.(char(types{i})));
		data = nan;
		sessions = [];
		treatment = strings;
		for j=1:size(groups,1)
			pop = s_pool_sub.(char(types{i})).(char(groups{j}));
			data = cat(1,data,reshape(pop,[size(pop,1)*size(pop,2),1]));
			for x=1:size(pop,2)
				sessions = cat(1,sessions,linspace(1,size(pop,1),size(pop,1))');
				for y=1:size(pop,1)
					treatment = cat(1,treatment,groups{j});
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
		for j=1:size(pval,1)
			outsts{j,1} = tbl{j+1,1};
			outsts{j,2} = tbl{j+1,7};
		end
		for j=1:size(mc_sts,1)
			outsts{end+1,1} = strcat(gp_names{mc_sts(j,1)},'_vs_',gp_names{mc_sts(j,2)});
			outsts{end,2} = mc_sts(j,6);
		end
		s_stats_sub.(char(types{i})).data = data;
		s_stats_sub.(char(types{i})).sessions = sessions;
		s_stats_sub.(char(types{i})).treatment = treatment;
		s_stats_sub.(char(types{i})).comparisons = outsts;
	end
	types = fieldnames(s_pool_sub);
	for i=1:size(types,1)
		ct = s_pool_sub.(char(types{i})).ct;
		glu = s_pool_sub.(char(types{i})).glu;
		gaba = s_pool_sub.(char(types{i})).gaba;
		ct_avg = mean(ct,2,'omitnan');
		glu_avg = mean(glu,2,'omitnan');
		gaba_avg = mean(gaba,2,'omitnan');
		ct_sem = std(ct,0,2,'omitnan')/sqrt(size(ct,2));
		glu_sem = std(ct,0,2,'omitnan')/sqrt(size(glu,2));
		gaba_sem = std(ct,0,2,'omitnan')/sqrt(size(gaba,2));
		lin_ct = linspace(1,size(ct,1),size(ct,1));
		lin_glu = linspace(1,size(glu,1),size(glu,1));
		lin_gaba = linspace(1,size(gaba,1),size(gaba,1));
		fig = figure;
		hold on
		plot(ct,'k')
		plot(glu,'g')
		plot(gaba,'r')
		yspan = ylim;
		shadedErrorBar(lin_ct,ct_avg,ct_sem,'lineProps',{'Color','k','LineWidth',2})
		shadedErrorBar(lin_glu,glu_avg,glu_sem,'lineProps',{'Color','g','LineWidth',2})
		shadedErrorBar(lin_gaba,gaba_avg,gaba_sem,'lineProps',{'Color','r','LineWidth',2})
		hold off
		ylabel('decoding error (cm)')
		ylim([0 yspan(2)]);
		xticks(lin_ct);
		print(strcat('C:\root\hpc\decod_snnavg_',types{i},'.pdf'),'-dpdf','-r300','-bestfit');
		close(fig);
	end
	lowbound = [];
	highbound = [];
	mice = fieldnames(s_decod);
	for i=1:size(mice,1)
		types = fieldnames(s_decod.(char(mice{i})));
		types = types(~contains(types,'cross'));
		for j=1:size(types,1)
			for k=1:size(s_decod.(char(mice{i})).(char(types{j})),2)
				try
					s_decod.(char(mice{i})).(char(types{j}))(k).hist = histcounts2(s_decod.(char(mice{i})).(char(types{j}))(k).real_pos_2_pop,s_decod.(char(mice{i})).(char(types{j}))(k).decoded_pos_2_pop,40,'Normalization','probability');
					lowbound(end+1) = min(s_decod.(char(mice{i})).(char(types{j}))(k).hist,[],"all");
					highbound(end+1) = max(s_decod.(char(mice{i})).(char(types{j}))(k).hist,[],"all");
				end
			end
		end
	end
	mice = fieldnames(s_decod);
	for i=1:size(mice,1)
		types = fieldnames(s_decod.(char(mice{i})));
		types = types(~contains(types,'cross'));
		for j=1:size(types,1)
			for k=1:size(s_decod.(char(mice{i})).(char(types{j})),2)
				try
					fig = figure();
					imagesc(linspace(0,200,40),linspace(0,200,40),s_decod.(char(mice{i})).(char(types{j}))(k).hist,[min(lowbound) max(highbound)]);
					
					fig = figure();
					imagesc(linspace(0,200,40),linspace(0,200,40),s_decod.m25_2.ref(5).hist,[0 0.01]);
					xticks([0 50 100 150 200]);
					yticks([0 50 100 150 200]);
					xlabel('position (cm)');
					ylabel('position (cm)');
					print(strcat('C:\root\hpc\decod_img\decod_m25b_ref_d4.pdf'),'-dpdf','-r300','-bestfit');
					close(fig);
					
					fig = figure();
					hold on
					scatter(linspace(0,3,6000),s_decod.m25_2.ref(5).real_pos_2_pop(1001:7000),20,'filled','MarkerEdgeAlpha',0,'MarkerFaceAlpha',0.1);
					scatter(linspace(0,3,6000),s_decod.m25_2.ref(5).decoded_pos_2_pop(1001:7000),30,'r','filled','MarkerEdgeAlpha',1,'MarkerFaceAlpha',1);
					hold off
					axis square
					axis off
					print(strcat('C:\root\hpc\decod_img\pos_m25b_ref_4_sub.pdf'),'-dpdf','-r300','-bestfit');
					close(fig);
					
					xticks([0 10]);
					yticks([0 200]);
					xlabel('time (min)');
					ylabel('position (cm)');
					print(strcat('C:\root\hpc\decod_img\decod_m25b_ref_d4.pdf'),'-dpdf','-r300','-bestfit');
					close(fig);
					
					print(strcat('C:\root\hpc\decod_img\decod_',s_decod.(char(mice{i})).(char(types{j}))(k).comp,'.pdf'),'-dpdf','-r300','-bestfit');
					close(fig);
				end
			end
		end
	end
	fig = figure();
	% plot3(PV_CT_pop,DC_CT_pop,BH_CT_pop,'-ok');
	% hold on
	% plot3(PV_GLU_pop,DC_GLU_pop,BH_GLU_pop,'-og');
	% hold on
	plot3(PV_GABA_pop,DC_GABA_pop,BH_GABA_pop,'-or');
	hold on
	% plot3(PV_CT_avg,DC_CT_avg,BH_CT_avg,'->k','LineWidth',2);
	% plot3(PV_GLU_avg,DC_GLU_avg,BH_GLU_avg,'->g','LineWidth',2);
	plot3(PV_GABA_avg,DC_GABA_avg,BH_GABA_avg,'->r','LineWidth',2);
	hold off
	grid on
	xlim([-0.2 0.6])
	ylim([20 55])
	zlim([0 0.8])
	fig.Renderer = 'painters';
	% plot3(DC_CT,PV_CT,BH_CT,'->k','LineWidth',2);
	% hold on
	% plot3(DC_GLU,PV_GLU,BH_GLU,'->g','LineWidth',2);
	% plot3(DC_GABA,PV_GABA,BH_GABA,'->r','LineWidth',2);
	% hold off
	% grid on
	% xlabel('PV corr. coeff.');
	% ylabel('decoding error (cm)');
	% zlabel('fraction of correct licks');
	print(strcat('C:\root\hpc\3wayGABA.pdf'),'-dpdf','-r300','-bestfit');
	close(fig);
end