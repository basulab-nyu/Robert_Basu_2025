function [] = review_events()
    root_path = '/gpfs/scratch/roberv04/cohort_5';
    root_id = 'm8';
    input_folder = 'fitness';
    input_name = 'fitness.mat';
    str_roi_type = ["ad","bd","m","s"];
    session_groups = [1 1 1 1 1 1 1 3 3 3 3 4 4 4 4 4 4 4 4 4];
    input_img = 'vid_max_proj_m8.tif';
    batch_size = 1000;
	output_name = 'events';
    addpath(genpath('code'));
    str_slash = '/';
    if ~contains(root_path,str_slash)
        str_slash = '\';
    end
    root_folder = fullfile(root_path,root_id);
	tic;
    fprintf('\nloading mat files...\n\n');
    s_input = load(fullfile(root_folder,input_folder,input_name),'PEAK','START_STOP','s_root','m_roi','m_traces_F','m_traces_df');
    s_input.s_root(1).root_id = root_id;
    s_input.s_root(1).root_folder = root_folder;
    s_input.s_root(1).session_groups = session_groups;
    s_output = struct;
    v_roi_type_size = NaN(size(str_roi_type,2),1);
    m_roi_id_logic = zeros(size(s_input.s_root(1).roi_id.names,1),size(str_roi_type,2));
    s_input.s_root_og = s_input.s_root;
	if(~exist(fullfile(s_input.s_root(1).root_folder,output_name),'dir'))
		mkdir(fullfile(s_input.s_root(1).root_folder,output_name));
	end
    for c=1:size(str_roi_type,2)
        v_roi_type_size(c) = sum(contains(s_input.s_root(1).roi_id.names,str_roi_type(c)));
        m_roi_id_logic(:,c) = contains(s_input.s_root(1).roi_id.names,str_roi_type(c));
    end
    for c=1:size(str_roi_type,2)
        s_input.s_root(1).root_id = strcat(s_input.s_root_og(1).root_id,'_',str_roi_type(c));
        for d=1:size(s_input.s_root_og,2)
            START_STOP_temp = cell(1,size(s_input.START_STOP,2));
            for b=1:size(s_input.START_STOP,2)
                if (isempty(s_input.START_STOP{1,b}(find(s_input.START_STOP{1,b}(:,1)>=1+(d-1)*batch_size & s_input.START_STOP{1,b}(:,1)<d*batch_size),1)) || isempty(s_input.START_STOP{1,b}(find(s_input.START_STOP{1,b}(:,2)>=1+(d-1)*batch_size & s_input.START_STOP{1,b}(:,2)<d*batch_size),2)))
                    continue
                else
                    start_temp = s_input.START_STOP{1,b}(find(s_input.START_STOP{1,b}(:,1)>=1+(d-1)*batch_size & s_input.START_STOP{1,b}(:,1)<d*batch_size),1);
                    stop_temp = s_input.START_STOP{1,b}(find(s_input.START_STOP{1,b}(:,2)>=1+(d-1)*batch_size & s_input.START_STOP{1,b}(:,2)<d*batch_size),2);
                    if size(start_temp,1) == size(stop_temp,1)
                        START_STOP_temp{1,b}(:,1) = start_temp;
                        START_STOP_temp{1,b}(:,2) = stop_temp;
                    end
                    START_STOP_temp{1,b} = START_STOP_temp{1,b}-(d-1)*batch_size;
                end
            end
            s_input.s_root(d).data.Events{1,1}.onset_offset = START_STOP_temp(:,(find(m_roi_id_logic(:,c))));
            m_traces_df_temp = s_input.m_traces_df(1+(d-1)*batch_size:d*batch_size,:);
            s_input.s_root(d).data.Imaging{1,1}.trace_restricted = m_traces_df_temp(:,(find(m_roi_id_logic(:,c))));
            s_input.s_root(d).roi_coor.Coor = s_input.s_root_og(d).roi_coor.Coor(find(m_roi_id_logic(:,c)));
            s_input.s_root(d).roi_id.names = s_input.s_root_og(d).roi_id.names(find(m_roi_id_logic(:,c)));
        end
        fprintf('\ndisplaying ROIs & waterfalls...\n\n');
        s_event_analysis = struct;
        m_roi_event_count = zeros(size(s_input.s_root,2),length(s_input.s_root(1).roi_coor.Coor));
         for i=1:size(s_input.s_root,2)
             for j=1:length(s_input.s_root(i).roi_coor.Coor)
                m_roi_event_count(i,j) = size(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j},1);
             end
         end
         m_Pevents = NaN(max(m_roi_event_count,[],'all'),length(s_input.s_root(1).roi_id.names),size(s_input.s_root,2));
         m_Tevents = NaN(max(m_roi_event_count,[],'all'),length(s_input.s_root(1).roi_id.names),size(s_input.s_root,2));
         m_Devents = NaN(max(m_roi_event_count,[],'all'),length(s_input.s_root(1).roi_id.names),size(s_input.s_root,2));
         m_Aevents = NaN(max(m_roi_event_count,[],'all'),length(s_input.s_root(1).roi_id.names),size(s_input.s_root,2));
        for i=1:size(s_input.s_root,2)
            for j=1:length(s_input.s_root(i).roi_coor.Coor)
                for k=1:size(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j},1)
                    if ~isempty(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j})
                        v_start = s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(k,1);
                        v_end = s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(k,2);
                        temp_cuttrace = s_input.s_root(i).data.Imaging{1,1}.trace_restricted(v_start:v_end,j);
                        m_Pevents(k,j,i) = max(temp_cuttrace,[],'all');
                        m_Tevents(k,j,i) = find(temp_cuttrace == m_Pevents(k,j,i),1) + v_start;
                        m_Devents(k,j,i) = (v_end - v_start)/1.666666666666666666666666666666666;
                        m_Aevents(k,j,i) = trapz(temp_cuttrace)/m_Devents(k,j,i);
                    end
                end
            end
        end
        m_Pevents(m_Pevents == 0) = NaN;
        m_Tevents(m_Tevents == 0) = NaN;
		m_Devents(m_Devents == 0) = NaN;
        m_Aevents(m_Aevents == 0) = NaN;
        fig_roi = figure('position',[50,75,600,600]);
        imagesc(s_input.s_root(1).img,[min(s_input.s_root(1).img,[],'all'),max(s_input.s_root(1).img(100:400,100:400),[],'all')]);
        axis('square');
        ylabel('pixel #');
        xlabel('pixel #');
        hold on
        for i=1:length(s_input.s_root(1).roi_coor.Coor)
            plot(s_input.s_root(1).roi_coor.Coor{i,1}(1,:),s_input.s_root(1).roi_coor.Coor{i,1}(2,:),'red');
            text(s_input.s_root(1).roi_coor.Coor{i,1}(1,1),s_input.s_root(1).roi_coor.Coor{i,1}(2,1),s_input.s_root(1).roi_id.names(i));
        end
        hold off
        fig_name = strcat('fig_roi_',s_input.s_root(1).root_id,'.pdf');
        print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
        close(fig_roi);
        for i=1:size(s_input.s_root,2)
            Cdf_data = s_input.s_root(i).data.Imaging{1,1}.trace_restricted;
            v_Cdf_max(i) = max(Cdf_data,[],'all');
            v_Cdf_length(i) = size(Cdf_data,1);
        end
        for i=1:size(s_input.s_root,2)
            Cdf_data = s_input.s_root(i).data.Imaging{1,1}.trace_restricted;
            v_offset = [1:1:size(Cdf_data,2)]*max(v_Cdf_max,[],'all');
            Cdf_data = Cdf_data+v_offset;
            y_markers = m_Pevents(:,:,i)+v_offset;
            x_markers = m_Tevents(:,:,i)/1.666666666666666666666666666666666;
            x_time = [1:1:size(Cdf_data,1)]/1.666666666666666666666666666666666;
            fig_wf = figure('position',[50,75,1300,600]);
            cc = ceil(length(s_input.s_root(i).roi_coor.Coor)/3);
            j=1;
            while j<ceil(length(s_input.s_root(i).roi_coor.Coor)/cc)+1
                if j == ceil(length(s_input.s_root(i).roi_coor.Coor)/cc)
                    u = length(s_input.s_root(i).roi_coor.Coor);
                else
                    u = (j*cc)-1;
                end
                subplot(1,ceil(length(s_input.s_root(i).roi_coor.Coor)/cc),j);
                hold on
                plot(x_time,Cdf_data(:,j+(j-1)*cc:u));
                plot(x_markers(:,j+(j-1)*cc:u),y_markers(:,j+(j-1)*cc:u),'.','Color','k','LineWidth',2);
                ax = gca;
                ax.YAxis.FontSize = 8;
                yticks(v_offset(:,j+(j-1)*cc:u));
                yticklabels(s_input.s_root(i).roi_id.names(j+(j-1)*cc:u));
                ylabel('ROI #');
                xlabel('time (s)');
                ylim([min(Cdf_data(:,j+(j-1)*cc:u),[],'all')*0.975 max(Cdf_data(:,j+(j-1)*cc:u),[],'all')*1.025]);
                title(s_input.s_root(i).name,'Interpreter','none');
                hold off
                j=j+1;
            end
            fig_name = strcat('fig_traces_waterfall_',s_input.s_root(i).name,'_',s_input.s_root(1).root_id,'.pdf');
            fig_wf.PaperOrientation = 'landscape';
            print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
            close(fig_wf);
        end
        fprintf('\nplotting events layouts...\n\n');
        m_Sevents = NaN(size(s_input.s_root,2),length(s_input.s_root(1).roi_coor.Coor));
		m_Nevents = NaN(size(s_input.s_root,2),length(s_input.s_root(1).roi_coor.Coor));
        for i=1:size(s_input.s_root,2)
            for j=1:length(s_input.s_root(i).roi_coor.Coor)
                if ~isempty(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j})
                    m_Nevents(i,j) = size(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j},1);
                    temp_diff = s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(:,2)-s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(:,1);
                    if isempty(temp_diff) == 1
                        m_Sevents(i,j) = 0;
                    else
                        m_Sevents(i,j) = max(temp_diff,[],'all');
                    end
                end
            end
        end
        for i=1:size(s_input.s_root,2)
            m_event_cutout = NaN(max(m_Sevents,[],'all')+4,max(m_Nevents,[],'all'),length(s_input.s_root(i).roi_coor.Coor));
            for j=1:length(s_input.s_root(i).roi_coor.Coor)
                if ~isempty(s_input.s_root(i).data.Events{1,1}.onset_offset{1,j})
                    for k=1:m_Nevents(i,j)
                        v_start = s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(k,1)-2;
                        v_end = s_input.s_root(i).data.Events{1,1}.onset_offset{1,j}(k,2)+2;
                        v_asgn = 1;
                        if v_start<1
                            v_asgn = 1-v_start;
                            v_start = 1;
                        end
                        if v_end>size(s_input.s_root(i).data.Imaging{1,1}.trace_restricted,1)
                            v_end = size(s_input.s_root(i).data.Imaging{1,1}.trace_restricted,1);
                        end
                        v_span = v_end-v_start+v_asgn;
                        m_event_cutout(v_asgn:v_span,k,j) = s_input.s_root(i).data.Imaging{1,1}.trace_restricted(v_start:v_end,j);
                    end
                end
               s_event_analysis(j).names = s_input.s_root(i).roi_id.names(j);
            end
            if size(m_event_cutout,1)>max(m_Sevents,[],'all')+4
                m_event_cutout = m_event_cutout(1:max(m_Sevents,[],'all')+4,:,:);
            end
            s_event_analysis(i).session = s_input.s_root(i).name;
            s_event_analysis(i).traces = m_event_cutout;
        end
        x_cut_time = [1:1:max(m_Sevents,[],'all')+4]/1.666666666666666666666666666666666 - 1;
        for i=1:size(s_input.s_root,2)
            k=1;
            while k<ceil(length(s_input.s_root(i).roi_coor.Coor)/60)+1
                fig_lay = figure('position',[50,75,1300,600]);
                y_layout = 6;
                x_layout = 10;
                fig_layout = tiledlayout(y_layout,x_layout,'TileSpacing','compact');
                if k*60<length(s_input.s_root(i).roi_coor.Coor)
                    for j=1:60
                        nexttile;
                        hold on
                        plot(x_cut_time,s_event_analysis(i).traces(:,:,j+(k-1)*60));
                        title(s_event_analysis(j+(k-1)*60).names,'Interpreter','none');
                        xlim([-1 max(x_cut_time,[],'all')]);
                        plot([-1 max(x_cut_time,[],'all')],[1 1],'black');
                        %plot([-1 max(x_cut_time,[],'all')],[s_input.s_root(i).data.Events{1,1}.options.SDON*s_input.s_root(i).data.Events{1,1}.STD_noise(1,j) s_input.s_root(i).data.Events{1,1}.options.SDON*s_input.s_root(i).data.Events{1,1}.STD_noise(1,j)],'--','Color','k');
                        if max(s_event_analysis(i).traces(:,:,j+(k-1)*60),[],'all') == 0
                            ylim([0 inf]);
                        elseif isnan(max(s_event_analysis(i).traces(:,:,j+(k-1)*60),[],'all')) == 1
                            ylim([0 inf]);
                        else
                            ylim([0 max(s_event_analysis(i).traces(:,:,j+(k-1)*60),[],'all')*1.025]);
                        end
                        hold off
                        title(fig_layout,s_input.s_root(i).name,'Interpreter','none');
                        xlabel(fig_layout,'time (s)');
                        ylabel(fig_layout,'df/f');
                    end
                else 
                    for j=1+(k-1)*60:length(s_input.s_root(i).roi_coor.Coor)
                        nexttile;
                        hold on
                        plot(x_cut_time,s_event_analysis(i).traces(:,:,j));
                        title(s_event_analysis(j).names,'Interpreter','none');
                        xlim([-1 max(x_cut_time,[],'all')]);
                        plot([-1 max(x_cut_time,[],'all')],[1 1],'black');
                        %plot([-1 max(x_cut_time,[],'all')],[s_input.s_root(i).data.Events{1,1}.options.SDON*s_input.s_root(i).data.Events{1,1}.STD_noise(1,j) s_input.s_root(i).data.Events{1,1}.options.SDON*s_input.s_root(i).data.Events{1,1}.STD_noise(1,j)],'--','Color','k');
                        if max(s_event_analysis(i).traces(:,:,j),[],'all') == 0
                            ylim([0 inf]);
                        elseif isnan(max(s_event_analysis(i).traces(:,:,j),[],'all')) == 1
                            ylim([0 inf]);
                        else
                            ylim([0 max(s_event_analysis(i).traces(:,:,j),[],'all')*1.025]);
                        end
                        hold off
                        title(fig_layout,s_input.s_root(i).name,'Interpreter','none');
                        xlabel(fig_layout,'time (s)');
                        ylabel(fig_layout,'df/f');
                    end
                end
                fig_name = strcat('fig_events_layout_',s_input.s_root(i).name,'_',num2str(k),'_',s_input.s_root(1).root_id,'.pdf');
                fig_lay.PaperOrientation = 'landscape';
                print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
                close(fig_lay);
                k=k+1;
            end
        end
        fprintf('\ngenerating event averages...\n\n');
        temp_fig = figure;
        temp_plot = plot(Cdf_data);
        c_colors = get(temp_plot,'Color');
        close(temp_fig);
        for f=1:length(s_input.s_root(1).session_groups)
            v_session_chunks(f) = sum(s_input.s_root(1).session_groups(1:f));
            fig_pop = figure('position',[50,75,1300,600]);
            fig_avg = tiledlayout(1,s_input.s_root(1).session_groups(f),'TileSpacing','compact');
            m_event_avg = NaN(max(m_Sevents,[],'all')+4,length(s_input.s_root(1).roi_coor.Coor));
            m_event_sem = NaN(max(m_Sevents,[],'all')+4,length(s_input.s_root(1).roi_coor.Coor));
            if f == 1
                for i=f:v_session_chunks(f)
                    temp_avg = mean(s_event_analysis(i).traces,2,'omitnan');
                    temp_std = std(s_event_analysis(i).traces,0,2,'omitnan');
                    nexttile;
                    hold on
                    for j=1:length(s_input.s_root(i).roi_coor.Coor)
                        m_event_avg(:,j) = temp_avg(:,:,j);
                        m_event_sem(:,j) = temp_std(:,:,j)/sqrt(m_Nevents(i,j));
                        shadedErrorBar(x_cut_time,m_event_avg(:,j),m_event_sem(:,j),'lineProps',{'Color',c_colors{j}});
                        %errorbar(x_cut_time,m_event_avg(:,j),m_event_sem(:,j));
                        xlim([-1 max(x_cut_time,[],'all')]);
                    end
                    hold off
                    t = title(s_input.s_root(i).name,'Interpreter','none');
					t.Rotation = 10;
                    s_event_analysis(i).event_avg = m_event_avg;
                    s_event_analysis(i).event_sem = m_event_sem;
                end
            else
                for i=v_session_chunks(f-1)+1:v_session_chunks(f)
                    temp_avg = mean(s_event_analysis(i).traces,2,'omitnan');
                    temp_std = std(s_event_analysis(i).traces,0,2,'omitnan');
                    nexttile;
                    hold on
                    for j=1:length(s_input.s_root(i).roi_coor.Coor)
                        m_event_avg(:,j) = temp_avg(:,:,j);
                        m_event_sem(:,j) = temp_std(:,:,j)/sqrt(m_Nevents(i,j));
                        shadedErrorBar(x_cut_time,m_event_avg(:,j),m_event_sem(:,j),'lineProps',{'Color',c_colors{j}});
                        %errorbar(x_cut_time,m_event_avg(:,j),m_event_sem(:,j));
                        xlim([-1 max(x_cut_time,[],'all')]);
                    end
                    hold off
					t = title(s_input.s_root(i).name,'Interpreter','none');
					t.Rotation = 10;
                    s_event_analysis(i).event_avg = m_event_avg;
                    s_event_analysis(i).event_sem = m_event_sem;
                end
            end
            c_legend = [s_event_analysis.names];
            lgd = legend(c_legend,'NumColumns',2,'FontSize',6);
            lgd.Layout.Tile = 'east';
            xlabel(fig_avg,'time (s)');
            ylabel(fig_avg,'df/f');
            fig_name = strcat('fig_events_average_',s_input.s_root(i).name,'_',s_input.s_root(1).root_id,'.pdf');
            fig_pop.PaperOrientation = 'landscape';
            print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
            close(fig_pop);
        end
        s_event_analysis(1).peak = m_Pevents;
        s_event_analysis(1).timing = m_Tevents;
        s_event_analysis(1).number = m_Nevents;
        s_event_analysis(1).duration = m_Devents;
        s_event_analysis(1).AUC = m_Aevents;
        fprintf('\ngraphing population metrics...\n\n');
		c_title = {};
		if strcmp(str_roi_type(c),'ad') == 1
			c_title = 'apical dendrites';
		elseif strcmp(str_roi_type(c),'bd') == 1
			c_title = 'basal dendrites';
		elseif strcmp(str_roi_type(c),'m') == 1
			c_title = 'mossy fibers';
		elseif strcmp(str_roi_type(c),'s') == 1
			c_title = 'somas';
		end
        c_lbl = {};
        for i=1:size(s_event_analysis(1).number,1)
            c_lbl{i} = s_input.s_root(i).name;
        end
        fig_Nevents = figure('position',[50,75,1300,600]);
        hold on
        for i=1:size(s_event_analysis(1).number,2)
            plot(s_event_analysis(1).number(:,i));
        end
        errorbar(mean(s_event_analysis(1).number,2,'omitnan'),std(s_event_analysis(1).number,0,2,'omitnan')/sqrt(size(s_event_analysis(1).number,2)),'_','Color','k','LineWidth',2,'MarkerSize',20);
        ylabel('number of events');
        set(gca,'TickLabelInterpreter','none')
		title(c_title,'Interpreter','none');
        xticks([1:1:size(s_event_analysis(1).number,1)]);
        xticklabels(c_lbl);
        axis padded
        hold off
        fig_name = strcat('fig_events_number_',s_input.s_root(1).root_id,'.pdf');
        fig_Nevents.PaperOrientation = 'landscape';
        print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
        close(fig_Nevents);
        fig_Pevents = figure('position',[50,75,1300,600]);
        temp_avg = squeeze(mean(s_event_analysis(1).peak,1,'omitnan'));
        hold on
        for i=1:size(s_event_analysis(1).peak,2)
            plot(temp_avg(i,:));
        end
        errorbar(mean(temp_avg,1,'omitnan'),std(temp_avg,0,1,'omitnan')/sqrt(size(temp_avg,1)),'_','Color','k','LineWidth',2,'MarkerSize',20);
        ylabel('event peak df/f');
        set(gca,'TickLabelInterpreter','none')
		title(c_title,'Interpreter','none');
        xticks([1:1:size(s_event_analysis(1).number,1)]);
        xticklabels(c_lbl);
        axis padded
        hold off
        fig_name = strcat('fig_events_peak_',s_input.s_root(1).root_id,'.pdf');
        fig_Pevents.PaperOrientation = 'landscape';
        print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
        close(fig_Pevents);
        fig_Devents = figure('position',[50,75,1300,600]);
        temp_avg = squeeze(mean(s_event_analysis(1).duration,1,'omitnan'));
        hold on
        for i=1:size(s_event_analysis(1).duration,2)
            plot(temp_avg(i,:));
        end
        errorbar(mean(temp_avg,1,'omitnan'),std(temp_avg,0,1,'omitnan')/sqrt(size(temp_avg,1)),'_','Color','k','LineWidth',2,'MarkerSize',20);
        ylabel('event duration (s)');
        set(gca,'TickLabelInterpreter','none')
		title(c_title,'Interpreter','none');
        xticks([1:1:size(s_event_analysis(1).number,1)]);
        xticklabels(c_lbl);
        axis padded
        hold off
        fig_name = strcat('fig_events_duration_',s_input.s_root(1).root_id,'.pdf');
        fig_Devents.PaperOrientation = 'landscape';
        print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
        close(fig_Devents);
        fig_Aevents = figure('position',[50,75,1300,600]);
        temp_avg = squeeze(mean(s_event_analysis(1).AUC,1,'omitnan'));
        hold on
        for i=1:size(s_event_analysis(1).AUC,2)
            plot(temp_avg(i,:));
        end
        errorbar(mean(temp_avg,1,'omitnan'),std(temp_avg,0,1,'omitnan')/sqrt(size(temp_avg,1)),'_','Color','k','LineWidth',2,'MarkerSize',20);
        ylabel('event AUC (df/f.s)');
        set(gca,'TickLabelInterpreter','none')
		title(c_title,'Interpreter','none');
        xticks([1:1:size(s_event_analysis(1).number,1)]);
        xticklabels(c_lbl);
        axis padded
        hold off
        %c_legend = [s_event_analysis.names];
        %lgd = legend(c_legend,'NumColumns',2,'FontSize',6,'Location','east');
        %lgd.Layout.Tile = 'east';
        fig_name = strcat('fig_events_AUC_',s_input.s_root(1).root_id,'.pdf');
        fig_Aevents.PaperOrientation = 'landscape';
        print(fullfile(s_input.s_root(1).root_folder,output_name,fig_name),'-dpdf','-r300','-bestfit');
        close(fig_Aevents);
        s_output(c).type = str_roi_type(c);
        s_output(c).data = s_input.s_root;
        s_output(c).analysis = s_event_analysis;
    end
    fprintf('\nsaving mat files...\n\n');
	save(fullfile(s_input.s_root(1).root_folder,output_name,'output_name.mat'),'s_output','-v7.3');
    toc;
	fprintf('\ndone!!!\n\n');
end