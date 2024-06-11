function F_PlotScores(EXP,P)
% dPrime
for fCond = 1:size(EXP.DP,2)
    for fBand = 1:size(EXP.DP,3)
        D.Data = EXP.DP(:,fCond,fBand);
        [D.CI,D.AVG] = F_BOOTCI(D.Data);
        EXP.AVG.DP(fCond,fBand)   = D.AVG;
        EXP.AVG.CI(:,fCond,fBand) = D.CI;
        ME = 1.96*(std(D.Data)/sqrt((length(D.Data))));
        EXP.AVG.CI2(1,fCond,fBand) = mean(D.Data)-ME;
        EXP.AVG.CI2(2,fCond,fBand) = mean(D.Data)+ME;
    end
end
figure(10);clf(10);
hold on
% Dummy lines
line(nan,nan,'Color',P.COL.MAP{P.COL.IDX(1)}*P.COL.FAC(1),'LineWidth',P.LW,'LineStyle','--')
line(nan,nan,'Color',P.COL.MAP{P.COL.IDX(2)}*P.COL.FAC(2),'LineWidth',P.LW,'LineStyle',':')
% real lines
for fCond = 1:size(EXP.DP,2)
    % CI
    for fBand = 1:size(EXP.DP,3)
        D.X1 = [P.XIDX{fCond}(fBand)];
        D.X(1) = P.XIDX{fCond}(fBand)-P.CI.W;D.X(2) = P.XIDX{fCond}(fBand);D.X(3) = P.XIDX{fCond}(fBand)+P.CI.W;
        D.Y(1) = EXP.AVG.CI(1,fCond,fBand);D.Y(2) = EXP.AVG.DP(fCond,fBand);D.Y(3) = EXP.AVG.CI(2,fCond,fBand);
        line([D.X(1),D.X(3)],[D.Y(1),D.Y(1)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
        line([D.X(2),D.X(2)],[D.Y(1),D.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
        line([D.X(1),D.X(3)],[D.Y(3),D.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
    end
    % MEAN
    plot(P.XIDX{fCond},EXP.AVG.DP(fCond,:),'Linewidth',P.LW,'Linestyle',P.LS{fCond},'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
end
for fCond = 1:size(EXP.DP,2)
    % Marker
    plot(P.XIDX{fCond},EXP.AVG.DP(fCond,:),'Linewidth',P.LW,'Linestyle','none','Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond),...
        'Marker',P.M.MARK{fCond},'MarkerSize',P.M.S,'MarkerFaceColor',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
end
hold off
xlabel(P.XL); ylabel(P.YL); xticks(P.XT);xticklabels(P.XTL);ylim(P.YLIM);box on; grid on;
title({'Experiment 2'});legend({'Target first','Mixture first'})
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp2_dPrime.png')
% - - - - - 
% Hitrate
for fCond = 1:size(EXP.DP,2)
    for fBand = 1:size(EXP.DP,3)
        D.Data = EXP.EDGE(:,fCond,fBand);
        [D.CI,D.AVG] = F_BOOTCI(D.Data);
        EXP.AVG.EDGE_HIT(fCond,fBand)   = D.AVG;
        EXP.AVG.EDGE_CI(:,fCond,fBand) = D.CI;
        D.Data2 = EXP.NDGE(:,fCond,fBand);
        [D.CI,D.AVG] = F_BOOTCI(D.Data2);
        EXP.AVG.NDGE_HIT(fCond,fBand)  = D.AVG;
        EXP.AVG.NDGE_CI(:,fCond,fBand) = D.CI;
    end
end
[D.CI,D.AVG] = F_BOOTCI(reshape(EXP.AVG.EDGE_HIT(1:4,2:3),[],1));
[D.CI,D.AVG] = F_BOOTCI(reshape(EXP.AVG.NDGE_HIT(1:4,2:3),[],1));
figure(11);clf(11);
P.LIM.COND = {[1,2],[3,4]};
P.TIT      = {'Target first','Target first','Mixture first','Mixture first'};
% real lines
D.COU = 0;
for fSP = 1:2
for fCond = P.LIM.COND{fSP}(1):P.LIM.COND{fSP}(2)
    D.COU = D.COU + 1;
    subplot(2,2,D.COU)
    hold on
    % Dummy lines
    line(nan,nan,'Color',[0,0,0],'LineWidth',P.LW,'LineStyle','none','Marker','p')
    line(nan,nan,'Color',[0,0,0],'LineWidth',P.LW,'LineStyle','none','Marker','d')
    % CI
    for fBand = 1:size(EXP.DP,3)
        d.X(1) = P.XIDX{fCond}(fBand)-P.CI.W;d.X(2) = P.XIDX{fCond}(fBand);d.X(3) = P.XIDX{fCond}(fBand)+P.CI.W;
        d.Y(1) = EXP.AVG.EDGE_CI(1,fCond,fBand);d.Y(2) = EXP.AVG.EDGE_HIT(fCond,fBand);d.Y(3) = EXP.AVG.EDGE_CI(2,fCond,fBand);
        line([d.X(1),d.X(3)],[d.Y(1),d.Y(1)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
        line([d.X(2),d.X(2)],[d.Y(1),d.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
        line([d.X(1),d.X(3)],[d.Y(3),d.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
        d.X(1) = P.XIDX{fCond}(fBand)-P.CI.W;d.X(2) = P.XIDX{fCond}(fBand);d.X(3) = P.XIDX{fCond}(fBand)+P.CI.W;
        d.Y(1) = EXP.AVG.NDGE_CI(1,fCond,fBand);d.Y(2) = EXP.AVG.NDGE_HIT(fCond,fBand);d.Y(3) = EXP.AVG.NDGE_CI(2,fCond,fBand);
        line([d.X(1),d.X(3)],[d.Y(1),d.Y(1)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond))
        line([d.X(2),d.X(2)],[d.Y(1),d.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond))
        line([d.X(1),d.X(3)],[d.Y(3),d.Y(3)],'Linewidth',P.CI.LW,'Color',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond))
    end
    % MEAN
    %plot(P.XIDX{fCond},squeeze(nanmean(EXP.HIT(:,fCond,:))),'Linewidth',P.LW,'Linestyle','--','Color',[0,0,0,0.2])
    plot(P.XIDX{fCond},EXP.AVG.EDGE_HIT(fCond,:),'Linewidth',P.LW,'Linestyle','none','Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
    plot(P.XIDX{fCond},EXP.AVG.NDGE_HIT(fCond,:),'Linewidth',P.LW,'Linestyle','none','Color',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond))
    % Marker
    plot(P.XIDX{fCond},EXP.AVG.EDGE_HIT(fCond,:),'Linewidth',P.LW,'Linestyle','none','Color',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond),...
        'Marker','p','MarkerSize',P.M.S-4,'MarkerFaceColor',P.COL.MAP{P.COL.IDX(fCond)}*P.COL.FAC(fCond))
    plot(P.XIDX{fCond},EXP.AVG.NDGE_HIT(fCond,:),'Linewidth',P.LW,'Linestyle','none','Color',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond),...
        'Marker','d','MarkerSize',P.M.S-4,'MarkerFaceColor',P.COL.MAP{P.COL.IDX(fCond)+10}*P.COL.FAC(fCond))
    hold off
xlabel(P.XL); ylabel('Hit rate'); xticks(P.XT);xticklabels(P.XTL);box on; grid on; xlim([0,7]);ylim([0.45,1.05])
title(P.TIT{D.COU})
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
end
end
sgtitle('Experiment 2 - Edge vs Non-Edge','FontSize',16,'FontWeight','bold')
legend({'Edge','Nonedge'},"Location",'southwest')
set(gca,'FontSize',14);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp2_Hits.png')