graduateprograms@bccn-berlin.de 

addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines\')) % athina
% rmpath(genpath('C:\Tommaso\TOMMASO USZ\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina

data_dir = 'graduateprograms@bccn-berlin.de \'

list = ls([data_dir '*edf'])

for block =  1:6
    
    switch block        
        
        case 1,  filename = 'Novichihin_ Vi_99462218-099d-49e2-b5d8-f85ca8c4338a.edf'      % 22.01.18      22.44.59
        case 2,  filename = 'Novichihin_ Vi_225196a0-a682-45f6-86e3-12eb9701b3c5.edf'      % 23.01.18      11.59.25
        case 3,  filename = 'Novichihin_ Vi_893b93f3-9663-40b1-b9f5-0885b6ea2679.edf'      % 23.01.18      00.00.45
        case 4,  filename = 'Novichihin_ Vi_5f27075a-82f5-4ed5-b1c2-422833bfb919.edf'      % 23.01.18      02.00.04
        case 5,  filename = 'Novichihin_ Vi_97a947f5-86c2-43c0-b877-eb268e68d905.edf'      % 23.01.18      04.00.35
        case 6,  filename = 'Novichihin_ Vi_ea07348b-4641-4420-8451-e69f29513547.edf'      % 23.01.18      05.59.54
            
    end
    [hdr] = edfread([data_dir filename]);
    hdr.label = hdr.label';
    [hdr.startdate '      ' hdr.starttime]
    
  

    % edfread targetSignals
    t1         = cputime;
    [hdr,data] = edfread([data_dir filename],'targetSignals',120:126); % EEG
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




