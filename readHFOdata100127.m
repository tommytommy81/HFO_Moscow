

addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina
% rmpath(genpath('C:\Tommaso\TOMMASO USZ\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina

data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

list = ls([data_dir '*edf'])

% filename =  'Pchelinceva_ K_43b56397-9714-43df-808c-165b3961f495.edf'      % 29.01.18      00.04.16
% filename = 'Pchelinceva_ K_bb6ba06b-8485-4cd4-a53e-5ad1c67e4c93.edf'     % 29.01.18      02.00.53
% filename = 'Pchelinceva_ K_c705eaaa-0a0f-4d80-a77b-53c763e22b6c.edf'      % 29.01.18      04.00.58
% filename = 'Pchelinceva_ K_9c80f5c7-d818-45b6-a0d1-697472331127.edf'      % 29.01.18      06.00.24
% filename = 'Pchelinceva_ K_b1d5d669-32b4-4b1a-86b0-a10b62d340cc.edf'     % 29.01.18      08.00.08





for block =  2:6
    switch block
        
        
        case 1,   filename =  'Pchelinceva_ K_43b56397-9714-43df-808c-165b3961f495.edf'    % 29.01.18      00.04.16
        case 2,   filename = 'Pchelinceva_ K_bb6ba06b-8485-4cd4-a53e-5ad1c67e4c93.edf'     % 29.01.18      02.00.53
        case 3,   filename = 'Pchelinceva_ K_c705eaaa-0a0f-4d80-a77b-53c763e22b6c.edf'     % 29.01.18      04.00.58
        case 4,   filename = 'Pchelinceva_ K_9c80f5c7-d818-45b6-a0d1-697472331127.edf'     % 29.01.18      06.00.24
        case 5,   filename = 'Pchelinceva_ K_b1d5d669-32b4-4b1a-86b0-a10b62d340cc.edf'     % 29.01.18      08.00.08
            
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
    t1 = cputime;
    [hdr,data] = edfread([data_dir filename],'targetSignals',primi); % EEG
    t_load = cputime-t1 % 288.1094

    
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
