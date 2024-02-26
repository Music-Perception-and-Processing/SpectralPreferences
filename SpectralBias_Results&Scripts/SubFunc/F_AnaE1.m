function [SCORE,MDL,COR_MSI] = F_AnaE1(OPT)
% Analysis of Experiment 1
load([OPT.PATH.MF 'dprim_exp1']) % load score of Exp1
load([OPT.PATH.MF 'PERC_exp1']) % load score of Exp1
load([OPT.PATH.MF 'TRAIN_exp1']) % load score of Exp1
S = dprim_all;
SZ = 6;                          % bands within each presentation order
ST = [1:SZ:size(S,1)]; EN = [SZ:SZ:size(S,1)]; % Indexes for each order
XV = [1:SZ;1:SZ];                              % X-Axis cordinates
N.Cond = size(dprim_all,1);         
N.Sub  = size(dprim_all,2);
IDX.Edge  = [ST,EN];
IDX.Inner = find(~ismember(1:N.Cond, [ST,EN]));
IDX.TM    = ismember(1:N.Cond, [ST(1):EN(1)]);
IDX.MT    = ismember(1:N.Cond, [ST(2):EN(2)]);
IDX.TMMT  = [find(IDX.TM);find(IDX.MT)];
[sortedVals,indexes] = sort(sum(train_score));
mus = ones(1,length(indexes)); mus(indexes(1:5)) = 0; mus = logical(mus);
%% Table containing all results
T = {}; N.ROW = 1; N.COL = 1;
T(N.ROW,N.COL) = {'Order'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'Band'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'Edge'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'Subject'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'dP'};N.COL = 1 + N.COL;
%T(N.ROW,N.COL) = {'RT'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'MSI_P'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'MSI_T'};N.COL = 1 + N.COL;
T(N.ROW,N.COL) = {'Musician'};
for fOrder = 1:length(ST)
    for fBand = 1:N.Cond/length(ST)
        for fSub = 1:N.Sub
            N.ROW = N.ROW + 1;
            N.COL = 1;
            T(N.ROW,N.COL) = {fOrder};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {fBand};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {ismember(fBand,IDX.Edge)};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {fSub};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {S(IDX.TMMT(fOrder,fBand),fSub)};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {sum(perc_score(:,fSub))};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {sum(train_score(:,fSub))};N.COL = 1 + N.COL;
            T(N.ROW,N.COL) = {mus(fSub)};N.COL = 1 + N.COL;
            %T(N.ROW,N.COL) = {1};N.COL = 1 + N.COL;
        end
    end
end
T = cell2table(T(2:end,:),"VariableNames",T(1,:));
%% Statistical evaluation
T.Order   = categorical(T.Order);
T.Edge    = categorical(T.Edge);
%T.Band    = categorical(T.Band);
T.Subject = categorical(T.Subject);
T.Musician = categorical(T.Musician);

% MSI CORELATION
UQ = unique(T.Subject);
OR = unique(T.Order);
for fUQ = 1:length(UQ)
    for fOR = 1:length(OR)
        fIdx = ((T.Subject == UQ(fUQ)) + (T.Order == OR(fOR))) == 2;
    SU.DP(fUQ,OR)= mean(T.dP(fIdx));
    SU.P(fUQ,OR) = mean(T.MSI_P(fIdx));
    SU.T(fUQ,OR) = mean(T.MSI_T(fIdx));
    end
end
COR_MSI.P1 = fitlm(SU.DP(:,1),SU.P(:,1));
COR_MSI.T1 = fitlm(SU.DP(:,1),SU.T(:,1));
COR_MSI.P2 = fitlm(SU.DP(:,2),SU.P(:,2));
COR_MSI.T2 = fitlm(SU.DP(:,2),SU.T(:,2));
M = fitlme(T,'dP~Order*Edge+(1|Subject)',DummyVarCoding='effects');
DS2C1 = dataset2cell(M.Coefficients);
M = fitlme(T,'dP~Order*Band+(1|Subject)',DummyVarCoding='effects');
DS2C2 = dataset2cell(M.Coefficients);
M = fitlme(T,'dP~Order*Edge*Band+(1|Subject)',DummyVarCoding='effects');
DS2C3 = dataset2cell(M.Coefficients);
M = fitlme(T,'dP~Order*MSI_P+Order*MSI_T+(1|Subject)',DummyVarCoding='effects');
DS2C4 = dataset2cell(M.Coefficients);
MDL   = [DS2C1(1:4,:);DS2C2(4,:);DS2C3(4,:);DS2C4(4:5,:);...
         DS2C1(5,:);DS2C2(5,:);DS2C3(6:end,:);DS2C4(6:end,:)];

