clear; clc;close all
addpath("SubFunc");
% * + * + *
% / - / - /
%% Plot Values
[OPT] = F_Options; % Initialize variables
%% Plot Method
% Simulate stimuli to illustrate the method
% Creates two figures in 'plot' directory
% 1. Method   - - > visual representation of melodies without erb space
%    distance
% 2. Method 3 - - > visual representation of melodies with erb space
%    distance
F_PlotMethod(OPT);
% / - / - /
%% EXP1
% / - / - /
% Statistcally analyse data of Experiment 1
% Creates four output files:
% 1. LME_E1           - - > Results of the Linear mixed effects model
% 2. LME_E1S          - - > Results of the Linear mixed effects model but
%                           with added individual slopes for edge effect 
% 3. TABLE_RESULTS_E1 - - > Table containing all participants and their
% 4. Results_E1.mat   - - > Matfile containing model results + table
%                           responses
[SCORE1,MDL1,MSI1] = F_AnaE1(OPT);
% Illustrates results of Experiment 1
% Creates two figures in 'plot' directory
% 1. Exp1_dPrime - - > dPrime scores 
% 2. Exp1_EE     - - > Edge Effect
F_PlotE1(OPT);clc;
%% Missing neighbour analysis
% Analyse what difference between targets where one neighbor melody 
% was omitted vs targets that were sorrounded by two neighboring melodies
% Creates one figure in 'plot' directory
% 1. Exp1_IO_dPrime - - > dPrime scores differences
F_MNA(OPT);
% / - / - /
%% EXP2
% / - / - /
%% Import results
[~,EXP,SUB] = F_ImportResults(OPT); %  Load
%% Plot Results
% Illustrates results of Experiment 1
% Creates three figures in 'plot' directory
% 1. Exp2_dPrime - - > dPrime scores 
% 2. Exp2_EE     - - > Edge Effect
% 3, Exp2_Hits   - - > Differences in hit rates for melodies appearing on
%                      the spectral edge or center of the mixture
F_PlotScores(EXP,OPT.P);
F_PlotE2(OPT);
%% Statistical evaluation with LME 
[MDL2,MSI2]   = F_StatisticEval(SUB,EXP,OPT);
% Statistcally analyse data of experiment 2
% Creates four output files:
% 1. LME_E2           - - > Results of the Linear mixed effects model
% 2. LME_E2S          - - > Results of the Linear mixed effects model but
%                           with added individual slopes for edge effect 
% 3. TABLE_RESULTS_E2 - - > Table containing all participants and their
%                           responses
% 4. Results_E2.mat   - - > Matfile containing model results + table
% / - / - /
%% Analyse and plot demographic data (age and gender)
% / - / - /
% Illustrates demograpic data
% Creates two figures in 'plot' directory
% 1. Age    - - > Histogram of participants age
% 2. Gender - - > Histogram of participants gender
F_AgeGender(OPT);
% / - / - /
% * + * + *
disp('Done :^)')
% Fin 
