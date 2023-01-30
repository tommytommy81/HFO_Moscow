%% PARAMETERS

if 1 
    load data_example
else
    data = RAWSIGNAL; % RAW DATA, format 1xN double
end

p.fs = 2000; % SAMPLING Frequency
p.duration = 300; % HOW MANY SECONDS OF DATA TO ANALYZE
p.filter.path = ['Filter_BirgitDetector_150706_coeff']; %  FILTER PATH for loading filter

p.hp = 80; % high pass ripple
p.hpFR = 250; % high pass FR
p.lp = 500; % low pass FR



%% LOAD FILTER 
load (p.filter.path)
p.filter = filter;

%% DETECTION
result = McGillDetector160422(data, p);

% result.autoSta - start of the detected events
% result.autoEnd - end of the detected events
% result.mark    - kind of events, 1 - Ripple, 2 - FR, 3 - Ripple and FR

% find(result.mark~=2) = indexes for Ripples
% find(result.mark~=1) = indexes for FRs
% find(result.mark==2) = indexes for Ripples and FRs

% other results
% signal - raw data
% signalFilt - data in ripple range
% signalFiltFR - data in FR range
% THR - Ripple, threshhold for Hilbert envelope, detection stage
% THRfiltered - Ripple, threshhold for filtered data, N consecutive oscillations, validation stage
% THRFR - Fast Ripple, ---
% THRfilteredFR - Fast Ripple, ---
