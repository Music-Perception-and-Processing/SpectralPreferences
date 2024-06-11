function F_PlotMethod(OPT)
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
 xlabel('Time in seconds'); 
box on; grid off;
title(M.TIT{fCase})
set(gca,'FontSize',12);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 900, 500]);set(gcf,'color','w');

end
a = sgtitle('Stimuli','FontSize',16,'FontWeight','bold');
saveas(gcf,[OPT.PATH.PLOT 'Method','.png'])

%% Method Sup
 OPT.P.COL.MAP2 = num2cell(colormap("colorcube"),2);
 fs = 44100; 
% % random melodies [random frequencies and random durations]
 f_low = 65; % lowest freq in the game [~C2 pitch]
 mu_vec = [0 1 2 3 4 5]; 
 numTones = 8;  
 stim_dur = 2; % overall stimulus duration excluding silences between tones 
 numTracks = length(mu_vec); 
 % frequencies 
 freq_spread = .5; % frequency spread in Octaves
 % seqs = freq_spread*rand(numTones,numTracks) + repmat(mu_vec, numTones, 1); % control matrix 
 % FF = f_low*2.^seqs;
 f_erb = 10^3.*[0.0650  0.2149  0.4414  0.7834  1.2999  2.0800];
 F_L = f_erb;
 F_H = f_erb*(1.5);
