% load, low pass and resample scalp EEG

data_dir = 'H:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'H:\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'

list = ls([data_dir '*mat'])

for ll = 1:size(list,1)
    
    t1 = cputime;
    load([data_dir char(list(ll,:))])
    
    t_load = cputime-t1
    
    % decimate
    for n=1:size(data,1)     
        V = decimate(data(n,:)',20)';
        data(n,1:length(V)) = V;
    end
    data(:,length(V)+1:end)=[];
 
    fs = 100;

    % low-pass
    
    [b,a] = butter(2,30/50);
    data = filtfilt(b,a,data')';
    
    save([data_dir char(list(ll,1:end-4)) '_100.mat'],'data','hdr')
end
     
%%

figure('units','normalized','outerposition',[0 0 1 1])
    shift = 1000
    ax(1) = subplot(1,1,1)
    plot_ch_list_simple(data, shift,  hdr.label, fs)
     
    addScrollbar( ax, 30  )
     
    title(hdr.starttime)
    
    
    
    
 
