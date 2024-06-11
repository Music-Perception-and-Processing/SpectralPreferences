%% INIT
clc; clear; close all;
PATH.S    = '/';if ispc == 1; PATH.S = '\';end
addpath(['SubFunc',PATH.S])
%% Options
OPT.LVL = 2; % Choose which level to use  (1= 40 dB, 2 = 50 dB, 3 = 60 dB)
OPT.MEL = [1,1,1,1,1,1]; % Choose which of the six frequency bands to exculde (0 = exclude, 1 = include)  
%% Amplification % Intensity settings
% The Intensity matrices are a result of individual setups and must
% therefore be calibrated individualy beforehand
% Calibration for 40 dB
INTENSITY.MAT(1,1) = 40;
INTENSITY.MAT(2,1) = 0.0086;INTENSITY.MAT(3,1) = 0.0021;
INTENSITY.MAT(4,1) = 0.0013;INTENSITY.MAT(5,1) = 0.0012;
INTENSITY.MAT(6,1) = 0.0010;INTENSITY.MAT(7,1) = 0.0012;
% Calibration for 50 dB
INTENSITY.MAT(1,2) = 50;
INTENSITY.MAT(2,2) = 0.0272;INTENSITY.MAT(3,2) = 0.0107;
INTENSITY.MAT(4,2) = 0.0060;INTENSITY.MAT(5,2) = 0.0046;
INTENSITY.MAT(6,2) = 0.0036;INTENSITY.MAT(7,2) = 0.0047;
% Calibration for 60 dB
INTENSITY.MAT(1,3) = 60;
INTENSITY.MAT(2,3) = 0.12;INTENSITY.MAT(3,3) = 0.035;
INTENSITY.MAT(4,3) = 0.032;INTENSITY.MAT(5,3) = 0.013;
INTENSITY.MAT(6,3) = 0.010;INTENSITY.MAT(7,3) = 0.013;
% Intensity Settings
INTENSITY.BASE   = INTENSITY.MAT(1,OPT.LVL);
INTENSITY.FACTOR = INTENSITY.MAT(2:end,OPT.LVL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% random melodies [random frequencies and random durations] 
mu_vec    = [0 1 2 3 4 5]; % melody octave spacing
numTones  = 8;             % number of tones
stim_dur  = 2;             % overall stimulus duration 
numTracks = length(mu_vec);% number of melodies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% frequencies 
f_low       = 65;        % lowest freq in the game [~C2 pitch]
fs          = 44100;    % sampling frequency
freq_spread = .5;       % frequency spread in Octaves
f_erb       = 10^3.*[0.0650  0.2149  0.4414  0.7834  1.2999  2.0800]; % Erb starting values
seqs        = freq_spread*rand(numTones,numTracks) + repmat(log2(f_erb), numTones, 1); % control matrix
FF          = 2.^seqs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create melodie onsets 
it = 1; 
it_req = 0; % required iterations 
while it == 1
    it_req = it_req + 1; 
    r = rand(numTones-1, numTracks);
    DD = stim_dur*[zeros(1,numTracks); sort(r); ones(1,numTracks)];
    dd = diff(DD) > 0.05; % minimum duration 
    it = min(dd(:)) == 0; 
end
% Create tones from onsets
Y  = F_sinewaver(FF, DD, fs);
for fBand = 1:min([size(Y,2),length(OPT.MEL)])
    Y(:,fBand) = OPT.MEL(fBand)*Y(:,fBand); % Exclude/Include frequency bands
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create signal and amplify level accordingly to intensity options
% Choose target and create mixture without target
idxPlay   = find(OPT.MEL == 1);
idxCue    = idxPlay(randperm(length(idxPlay),1)); % Chose target melody
IdxOut    = idxPlay(idxPlay ~= idxCue);
IdxOut    = IdxOut(randperm(length(IdxOut),1));
YN = Y; YN(:,idxCue) = zeros(size(Y,1),1);        % Mixture without target
YT = Y; YT(:,IdxOut) = zeros(size(Y,1),1);        %Exclude a non target melody
%% Create audio vectors                                                  
AUDIO.Cue = Y(:,idxCue)*INTENSITY.FACTOR(idxCue); % Create target cue
AUDIO.Mix = Y*INTENSITY.FACTOR;                   % Create mixture with target
AUDIO.Nix = YN*INTENSITY.FACTOR;                  % Create mixture without target
% Create stimuli in both orders (Mixture-Target & Target-Mixture)
AUDIO.MT  = [zeros(ceil(fs*0.1),1);AUDIO.Mix;zeros(ceil(fs*1.0),1);AUDIO.Cue;zeros(ceil(fs*0.1),1)]; % stimuli with target (mixture-target)
AUDIO.TM  = [zeros(ceil(fs*0.1),1);AUDIO.Cue;zeros(ceil(fs*1.0),1);AUDIO.Mix;zeros(ceil(fs*0.1),1)]; % stimuli with target (target-mixture)
AUDIO.NT  = [zeros(ceil(fs*0.1),1);AUDIO.Nix;zeros(ceil(fs*1.0),1);AUDIO.Cue;zeros(ceil(fs*0.1),1)]; % stimuli without target (mixture-target)
AUDIO.TN  = [zeros(ceil(fs*0.1),1);AUDIO.Cue;zeros(ceil(fs*1.0),1);AUDIO.Nix;zeros(ceil(fs*0.1),1)]; % stimuli without target (target-mixture)
% Save Stimuli
audiowrite(['Stimuli',PATH.S,'TAR_(',num2str(idxCue),')_MT.wav'],AUDIO.MT,fs); % stimuli with target (mixture-target)
audiowrite(['Stimuli',PATH.S,'TAR_(',num2str(idxCue),')_NT.wav'],AUDIO.NT,fs); % stimuli with target (target-mixture)
audiowrite(['Stimuli',PATH.S,'TAR_(',num2str(idxCue),')_TM.wav'],AUDIO.TM,fs); % stimuli without target (mixture-target)
audiowrite(['Stimuli',PATH.S,'TAR_(',num2str(idxCue),')_TN.wav'],AUDIO.TN,fs); % stimuli without target (target-mixture)