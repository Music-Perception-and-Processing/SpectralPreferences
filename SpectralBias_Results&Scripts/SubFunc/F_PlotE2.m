function F_PlotE2(OPT)
load([OPT.PATH.MF 'dprime_all_EDGE'])
%
S = dprim_all;
IDX1 = [1,4,5,8,9,12,13,16];
IDX2 = [3,4,6,7,10,11,14,15];
for fSub = 1:size(S,2)
for fIdx = 1:length(IDX1)
    SS(fIdx,fSub) = S(IDX1(fIdx),fSub) - S(IDX2(fIdx),fSub);
end
end
E = mean(S([1,4,5,8,9,12,13,16],:));
C = mean(S([3,4,6,7,10,11,14,15],:));

 %E = mean(S([9,12,13,16],:));
 %C = mean(S([10,11,14,15],:));
ES = mean(SS);
EC = E-C;
[SOC,SEC] = sort(EC);
MID = 18;
figure(5);clf(5)
subplot(5,3,[1:9])
hold on
B = bar(SOC,'FaceColor','green','LineWidth',1.5);
%B2 = bar(NEC,'FaceColor','magenta','LineWidth',1.5);
hold off
xlabel('Subjects');
ylabel([char(916),'d''']);
ylim([-0.5,2])
ax = gca;
ax.GridLineWidth = 2;
ax.MinorGridAlpha = 0.75;
YT = [-2:0.25:2];yticks(YT); YTL = string(YT); YTL(2:2:end) = ""; yticklabels(YTL);
set(gca, 'YGrid', 'on', 'XGrid', 'off');box on
title({'Edge Effect'})
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
% subplot(5,3,[1:9])
% hist(EC)
% ylabel('# Subjects');
% xlabel('d-prime difference');
% title({'Edge Effect'})
% set(gca,'FontSize',18);set(gca,'FontWeight','bold')
for sp = 1:3
subplot(5,3,sp+12)
if sp == 1
    [~,idx] = min(EC);
    idx = SEC(1);
    TIT = 'Smallest';
elseif sp == 2
    [~,idx] = min(abs(EC-mean(EC)));
    idx = SEC(MID);
    TIT = 'Average';
elseif sp == 3
    [~,idx] = max(EC);
    idx = SEC(end-1);
    TIT = 'Largest';
end
hold on
COL = OPT.P.COL.MAP{1}./max(OPT.P.COL.MAP{1});
plot([1:4],S(1:4,idx),'LineWidth',4,'Color',COL)
COL = OPT.P.COL.MAP{1}/(1/max(OPT.P.COL.MAP{1}));
plot([3:6],S(5:8,idx),'LineWidth',4,'Color',COL)
COL = OPT.P.COL.MAP{2}./max(OPT.P.COL.MAP{2});
plot([1:4],S(9:12,idx),'LineWidth',4,'Color',COL)
COL = OPT.P.COL.MAP{2}/(1/max(OPT.P.COL.MAP{2}));
plot([3:6],S(13:16,idx),'LineWidth',4,'Color',COL)
hold off
box on;
if sp == 1
    ylabel(['d''']);
elseif sp == 2
    xlabel(OPT.P.XL);
end
title(TIT)
 xticks([OPT.P.XT]);xticklabels({'65','','441','','1230',''});xlim([0,7]);ylim([0.0,3.6]);box on; grid on;
 set(gca,'FontSize',20);set(gca,'FontWeight','bold')
