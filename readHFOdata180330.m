clear all

% addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines\')) % athina
% rmpath(genpath('C:\Tommaso\TOMMASO USZ\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina
addpath(genpath('F:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))


 data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180415\nights\'

list = ls([data_dir '*edf'])

for block =  1:6
    
    switch block        
        
        case 1,  filename = 'Arshakyan_ Ste_761f8952-9696-460e-9b8c-a03e5029a521.edf'      % 15.04.18      22.19.54
        case 2,  filename = 'Arshakyan_ Ste_ec6ad85c-ab7f-459a-b1c3-7d452dcefd28.edf'      % 16.04.18      02.20.21
        case 3,  filename = 'Arshakyan_ Ste_9065d10a-7898-4cab-b0bb-4fbf410dbac0.edf'      % 16.04.18      00.20.24
        case 4,  filename = 'Arshakyan_ Ste_050e4346-3b9f-4669-aee3-b27ca894f3c2.edf'      % 16.04.18      04.20.44
        case 5,  filename = 'Arshakyan_ Ste_c3334bd4-b3b8-4f3a-b46f-180fdacda51a.edf'      % 16.04.18      06.20.32
             
    end
    [hdr] = edfread([data_dir filename]);
    hdr.label = hdr.label';
    [hdr.startdate '      ' hdr.starttime]
 
    %     non avendo lo scalp EEG, prendiamo tutti i primi contatti, sperando di vedere slow waves

    primi = []
    for ch = 1:length(hdr.label)
        if  hdr.label{ch}(end) == '1'
            primi = [primi ch];
        end
    end

    % edfread targetSignals
    t1         = cputime;
    [hdr,data] = edfread([data_dir filename],'targetSignals',primi); % EEG
    t_load     = cputime-t1 % 288.1094

    % decimate
    for n=1:size(data,1)
        V = decimate(data(n,:)',20)';
        data(n,1:length(V)) = V;
    end
    data(:,length(V)+1:end)=[];

    fs    = 100; 
    [b,a] = butter(2,30/50);
    data  = filtfilt(b,a,data')';

    % save([data_dir char(list(ll,1:end-4)) '_100.mat'],'data','hdr')

    save([data_dir 'scalpEEGblock' num2str(block) '_100.mat'] ,'data','hdr')
    
end

%%
chs = 1:7
figure, 
plot_ch_list_simple((data(chs,1:1e6)'-repmat(data(1,1:1e6),7,1)')', 200, (hdr.label(chs))', 200)

for ch = 1:7
    
    [P(ch,:), f] = calcPSD(data(ch,:)-data(1,:),1024,100);
end


figure, semilogy(f,P)


%% bipolar,

data_bip = diff(data);

for ch = 1:3
    
    [P_bip(ch,:), f] = calcPSD(data_bip(ch,:),1024,2000);
end

figure, loglog(f,P_bip)

hold on

, plot(f,P,'r')


%%

[b,a] = butter(2,[250 500]/1000)

figure, plot(detrend(data(1,:)))
hold on
plot(detrend(data_bip(1,:)),'r')


figure, 
plot(filtfilt(b,a,(data(1,:))))
hold on
plot(filtfilt(b,a,(data_bip(1,:))),'r')




