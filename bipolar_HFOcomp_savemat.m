clear data
for jj = 1:length(bipol)
    data.lab_bip{jj,1} = [char(hdr.label{bipol(jj,1)}) '-' char(hdr.label{bipol(jj,2)})];
    data.x_bip(jj,:)   = dataraw(bipol(jj,1),:) - dataraw(bipol(jj,2),:);
end

%%

if 0
    
    close all %+17 
    chs = [1:20]  +20 +20 +20 +20 +12 
    figure('units','normalized','outerposition',[0 0 1 1])
    shift = 2000
    ax(1) = subplot(1,1,1)
    
    %         shift = 100
    %         [b,a] = butter(2,250/1000,'high');
    %         plot_ch_list_simple(filtfilt(b,a,(data.x_bip(chs,:)'))', shift,  data.lab_bip(chs), 2000)

    plot_ch_list_simple(detrend(data.x_bip(chs,:)')', shift,  data.lab_bip(chs), 2000)    
%         plot_ch_list_simple(detrend(dataraw(chs,:)')', shift,  hdr.label(chs)', 2000)    

    addScrollbar( ax, 30  )
    aspetta = 1
end

 

%% remove channels
ciao = bad_channels
data.x_bip(ciao,:) = [];
data.lab_bip(ciao) = [];



%% HFO analysis
load FIR_2kHz
% run the detector
p.fs          = 2000; % SAMPLING Frequency
p.duration    = length(data.x_bip); % HOW MANY SECONDS OF DATA TO ANALYZE
p.filter      = filter;
p.hp          = 80; % high pass ripple
p.hpFR        = 250; % high pass FR
p.lp          = 500; % low pass FR
dt            = 1/p.fs;

for ch = 1:length( data.lab_bip)
    ch
    HFOobj(ch).result      = McGillDetector160422(data.x_bip(ch,:), p);
    HFOobj(ch).label       = data.lab_bip(ch);
    HFOobj(ch).result.time = dt:dt:dt*length(data.x_bip);
end

save(['E:\Tom_Local\Results\MOSCOW_HFO\' filesave], 'HFOobj','-v7.3')