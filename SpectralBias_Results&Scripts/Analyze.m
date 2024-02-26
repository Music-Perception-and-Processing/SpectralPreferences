clear; clc;close all
addpath("SubFunc");
%% Plot Values
[OPT] = F_Options; % Initialize variables
%% Plot Method
F_PlotMethod(OPT);
% / - / - /
%% EXP1
% / - / - /
[SCORE1,MDL1,MSI1] = F_AnaE1(OPT);
F_PlotE1(OPT);
% / - / - /
%% EXP2
% / - / - /
%% Import results
[SUB,EXP] = F_ImportResults; %  Load
%% Plot Results
F_PlotScores(EXP,OPT.P);
clear SUB;
load([OPT.PATH.MF 'dprime_all_EDGE'])
ST = [1:4:size(dprim_all,1)]; 
EN = [4:4:size(dprim_all,1)];
XV = [1:4;3:6;1:4;3:6];
F_PlotE2(OPT)
%% Statistical evaluation with LME 
SUB.dP = dprim_all;EXP.DP = dprim_all;
[MDL2,MSI2]   = F_StatisticEval(SUB,EXP);
%% Clustering
%CLUSTER = F_Cluster(dprim_all);