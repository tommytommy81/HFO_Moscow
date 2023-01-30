clear all

 
addpath(genpath('D:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
 data_dir = 'D:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180424\nights\'

list = ls([data_dir '*edf'])

for block =  3
    
    switch block          
         
        case 1,  filename = 'Mahacheva_ El_213b4f12-c559-4473-a5a6-f724373cb522.edf'      % 27.04.18      00.35.39
        case 2,  filename = 'Mahacheva_ El_a5240edc-8928-4bc8-be15-09d5f8c88d2f.edf'      % 26.04.18      22.57.24      
        case 3,  filename = 'Mahacheva_ El_bf994021-2b5c-418e-9fd4-7c7e4460bf45.edf'      % 27.04.18      01.41.31    
         
 
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
    primi = 66:72;
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