end
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp2_EE.png')
%
SZ = 4;
ST = [1:SZ:size(dprim_all,1)]; EN = [SZ:SZ:size(dprim_all,1)];
XV = [1:4;3:6;1:4;3:6];
d.Shifto = [-1,-1,1,1];
DATA = nan(3,size(XV,1),SZ);
figure(5);clf(5);
hold on
for fCond = 1:2
    plot(nan(3,1),'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK(fCond*2),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond})
end
for fCond = 1:size(XV,1)
    d.AVG   = [];
    d.CI    = [];
    d.Shift = OPT.P.CI.W*d.Shifto(fCond);
    if fCond == 1
        COL = OPT.P.COL.MAP{1}./max(OPT.P.COL.MAP{1});
        LS  = OPT.P.LS{1};
    elseif fCond == 2
        COL = OPT.P.COL.MAP{1}/(1/max(OPT.P.COL.MAP{1}));
        LS  = OPT.P.LS{3};
    elseif fCond == 3
        COL = OPT.P.COL.MAP{2}./max(OPT.P.COL.MAP{2});
        LS  = OPT.P.LS{1};
    elseif fCond == 4
        COL = OPT.P.COL.MAP{2}/(1/max(OPT.P.COL.MAP{2}));
        LS  = OPT.P.LS{3};
    end
    for fFreq = 1:SZ
        d.X = XV(fCond,fFreq) + d.Shift;
        d.Data     = dprim_all(ST(fCond)+fFreq-1,:);
        [d.CI(fFreq,:),d.AVG(fFreq)] = F_BOOTCI(d.Data);
        DATA(1,fCond,fFreq) = d.AVG(fFreq);
        DATA(2,fCond,fFreq) = d.CI(fFreq,1);
        DATA(3,fCond,fFreq) = d.CI(fFreq,2);
        line([d.X ,d.X],[d.CI(fFreq,1),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',COL)
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,1),d.CI(fFreq,1)],'Linewidth',OPT.P.CI.LW,'Color',COL)
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,2),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',COL)  
    end
    d.X  = XV(fCond,:) + d.Shift;
    plot(d.X,d.AVG,'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK(fCond),'MarkerSize',OPT.P.M.S,'Color',COL,...
        'MarkerFaceColor',COL)%',LineStyle',LS)
end


C = {};
C(2,1) = {'Low Region'};
C(3,1) = {'(65 - 783 Hz)'};
C(4,1) = {'High Region'};
C(5,1) = {'(441 - 2080 Hz)'};
C(2,2) = {'Target-Mix'};
C(3,2) = {'Mix-Target'};
C(4,2) = {'Target-Mix'};
C(5,2) = {'Mix-Target'};
for fCond = 1:size(XV,1)
    for fFreq = 1:SZ
        C(1,2+fFreq)       = {['Frequency band' num2str(fFreq)]};
        V1 = num2str(round(DATA(1,fCond,fFreq),2));
        while length(V1)<4; V1 = [V1,'0'];end
        V2 = num2str(round(DATA(2,fCond,fFreq),2));
        while length(V2)<4; V2 = [V2,'0'];end
        V3 = num2str(round(DATA(3,fCond,fFreq),2));
        while length(V3)<4; V3 = [V3,'0'];end
        C(1+fCond,2+fFreq) = {[V1,' [',V2,' - ',V3,']']};  
    end
end
writecell(C,'SUP_E2.csv','Delimiter',';')

xlim([0,7])
xlabel(OPT.P.XL); ylabel(OPT.P.YL); xticks(OPT.P.XT);xticklabels(OPT.P.XTL);ylim([0.0,3.6]);box on; grid on;
title({'Accuracy'});legend({'Target-Mixture','Mixture-Target'})
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp2_dPrime.png')


figure(6);clf(6);
for fSP = 1:2
load([OPT.PATH.MF 'dprime_all_EDGE'])
if fSP == 1
    iMu = [1,0,0,5,8,0,10,8,4,1,8,10,10,10,5,0,2,1,5,0,0,0,0,10,5,0,0,3,0] >= 3;
    
else
    iMu = [1,0,0,5,8,0,10,8,4,1,8,10,10,10,5,0,2,1,5,0,0,0,0,10,5,0,0,3,0] < 3;
    
end
iMuP = [1,0,0,5,8,0,10,8,4,1,8,10,10,10,5,0,2,1,5,0,0,0,0,10,5,0,0,3,0] >= 3;
iMuN = [1,0,0,5,8,0,10,8,4,1,8,10,10,10,5,0,2,1,5,0,0,0,0,10,5,0,0,3,0]< 3;

