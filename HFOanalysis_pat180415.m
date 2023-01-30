 
 
addpath(genpath('F:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180415\nights\'
addpath(genpath('F:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20180122\'))

patient =  6

% pat180415
% block 1:   4870-5500 s            %521
% block 2:   5300-6000 s            %d28
% block 3:   2 or 3 seizures
% block 4:   1500-2300 s            %3c2

% data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180415\nights\'


%% create biploar

filename = 'Arshakyan_ Ste_761f8952-9696-460e-9b8c-a03e5029a521.edf';
[hdr] = edfread([data_dir filename]);

change = [];
for l = 2:95
    if ~strncmp(hdr.label{l-1}(1),hdr.label{l}(1),1)
        change = [change l];
    end
end
change = change-1;
bipol           = [[1:94]' [1:94]'+1]
bipol(change,:) = [];
% clear data
% for jj = 1:length(bipol)
%     data.lab_bip{jj,1} = [char(hdr.label{bipol(jj,1)}) '-' char(hdr.label{bipol(jj,2)})];
% %     data.x_bip(jj,:)   = dataraw(bipol(jj,1),:) - dataraw(bipol(jj,2),:);
% end

% data.lab_bip(change)


% data.lab_bip(change) = [];
% data.lab_bip
%%

 

 bad_channels = [11 28 29  ]; % 28 and 29 are 4F1-2 and 4F2-3



%%

for block = 1:5
    
    switch block % pat180415
        
         case 1,  filename = 'Arshakyan_ Ste_761f8952-9696-460e-9b8c-a03e5029a521.edf'      % 15.04.18      22.19.54
             for iter = 1:2
                switch iter    
                    case 1
                        filesave = 'HFO_pat180415_block1_sample1';
                        block = 1;  samples =  [4900*2000   5200*2000];
                    case 2
                        filesave = 'HFO_pat180415_block1_sample2';
                        block = 3;  samples =  [5200*2000   5500*2000];
                   
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
            
        case 2,  filename = 'Arshakyan_ Ste_ec6ad85c-ab7f-459a-b1c3-7d452dcefd28.edf'      % 16.04.18      02.20.21
            
            for iter = 1:2
                switch iter    
                    case 1
                        filesave = 'HFO_pat180415_block2_sample1';
                        block = 1;  samples =  [5300*2000   5600*2000];
                    case 2
                        filesave = 'HFO_pat180415_block2_sample2';
                        block = 3;  samples =  [5700*2000   6000*2000];
                   
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
        
        case 3,  filename = 'Arshakyan_ Ste_9065d10a-7898-4cab-b0bb-4fbf410dbac0.edf'      % 16.04.18      00.20.24
        case 4,  filename = 'Arshakyan_ Ste_050e4346-3b9f-4669-aee3-b27ca894f3c2.edf'      % 16.04.18      04.20.44
            
             for iter = 1:2
                switch iter    
                    case 1
                        filesave = 'HFO_pat180415_block4_sample1';
                        block = 1;  samples =  [1500*2000   1800*2000];
                    case 2
                        filesave = 'HFO_pat180415_block4_sample2';
                        block = 3;  samples =  [2000*2000   2300*2000];
                   
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
            
        case 5,  filename = 'Arshakyan_ Ste_c3334bd4-b3b8-4f3a-b46f-180fdacda51a.edf'      % 16.04.18      06.20.32
            
           
            
       
            
           
        
            
       
                
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
    
    