 
 
addpath(genpath('E:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
         data_dir = 'E:\DATA\MOSCOW\Pirogov\Pirogov DATA\180516\nights\'
addpath(genpath('E:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20180122\'))

patient =  7

% pat180516
% block 2: 6500 6800 %d02
% block 2: 7000 7300 %d02
% block 3: 1600 1900 %150
% block 4: 2300 2600 %e33 

% data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'




%%
filename = 'Uvarov_ Vladim_c604a8a4-16f1-47cc-b861-85bd28e1dd02.edf' 
[hdr] = edfread([data_dir filename]);
label = hdr.label';
change = [];
for l = 2:129
    if ~strncmp(hdr.label{l-1}(1),hdr.label{l}(1),1)
        change = [change l];
    end
end
change = change-1;
bipol           = [[1:128]' [1:128]'+1]
bipol(change,:) = [];
bipol([81 91 99 109],:) = [];
% %%test
% clear data
for jj = 1:length(bipol)
    data.lab_bip{jj,1} = [char(hdr.label{bipol(jj,1)}) '-' char(hdr.label{bipol(jj,2)})];
%     data.x_bip(jj,:)   = dataraw(bipol(jj,1),:) - dataraw(bipol(jj,2),:);
end
% 
data.lab_bip 

 %%

bad_channels = [5 16 17 20 52 53 85 86 111 112]; % 28 and 29 are 4F1-2 and 4F2-3

%%

% pat180516
% block 1:   3500-5500 s
% block 2:   2500-4500 s
% block 3:   not sure
% block 4:   200-500 s
% block 5:   1500-2300 s

for block = 2:3
    
    switch block % pat180516
        
        case 2,  filename = 'Uvarov_ Vladim_c604a8a4-16f1-47cc-b861-85bd28e1dd02.edf'      % 09.04.18      22.21.26
            
            
            for iter = 1:2
                switch iter
                    case 1
                        filesave = 'HFO_pat180516_block1_sample1';
                        block = 1;  samples =  [6500*2000   6800*2000];
                    case 2
                        filesave = 'HFO_pat180516_block1_sample2';
                        block = 3;  samples =  [7000*2000   7300*2000];
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
                data_baseline  = ft_preprocessing(cfg);
                hdr.label      = data_baseline.label';
                dataraw        = data_baseline.trial{1};
                clear data_baseline
                
                bipolar_HFOcomp_savemat
                
            end
            
        case 3,  filename = 'Uvarov_ Vladim_da335d55-7d75-4c02-b639-cc900ffdd150.edf'      % 10.04.18      00.21.04
            
            for iter = 1:2
                switch iter
                    case 1
                        filesave = 'HFO_pat180516_block2_sample1';
                        block = 1;  samples =  [1600*2000   1900*2000];
                    case 2
                        filesave = 'HFO_pat180516_block2_sample2';
                        block = 3;  samples =  [2300*2000   2600*2000];
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
                data_baseline  = ft_preprocessing(cfg);
                hdr.label      = data_baseline.label';
                dataraw        = data_baseline.trial{1};
                clear data_baseline
                
                bipolar_HFOcomp_savemat
                
            end
            
            
            
    end
    
    
    
    
    
    
    
    
    
    
end
            


    
    
    
     
    %%
    if 0
        close all
        chs = [1:20]%+20+20+20+20+5%
        figure('units','normalized','outerposition',[0 0 1 1])
        shift = 1000
        ax(1) = subplot(1,1,1)
        plot_ch_list_simple(detrend(data.x_bip(chs,:)')', shift,  data.lab_bip(chs), 2000)
        
        addScrollbar( ax, 30  )
    end
    
    %% remove channels
    %  ciao = [10 11 28 29 43]
    %  data.x_bip(ciao,:) = [];
    %   data.lab_bip(ciao) = [];
    
    