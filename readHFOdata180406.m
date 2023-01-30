clear all

 
addpath(genpath('F:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
 data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180406\nights\'

list = ls([data_dir '*edf'])

for block =  1:5
    
    switch block          
         
        case 1,  filename = 'Pavlova_ Yuliy_697afb2d-bd45-4f79-8c8e-f6dc9b513099.edf'      % 09.04.18      22.21.26
        case 2,  filename = 'Pavlova_ Yuliy_b263c632-841e-4ec1-b378-134822adc022.edf'      % 10.04.18      00.21.04      
        case 3,  filename = 'Pavlova_ Yuliy_1ecc06da-f264-4027-971b-81e9ffcf6c7a.edf'      % 10.04.18      02.21.08
        case 4,  filename = 'Pavlova_ Yuliy_ec6b333c-5da2-4b42-8549-0e5bc615f343.edf'      % 10.04.18      04.21.13
        case 5,  filename = 'Pavlova_ Yuliy_2f6bb3d2-e151-4ce6-a388-cd334374a0a1.edf'      % 10.04.18      06.21.18
 
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
