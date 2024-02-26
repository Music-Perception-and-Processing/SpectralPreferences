function CLUSTER = F_Cluster(dprim_all)
CC = corrcoef(dprim_all);
for sub = 1:length(CC)
    GR(sub,:) = CC(sub,:) > mean(CC,'all')*1.5;
end
% Heatmap
figure(6);clf(6)
HM.D = CC; %HM.D(HM.D<0.5) = nan;
HM.P  = heatmap(HM.D,'colormap',parula);
HM.P.XDisplayLabels = [strcat('Subj',string(1:size(HM.D,1)))];
HM.P.YDisplayLabels = [strcat('Subj',string(1:size(HM.D,1)))];
set(gca,'FontSize',12);
set(gcf,'Position', [0,0, 800, 800]);set(gcf,'color','w');
title('Experiment 2 - Correlation')
saveas(gcf,'Plot\Cluster_HeatMap.png')
% Participant Plots
figure(1);clf(1);
ST = [1:4:size(dprim_all,1)]; EN = [4:4:size(dprim_all,1)];
XV = [1:4;3:6;1:4;3:6];
L =  size(dprim_all,2);
for sub = 1:L
    subplot(5,6,sub)
    hold on
    for idx = 1:4
        AVG = dprim_all(ST(idx):EN(idx),sub);
        plot(XV(idx,:),AVG,'Linewidth',3)
    end
    ylim([0,4]); box on
    title(['',num2str(sub),'Subs'])
    hold off
    set(gca,'FontSize',12);
    xticklabels({''})
    yticklabels({''})
end
set(gca,'FontSize',12);
set(gcf,'Position', [0,0, 800, 800]);set(gcf,'color','w');
sgtitle('Experiment 2 - Participants','FontSize',16,'FontWeight','bold')
saveas(gcf,'Plot\Cluster_Subjects.png')
%% Subject categorisation
CLUSTER.GRP.L = size(dprim_all,2);     % Number of subjects
CLUSTER.GRP.P = nan(sub,idx,4);        % CLUSTER.GRP.P of group
for sub = 1:CLUSTER.GRP.L
    for idx = 1:4
        data = dprim_all(ST(idx):EN(idx),sub);
        CLUSTER.GRP.P(sub,idx,1) = data(1) > mean([data(2),data(3)]); % Is band 1 larger than band 2&3
        CLUSTER.GRP.P(sub,idx,2) = data(2) > data(3); % Is band 1 larger than band 2
        CLUSTER.GRP.P(sub,idx,3) = data(3) > data(2); % Is band 1 larger than band 2
        CLUSTER.GRP.P(sub,idx,4) = data(4) > mean([data(2),data(3)]); % Is band 4 larger than band 2&3
        CLUSTER.GRP.P(sub,idx,5) = var(data);
    end
end
% Are u an edgelord or CLUSTER.GRP.FE?
CLUSTER.GRP.EL = (sum([CLUSTER.GRP.P(:,3,1)' + CLUSTER.GRP.P(:,3,4)'; ...
CLUSTER.GRP.P(:,4,1)' + CLUSTER.GRP.P(:,4,4)'] == 2) == 2);
CLUSTER.GRP.SE = (sum([~CLUSTER.GRP.P(:,3,1)' + ~CLUSTER.GRP.P(:,3,4)'; ...
~CLUSTER.GRP.P(:,4,1)' + ~CLUSTER.GRP.P(:,4,4)'] == 2) == 2);
CLUSTER.GRP.FE = (sum([CLUSTER.GRP.P(:,1,5) < quantile(squeeze(CLUSTER.GRP.P(:,1,5)),0.33),...
              CLUSTER.GRP.P(:,2,5) < quantile(squeeze(CLUSTER.GRP.P(:,2,5)),0.33),...
              CLUSTER.GRP.P(:,3,5) < quantile(squeeze(CLUSTER.GRP.P(:,3,5)),0.33),...
              CLUSTER.GRP.P(:,4,5) < quantile(squeeze(CLUSTER.GRP.P(:,4,5)),0.33)],2) == 3);