%% SCORE TABLE
IDX.R = 1;
R(IDX.R,:) = [mean(S(IDX.TM,:),"all"),mean(S(IDX.MT,:),"all"),mean(S(IDX.TM,:),"all")-mean(S(IDX.MT,:),"all")];   IDX.R = IDX.R + 1;
R(IDX.R,:) = [mean(S(IDX.Edge,:),"all"),mean(S(IDX.Inner,:),"all"),mean(S(IDX.Edge,:),"all")-mean(S(IDX.Inner,:),"all")];IDX.R = IDX.R + 1;
% AVG & ORD
R(IDX.R,:) = [mean(S(IDX.Edge(ismember(IDX.Edge,find(IDX.TM))),:),"all") ...
    mean(S(IDX.Edge(ismember(IDX.Edge,find(IDX.MT))),:),"all") ...
    mean(S(IDX.Edge(ismember(IDX.Edge,find(IDX.TM))),:),"all") - ...
    mean(S(IDX.Edge(ismember(IDX.Edge,find(IDX.MT))),:),"all")]; IDX.R = IDX.R + 1;
R(IDX.R,:) = [mean(S(IDX.Inner(ismember(IDX.Inner,find(IDX.TM))),:),"all") ...
    mean(S(IDX.Inner(ismember(IDX.Inner,find(IDX.MT))),:),"all") ...
    mean(S(IDX.Inner(ismember(IDX.Inner,find(IDX.TM))),:),"all") - ...
    mean(S(IDX.Inner(ismember(IDX.Inner,find(IDX.MT))),:),"all")]; IDX.R = IDX.R + 1;
IDX.R = 1;
D1(IDX.R,:) = {'TarMix','MixTar','Difference'};IDX.R = IDX.R + 1;
D1(IDX.R,:) = {'Edge','Inner','Difference'};IDX.R = IDX.R + 1;
D1(IDX.R,:) = {'Edge (TarMix)','Edge (MixTar)','Difference'};IDX.R = IDX.R + 1;
D1(IDX.R,:) = {'Inner (TarMix)','Inner (MixTar)','Difference'};IDX.R = IDX.R + 1;
IDX.R = 1;
SCORE = {};
SCORE(IDX.R,2) = {'Experiment 1 - Spectral preference regions'};
for fR = 1:size(R,1)
    IDX.R = IDX.R + 1;
    SCORE(IDX.R,2:size(R,2)+1) = D1(fR,:);
    IDX.R = IDX.R + 1;
    SCORE(IDX.R,2:size(R,2)+1) = num2cell(R(fR,:));
end
% ALL
R2 = [mean(S(IDX.TM,:),2)';mean(S(IDX.MT,:),2)';mean(S(IDX.TM,:),2)'-mean(S(IDX.MT,:),2)'];
D2    = {'65','215','441','783','1230','2080'};IDX.R = IDX.R + 1;
D3(1) = {'TarMix'};
D3(2) = {'MixTar'};
D3(3) = {'Difference'};
IDX.R = IDX.R + 1;
SCORE(IDX.R,1) ={'Frequency'};
SCORE(IDX.R,2:size(D2,2)+1) = D2; IDX.R = IDX.R + 1;
SCORE(IDX.R,1) =D3(1);
SCORE(IDX.R,2:size(R2,2)+1) = num2cell(R2(1,:)); IDX.R = IDX.R + 1;
SCORE(IDX.R,1) =D3(2);
SCORE(IDX.R,2:size(R2,2)+1) = num2cell(R2(2,:)); IDX.R = IDX.R + 1;
SCORE(IDX.R,1) =D3(3);
SCORE(IDX.R,2:size(R2,2)+1) = num2cell(R2(3,:)); IDX.R = IDX.R + 1;
writecell(MDL,'GLME_E1.csv','Delimiter',';')
writetable(T,'RESULTS_E1.csv','Delimiter',';')
save('Results_E1.mat','T','MDL');