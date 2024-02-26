function [MDL,COR_MSI] = F_StatisticEval(SUB,EXP)
COR_MSI = struct;
%D.dP  = reshape(EXP.DP,[],16)';
D.HIT = reshape(EXP.HIT,[],16)';
D.FA  = reshape(EXP.FA,[],16)';
D.E  = reshape(EXP.EDGE,[],16)';
D.N  = reshape(EXP.NDGE,[],16)';
D.dP  = SUB.dP;
for sub = 1:29
    DIF(:,sub) = D.dP(:,30) - D.dP(:,sub);
end
[DIFFI,idx] = min(abs(DIF'));
for val = 1:16
    D.HIT(val,30) = D.HIT(val,idx(val));
    D.FA(val,30) = D.FA(val,idx(val));
    D.E(val,30) = D.E(val,idx(val));
    D.N(val,30) = D.N(val,idx(val));
end
%% Table
T = {};
iO = [ones(1,8),ones(1,8)*2];
iBL = [ones(1,4),ones(1,4)*2,ones(1,4),ones(1,4)*2];
iBA = [1:4,1:4,1:4,1:4];
iEdge = [1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1];
iMid  = [0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0];
EXP.MSI.P(end+1) = EXP.MSI.P(end) +1;
EXP.MSI.T(end+1) = EXP.MSI.T(end) +4;
iMu = [1,0,0,5,8,0,10,8,4,1,8,10,10,10,5,0,2,1,5,0,0,0,0,10,5,0,0,3,0] >= 3;
%EXP.MSI.P = [nan(1,30)];EXP.MSI.T = [nan(1,30)];
[mean(EXP.MSI.P(iMu)),mean(EXP.MSI.T(iMu))];
[mean(EXP.MSI.P(~iMu)),mean(EXP.MSI.T(~iMu))];
row = 0;
for fCond = 1:size(D.dP,1)
    for fSub = 1:size(D.dP,2)
        row = row + 1;col = 0;
        col = col + 1;T(row,col) = {iO(fCond)}; % 'Order'
        col = col + 1;T(row,col) = {iBL(fCond)}; % 'Blocks'
        col = col + 1;T(row,col) = {iBA(fCond)}; % 'Band_ID'
        col = col + 1;T(row,col) = {iEdge(fCond)}; % 'Edge'
        col = col + 1;T(row,col) = {iMid(fCond)}; % 'Mid'
        col = col + 1;T(row,col) = {fSub}; % 'Subject'
        col = col + 1;T(row,col) = {iMu(fCond)}; % 'Musicians'
        col = col + 1;T(row,col) = {EXP.MSI.P(fSub)};%{sum(SUB(sub).MSI.P)}; % 'Musicians'
        col = col + 1;T(row,col) = {EXP.MSI.T(fSub)};%{sum(SUB(sub).MSI.T)}; % 'Musicians'
        col = col + 1;T(row,col) = {D.dP(fCond,fSub)}; % 'dPrime'
        col = col + 1;T(row,col) = {D.HIT(fCond,fSub)}; % 'Hit rate'
        col = col + 1;T(row,col) = {D.FA(fCond,fSub)}; % 'False alarm rate'
        col = col + 1;T(row,col) = {D.E(fCond,fSub)}; % 'Edge Accuracy'
        col = col + 1;T(row,col) = {D.N(fCond,fSub)}; % 'None Edge Accuracy'
    end
end
T = cell2table(T,'VariableNames',{'Order','Blocks','Band','Edge','Mid','Subject','Musicians','MSI_Perception','MSI_Training','dPrime','Hitrate','FA','Hit_Edge','Hit_NonEdge'});
%%
UQ = unique(T.Subject);
OR = unique(T.Order);
for fUQ = 1:length(UQ)
    for fOR = 1:length(OR)
        fIdx = ((T.Subject == UQ(fUQ)) + (T.Order == OR(fOR))) == 2;
    SU.DP(fUQ,OR)= mean(T.dPrime(fIdx));
    SU.P(fUQ,OR) = mean(T.MSI_Perception(fIdx));
    SU.T(fUQ,OR) = mean(T.MSI_Training(fIdx));
    end
end
DP = (mean(EXP.DP));DP = DP(1:end-1);
MP = EXP.MSI.P;
MT = EXP.MSI.T;
%COR_MSI.P = corrcoef(MP,DP).^2;
%COR_MSI.T = corrcoef(MT,DP).^2;


T.Order = categorical(T.Order);
T.Blocks = categorical(T.Blocks);
T.Edge = categorical(T.Edge);
T.Mid = categorical(T.Mid);
%T.Band = categorical(T.Band);
T.Musicians = categorical(T.Musicians);
T.Subject = categorical(T.Subject);
writetable(T,'RESULTS_E2.csv','Delimiter',';')

%% LME
M = fitlme(T,'dPrime ~ 1 + Order*Edge*Blocks*Band*MSI_Training*MSI_Perception + (1|Subject)','DummyVarCoding','effects');
M = fitlme(T,'dPrime ~ 1 + Order*Edge*Blocks + (1|Subject)','DummyVarCoding','effects');
MDL = dataset2cell(M.Coefficients);
M = fitlme(T,'dPrime ~ 1 + Order*Band + (1|Subject)','DummyVarCoding','effects');
DS2C1 = dataset2cell(M.Coefficients);
M = fitlme(T,'dPrime ~ 1 + Order*MSI_Training + Order*MSI_Perception + (1|Subject)','DummyVarCoding','effects');
DS2C2 = dataset2cell(M.Coefficients);
MDL   = [MDL(1:5,:);DS2C1(4,:);DS2C2(4,:);DS2C2(5,:);...
         MDL(6:9,:);DS2C1(5,:);DS2C2(6:7,:)];
TT  = T; 
TT  = TT(~isnan(TT.Hit_NonEdge),:);
TTT = TT;
TT.Hitrate = TT.Hit_NonEdge; TT.Hit_NonEdge(:) = 1; TT.Hit_Edge(:) = 0;
TTT.Hitrate = TTT.Hit_Edge; TTT.Hit_NonEdge(:) = 0; TTT.Hit_Edge(:) = 1;
TT = [TTT;TT];
TT.Subject = categorical(TT.Hit_NonEdge);
TT.Subject = categorical(TT.Hit_Edge);
MDL4 = fitglme(TT,'Hitrate ~ 1 + Order*Hit_NonEdge + (1|Subject)','DummyVarCoding','effects');
% MDL4 = anova(MDL4);
%MDL  = {MDL1,MDL2,MDL3};

%% Plot data
TT = T;
TT.dPrime = round(TT.dPrime,4);
writetable(TT,'RESULTS_E2.csv','Delimiter',';')
save('Results_E2.mat','T','MDL');