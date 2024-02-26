function F_PlotE1(OPT)
load([OPT.PATH.MF 'dprim_exp1'])
SZ = 6;
ST = [1:SZ:size(dprim_all,1)]; EN = [SZ:SZ:size(dprim_all,1)];
XV = [1:SZ;1:SZ];
figure(5);clf(5);
hold on
for fCond = 1:size(XV,1)
    plot(nan(3,1),'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK((fCond*2)-1),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond})
end
DATA = nan(3,size(XV,1),SZ);
for fCond = 1:size(XV,1)
    d.Shift = OPT.P.CI.W*((-1)^fCond);
    for fFreq = 1:SZ
        d.X = fFreq + d.Shift;
        d.Data     = dprim_all(ST(fCond)+fFreq-1,:);
        [d.CI(fFreq,:),d.AVG(fFreq)] = F_BOOTCI(d.Data);
        DATA(1,fCond,fFreq) = d.AVG(fFreq);
        DATA(2,fCond,fFreq) = d.CI(fFreq,1);
        DATA(3,fCond,fFreq) = d.CI(fFreq,2);
        line([d.X ,d.X],[d.CI(fFreq,1),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond})
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,1),d.CI(fFreq,1)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond})
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,2),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond})  
    end
    d.X  = XV(fCond,:) + d.Shift;
    plot(d.X,d.AVG,'Linewidth',OPT.P.LW,'Marker',OPT.P.M.MARK((fCond*2)-1),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond})
end
C = {};
C(2,1) = {'Target-Mix'};
C(3,1) = {'Mix-Target'};
for fCond = 1:size(XV,1)
    for fFreq = 1:SZ
        C(1,1+fFreq)       = {[num2str(OPT.P.XTL(fFreq)),' Hz']};
        V1 = num2str(round(DATA(1,fCond,fFreq),2));
        while length(V1)<4; V1 = [V1,'0'];end
        V2 = num2str(round(DATA(2,fCond,fFreq),2));
        while length(V2)<4; V2 = [V2,'0'];end
        V3 = num2str(round(DATA(3,fCond,fFreq),2));
        while length(V3)<4; V3 = [V3,'0'];end
        C(1+fCond,1+fFreq) = {[V1,' [',V2,' - ',V3,']']};  
    end
end
writecell(C,'SUP_E1.csv','Delimiter',';')
xlim([0,7])
xlabel(OPT.P.XL); ylabel(OPT.P.YL); xticks(OPT.P.XT);xticklabels(OPT.P.XTL);ylim([0.0,3.6]);box on; grid on;
title({'Accuracy'});legend({'Target-Mixture','Mixture-Target'})
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp1_dPrime.png')
%% Subplot

S = dprim_all;
E = mean(S([1,6,7,12],:));
C = mean(S([2:5,8:11],:));
E2 = mean(S([7,12],:));
C2 = mean(S([8:11],:));
EC = E-C;EC2 = sort(E2-C2);
[ci,avg] = F_BOOTCI(EC)
[SEC, UDX]= sort(EC);
NEC = nan(size(SEC)); NEC([1,13,end]) =  SEC([1,13,end]);
figure(5);clf(5)
subplot(5,3,[1:9])
hold on
B = bar(SEC,'FaceColor','green','LineWidth',1.5);
%B2 = bar(NEC,'FaceColor','magenta','LineWidth',1.5);
hold off
xlabel('Subjects');
ylabel([char(916),'d']);
ylim([-0.5,2])
ax = gca;
ax.GridLineWidth = 2;
ax.MinorGridAlpha = 0.75;
YT = [-2:0.25:2];yticks(YT); YTL = string(YT); YTL(2:2:end) = ""; yticklabels(YTL);
set(gca, 'YGrid', 'on', 'XGrid', 'off');box on
title({'Edge Effect'})
% figure(5);clf(5);
% 
% subplot(5,3,[1:9])
% [N]= histogram(EC,10,'FaceColor','green')
% N.EdgeColor = [0,0,0];N.LineWidth = 2;
% ylabel('# Subjects');
% xlabel('Difference');
% title({'Edge Effect'})
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
for sp = 1:3
subplot(5,3,sp+12)
if sp == 1
    [~,idx] = min(SEC);
    TIT = 'Smallest';
elseif sp == 2
    [~,idx] = min(abs(SEC-mean(SEC)));
    TIT = 'Average';
elseif sp == 3
    [~,idx] = max(SEC);
    TIT = 'Largest';
end
idx= UDX(idx);
hold on
plot(S(1:6,idx),'LineWidth',5)
plot(S(7:12,idx),'LineWidth',5)
hold off
box on;
if sp == 1
    ylabel('d''');
elseif sp == 2
    xlabel(OPT.P.XL);
    
end
title(TIT)
 xticks([OPT.P.XT]);xticklabels({'65','','441','','1230',''});xlim([0,7]);ylim([0.0,3.6]);box on; grid on;
 set(gca,'FontSize',20);set(gca,'FontWeight','bold')
end
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp1_EE.png')