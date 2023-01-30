clear all

 
addpath(genpath('D:\_Tommaso\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines'))
data_dir = 'H:\DATA\MOSCOW\Pirogov\Pirogov DATA\180810\Night\'

list = ls([data_dir '*edf'])

for  j = 1:size(list,1)
    
    filenamess{j,1} = list(j,:);
    
end

HDR_time = [] 

for block =  1:size(filenamess,1)
    
    switch block          
         
        case block,  filename = char(filenamess(block));
            
        %         07.06.18      05.23.16
        %         07.06.18      01.23.42
        %         07.06.18      03.29.07
        %         07.06.18      07.12.22
        %         06.06.18      23.19.58
    
    end
    
    [hdr] = edfread([data_dir filename]);
    hdr.label = hdr.label';
    HDR_time = [HDR_time; hdr.startdate '      ' hdr.starttime]
    
    distalch_id = distalcontact(hdr.label);

%     non avendo lo scalp EEG, prendiamo tutti i primi contatti, sperando di vedere slow waves
 
    
    % edfread targetSignals
    t1         = cputime;
    [hdr,data] = edfread([data_dir filename],'targetSignals',distalch_id); % EEG
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

 
  
