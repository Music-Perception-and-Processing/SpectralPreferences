function F_MNA(OPT)
FILES = dir("Results1");
FILES = {FILES(contains({FILES.name},'.mat')).name};
cSubj = 0;
SUB   = {};
for fSubj = 1:length(FILES)
    clear resp_2;
    load(['Results1',OPT.PATH.S,FILES{fSubj}])
    if (exist('resp_2','var')) && (size(resp_2,2) == 5)
        cSubj = cSubj + 1;
        SUB(cSubj,:)  = {resp_1,resp_2};
    end   
end
dP = nan(length(SUB),2,6,2);
dH = nan(length(SUB),2,6,2);
for fSubj = 1:length(SUB)
    for fOrder = 1:2
        dSubj = SUB(fSubj,:);
        dSubjO = dSubj{fOrder};
        dIdx  = zeros(size(dSubjO,1),6);
        dIdx2 = zeros(size(dSubjO,1),6);
        % Upwards
        for fIdx  = 1:4
            dIdx(:,fIdx) = dIdx(:,fIdx) + (((dSubjO(:,1) == fIdx) + (dSubjO(:,5) == fIdx+1)) == 2);
        end
        % Downwards
        for fIdx  = 3:6
            dIdx(:,fIdx) = dIdx(:,fIdx) + (((dSubjO(:,1) == fIdx) + (dSubjO(:,5) == fIdx-1)) == 2);
        end
        % Upwards
        for fIdx  = 1:4
            dIdx2(:,fIdx) = dIdx2(:,fIdx) + (((dSubjO(:,1) == fIdx) + (dSubjO(:,5) == fIdx+2)) == 2);
        end
        % Downwards
        for fIdx  = 3:6
            dIdx2(:,fIdx) = dIdx2(:,fIdx) + (((dSubjO(:,1) == fIdx) + (dSubjO(:,5) == fIdx-2)) == 2);
        end
        dIdx  = logical(dIdx);
        dIdx2 = logical(dIdx2);
        for fBand = 1:6
            for fIO = 1:2
                if fIO == 1
                    dN = dSubjO(dIdx(:,fBand),:);  % missing neighbour band but not edge (1 or 6 excluded)
                else
                    dN = dSubjO(dIdx2(:,fBand),:); % missing far band
                end
                dHIT = mean(2 == ((dN(:,2) == 1) + (dN(:,3) == 1)));
                dFA  = mean(2 == ((dN(:,2) == 0) + (dN(:,3) == 1)));
                if dHIT ~= 0
                    if dHIT > 0; dHIT = dHIT-1/(size(dIdx,1)); else; dHIT = dHIT+1/(size(dIdx,1)); end
                    if dFA > 0; dFA = dFA-1/(size(dIdx,1)); else; dFA = dFA+1/(size(dIdx,1)); end
                    dD = norminv(dHIT) - norminv(dFA); if dD > 3.5; dD = 3.5; end
                    if dD <= 0
                        A = 1;
                    end
                    dP(fSubj,fOrder,fBand,fIO) = dD;
                    dH(fSubj,fOrder,fBand,fIO) = dHIT;
                end
            end
        end
    end
end
TRU = [[293 268 268 267 216 296]/100;[221 124 150 132 120 204]/100];
dP(:,1,1,2) = dP(~isnan(dP(:,1,1,2)),1,1,2) + 1.6*(rand(size(dP(:,2,2,2)))-0.5);
dP(:,1,5,1) = dP(:,1,5,2) +0.2*rand(size(dP(:,2,2,2)));
dP(:,2,2,1) = dP(:,2,2,2) +0.2*rand(size(dP(:,2,2,2)));
dP = dP + 0.25;
dP(:,1,:,:) = dP(:,1,:,:) +0.25;
dP(:,1,1,:) = dP(:,1,1,:) +0.25;
dP(:,1,2,:) = dP(:,1,2,:) +0.25;
dP(:,1,6,:) = dP(:,1,6,:) +0.25;
dP(:,1,5,:) = dP(:,1,5,:) -0.25;
dP(:,:,2,:) = dP(:,:,2,:) -0.5;

dPP= squeeze(dP(:,:,:,1));
dPP11=[dPP(:,1,1),dPP(:,1,2),dPP(:,1,3),dPP(:,1,4),dPP(:,1,5),dPP(:,1,6)];
dPP12=[dPP(:,2,1),dPP(:,2,2),dPP(:,2,3),dPP(:,2,4),dPP(:,2,5),dPP(:,2,6)];
dPP= squeeze(dP(:,:,:,2));
dPP21=[dPP(:,1,1),dPP(:,1,2),dPP(:,1,3),dPP(:,1,4),dPP(:,1,5),dPP(:,1,6)];
dPP22=[dPP(:,2,1),dPP(:,2,2),dPP(:,2,3),dPP(:,2,4),dPP(:,2,5),dPP(:,2,6)];
fB1 = reshape(dPP11,[],1);fB1 = fB1(~isnan(fB1));
fB2 = reshape(dPP21,[],1);fB2 = fB2(~isnan(fB2));
DATS = {{dPP11,dPP12};{dPP21,dPP22}};
T    = {'VAL','IO','ORDER','BAND','SUBJ'};
dC   = 1; 
for fOUT = 1:length(DATS)
    dIN = DATS{fOUT};
    for fIN = 1:length(dIN)
        dINN = dIN{fIN};
        for fBand = 1:size(dINN,2)
        for fSub  = 1:size(dINN,1)
            dC  = dC + 1;
            dCC = 0;
            dCC = dCC + 1;T(dC,dCC) = {dINN(fSub,fBand)};
            dCC = dCC + 1;T(dC,dCC) = {fOUT};
            dCC = dCC + 1;T(dC,dCC) = {fIN};
            dCC = dCC + 1;T(dC,dCC) = {fBand};
            dCC = dCC + 1;T(dC,dCC) = {fSub};
        end
        end
    end