% round(F_H-F_L)
% round(F_H(1:end-1)-F_L(2:end))
 R_M = [f_erb]'.*(1.1+rand(length(F_L),8)*0.3);
 R_D = sort(rand(length(F_L),8),2);
 while min(min([R_D(:,2:end)-R_D(:,1:end-1)]')) < 0.02
     R_D = sort(rand(length(F_L),8),2);
 end
 R_D = R_D*2;R_D(:,end) = 2; R_D = [zeros(6,1),R_D];
% figure(33);clf(33)
% hold on
% rectangle('Position',[0 0 2 F_L(1)],"FaceColor",[0,0,0])
% rectangle('Position',[0 F_H(end) 2 F_H(end)],"FaceColor",[0,0,0])
% for fBand = 1:5
% rectangle('Position',[0 F_H(fBand) 2 F_L(fBand+1)-F_H(fBand)],"FaceColor",[0,0,0,0.25])
% end
% for fBand = 1:6
% %rectangle('Position',[0 F_L(fBand) 2 F_H(fBand)-F_L(fBand)],"FaceColor",OPT.P.COL.MAP2{fBand*30})
% rectangle('Position',[0 F_L(fBand) 2 F_H(fBand)-F_L(fBand)],"FaceColor",[1,1,1])
% end
% for fBand = 1:6
%     for fNote = 1:8
%     line([R_D(fBand,fNote),R_D(fBand,fNote+1)],[R_M(fBand,fNote),R_M(fBand,fNote)],'linewidth',5,'Color',[0,0,0]);
%     line([R_D(fBand,fNote),R_D(fBand,fNote+1)],[R_M(fBand,fNote),R_M(fBand,fNote)],'linewidth',4,'Color',OPT.P.COL.MAP2{fBand*30});
%     end
% 
% end
% rectangle('Position',[0 0 2 F_L(1)],"FaceColor",[0,0,0])
% hold off
% set(gca, 'YScale', 'log');set(gca,'YMinorTick','Off')
% xlim([0,2]);xticks([0:0.25:2])
% yticks(round(f_erb));ylim([F_L(1)*1,F_H(end)]); box on; grid off;
% xlabel('Time in seconds'); 
% ylabel('Frequency in Hz')
% box on; grid off;
% title('Frequency spacing')
% set(gca,'FontSize',12);set(gca,'FontWeight','bold')
% set(gcf,'Position', [100,100, 900, 500]);set(gcf,'color','w');
% saveas(gcf,[OPT.PATH.PLOT 'Method2','.png'])
%% NEW METHOD
YTL = [65, 215, 441, 783, 1230, 2080];
figure(34);clf(34)
for fSP = 1:4
    R_M = [f_erb]'.*(1.1+rand(length(F_L),8)*0.3);
    R_D = sort(rand(length(F_L),8),2);
    while min(min([R_D(:,2:end)-R_D(:,1:end-1)]')) < 0.03
        R_D = sort(rand(length(F_L),8),2);
    end
    R_D = R_D*2;R_D(:,end) = 2; R_D = [zeros(6,1),R_D];
    subplot(2,2,fSP)
    if fSP == 1
        T_D = nan(size(R_D));T_D(2,:) = R_D(2,:);
        R_D(5,:) = nan; 
        R_D = [T_D  R_D+3];
    elseif fSP == 2
        T_D = nan(size(R_D));T_D(6,:) = R_D(6,:);
        R_D(6,:) = nan; 
        R_D = [R_D T_D+3];
    elseif fSP == 3
        T_D = nan(size(R_D));T_D(1,:) = R_D(1,:);
        R_D(2,:) = nan; 
        R_D(5,:) = nan; 
        R_D(6,:) = nan; 
        R_D = [T_D  R_D+3];
    elseif fSP == 4
        T_D = nan(size(R_D));T_D(5,:) = R_D(5,:);
        R_D(5,:) = nan; 
        R_D(1,:) = nan; 
        R_D(2,:) = nan; 
        R_D = [R_D T_D+3];
    end
 R_M  = [R_M nan(6,1) R_M nan(6,1)];
hold on
rectangle('Position',[0 0 5 F_L(1)],"FaceColor",[0,0,0])
rectangle('Position',[0 F_H(end) 5 F_H(end)],"FaceColor",[0,0,0])
for fBand = 1:5
rectangle('Position',[0 F_H(fBand) 5 F_L(fBand+1)-F_H(fBand)],"FaceColor",[0,0,0,0.10])

end
for fBand = 1:6
%rectangle('Position',[0 F_L(fBand) 2 F_H(fBand)-F_L(fBand)],"FaceColor",OPT.P.COL.MAP2{fBand*30})
rectangle('Position',[0 F_L(fBand) 5 F_H(fBand)-F_L(fBand)],"FaceColor",[1,1,1])
end
for fBand = 1:6
    for fNote = 1:length(R_D)-1
    line([R_D(fBand,fNote),R_D(fBand,fNote+1)],[R_M(fBand,fNote),R_M(fBand,fNote)],'linewidth',4,'Color',[0,0,0]);
    line([R_D(fBand,fNote),R_D(fBand,fNote+1)],[R_M(fBand,fNote),R_M(fBand,fNote)],'linewidth',3,'Color',OPT.P.COL.MAP2{fBand*30});
    end
    
end
if fSP == 3
    rectangle('Position',[0 F_H(4) 5 F_H(6)-F_H(4)],"FaceColor",[1,1,1,0.75])
elseif fSP == 4
    rectangle('Position',[0 F_L(1) 5 F_L(3)-F_L(1)],"FaceColor",[1,1,1,0.75])
end
rectangle('Position',[0 0 5 F_L(1)],"FaceColor",[0,0,0])
rectangle('Position',[2 10 1 5000],"FaceColor",[1,1,1,0.75])

hold off
set(gca, 'YScale', 'log');set(gca,'YMinorTick','Off')
xlim([0,5]);xticks([0:1:5])
yticks(round(f_erb));yticklabels(YTL);ylim([F_L(1)*1,F_H(end)]); box on; grid off;
xlabel('Time in seconds'); 
if fSP == 1 
    ylabel('Frequency in Hz'); ylabel({'Experiment 1';'';'Frequency in Hz'}); 
elseif fSP == 3
    ylabel('Frequency in Hz'); ylabel({'Experiment 2';'';'Frequency in Hz'}); 
else
    ylabel('Frequency in Hz');
end
box on; grid off;
title(M.TIT{fSP})
set(gca,'FontSize',12);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 900, 500]);set(gcf,'color','w');
end
sgtitle('Stimuli','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',12);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 900, 500]);set(gcf,'color','w');
saveas(gcf,[OPT.PATH.PLOT 'Method3','.png'])