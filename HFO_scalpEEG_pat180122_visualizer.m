addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina


pat = 2

switch pat
    
    case 2
        data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'

    case 3
        data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

    case 4
        data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

end



% file2: 500-1500 s

list = ls([data_dir '*_100.mat'])

%%

for block = 2:size(list,1)
    
    load([data_dir list(block,:)])
    data = data-repmat(data(1,:),size(data,1),1); % reference to Fz
    close all
    figure('units','normalized','outerposition',[0 0 1 1])
    shift = 100
    ax(1) = subplot(1,1,1)
    plot_ch_list_simple(data(2:end,:), shift,  hdr.label', 100)
    addScrollbar( ax, 30  )
    title(hdr.starttime)
    aspetta = 1
    
end

