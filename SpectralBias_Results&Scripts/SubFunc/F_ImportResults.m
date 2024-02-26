function [SUB,EXP] = F_ImportResults
DIR = dir('Results_2'); DIR = DIR(contains({DIR.name},'.mat'));
SUB = struct;
% Edge
EDGE_FAC = {[1:4],[1],[4],[1:4];...
            [1:4],[1],[4],[1:4];...
            [1:4],[1],[4],[1:4];...
            [1:4],[1],[4],[1:4]};
EDGEN = nan(length(DIR),4,4); % Number of stimuli on Edge
ADGE  = nan(length(DIR),4,4); % Hit rate of all stimuli for a given subject | condition | band 
EDGE  = nan(length(DIR),4,4); % Hit rate of edge stimuli for a given subject | condition | band    
NDGE  = nan(length(DIR),4,4); % Hit rate of non-edge stimuli for a given subject | condition | band    
% Musical sophistication
MSI.SCORE = [1:7;7:-1:1];
MSI.P_IDX = [1,1,2,1,2,1,1,2,1];
MSI.T_IDX = [1,1,1,2,1,1,1];
for fSub = 1:length(DIR)
    load([DIR(fSub).folder,'\',DIR(fSub).name])
    for fIdxm = 1:size(MSI.SCORE,1) 
        if fIdxm == 1
            data1 = [PAR.QUEST.MSI_P_V{:}];
            data2 = MSI.P_IDX;
        else
            data1 = [PAR.QUEST.MSI_T_V{:}];
            data2 = MSI.T_IDX;
        end
        data3 = nan(size(data1));
        for fIdxq = 1:length(data1)
            data3(fIdxq) = MSI.SCORE(data2(fIdxq),data1(fIdxq));
        end
         if fIdxm == 1
            SUB(fSub).MSI.T = data3;
        else
            SUB(fSub).MSI.P = data3;
        end
    end
    DATA = {resp_TL,resp_TH,resp_ML,resp_MH};
    for fData = 1:length(DATA)
        % resp_TL (condition = band / response / included? / RT / Leftout band)
        RESP     = DATA{fData};
        HD    = RESP(RESP(:,3) == 1,:); % HIT or MISS?
        FD    = RESP(RESP(:,3) == 0,:); % FA or REJECTION?
        % HIT & MISS
        HIT   = (HD(:,2) == 1) + (HD(:,3) == 1) ==2; % With target, answer yes
        MISS  = (HD(:,2) == 0) + (HD(:,3) == 1) ==2; % With target, answer no
        % FA & REJ
        FA    = (FD(:,2) == 1) + (FD(:,3) == 0) ==2; % Without target, answer yes
        REJ   = (FD(:,2) == 0) + (FD(:,3) == 0) ==2; % Without target, answer no
        UQ    = unique(RESP(:,1));
        % Condition
        Cidx1  = nan(length(unique(RESP(:,1))),size(HIT,1));
        Cidx2  = nan(length(unique(RESP(:,1))),size(HIT,1));
        for fCond = 1:size(Cidx1,1)
            Cidx1(fCond,:)  =HD(:,1) == UQ(fCond);
            Cidx2(fCond,:)  =FD(:,1) == UQ(fCond);
        end
        Cidx1 = logical(Cidx1);
        Cidx2 = logical(Cidx2);
        % hit / false alarm / dPrime for each condition
        ht = nan(size(Cidx1,1) ,1);
        fa = nan(size(Cidx1,1) ,1);
        dp = nan(size(Cidx1,1) ,1);
        for fCond = 1:size(Cidx1,1)
            HT.RESP = HD(Cidx1(fCond,:),:);
            DP.RESP = FD(Cidx2(fCond,:),:);
            ht(fCond) = mean(HT.RESP(:,2));
            fa(fCond) = mean(DP.RESP(:,2)); 
            idxe = ismember(HT.RESP(:,5),EDGE_FAC{fData,fCond});
            EdgeData = HT.RESP(:,2); EdgeData = EdgeData(idxe==1); % Hit accuracy when presented as an edge 
            NdgeData = HT.RESP(:,2); NdgeData = NdgeData(idxe==0);% Hit accuracy when not presented as an edge 
            EDGEN(fSub,fData,fCond) = sum(idxe);
            ADGE(fSub,fData,fCond)  = mean(HT.RESP(:,2));
            if sum(idxe == 1) > 0
                EDGE(fSub,fData,fCond)  = nanmean(EdgeData);    
            else
                EDGE(fSub,fData,fCond)  = nan;
            end
            if sum(idxe == 0) > 0
                NDGE(fSub,fData,fCond)  = nanmean(NdgeData);    
            else
                NDGE(fSub,fData,fCond)  = nan;
            end
            if ht(fCond) == 0
                ht(fCond) = 1/sum(Cidx1(fCond,:));
            elseif ht(fCond) == 1
                ht(fCond) = 1 - (1/sum(Cidx1(fCond,:)));
            end
            if fa(fCond) == 0
                fa(fCond) = (1/sum(Cidx2(fCond,:)));
            elseif fa(fCond) == 1
                fa(fCond) = 1 - (1/sum(Cidx2(fCond,:)));
            end
            dp(fCond) = norminv(ht(fCond))-norminv(fa(fCond));
        end
        SUB(fSub).HIT(fData,:) = ht;
        SUB(fSub).FA(fData,:)  = fa;
        SUB(fSub).DP(fData,:)  = dp;
    end
end
EXP = struct;
for fSub = 1:length(DIR)
    for fCond = 1:4
        for fBand = 1:4
            EXP.DP(fSub,fCond,fBand)   = SUB(fSub).DP(fCond,fBand);
            EXP.HIT(fSub,fCond,fBand)  = SUB(fSub).HIT(fCond,fBand);
            EXP.FA(fSub,fCond,fBand)   = SUB(fSub).FA(fCond,fBand);
            EXP.EDGE(fSub,fCond,fBand) = EDGE(fSub,fCond,fBand);
            EXP.NDGE(fSub,fCond,fBand) = NDGE(fSub,fCond,fBand);
            EXP.DDGE(fSub,fCond,fBand) = EDGE(fSub,fCond,fBand)-NDGE(fSub,fCond,fBand);
        end
    end
    EXP.MSI.P(fSub) = [sum(SUB(fSub).MSI.P)];
    EXP.MSI.T(fSub) = [sum(SUB(fSub).MSI.T)];
end
D.Data = mean([mean(squeeze(EXP.DP(:,1,:)),2),...
               mean(squeeze(EXP.DP(:,2,:)),2),...
               mean(squeeze(EXP.DP(:,3,:)),2),...
               mean(squeeze(EXP.DP(:,4,:)),2)],2);
D.CC = corrcoef(D.Data,EXP.MSI.P); EXP.MSI.P_CC = D.CC(2,1)^2;
D.CC = corrcoef(D.Data,EXP.MSI.T); EXP.MSI.T_CC = D.CC(2,1)^2;
D.CC = corrcoef(D.Data,EXP.MSI.P+EXP.MSI.T); EXP.MSI.PT_CC = D.CC(2,1)^2;



D.EDGE(1) ={reshape(EXP.EDGE,[],16)};
D.EDGE(2) ={reshape(EXP.NDGE,[],16)};