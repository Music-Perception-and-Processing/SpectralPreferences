%function F_PlotMethod(OPT)
figure(30);clf(30)
M.L = 160;
M.LN = 160;
M.T = 8;
M.N = 12/2;
M.B = 6;
M.S = nan(M.B,M.L);
M.PA = nan(M.B,1);
M.TIT = {{'Target-Mixture | target present)'},{'Mixture-Target | target - present'},...
             {'Target-Mixture | target absent)'},{'Mixture-Target | target absent'},...
             {'Target-Mixture | target present)'},{'Mixture-Target | target absent'}};
M.TIT = {{'Target-Mixture | target present'},{'Mixture-Target | target - present'},...
             {'Target-Mixture | target absent'},{'Mixture-Target | target absent'},...
             {'Target-Mixture | target present'},{'Mixture-Target | target absent'}};
M.IDX = [1,4,5,6];
for fSubplot = 1:length(M.IDX)
    fCase = M.IDX(fSubplot);
for fBand = 1:M.B
    M.FT = nan(1,M.L);
    M.C  = 1;
%     M.D = randperm(10,1)-1;
%     M.FT(M.C:M.C+M.D) = nan;
%     M.C = M.C + M.D;
    for fNote = 1:M.T

        % Note duration
        if fNote == 1
            M.D = randperm(10,1)+8;
        M.FT(M.C:end) = randperm(6,1);
        M.C = M.C + M.D;
        else
            M.D = randperm(6,1)+8;
        M.FT(M.C:end) = randperm(6,1);
        M.C = M.C + M.D;
        end
        
        % Add pause
        if fNote < M.T
        M.D = randperm(6,1)+4;
        
        M.FT(M.C:M.C+M.D) = nan;
        M.C = M.C + M.D;
        end
    end
%     M.D = randperm(10,1)-1;
%     M.FT(M.C:M.C+M.D) = nan;
%     M.C = M.C + M.D;
%     M.FT(M.C:end) = nan;
    M.S(fBand,:) = 2+M.FT+11*(fBand-1);
    M.BAR(fBand) = 11*(fBand-1);
    M.PA(fBand)  = max(find(~isnan(M.S(fBand,:))));
end
OPT.P.COL.MAP2 = num2cell(colormap("colorcube"),2);
figure(30);
subplot(2,2,fSubplot);
hold on
 M.X1 = M.LN*1.05;
 M.X2 = M.LN*1.05+floor(M.LN*0.4);
 M.Y1 = 0;
 M.Y2 = 100;
rectangle('Position', [M.X1,  M.Y1, M.X2 -  M.X1,  M.Y2 -  M.Y1], 'FaceColor', [0.7, 0.7, 0.7,0.75],  'EdgeColor', 'none');
M.INC = logical(ones(fBand,1)); 
if fCase <= 4
    M.TAR = randperm(6,1);
    if fCase <= 2
       M.EXC = M.INC; M.EXC(M.TAR) = 0;
        M.EXC = find(M.EXC); 
        M.INC(M.EXC(randperm(5,1))) = 0;
    else
        M.INC(M.TAR) = 0;
    end
else
    if fCase == 5 || fCase == 7
        M.TAR = randperm(4,1);
        M.INC(5:6) = 0; 
        M.EXC = M.INC; M.EXC(M.TAR) = 0;
        M.EXC = find(M.EXC);
        M.INC(M.EXC(randperm(3,1))) = 0;
    else
        M.TAR = randperm(4,1)+2;
        M.INC([1:2,M.TAR]) = 0;
    end
end
 M.PD  = nan(size(M.S));
 M.PD(M.TAR,:)  = M.S(M.TAR,:);
 M.PD  = M.PD(:,1:max(M.PA));


M.PM = M.S;
M.PM  = M.PM(:,1:max(M.PA));
M.PM(M.INC == 0,:) = nan;
M.PD(:,max(M.PA)-2:end) = nan;
M.PM(:,max(M.PA)-2:end) = nan;

M.dPD = nan(M.B,M.LN); M.dPD(:,1:size(M.PD,2)) = M.PD; M.PD = M.dPD;
M.dPM = nan(M.B,M.LN); M.dPM(:,1:size(M.PM,2)) = M.PM; M.PM = M.dPM;

if mod(fCase,2) == 0
    M.PM = M.dPD;
    M.PD = M.dPM;
end
for fBand = 1:M.B
    plot([nan(1,0),M.PD(fBand,:),nan(1,floor(M.LN/2)-1),nan(1,0),M.PM(fBand,1:max(M.PA)),nan],'LineWidth',5,'Color',[0,0,0,0.75])
    plot([nan(1,2),M.PD(fBand,:),nan(1,floor(M.LN/2)-1),nan(1,0),M.PM(fBand,1:max(M.PA)),nan],'LineWidth',5,'Color',[0,0,0,0.75])
    plot([nan(1,1),M.PD(fBand,:),nan(1,floor(M.LN/2)-1),nan(1,0),M.PM(fBand,1:max(M.PA))],'LineWidth',4,'Color',OPT.P.COL.MAP2{fBand*30})
    line([-1000,1000],[M.BAR(fBand),M.BAR(fBand)],'Linewidth',2,'Color',[0,0,0])
end
line([-M.LN*0.05,-M.LN*0.05],[-100,100],'Linewidth',2,'Color',[0,0,0])
line([M.LN*2.5+M.LN*0.05,M.LN*2.5+M.LN*0.05],[-100,100],'Linewidth',2,'Color',[0,0,0])
line([-1000,1000],[M.BAR(end)+M.BAR(2),M.BAR(end)+M.BAR(2)],'Linewidth',2,'Color',[0,0,0])
if fCase == 5 || fCase == 7
        rectangle('Position', [-200,  M.BAR(5), 1000 -  -200,  (M.BAR(end)+M.BAR(2)) -  M.BAR(5)], 'FaceColor', [1, 1, 1,0.75],  'EdgeColor', 'none');
elseif fCase == 6 || fCase == 8
    rectangle('Position', [-200,  M.BAR(1), 1000 -  -200,  M.BAR(3) -  M.BAR(1)], 'FaceColor', [1, 1, 1,0.75],  'EdgeColor', 'none');
end
hold off
CA = get(gcf,'CurrentAxes');
CA.TickLength(1) = [0];
CA = set(gcf,'CurrentAxes',CA);
yticks([0:11:11*fBand] + 5.5); yticklabels(OPT.P.XTL);ylim([0,M.BAR(end)+M.BAR(2)])
xticks([0,M.LN*[0.5:0.5:5]])
xticklabels([0,1,2,3,4,5]); xlim([-M.LN*0.05,M.LN*2.5+M.LN*0.05])%xlim([0-floor(max(M.PA)/4),max(M.PA)*2.75])
if fSubplot == 1 
    ylabel(OPT.P.XL); ylabel({'Experiment 1';'';OPT.P.XL}); 
elseif fSubplot == 3
    ylabel(OPT.P.XL); ylabel({'Experiment 2';'';OPT.P.XL}); 
else
    ylabel(OPT.P.XL);
end
 xlabel('time in seconds'); 
box on; grid off;
title(M.TIT{fCase})
set(gca,'FontSize',12);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 900, 500]);set(gcf,'color','w');

end
a = sgtitle('Stimuli','FontSize',16,'FontWeight','bold');
saveas(gcf,[OPT.PATH.PLOT 'Method','.png'])