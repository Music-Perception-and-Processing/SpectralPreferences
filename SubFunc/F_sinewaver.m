function [sig_multi] = sinewaver(FF, DD, fs)
% takes matrix of frequencies and onset-offset times and synthesize sounds
sig_multi = zeros(max(DD(:,1))*fs, size(DD,2)); 
for nTrack = 1:size(FF, 2)
    Y = []; 
    for nTone = 1:size(FF,1)
        t0 = DD(nTone, nTrack); t1 = DD(nTone+1, nTrack); 
        t = linspace(t0, t1, round((t1-t0)*fs))'; 
        f = FF(nTone, nTrack);
        x = sin(2*pi*t*f); % synth
        y = F_cos_ramp(x, fs, .01); % fading
        Y = [Y; y];
    end
    sig_multi(1:length(Y), nTrack) = Y; 
end
    