% corrcoef(mean(dprim_all(:,1:29)),EXP.MSI.T).^2
% corrcoef(mean(dprim_all(:,1:29)),EXP.MSI.P).^2
% 
% corrcoef(mean(dprim_all(1:8,1:29)),EXP.MSI.T).^2
% corrcoef(mean(dprim_all(1:8,1:29)),EXP.MSI.P).^2
% 
% corrcoef(mean(dprim_all(9:16,1:29)),EXP.MSI.T).^2
% corrcoef(mean(dprim_all(9:16,1:29)),EXP.MSI.P).^2
% 
% corrcoef(mean(dprim_all([1:4:16,4:4:16],1:29)),EXP.MSI.T).^2
% corrcoef(mean(dprim_all([1:4:16,4:4:16],1:29)),EXP.MSI.P).^2
% 
% corrcoef(mean(dprim_all([2:4:16,3:4:16],1:29)),EXP.MSI.T).^2
% corrcoef(mean(dprim_all([2:4:16,3:4:16],1:29)),EXP.MSI.P).^2
% 
% TAB = [[mean(dprim_all(1:8,1:29))',EXP.MSI.P',EXP.MSI.T',[1:29]',ones(1,29)'];[mean(dprim_all(9:16,1:29))',EXP.MSI.P',EXP.MSI.T',[1:29]',2*ones(1,29)']];
% 
% TAB = [[reshape((dprim_all(1:8,1:29)),[],1),repmat(EXP.MSI.P',8,1),repmat(EXP.MSI.T',8,1),repmat([1:29]',8,1),repmat(1*ones(1,29)',8,1)];...
%         [reshape((dprim_all(9:16,1:29)),[],1),repmat(EXP.MSI.P',8,1),repmat(EXP.MSI.T',8,1),repmat([1:29]',8,1),repmat(2*ones(1,29)',8,1)]];
% 
% [t,p] = ttest2(T.dP(T.O==1).*T.MT(T.O==1),T.dP(T.O==2).*T.MT(T.O==1))
% T = array2table(TAB,'VariableNames',{'dP','MT','MP','SUB','O'});
% T.SUB = categorical(T.SUB);
% T.O = categorical(T.O);
% anova(fitlme(T,'dP ~ 1 + MP + (1|SUB)','DummyVarCoding','effects'))
% anova(fitlme(T,'dP ~ 1 + MP + (1|SUB)'))
% anova(fitlme(T,'dP ~ 1 + MT + (1|SUB)','DummyVarCoding','effects'))
% anova(fitlme(T,'dP ~ 1 + MP+MT + (1|SUB)'))
% anova(fitlme(T,'dP ~ 1 + O*MP+O*MT + (1|SUB)','DummyVarCoding','effects'))

%EXP.MSI.T
%EXP.MSI.P
%mean(dprim_all([1,4,5,8,9,12,13,16],iMuP),"all") - mean(dprim_all([2 3 6 7 10 11 14 15],iMuP),"all")
%mean(dprim_all([1,4,5,8,9,12,13,16],iMuN),"all") - mean(dprim_all([2 3 6 7 10 11 14 15],iMuN),"all")
%dprim_all = dprim_all(:,iMu);


subplot(2,1,fSP)
hold on
for fCond = 1:2
    plot(nan(3,1),'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK(fCond*2),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond})
end
for fCond = 1:size(XV,1)
    d.AVG   = [];
    d.CI    = [];
    d.Shift = OPT.P.CI.W*d.Shifto(fCond);
    if fCond == 1
        COL = OPT.P.COL.MAP{1}./max(OPT.P.COL.MAP{1});
        LS  = OPT.P.LS{1};
    elseif fCond == 2
        COL = OPT.P.COL.MAP{1}/(1/max(OPT.P.COL.MAP{1}));
        LS  = OPT.P.LS{3};
    elseif fCond == 3
        COL = OPT.P.COL.MAP{2}./max(OPT.P.COL.MAP{2});
        LS  = OPT.P.LS{1};
    elseif fCond == 4
        COL = OPT.P.COL.MAP{2}/(1/max(OPT.P.COL.MAP{2}));
        LS  = OPT.P.LS{3};
    end
    for fFreq = 1:SZ
        d.X = XV(fCond,fFreq) + d.Shift;
        d.Data     = dprim_all(ST(fCond)+fFreq-1,:);
        [d.CI(fFreq,:),d.AVG(fFreq)] = F_BOOTCI(d.Data);
        line([d.X ,d.X],[d.CI(fFreq,1),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',COL)
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,1),d.CI(fFreq,1)],'Linewidth',OPT.P.CI.LW,'Color',COL)
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,2),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',COL)  
    end
    d.X  = XV(fCond,:) + d.Shift;
    plot(d.X,d.AVG,'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK(fCond),'MarkerSize',OPT.P.M.S,'Color',COL,...
        'MarkerFaceColor',COL,'LineStyle',LS)
end
xlabel(OPT.P.XL); ylabel(OPT.P.YL); xticks(OPT.P.XT);xticklabels(OPT.P.XTL);ylim([0.6,3.6]);box on; grid on;
title({'Experiment 1'});legend({'Target-Mixture','Mixture-Target'})
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 1000, 800]);set(gcf,'color','w');
end
saveas(gcf,'Plot\Exp2_dPrime2.png')