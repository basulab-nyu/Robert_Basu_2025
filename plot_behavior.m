function [] = plot_behavior(input_folder,output_folder)
	if (exist(output_folder,'dir'))
        if(~isempty(dir(fullfile(output_folder,'struct_behavior_lap*.mat'))));
            fprintf('\nbehavior already analyzed\n');
            return
        end 
	end
	fprintf('\nanalyzing behavior...\n');
    temp_load = load(fullfile(output_folder,'Behavior.mat'));
    struct_behavior = temp_load.Behavior;
    var_Gfam = 95;
    var_Gint = 155;
    var_Gnov = 35;
    v_str_cut = strfind(input_folder,'\');
    if isempty(v_str_cut) == 1
        v_str_cut = strfind(input_folder,'/');
    end
    temp_name = extractAfter(input_folder,v_str_cut(length(v_str_cut)));
    v_start_lap_time = NaN(size(struct_behavior.lap,2),1);
    v_end_lap_time = NaN(size(struct_behavior.lap,2),1);
    v_start_lap_index = NaN(size(struct_behavior.lap,2),1);
    v_end_lap_index = NaN(size(struct_behavior.lap,2),1);
    for i = 1:size(struct_behavior.lap,2)
        v_start_lap_time(i) = struct_behavior.lap{1,i}(1);
        v_end_lap_time(i) = struct_behavior.lap{1,i}(2);
        v_start_lap_index(i) = find(struct_behavior.time==v_start_lap_time(i),1);
        v_end_lap_index(i) = find(struct_behavior.time==v_end_lap_time(i),1);
    end
    v_size_lap = v_end_lap_index - v_start_lap_index + 1;
    m_position_lap = NaN(max(v_size_lap),size(struct_behavior.lap,2));
    m_time_lap = NaN(max(v_size_lap),size(struct_behavior.lap,2));
    m_lick_lap = NaN(max(v_size_lap),size(struct_behavior.lap,2));
    m_speed_lap = NaN(max(v_size_lap),size(struct_behavior.lap,2));
    for i = 1:size(struct_behavior.lap,2)
        m_position_lap(1:v_size_lap(i),i) = struct_behavior.position(v_start_lap_index(i):v_end_lap_index(i));
        m_time_lap(1:v_size_lap(i),i) = struct_behavior.time(v_start_lap_index(i):v_end_lap_index(i));
        m_lick_lap(1:v_size_lap(i),i) = struct_behavior.lick(v_start_lap_index(i):v_end_lap_index(i));
        temp_speed = diff(struct_behavior.position(v_start_lap_index(i):v_end_lap_index(i)))./diff(struct_behavior.time(v_start_lap_index(i):v_end_lap_index(i)));
        temp_speed(size(temp_speed,1)+1,:) = NaN;
        m_speed_lap(1:v_size_lap(i),i) = temp_speed;
        %m_speed_lap(1:v_size_lap(i),i) = diff(struct_behavior.position(v_start_lap_index(i):v_end_lap_index(i)))./diff(struct_behavior.time(v_start_lap_index(i):v_end_lap_index(i)));
    end
    m_time_bin_10 = NaN(20,size(struct_behavior.lap,2));
    m_lick_bin_10 = NaN(20,size(struct_behavior.lap,2));
    m_speed_bin_10 = NaN(20,size(struct_behavior.lap,2));
    m_pos_bin_start_idx_10 = NaN(20,size(struct_behavior.lap,2));
    m_pos_bin_end_idx_10 = NaN(20,size(struct_behavior.lap,2));
    m_pos_bin_center_10 = NaN(20,size(struct_behavior.lap,2));
    m_time_bin_4 = NaN(50,size(struct_behavior.lap,2));
    m_lick_bin_4 = NaN(50,size(struct_behavior.lap,2));
    m_speed_bin_4 = NaN(50,size(struct_behavior.lap,2));
    m_pos_bin_start_idx_4 = NaN(50,size(struct_behavior.lap,2));
    m_pos_bin_end_idx_4 = NaN(50,size(struct_behavior.lap,2));
    m_pos_bin_center_4 = NaN(50,size(struct_behavior.lap,2));
    m_norm_pos_lap = m_position_lap;
    for i = 1:size(struct_behavior.lap,2)
        m_norm_pos_lap(:,i) = 200*m_norm_pos_lap(:,i)/max(m_norm_pos_lap(:,i));
        for j = 1:20
            m_pos_bin_start_idx_10(j,i) = find(abs(m_norm_pos_lap(:,i) - (10*j-10)) < 0.2 ,1);
            m_pos_bin_end_idx_10(j,i) = find(abs(m_norm_pos_lap(:,i) - (10*j-0.09)) < 0.2 ,1);
            m_pos_bin_center_10(j,i) = 10*j-5;
        end
        for k = 1:50
            m_pos_bin_start_idx_4(k,i) = find(abs(m_norm_pos_lap(:,i) - (4*k-4)) < 0.2 ,1);
            m_pos_bin_end_idx_4(k,i) = find(abs(m_norm_pos_lap(:,i) - (4*k-0.09)) < 0.2 ,1);
            m_pos_bin_center_4(k,i) = 4*k-2;
        end
    end
    for i = 1:size(struct_behavior.lap,2)
        for j = 1:20
            m_lick_bin_10(j,i) = size(find(diff(m_lick_lap(m_pos_bin_start_idx_10(j,i):m_pos_bin_end_idx_10(j,i),i))>=1),1);
            m_time_bin_10(j,i) = m_time_lap(m_pos_bin_end_idx_10(j,i),i)-m_time_lap(m_pos_bin_start_idx_10(j,i),i);
            %m_lick_bin(j,i) = 0.5*sum(m_lick_lap(m_pos_bin_start_idx(j,i):m_pos_bin_end_idx(j,i),i),'omitnan');
            m_speed_bin_10(j,i) = mean(m_speed_lap(m_pos_bin_start_idx_10(j,i):m_pos_bin_end_idx_10(j,i),i));
        end
        for k = 1:50
            m_lick_bin_4(k,i) = size(find(diff(m_lick_lap(m_pos_bin_start_idx_4(k,i):m_pos_bin_end_idx_4(k,i),i))>=1),1);
            m_time_bin_4(k,i) = m_time_lap(m_pos_bin_end_idx_4(k,i),i)-m_time_lap(m_pos_bin_start_idx_4(k,i),i);
            m_speed_bin_4(k,i) = mean(m_speed_lap(m_pos_bin_start_idx_4(k,i):m_pos_bin_end_idx_4(k,i),i));
        end
    end
    m_time_bin_10_avg = mean(m_time_bin_10,2);
    m_lick_bin_10_avg = mean(m_lick_bin_10,2);
    m_speed_bin_10_avg = mean(m_speed_bin_10,2);
    m_time_bin_10_sem = std(m_time_bin_10,0,2)/sqrt(size(m_time_bin_10,2));
    m_lick_bin_10_sem = std(m_lick_bin_10,0,2)/sqrt(size(m_lick_bin_10,2));
    m_speed_bin_10_sem = std(m_speed_bin_10,0,2)/sqrt(size(m_speed_bin_10,2));
    m_time_bin_4_avg = mean(m_time_bin_4,2);
    m_lick_bin_4_avg = mean(m_lick_bin_4,2);
    m_speed_bin_4_avg = mean(m_speed_bin_4,2);
    m_time_bin_4_sem = std(m_time_bin_4,0,2)/sqrt(size(m_time_bin_4,2));
    m_lick_bin_4_sem = std(m_lick_bin_4,0,2)/sqrt(size(m_lick_bin_4,2));
    m_speed_bin_4_sem = std(m_speed_bin_4,0,2)/sqrt(size(m_speed_bin_4,2));
    m_lick_scat = diff(m_lick_lap)>=1;
    m_lick_scat = double(m_lick_scat);
    m_lick_scat(size(m_lick_scat,1)+1,:) = NaN;
    m_lick_scat(m_lick_scat == 0) = NaN;
    v_offset = [1:1:size(struct_behavior.lap,2)];
    m_lick_scat = m_lick_scat.*v_offset;
    fig_raster = figure;
    plot(m_norm_pos_lap,m_lick_scat,'|','Color','k');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('lick raster');
    xlabel('position (cm)');
    ylabel('lap #');
    axis padded;
    axis ij;
    xlim([0 200]);
    hold off
    fig_name = strcat('fig_raster_',temp_name,'.pdf');
    saveas(fig_raster,fullfile(output_folder,fig_name));
    close(fig_raster);
    fig_time_10 = figure;
    %plot(m_pos_bin_center(:,1),m_time_bin_avg);
    errorbar(m_pos_bin_center_10(:,1),m_time_bin_10_avg,m_time_bin_10_sem);
    %title('occupancy');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('occupancy (10cm bins)');
    xlabel('position (cm)');
    ylabel('time (s)');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_time_10_',temp_name,'.pdf');
    saveas(fig_time_10,fullfile(output_folder,fig_name));
    close(fig_time_10);
    fig_time_4 = figure;
    %plot(m_pos_bin_center(:,1),m_time_bin_avg);
    errorbar(m_pos_bin_center_4(:,1),m_time_bin_4_avg,m_time_bin_4_sem);
    %title('occupancy');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('occupancy (4cm bins)');
    xlabel('position (cm)');
    ylabel('time (s)');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_time_4_',temp_name,'.pdf');
    saveas(fig_time_4,fullfile(output_folder,fig_name));
    close(fig_time_4);
    fig_lick_10 = figure;
    errorbar(m_pos_bin_center_10(:,1),m_lick_bin_10_avg,m_lick_bin_10_sem);
    %title('licking');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('licking (10cm bins)');
    xlabel('position (cm)');
    ylabel('number of licks');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_lick_10_',temp_name,'.pdf');
    saveas(fig_lick_10,fullfile(output_folder,fig_name));
    close(fig_lick_10);
    fig_lick_4 = figure;
    errorbar(m_pos_bin_center_4(:,1),m_lick_bin_4_avg,m_lick_bin_4_sem);
    %title('licking');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('licking (4cm bins)');
    xlabel('position (cm)');
    ylabel('number of licks');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_lick_4_',temp_name,'.pdf');
    saveas(fig_lick_4,fullfile(output_folder,fig_name));
    close(fig_lick_4);    
    fig_speed_10 = figure;
    %plot(m_pos_bin_center(:,1),m_time_bin_avg);
    errorbar(m_pos_bin_center_10(:,1),m_speed_bin_10_avg,m_speed_bin_10_sem);
    %title('occupancy');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('speed (10cm bins)');
    xlabel('position (cm)');
    ylabel('speed (cm/s)');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_speed_10_',temp_name,'.pdf');
    saveas(fig_speed_10,fullfile(output_folder,fig_name));
    close(fig_speed_10);
    fig_speed_4 = figure;
    %plot(m_pos_bin_center(:,1),m_time_bin_avg);
    errorbar(m_pos_bin_center_4(:,1),m_speed_bin_4_avg,m_speed_bin_4_sem);
    %title('occupancy');
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('speed (4cm bins)');
    xlabel('position (cm)');
    ylabel('speed (cm/s)');
    xlim([0 200]);
    ylim([0 inf]);
    hold off
    fig_name = strcat('fig_speed_4_',temp_name,'.pdf');
    saveas(fig_speed_4,fullfile(output_folder,fig_name));
    close(fig_speed_4);   
    m_lick_bin_10_G = NaN(size(m_lick_bin_10,2),1);
    m_lick_bin_10_G_mode = NaN(size(m_lick_bin_10,2),1);
    m_lick_bin_10_G_median = NaN(size(m_lick_bin_10,2),1);
    m_lick_bin_10_G_std = NaN(size(m_lick_bin_10,2),1);
	[temprow,tempcol] = find(m_lick_bin_10);
    tempcolu = unique(tempcol);
    for r=1:length(tempcolu)
        m_lick_bin_10_G(tempcolu(r)) = mean(temprow(find(tempcol == tempcolu(r))),'all','omitnan');
        m_lick_bin_10_G_mode(tempcolu(r)) = mode(temprow(find(tempcol == tempcolu(r))),'all');
        m_lick_bin_10_G_median(tempcolu(r)) = median(temprow(find(tempcol == tempcolu(r))),'all','omitnan');
        m_lick_bin_10_G_std(tempcolu(r)) = std(temprow(find(tempcol == tempcolu(r))),0,'all','omitnan');
    end
    m_lick_bin_10_G = (m_lick_bin_10_G*4);
    m_lick_bin_10_G_mode = (m_lick_bin_10_G_mode*4);
    m_lick_bin_10_G_median = (m_lick_bin_10_G_median*4);
    m_lick_bin_10_G_std = (m_lick_bin_10_G_std*4);
    fig_goal_10 = figure;
    plot(m_lick_bin_10_G,[1:1:length(m_lick_bin_10_G)],'+','Color','k','LineWidth',2)
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('licks position (10cm bins)');
    xlim([0 200]);
    xfam = xline(var_Gfam,'-','fam');
    xfam.LineWidth = 2;
    xfam.Color = 'r';
    xint = xline(var_Gint,'-','int');
    xint.LineWidth = 2;
    xint.Color = 'g';
    xnov = xline(var_Gnov,'-','nov');
    xnov.LineWidth = 2;
    xnov.Color = 'b';
    ylabel('lap #');
    xlabel('position (cm)');
    axis ij
    hold off
    fig_name = strcat('fig_goal_10_',temp_name,'.pdf');
    saveas(fig_goal_10,fullfile(output_folder,fig_name));
    close(fig_goal_10);
    fig_goal_10_fam = figure;
    errorbar(m_lick_bin_10_G-var_Gfam,m_lick_bin_10_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_10_G_mode-var_Gfam,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_10_G_median-var_Gfam,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_10_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs fam goal location (10cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_fam = gca;
    ylim([-1.1*max([abs(ax_fam.YLim(1)) abs(ax_fam.YLim(2))]) 1.1*max([abs(ax_fam.YLim(1)) abs(ax_fam.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_10_fam_',temp_name,'.pdf');
    saveas(fig_goal_10_fam,fullfile(output_folder,fig_name));
    close(fig_goal_10_fam);
    fig_goal_10_int = figure;
    errorbar(m_lick_bin_10_G-var_Gint,m_lick_bin_10_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_10_G_mode-var_Gint,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_10_G_median-var_Gint,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_10_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs int goal location (10cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_int = gca;
    ylim([-1.1*max([abs(ax_int.YLim(1)) abs(ax_int.YLim(2))]) 1.1*max([abs(ax_int.YLim(1)) abs(ax_int.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_10_int_',temp_name,'.pdf');
    saveas(fig_goal_10_int,fullfile(output_folder,fig_name));
    close(fig_goal_10_int);
    fig_goal_10_nov = figure;
    errorbar(m_lick_bin_10_G-var_Gnov,m_lick_bin_10_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_10_G_mode-var_Gnov,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_10_G_median-var_Gnov,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_10_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs nov goal location (10cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_nov = gca;
    ylim([-1.1*max([abs(ax_nov.YLim(1)) abs(ax_nov.YLim(2))]) 1.1*max([abs(ax_nov.YLim(1)) abs(ax_nov.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_10_nov_',temp_name,'.pdf');
    saveas(fig_goal_10_nov,fullfile(output_folder,fig_name));
    close(fig_goal_10_nov);
    m_lick_bin_4_G = NaN(size(m_lick_bin_4,2),1);
    m_lick_bin_4_G_mode = NaN(size(m_lick_bin_4,2),1);
    m_lick_bin_4_G_median = NaN(size(m_lick_bin_4,2),1);
    m_lick_bin_4_G_std = NaN(size(m_lick_bin_4,2),1);
	[temprow,tempcol] = find(m_lick_bin_4);
    tempcolu = unique(tempcol);
    for r=1:length(tempcolu)
        m_lick_bin_4_G(tempcolu(r)) = mean(temprow(find(tempcol == tempcolu(r))),'all','omitnan');
        m_lick_bin_4_G_mode(tempcolu(r)) = mode(temprow(find(tempcol == tempcolu(r))),'all');
        m_lick_bin_4_G_median(tempcolu(r)) = median(temprow(find(tempcol == tempcolu(r))),'all','omitnan');
        m_lick_bin_4_G_std(tempcolu(r)) = std(temprow(find(tempcol == tempcolu(r))),0,'all','omitnan');
    end
    m_lick_bin_4_G = (m_lick_bin_4_G*4);
    m_lick_bin_4_G_mode = (m_lick_bin_4_G_mode*4);
    m_lick_bin_4_G_median = (m_lick_bin_4_G_median*4);
    m_lick_bin_4_G_std = (m_lick_bin_4_G_std*4);
    fig_goal_4 = figure;
    plot(m_lick_bin_4_G,[1:1:length(m_lick_bin_4_G)],'+','Color','k','LineWidth',2)
    hold on
    title(temp_name,'Interpreter','none');
    subtitle('licks position (4cm bins)');
    xlim([0 200]);
    xfam = xline(var_Gfam,'-','fam');
    xfam.LineWidth = 2;
    xfam.Color = 'r';
    xint = xline(var_Gint,'-','int');
    xint.LineWidth = 2;
    xint.Color = 'g';
    xnov = xline(var_Gnov,'-','nov');
    xnov.LineWidth = 2;
    xnov.Color = 'b';
    ylabel('lap #');
    xlabel('position (cm)');
    axis ij
    hold off
    fig_name = strcat('fig_goal_4_',temp_name,'.pdf');
    saveas(fig_goal_4,fullfile(output_folder,fig_name));
    close(fig_goal_4);
    fig_goal_4_fam = figure;
    errorbar(m_lick_bin_4_G-var_Gfam,m_lick_bin_4_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_4_G_mode-var_Gfam,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_4_G_median-var_Gfam,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_4_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs fam goal location (4cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_fam = gca;
    ylim([-1.1*max([abs(ax_fam.YLim(1)) abs(ax_fam.YLim(2))]) 1.1*max([abs(ax_fam.YLim(1)) abs(ax_fam.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_4_fam_',temp_name,'.pdf');
    saveas(fig_goal_4_fam,fullfile(output_folder,fig_name));
    close(fig_goal_4_fam);
    fig_goal_4_int = figure;
    errorbar(m_lick_bin_4_G-var_Gint,m_lick_bin_4_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_4_G_mode-var_Gint,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_4_G_median-var_Gint,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_4_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs int goal location (4cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_int = gca;
    ylim([-1.1*max([abs(ax_int.YLim(1)) abs(ax_int.YLim(2))]) 1.1*max([abs(ax_int.YLim(1)) abs(ax_int.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_4_int_',temp_name,'.pdf');
    saveas(fig_goal_4_int,fullfile(output_folder,fig_name));
    close(fig_goal_4_int);
    fig_goal_4_nov = figure;
    errorbar(m_lick_bin_4_G-var_Gnov,m_lick_bin_4_G_std,'+','Color','k','LineWidth',2)
    hold on
    plot(m_lick_bin_4_G_mode-var_Gnov,'+','Color','b','LineWidth',2)
    plot(m_lick_bin_4_G_median-var_Gnov,'+','Color','g','LineWidth',2)
    plot(m_lick_bin_4_G_std,'+','Color','r','LineWidth',2)
    title(temp_name,'Interpreter','none');
    subtitle('licks position vs nov goal location (4cm bins)');
    xlabel('lap #');
    ylabel('position (cm)');
    axis padded
    ax_nov = gca;
    ylim([-1.1*max([abs(ax_nov.YLim(1)) abs(ax_nov.YLim(2))]) 1.1*max([abs(ax_nov.YLim(1)) abs(ax_nov.YLim(2))])]);
    yline(0,'--');
    legend('mean+/-sd','mode','median','sd','Location','best')
    hold off
    fig_name = strcat('fig_goal_4_nov_',temp_name,'.pdf');
    saveas(fig_goal_4_nov,fullfile(output_folder,fig_name));
    close(fig_goal_4_nov);
    struct_behavior_lap = struct;
    struct_behavior_lap.m_position_lap = m_position_lap;
    struct_behavior_lap.m_norm_pos_lap = m_norm_pos_lap;
    struct_behavior_lap.m_time_lap = m_time_lap;
    struct_behavior_lap.m_pos_bin_center_10 = m_pos_bin_center_10;
    struct_behavior_lap.m_time_bin_10 = m_time_bin_10;
    struct_behavior_lap.m_time_bin_10_avg = m_time_bin_10_avg;
    struct_behavior_lap.m_time_bin_10_sem = m_time_bin_10_sem;
    struct_behavior_lap.m_pos_bin_center_4 = m_pos_bin_center_4;
    struct_behavior_lap.m_time_bin_4 = m_time_bin_4;
    struct_behavior_lap.m_time_bin_4_avg = m_time_bin_4_avg;
    struct_behavior_lap.m_time_bin_4_sem = m_time_bin_4_sem;
    struct_behavior_lap.m_lick_lap = m_lick_lap;
    struct_behavior_lap.m_lick_bin_10 = m_lick_bin_10;
    struct_behavior_lap.m_lick_bin_10_avg = m_lick_bin_10_avg;
    struct_behavior_lap.m_lick_bin_10_sem = m_lick_bin_10_sem;
    struct_behavior_lap.m_lick_bin_4 = m_lick_bin_4;
    struct_behavior_lap.m_lick_bin_4_avg = m_lick_bin_4_avg;
    struct_behavior_lap.m_lick_bin_4_sem = m_lick_bin_4_sem;
    struct_behavior_lap.m_speed_lap = m_speed_lap;
    struct_behavior_lap.m_speed_bin_10 = m_speed_bin_10;
    struct_behavior_lap.m_speed_bin_10_avg = m_speed_bin_10_avg;
    struct_behavior_lap.m_speed_bin_10_sem = m_speed_bin_10_sem;
    struct_behavior_lap.m_speed_bin_4 = m_speed_bin_4;
    struct_behavior_lap.m_speed_bin_4_avg = m_speed_bin_4_avg;
    struct_behavior_lap.m_speed_bin_4_sem = m_speed_bin_4_sem;
    struct_behavior_lap.m_lick_bin_10_G = m_lick_bin_10_G;
	struct_behavior_lap.m_lick_bin_10_G_mode = m_lick_bin_10_G_mode;
	struct_behavior_lap.m_lick_bin_10_G_median = m_lick_bin_10_G_median;
	struct_behavior_lap.m_lick_bin_10_G_std = m_lick_bin_10_G_std;
	struct_behavior_lap.m_lick_bin_10_G_fam = m_lick_bin_10_G - var_Gfam;
	struct_behavior_lap.m_lick_bin_10_G_mode_fam = m_lick_bin_10_G_mode - var_Gfam;
	struct_behavior_lap.m_lick_bin_10_G_median_fam = m_lick_bin_10_G_median - var_Gfam;
	struct_behavior_lap.m_lick_bin_10_G_int = m_lick_bin_10_G - var_Gint;
	struct_behavior_lap.m_lick_bin_10_G_mode_int = m_lick_bin_10_G_mode - var_Gint;
	struct_behavior_lap.m_lick_bin_10_G_median_int = m_lick_bin_10_G_median - var_Gint;
	struct_behavior_lap.m_lick_bin_10_G_nov = m_lick_bin_10_G - var_Gnov;
	struct_behavior_lap.m_lick_bin_10_G_mode_nov = m_lick_bin_10_G_mode - var_Gnov;
	struct_behavior_lap.m_lick_bin_10_G_median_nov = m_lick_bin_10_G_median - var_Gnov;
    struct_behavior_lap.m_lick_bin_4_G = m_lick_bin_4_G;
	struct_behavior_lap.m_lick_bin_4_G_mode = m_lick_bin_4_G_mode;
	struct_behavior_lap.m_lick_bin_4_G_median = m_lick_bin_4_G_median;
	struct_behavior_lap.m_lick_bin_4_G_std = m_lick_bin_4_G_std;
	struct_behavior_lap.m_lick_bin_4_G_fam = m_lick_bin_4_G - var_Gfam;
	struct_behavior_lap.m_lick_bin_4_G_mode_fam = m_lick_bin_4_G_mode - var_Gfam;
	struct_behavior_lap.m_lick_bin_4_G_median_fam = m_lick_bin_4_G_median - var_Gfam;
	struct_behavior_lap.m_lick_bin_4_G_int = m_lick_bin_4_G - var_Gint;
	struct_behavior_lap.m_lick_bin_4_G_mode_int = m_lick_bin_4_G_mode - var_Gint;
	struct_behavior_lap.m_lick_bin_4_G_median_int = m_lick_bin_4_G_median - var_Gint;
	struct_behavior_lap.m_lick_bin_4_G_nov = m_lick_bin_4_G - var_Gnov;
	struct_behavior_lap.m_lick_bin_4_G_mode_nov = m_lick_bin_4_G_mode - var_Gnov;
	struct_behavior_lap.m_lick_bin_4_G_median_nov = m_lick_bin_4_G_median - var_Gnov;
	struct_behavior_lap.m_lick_scat = m_lick_scat;
    %assignin('base','struct_behavior_lap',struct_behavior_lap); %%%
    output_name = strcat('struct_behavior_lap_',temp_name,'.mat');
    %save(fullfile(output_folder,'struct_behavior_lap.mat'),'struct_behavior_lap');
    save(fullfile(output_folder,output_name),'struct_behavior_lap'); %%%
    fprintf('\nbehavior analyzed!!!\n');
    %assignin('base','m_lick_bin_4_avg',m_lick_bin_4_avg)
    %assignin('base','m_lick_bin_4_sem',m_lick_bin_4_sem)
end