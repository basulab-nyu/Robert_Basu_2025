% First run guided_merge_general.m to load in a dataset

root_folder = '/gpfs/data/basulab/VR/cohort_7/m30';
input_mat = 'ROI_merge.mat';
output_mat = 'ROI_link.mat';

addpath(genpath('code'));
load(fullfile(root_folder,input_mat));
DIM = [512 512];
cROIs = ROI_SET.cROI;
cROIs2 = reshape(full(cROIs),[DIM size(cROIs,2)]);
for i_roi = 1:size(cROIs,2)
    cROIs2(:,:,i_roi) = gaussian_smooth_2d(cROIs2(:,:,i_roi),3)>0;
end
cROIs2 = sparse(reshape(cROIs2,[prod(DIM) size(cROIs,2)]));
nOverlap = triu(cROIs2'*cROIs2,1);
%%
ccc = triu(corrcoef(ROI_SET.Cs2'),1);
ddd = triu(corrcoef(corTrace'),1);
[a,b] = find((ccc>0.7) & (nOverlap>0));
zY = zscore(double(Y),[],2);    
order = 1:length(a);
linked = cell(size(a));
i = 1;
%%
while i<=length(order)
    clf;
    idx1 = a(i);
    idx2 = b(i);

    subplot(2,4,1);
    this = reshape(ROI_SET.cROI(:,idx1)+2*ROI_SET.cROI(:,idx2),DIM);
    imagesc(this);
    [bb,aa] = find(this>0);
    xlim([min(aa)-20 max(aa)+20]);
    ylim([min(bb)-20 max(bb)+20]);
    % axis equal;
    title(sprintf('%d of %d: %s', i, length(order), linked{i}));
    [aa1,bb1] = find(reshape(ROI_SET.cROI(:,idx1)>0,DIM));
    c1 = boundary(aa1,bb1,1);
    [aa2,bb2] = find(reshape(ROI_SET.cROI(:,idx2)>0,DIM));
    c2 = boundary(aa2,bb2,1);
    caxis([0 3]);
    x = xlabel('Z: Previous      X: Next      Y: Connected      N: Not Connected');
    x.Position = x.Position+[range(xlim)*0.5 range(ylim)*0.1 0];
    x.FontSize = 14;
    
    subplot(2,2,2);
    h = plot_offset(1:size(ROI_SET.Cs2,2),ROI_SET.Cs2([idx1 idx2],:)');
    h(2).Color = [0 0.5 0];
    text(min(xlim),max(h(1).YData),sprintf(' %d',idx1),'Fontsize',14);
    text(min(xlim),max(h(2).YData),sprintf(' %d',idx2),'Fontsize',14);
    
    title(sprintf('C: %.02f',ccc(idx1,idx2)));
    ylabel('\DeltaF/F');
    
    these = corTrace([idx1 idx2],:);
    [~,frame1] = max(these(1,:));
    [~,frame2] = max(these(2,:));
    [~,frame12] = max(sqrt(sum(these.^2,1)));
    subplot(2,2,4);
    h = plot_offset(1:size(ROI_SET.Cs2,2),these');
    h(2).Color = [0 0.5 0];
    text(min(xlim),max(h(1).YData),sprintf(' %d',idx1),'Fontsize',14);
    text(min(xlim),max(h(2).YData),sprintf(' %d',idx2),'Fontsize',14);
    title(sprintf('C: %.02f',ddd(idx1,idx2)));
    ylabel('Fitness');
    
    subplot(2,4,2);
    imagescc(zY(:,frame1));
    xlim([min(aa)-20 max(aa)+20]);
    ylim([min(bb)-20 max(bb)+20]);
    % axis equal;
    caxis([0 5]);
    hold on;
    plot(bb1(c1),aa1(c1),'r','Linewidth',2);
    plot(bb2(c2),aa2(c2),'r','Linewidth',2);
    title(sprintf('%d', idx1));
    
    subplot(2,4,5);
    imagescc(zY(:,frame2));
    xlim([min(aa)-20 max(aa)+20]);
    ylim([min(bb)-20 max(bb)+20]);
    % axis equal;
    caxis([0 5]);
    hold on;
    plot(bb1(c1),aa1(c1),'r','Linewidth',2);
    plot(bb2(c2),aa2(c2),'r','Linewidth',2);
    title(sprintf('%d', idx2));
    
    subplot(2,4,6);
    imagescc(zY(:,frame12));
    xlim([min(aa)-20 max(aa)+20]);
    ylim([min(bb)-20 max(bb)+20]);
    % axis equal;
    caxis([0 5]);
    hold on;
    plot(bb1(c1),aa1(c1),'r','Linewidth',2);
    plot(bb2(c2),aa2(c2),'r','Linewidth',2);
    title(sprintf('%d - %d', idx1, idx2));
    
    w = waitforbuttonpress;
    if w
       p = get(gcf, 'CurrentCharacter');
       if(strcmp(p,'z') && order(i)>1)
           i = i-1;
       elseif(strcmp(p,'z') && order(i)<=1)
           % Do nothing
       elseif(strcmp(p,'x') && order(i)<length(linked))
           i = i+1;
       else
           linked{order(i)} = p;
           i = i+1;
       end
            
    end
end
%
linked = cellfun(@(x) strcmp(x,'y'), linked);
connected = sparse(a(linked),b(linked),ones(1,sum(linked)),size(cROIs,2),size(cROIs,2));
save('/gpfs/data/basulab/VR/cohort_7/m30/ROI_link.mat','connected','-v7.3');