 

pat = 9

switch pat
    
    case 2
        
        data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'
        
    case 3
        data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        
    case 5
        % data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'H:\DATA\MOSCOW\Pirogov\Pirogov DATA\180330\nights\'
        
    case 6
        % data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180415\nights\'
        
        
    case 7
        % data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180406\nights\'
        
        case 8
        % data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
        data_dir = 'D:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180424\nights\'
        
    case 9
         data_dir = 'E:\DATA\MOSCOW\Pirogov\Pirogov DATA\180516\nights\'

        
end



% file2: 500-1500 s

list = ls([data_dir '*_100.mat'])

%%

for block = 3%:size(list,1)
    
    load([data_dir list(block,:)])

    % data = data-repmat(data(1,:),size(data,1),1); % reference to Fz
    close all

    figure('units','normalized','outerposition',[0 0 1 1])
        shift = 200
        ax(1) = subplot(1,1,1)
        plot_ch_list_simple(data, shift,  hdr.label', 100)

        addScrollbar( ax, 30  )

        title(hdr.starttime)
        aspetta = 1
end

%% 

% pat180122
% block 4:   600-1900 s


% pat180127
% block 3:   100-400 s
% block 3:   700-1000 s
% block 3:   4860-5160 s
% block 3:   5900-6200 s
% block 4:   2000-2300 s
% block 4:   2500-2800 s
 

% pat180330
% block 3:   1000-2700 s
% block 3:   6500-7000 s
% block 4:   6000-6300 s
% block 5:   1-1500 s
% block 5:   4500-5500 s
% block 6:   2500-2800 s


% pat180415
% block 1:   4870-5500 s
% block 2:   5300-6000 s
% block 3:   2 or 3 seizures
% block 4:   1500-2300 s

% pat180406
% block 1:   3500-5500 s
% block 2:   2500-4500 s
% block 3:   not sure
% block 4:   200-500 s
% block 5:   1500-2300 s

% pat180424
%block3: 6200-7000 s
%block3: 7750-8100


% pat180516
% block 2: 6500 6800
% block 2: 7000 7300
% block 3: 1600 1900
% block 4: 2300 2600

 
 