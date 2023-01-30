clear all

 
addpath(genpath('E:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines'))
 data_dir = 'E:\DATA\MOSCOW\Pirogov\Pirogov DATA\180516\nights\'

list = ls([data_dir '*edf'])


for block =  1:4
    
    switch block          
         
        case 1,  filename = 'Uvarov_ Vladim_5e2b31e6-e199-4667-9f25-eeae90b4707d.edf'      % 21.05.18      23.14.59      
        case 2,  filename = 'Uvarov_ Vladim_c604a8a4-16f1-47cc-b861-85bd28e1dd02.edf'      % 22.05.18      01.16.26   
        case 3,  filename = 'Uvarov_ Vladim_da335d55-7d75-4c02-b639-cc900ffdd150.edf'      % 22.05.18      03.32.16   
        case 4,  filename = 'Uvarov_ Vladim_2ee66afa-244e-48c4-8614-a2c8932b0e33.edf'      % 22.05.18      06.23.45
    
    end
    
    
    
    [hdr] = edfread([data_dir filename]);
    hdr.label = hdr.label';
    [hdr.startdate '      ' hdr.starttime]
    
    
%     non avendo lo scalp EEG, prendiamo tutti i primi contatti, sperando di vedere slow waves
 
    primi = []
    for ch = 1:length(hdr.label)
        if  hdr.label{ch}(end) == '1' & hdr.label{ch}(end-1) ~= '1'
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

% %%
% chs = 1:7
% figure, 
% plot_ch_list_simple((data(chs,1:1e6)'-repmat(data(1,1:1e6),7,1)')', 200, (hdr.label(chs))', 200)
% 
% for ch = 1:7
%     
%     [P(ch,:), f] = calcPSD(data(ch,:)-data(1,:),1024,100);
% end
% 
% 
% figure, semilogy(f,P)
% 
% 
% %% bipolar,
% 
% data_bip = diff(data);
% 
% for ch = 1:3
%     
%     [P_bip(ch,:), f] = calcPSD(data_bip(ch,:),1024,2000);
% end
% 
% figure, loglog(f,P_bip)
% 
% hold on
% 
% , plot(f,P,'r')
% 
% 
% %%
% 
% [b,a] = butter(2,[250 500]/1000)
% 
% figure, plot(detrend(data(1,:)))
% hold on
% plot(detrend(data_bip(1,:)),'r')
% 
% 
% figure, 
% plot(filtfilt(b,a,(data(1,:))))
% hold on
% plot(filtfilt(b,a,(data_bip(1,:))),'r')
% 
% 
% 
% 