CLUSTER.GRP.PO                 = 1:30;
CLUSTER.GRP.PO(CLUSTER.GRP.EL) = 0;
CLUSTER.GRP.PO(CLUSTER.GRP.FE) = 0;
CLUSTER.GRP.EL(CLUSTER.GRP.FE) = 0;
CLUSTER.GRP.PO = find(CLUSTER.GRP.PO);
CLUSTER.GRP.FE = find(CLUSTER.GRP.FE);
CLUSTER.GRP.EL = find(CLUSTER.GRP.EL);
CLUSTER.GRP.SE = find(CLUSTER.GRP.SE);
CLUSTER.GRP.ALL= {CLUSTER.GRP.EL,CLUSTER.GRP.FE,CLUSTER.GRP.SE,CLUSTER.GRP.PO};
CLUSTER.GRP.DES1= {'Edgelords','Flatearther','Plateau people','Poser'};
CLUSTER.GRP.DES2= {'(edge effect in both MIXTAR)','(smallest variance)','(reversed edge effect)','(other)'};
%% PLOT everything
figure(2);clf(2);
for fC = 1:length(CLUSTER.GRP.ALL)
subplot(2,2,fC)
dIdxGrp = CLUSTER.GRP.ALL{fC};
hold on
for dIdxCond = 1:4
     for dSub = 1:length(dIdxGrp)
        dData = dprim_all(ST(dIdxCond):EN(dIdxCond),dIdxGrp(dSub));
        plot(XV(dIdxCond,:),dData,'Linewidth',2,'Color',[rand(3,1);0.1])
     end
end
for dIdxCond = 1:4
    dData = mean(dprim_all(ST(idx):EN(idx),dIdxGrp),2);
    plot(XV(dIdxCond,:),dData,'Linewidth',5)
