function [ci,avg] = F_BOOTCI(data,alpha,n,mode)
%% Description
% Function f_BOOTCI evaluates the confidenz interval of a given
% 1-dimensional "data" array. 
% All input variables except for "data" are optional.
% * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Input Vars
% data  -> 1-dimensional data array (Example = [1, 2, 3, 4, 5])
% Optional * * * * * * *
% alpha -> confidence level 
% n     -> number of bootstrap iterations
% mode  -> statistical averaging method. (1 = mean / 2 = logarithmic / else = median)
% * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Output Vars
% ci    ->  lower "c(1)" and upper "c(2)" boundry of confidenz interval
% avg   ->  statistical average dependent on mode. 
%           mode = 1: uses mean for confidenz interval
%           mode = 2: uses median for confidenz interval 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * 
%% Adjust input vars
data   = squeeze(data(~isnan(data)));
if exist('alpha','var') == 0 || isempty(alpha) == 1; alpha = 0.05 ;end
if exist('n','var')     == 0 || isempty(n)     == 1; n     = 1000 ;end
if exist('mode','var')  == 0 || isempty(mode)  == 1; mode  = 1;end
% Perform bootstrap
bootstrapStatistics = zeros(1, n);
for strap = 1:n
    bootstrapSample = datasample(data, numel(data), 'Replace', true);
    bootstrapSample = bootstrapSample(~isnan(bootstrapSample));
    if mode == 1
        sampleStatistic = mean(bootstrapSample);
    elseif mode == 2
        sampleStatistic = 10^(mean(log10(bootstrapSample)));
    else
        sampleStatistic = median(bootstrapSample);
    end
    bootstrapStatistics(strap) = sampleStatistic;
end
%% Calculate confidence intervals and sample statistic
ci(1) = prctile(bootstrapStatistics, 100 * alpha/2);
ci(2) = prctile(bootstrapStatistics, 100 * (1 - alpha/2));
if mode == 1
    avg = mean(bootstrapStatistics);
elseif mode == 2
    avg = mean(bootstrapStatistics);
else
    avg = median(bootstrapStatistics);
end
% - : - . - : - - : - . - : - FIN - : - . - : - - : - . - : -