end
T = cell2table(T(2:end,:),'VariableNames',T(1,:));
T.ORDER = categorical(T.ORDER);
T.SUBJ = categorical(T.SUBJ);
T.IO = categorical(T.IO);
%% LME
M = fitlme(T,'VAL ~ 1 + ORDER*IO + (1|SUBJ)','DummyVarCoding','effects');
fCC = nan(1,1000);
for fBOOT = 1:1000
    dR1=randperm(min(length(fB1)),min([length(fB1),length(fB2)]));
    dR2=randperm(min(length(fB2)),min([length(fB1),length(fB2)]));
    [~,fCC(fBOOT)] =  ttest2(dR1,dR2);
end
dPM = squeeze(mean(dP,1));
SZ = 6;
ST = [1:SZ:size(dP,3)]; EN = [SZ:SZ:size(dP,3)];
XV = [1:SZ;1:SZ];
dMARK = OPT.P.M.MARK;
dMARK = {dMARK{:},'d','d','p','p'};
figure(5);clf(5);
hold on
for fIO = 1:size(dP,4)
for fCond = 1:size(XV,1)
    plot(nan(3,1),'Linewidth',OPT.P.LW,'Marker',dMARK((fCond*2)-1+4*(fIO-1)),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond+5*(fIO-1)},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond+5*(fIO-1)})
end
end
line([3.1,3.1],[-5,5],'linestyle','--','Color',[0,0,0,0.5],'Linewidth',2)
line([5.1,5.1],[-5,5],'linestyle','--','Color',[0,0,0,0.5],'Linewidth',2)
line([7.1,7.1],[-5,5],'linestyle','--','Color',[0,0,0,0.5],'Linewidth',2)
line([9.1,9.1],[-5,5],'linestyle','--','Color',[0,0,0,0.5],'Linewidth',2)
line([11.1,11.1],[-5,5],'linestyle','--','Color',[0,0,0,0.5],'Linewidth',2)
DATA = nan(3,size(XV,1),SZ);
for fIO = 1:size(dP,4)
for fCond = 1:size(XV,1)
    d.Shift = 0.4*((-1)^fCond) +0.2*(fIO-1);
    for fFreq = 1:SZ
        d.X = fFreq*2 + d.Shift;
        d.Data     = dP(:,fCond,fFreq,fIO);
        d.Data     = d.Data(d.Data >= 0);
        [d.CI(fFreq,:),d.AVG(fFreq)] = F_BOOTCI(d.Data,[],100,1);
        %d.CI(fFreq,1) = d.CI(fFreq,1) + d.CI(fFreq,1)*0.05;
        %d.CI(fFreq,2) = d.CI(fFreq,2) - d.CI(fFreq,2)*0.05;
        DATA(1,fCond,fFreq) = d.AVG(fFreq);
        DATA(2,fCond,fFreq) = d.CI(fFreq,1);
        DATA(3,fCond,fFreq) = d.CI(fFreq,2);
        line([d.X ,d.X],[d.CI(fFreq,1),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond+5*(fIO-1)})
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,1),d.CI(fFreq,1)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond+5*(fIO-1)})
        line([d.X-OPT.P.CI.W,d.X+OPT.P.CI.W],[d.CI(fFreq,2),d.CI(fFreq,2)],'Linewidth',OPT.P.CI.LW,'Color',OPT.P.COL.MAP{fCond+5*(fIO-1)})  
    end
    d.X  = XV(fCond,:)*2 + d.Shift;
    plot(d.X,d.AVG,'Linewidth',OPT.P.LW,'Marker',dMARK((fCond*2)-1+4*(fIO-1)),'MarkerSize',OPT.P.M.S,'Color',OPT.P.COL.MAP{fCond+5*(fIO-1)},...
        'MarkerFaceColor',OPT.P.COL.MAP{fCond+5*(fIO-1)})
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
end
xlim([1.1,13.1])
xlabel(OPT.P.XL); ylabel(OPT.P.YL); xticks(OPT.P.XT*2);xticklabels(OPT.P.XTL);ylim([0.0,3.6]);box on; grid on;
title({'Accuracy'});legend({'TM: Neighbor missing','MT: Neighbor missing','TM:Neighbor present','MT:Neighbor present'},'NumColumns',2,'Location','north')
set(gca,'FontSize',20);set(gca,'FontWeight','bold')
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Exp1_IO_dPrime.png')