end
ylabel('d score');xticks(1:6); xticklabels([65,215,441,783,1230,2080])
ylim([0,4]);box on;xlim([0.5,6.5])
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
title({[CLUSTER.GRP.DES1{fC},' #',num2str(length(dIdxGrp))];CLUSTER.GRP.DES2{fC}})
hold off
end
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
set(gcf,'Position', [0,0, 800, 1000]);set(gcf,'color','w');
sgtitle('Experiment 2 - Cluster','FontSize',16,'FontWeight','bold')
saveas(gcf,'Plot\Cluster_CLUSTER.GRP.P1.png')
%% K Means Clustering
% k-means clustering tries to organize data into k groups by finding points
% that are close together. It does this by iteratively adjusting the cluster 
% centers until they represent the center of mass for the data points assigned to each cluster.
% CLUSTER.ID   = Index that determine which participant belongs to which cluster
% CLUSTER.SUMD = Distance from cluster to centroid
data = dprim_all;
ST = [1:4:size(dprim_all,1)]; EN = [4:4:size(dprim_all,1)];
XV = [1:4;3:6;1:4;3:6];
for fCA = 1:6
    CLUSTER_MAX = 1+fCA;
    [CLUSTER.ID, ~, CLUSTER.SUMD] = kmeans(data',CLUSTER_MAX);
figure(30+fCA);clf(30+fCA);
for fC = 1:CLUSTER_MAX
    CLUSTER.IDx  = find(fC == CLUSTER.ID);
    CLUSTER.DATA = data(:,CLUSTER.IDx);
subplot(ceil(sqrt(CLUSTER_MAX)),ceil(sqrt(CLUSTER_MAX)),fC)
hold on
for fIdx = 1:4
     for idx2 = 1:length(CLUSTER.IDx)
        plot(XV(fIdx,:),CLUSTER.DATA(ST(fIdx):EN(fIdx),idx2),'Linewidth',2,'Color',[rand(3,1);0.1])
     end
end
for fIdx = 1:4
    AVG = mean(CLUSTER.DATA,2);
    plot(XV(fIdx,:),AVG(ST(fIdx):EN(fIdx)),'Linewidth',5)
end
ylabel('d score');xticks(1:6); xticklabels([65,215,441,783,1230,2080])
ylim([0,4]);box on;xlim([0.5,6.5])
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
title({['Cluster #',num2str(fC), '(' ,num2str(length(CLUSTER.IDx)),' Subs)']})
hold off
end
sgtitle('Experiment 2 - kmeans cluster','FontSize',16,'FontWeight','bold')
set(gcf,'Position', [0,0, 800, 1000]);set(gcf,'color','w');
end
saveas(gcf,'Plot\Cluster_kMeans.png')
% Elbow Method:
% Plot the within-cluster sum of squares (WCSS) against the number of clusters. 
% The "elbow" of the curve represents a point where adding more clusters doesn't significantly reduce WCSS. 
% This point is often considered the optimal number of clusters.
wcss = zeros(1, CLUSTER_MAX);
wcss = CLUSTER.SUMD;
figure(40);clf(40)
plot(1:CLUSTER_MAX, wcss, 'o-');xlabel('Number of Clusters');ylabel('Within-Cluster Sum of Squares (WCSS)');title('Elbow Method');
%% Mic clustering
data = dprim_all;
ST = [1:4:size(dprim_all,1)]; EN = [4:4:size(dprim_all,1)];
XV = [1:4;3:6;1:4;3:6];

P.Edge = repmat([1,0,0,1],4,1);
P.Hill = repmat([0,1,1,0],4,1);
P.Low  = [[1,1,1,0];[0,0,0,0];[1,1,1,0];[0,0,0,0]];
P.Mid = [[0,0,1,1];[1,1,0,0];[0,0,1,1];[1,1,0,0]];
P.High = [[0,0,0,0];[0,1,1,1];[0,0,0,0];[0,1,1,1]];
P.OnlyL  = repmat([1,0,0,0],4,1);
P.OnlyH = repmat([0,0,0,1],4,1);
P.ZigL = repmat([1,0,1,0],4,1);
P.ZigH = repmat([0,1,0,1],4,1);
P.P    = {P.Edge',P.Hill',P.Low',P.Mid',P.High',P.OnlyL',P.OnlyH',P.ZigL',P.ZigH'};
P.Idx  = [1,2,3,4];

CLUSTER.Mic.CLUSTER.GRP.P = nan(length(ST),length(ST),size(data,2));
CLUSTER.Mic.CLUSTER.GRP.P2 = nan(length(P.P),size(data,2));
CLUSTER.Mic.ID         = nan(1,size(data,2));
CLUSTER.Mic.Names   = {'Edge','Plateau','Low','Mid','High','LowEdge','HighEdge','ZigLow (Down-Up)','ZigHigh (Up-Down)','Inconsistent'};

for fSub = 1:size(data,2)
    dSub = data(:,fSub);
    for fIdx = 1:length(ST)
        dSubd = dSub(ST(fIdx):EN(fIdx));
        CLUSTER.Mic.CLUSTER.GRP.P(:,fIdx,fSub) = dSubd > mean(dSubd);
    end
    % Overall CLUSTER.GRP.P
    dSubTM = dSub(ST(1):EN(2));
    dSubMT = dSub(ST(3):EN(4));
    dSubTMMT =[[dSubTM > mean(dSubTM)];[dSubMT > mean(dSubMT)]];    
    % CLUSTER.GRP.P per Condition
    dSub = squeeze(CLUSTER.Mic.CLUSTER.GRP.P(:,:,fSub));
    dSub = dSub(:,P.Idx);
    dScore= nan(size(dSub,2));
    dScore2= nan(size(dSub,2),1);
    for fPat = 1:length(P.P)
        dScore(fPat,:) = sum(dSub == P.P{fPat}) == size(dSub,1);
        dScore2(fPat) = sum(dSubTMMT == reshape(P.P{fPat},[],1));
    end
    CLUSTER.Mic.CLUSTER.GRP.P2(:,fSub) = dScore2;
    P.Sub(fSub,:) = sum(dScore,2);
    [dMax,dIdx] = max(sum(dScore,2));
    if dMax > size(dSub,2)/2-1
        CLUSTER.Mic.ID(fSub) = dIdx;
    else
        P.Sub2(fSub,:) = sum(dScore2,2);
        P.Sub2(fSub,1) = 0;
        P.Sub2(fSub,2) = 0;
        [dMax,dIdx] = max(P.Sub2(fSub,:));
        if dMax >= length(dSubTMMT)*0.60
            CLUSTER.Mic.ID(fSub) = dIdx;
        else
             CLUSTER.Mic.ID(fSub) = length(P.P);
        end
    end
end
% Plot
figure(30);clf(30);
for fC = 1:max(CLUSTER.Mic.ID)
    CLUSTER.IDx  = find(fC == CLUSTER.Mic.ID);
    CLUSTER.DATA = data(:,CLUSTER.IDx);
subplot(3,3,fC)
hold on
for fIdx = 1:4
     for idx2 = 1:length(CLUSTER.IDx)
        plot(XV(fIdx,:),CLUSTER.DATA(ST(fIdx):EN(fIdx),idx2),'Linewidth',2,'Color',[rand(3,1);0.1])
     end
end
for fIdx = 1:4
    AVG = mean(CLUSTER.DATA,2);
    plot(XV(fIdx,:),AVG(ST(fIdx):EN(fIdx)),'Linewidth',5)
end
ylabel('d score');xticks(1:6); xticklabels([65,215,441,783,1230,2080])
ylim([0,4]);box on;xlim([0.5,6.5])
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
title({[CLUSTER.Mic.Names{fC}];['(' ,num2str(length(CLUSTER.IDx)),' Subs)']})
hold off
end
sgtitle('Experiment 2 - Cluster','FontSize',16,'FontWeight','bold')
set(gcf,'Position', [0,0, 800, 1000]);set(gcf,'color','w');
saveas(gcf,'Plot\CLUSTER.GRP.PCluster2.png')