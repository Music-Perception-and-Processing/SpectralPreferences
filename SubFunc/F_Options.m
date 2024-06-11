function [OPT] = F_Options
OPT = struct;
PATH.S    = '/';
if ispc == 1; PATH.S = '\';end
PATH.PLOT = ['Plot',PATH.S];
PATH.SF   = ['SubFunc',PATH.S];
PATH.MF   = ['Matfiles',PATH.S];
PATH.R2   = ['Results 4',PATH.S];
PATH.OUT  = ['Output Files',PATH.S];
if exist(PATH.PLOT,"dir") == 0
    mkdir(PATH.PLOT)
end
%% Plot var initialization
P = struct;
P.COL.MAP = num2cell(colormap('lines'),2);
P.COL.FAC = [1,1,0.75,0.75];
P.COL.IDX = [1,2,1,2];
P.LW   = 3;
P.CI.W = 0.15;
P.CI.LW= P.LW*0.75;
P.XL  = 'Frequency in Hz';
P.XT  = [1:6];
P.XTL = [65,215,441,783,1230,2080];
P.YL  = 'd''';
P.YLIM = [0,3];
P.XIDX = {[1:4]-P.CI.W/2;[3:6]-P.CI.W/2;[1:4]+P.CI.W/2;[3:6]+P.CI.W/2};
P.LS   = {'--','--',':',':'};
P.M.MARK = {'o','o','s','s'};
P.M.S    = 12;
%% Combine all vars to opt struct
OPT.P    = P;
OPT.PATH = PATH;